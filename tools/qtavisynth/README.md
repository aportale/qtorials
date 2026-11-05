# QtAviSynth

An [AviSynth+](https://github.com/AviSynth/AviSynthPlus) plugin that uses Qt to render
titles, subtitles, highlights, SVG artwork, QML animations and zoom-and-pan effects into
video clips. It is used to produce the qtorials screencasts in [`../../screencasts`](../../screencasts).

## Requirements

- Windows, x64
- [AviSynth+](https://github.com/AviSynth/AviSynthPlus), installed **with the Filter SDK**.
  The build expects it in `%ProgramFiles(x86)%\AviSynth+\FilterSDK`.
- Qt 6.6 or newer with the Gui, Svg, Quick and Widgets modules. The QML animations also need
  the Qt Quick Timeline module at runtime.
- CMake 3.20 or newer, MSVC
- Optional: the `quad` filter from David Horman's
  [warp](http://horman.net/avisynth/download/warp.zip) plugin, for the perspective effect of
  `QtAviSynthZoomNPan`, see [Zoom and pan](#zoom-and-pan)

## Building

Open `CMakeLists.txt` in Qt Creator with a Qt 6 MSVC kit, or build from the command line:

```
cmake -S . -B build -DCMAKE_PREFIX_PATH=<path to Qt 6>
cmake --build build
```

The plugin is written straight to the screencasts directory, as
`../../screencasts/qtavisynth.dll`, where the `.avs` scripts load it from.

## Usage

Load the plugin in an AviSynth script. Qt's `bin` directory must be in the `PATH` of the
application that opens the script, so that the Qt DLLs and plugins are found.

```
LoadPlugin("qtavisynth.dll")

ColorBars().Trim(1, 300)
\ .QtAviSynthSubtitle("Qt Creator", "Documentation", 20, 80)
\ .QtAviSynthElements("qtlogosmall")
```

All filters render with Qt and overlay the result on the input clip. The scripts in
[`../../screencasts/test`](../../screencasts/test) show each filter in use;
`qtavisynth_all.avs` combines all of them.

### Filters

| Filter | Parameters | Description |
|---|---|---|
| `QtAviSynthElements` | `clip, string elements, ...` | Paints built-in elements: `vignette`, `rgbpatterns`, `qtlogosmall`, `qtlogobig`, `codecblockpattern`, `cc-by-nc-sa`, `cc-by-nc-nd`, `cc-by-sa` |
| `QtAviSynthSvg` | `clip, string svgfile, string elements, ...` | Paints the elements with the given ids from an SVG file |
| `QtAviSynthTitle` | `clip, string text, string fontface, int color` | Centered title text. `\n` starts a new line; HTML markup is rendered as rich text |
| `QtAviSynthSubtitle` | `clip, string title, string subtitle, int start, int end` | Animated title and subtitle, visible from frame `start` to `end` |
| `QtAviSynthHighlight` | `clip, int left, int top, int width, int height, int start, int end` | Dims everything except a rectangle, from frame `start` to `end` |
| `QtAviSynthSvgAnimation` | `[clip], string svgfile, float fps, (string element, int start, int end, string blendin, string blendout), ...` | Shows and hides SVG elements over time. Blending is `immediate`, `fade` or `fadeandscale` |
| `QtAviSynthQmlAnimation` | `[clip], string qmlfile, float fps, string initialproperties, bool usegpu` | Renders a QML scene, see below |
| `QtAviSynthZoomNPan` | `clip, int width, int height, int defaulttransitionframes, string resizefilter, float perspectivestrength, int startleft, int starttop, int startwidth, int startheight, (int keyframe, int transitionframes, int left, int top, int width, int height), ...` | Animated zoom and pan between detail rectangles, see below |

`QtAviSynthSvgAnimation` and `QtAviSynthQmlAnimation` don't need an input clip. Without one,
they create a clip at the given `fps`, sized by the SVG or the QML root item. With an input
clip, they use its frame rate and ignore `fps`.

### QML animations

`qmlfile` is a `.qml` file or a `.qmlproject`, whose `mainFile` and `importPaths` are used.
The root object must be an `Item` and contain a `Timeline` from Qt Quick Timeline. The
plugin drives the timeline frame by frame, so its animations should not run on their own.
Timeline frames are milliseconds: the clip lasts `endFrame - startFrame` ms.
`initialproperties` is a JSON object whose values are set as initial properties of the root
item. `usegpu` (default `true`) renders on the GPU, with the default graphics API of Qt
Quick: Direct3D 11 on Windows, or the one set with the `QSG_RHI_BACKEND` environment variable
(`opengl`, `vulkan`, `d3d12`). `false` uses the software backend.

### Zoom and pan

`QtAviSynthZoomNPan` scales the input clip to `width` × `height`, showing the start
rectangle first. It then moves to each detail rectangle so that it is reached at its
`keyframe`, using `transitionframes` frames for the move; `-1` uses
`defaulttransitionframes`. In a rectangle, `left` or `top` of `-1` means the whole clip (centered and cropped to the
output aspect ratio), and
`width` or `height` of `-1` means the output size, at native resolution. A
`perspectivestrength` above 0 tilts the image while it moves.

The tilt is done by the `quad` filter of David Horman's warp plugin, which QtAviSynth
invokes by name. With a `perspectivestrength` above 0, the warp plugin must be loaded
before `QtAviSynthZoomNPan` is called, otherwise loading the script fails with an error
pointing to it. With a `perspectivestrength` of 0, the warp plugin is not needed.

Download [warp.zip](http://horman.net/avisynth/download/warp.zip) from
[horman.net/avisynth](http://horman.net/avisynth/), then either copy its `x64\warp.dll`
into `%ProgramFiles(x86)%\AviSynth+\plugins64+` to have it loaded automatically, or load
it in the script with `LoadPlugin("warp.dll")`. The separate `quad.zip` on that page is
not suitable: it contains an older, 32-bit only version of `quad` with different
parameters.

## Testing

`test/` contains `qtavisynth_filtertest`, a small Qt Widgets application that shows the
painting functions without AviSynth. Pick a function from the combo box; the selection is
remembered across runs.

`test/check_avs.py` is a smoke test for the plugin that needs no video application. It
loads AviSynth scripts through the AviSynth+ C API and renders a few frames of each, so
it catches script errors as well as errors and crashes while rendering. Each script runs
in its own process. Run it with Python 3:

```
python test/check_avs.py --qt-bin <path to Qt 6>/bin ../../screencasts/test/*.avs
```

`--frames 0,80,-1` selects the frames to render (negative numbers count from the end),
and `--png DIR` writes them as images. See `--help` for all options.

To watch the result, open a script from `../../screencasts/test` in a video
application that supports AviSynth, for example [VirtualDub2](https://sourceforge.net/projects/vdfiltermod/)
or [mpv](https://mpv.io/):

```
choco install virtualdub2 -a
```

To debug from Qt Creator, use a run configuration with:

- Executable: `%{Env:ProgramData}\chocolatey\lib\virtualdub2\tools\VirtualDub64.exe`,
  or for mpv `%{Env:ProgramData}\chocolatey\lib\mpv.install\tools\mpv.exe`
- Command line arguments: `%{sourceDir}\..\..\screencasts\test\qtavisynth_all.avs`
- Environment: prepend `${QTDIR}\bin;` to `Path`, or add `PATH=+${QTDIR}\bin`

## License

This work is licensed under the
[Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/).
