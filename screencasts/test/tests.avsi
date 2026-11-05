try {
  LoadPlugin("..\qtavisynth.dll")
} catch (err) {
  LoadPlugin("../libqtavisynth.so")
}

function Blank()
{
    BlankClip(color = $ffffffff, length = 1000, width = 640, height = 480)
}

function ScreenCast()
{
    ColorBars().trim(1, 1000)
}
