#!/usr/bin/env python3
"""Smoke test for AviSynth scripts, without a video application.

Loads each script through the AviSynth+ C API (avisynth.dll or libavisynth.so), like a video
application opening the .avs file would, then renders a few frames. Rendering
runs the whole filter chain, so this also catches errors that only show up in
the filters' GetFrame(), not just script errors.

Examples:
    check_avs.py ../../../screencasts/test/*.avs
    check_avs.py --frames 0,80,-1 --png out qtavisynth.avs

The plugin needs the Qt libraries, so Qt's bin directory (Windows) or lib directory
(Linux) must be in PATH or LD_LIBRARY_PATH, or be passed with --qt-bin. On Linux, run
with QT_QPA_PLATFORM=offscreen when there is no display.

Exits with 1 if any script fails to load or any frame fails to render.
"""

import argparse
import ctypes
import os
import struct
import subprocess
import sys
import zlib
from ctypes import POINTER, c_char_p, c_int, c_int64, c_short, c_uint, c_void_p


class AVS_Value(ctypes.Structure):
    class _Data(ctypes.Union):
        _fields_ = [('clip', c_void_p), ('integer', c_int), ('string', c_char_p),
                    ('array', c_void_p), ('longlong', c_int64)]
    _fields_ = [('type', c_short), ('array_size', c_short), ('d', _Data)]


class AVS_VideoInfo(ctypes.Structure):
    _fields_ = [('width', c_int), ('height', c_int),
                ('fps_numerator', c_uint), ('fps_denominator', c_uint),
                ('num_frames', c_int), ('pixel_type', c_int),
                ('audio_samples_per_second', c_int), ('sample_type', c_int),
                ('num_audio_samples', c_int64), ('nchannels', c_int),
                ('image_type', c_int)]


# Pixel types from avisynth_c.h
AVS_CS_BGR = 1 << 28
AVS_CS_INTERLEAVED = 1 << 30
AVS_CS_BGR24 = 1 << 0 | AVS_CS_BGR | AVS_CS_INTERLEAVED
AVS_CS_BGR32 = 1 << 1 | AVS_CS_BGR | AVS_CS_INTERLEAVED

AVISYNTH_INTERFACE_VERSION = 6


def load_avisynth():
    if sys.platform == 'win32':
        avs = ctypes.WinDLL('avisynth')
    else:
        avs = ctypes.CDLL('libavisynth.so')
    signatures = {
        'avs_create_script_environment': (c_void_p, [c_int]),
        'avs_delete_script_environment': (None, [c_void_p]),
        'avs_invoke': (AVS_Value, [c_void_p, c_char_p, AVS_Value, c_void_p]),
        'avs_release_value': (None, [AVS_Value]),
        'avs_take_clip': (c_void_p, [AVS_Value, c_void_p]),
        'avs_release_clip': (None, [c_void_p]),
        'avs_clip_get_error': (c_char_p, [c_void_p]),
        'avs_get_video_info': (POINTER(AVS_VideoInfo), [c_void_p]),
        'avs_get_frame': (c_void_p, [c_void_p, c_int]),
        'avs_release_video_frame': (None, [c_void_p]),
        'avs_get_read_ptr_p': (c_void_p, [c_void_p, c_int]),
        'avs_get_pitch_p': (c_int, [c_void_p, c_int]),
    }
    for name, (restype, argtypes) in signatures.items():
        function = getattr(avs, name)
        function.restype = restype
        function.argtypes = argtypes
    return avs


def write_png(path, width, height, rgb_rows):
    """Writes 8 bit RGB rows (top to bottom) as PNG."""
    def chunk(chunk_type, data):
        return (struct.pack('>I', len(data)) + chunk_type + data
                + struct.pack('>I', zlib.crc32(chunk_type + data)))
    raw = b''.join(b'\0' + row for row in rgb_rows)  # filter type 0 per row
    header = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)  # 8 bit RGB
    with open(path, 'wb') as f:
        f.write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', header)
                + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b''))


def frame_rgb_rows(avs, frame, vi):
    """Returns the frame as RGB rows, top to bottom. Supports RGB32 and RGB24."""
    bytes_per_pixel = {AVS_CS_BGR32: 4, AVS_CS_BGR24: 3}[vi.pixel_type]
    ptr = avs.avs_get_read_ptr_p(frame, 0)
    pitch = avs.avs_get_pitch_p(frame, 0)
    rows = []
    for y in range(vi.height):
        # AviSynth RGB frames are stored bottom-up, as BGR(A)
        bgr = ctypes.string_at(ptr + (vi.height - 1 - y) * pitch, vi.width * bytes_per_pixel)
        rgb = bytearray(vi.width * 3)
        rgb[0::3] = bgr[2::bytes_per_pixel]
        rgb[1::3] = bgr[1::bytes_per_pixel]
        rgb[2::3] = bgr[0::bytes_per_pixel]
        rows.append(bytes(rgb))
    return rows


def check_script(script, frames, png_dir):
    """Loads and renders one script. Returns True on success."""
    avs = load_avisynth()
    env = avs.avs_create_script_environment(AVISYNTH_INTERFACE_VERSION)
    if not env:
        print(f'{script}: ERROR: Could not create an AviSynth script environment')
        return False

    clip = None
    result = None
    try:
        # Import() evaluates the script with its own directory as current
        # directory, so that relative paths in the script work.
        argument = AVS_Value(type=ord('s'), array_size=1)
        argument.d.string = os.path.abspath(script).encode()
        result = avs.avs_invoke(env, b'Import', argument, None)
        if result.type == ord('e'):
            print(f'{script}: ERROR: {result.d.string.decode(errors="replace")}')
            return False
        if result.type != ord('c'):
            print(f'{script}: ERROR: Script returns no clip')
            return False

        clip = avs.avs_take_clip(result, env)
        vi = avs.avs_get_video_info(clip).contents
        print(f'{script}: {vi.width}x{vi.height}, {vi.num_frames} frames, '
              f'{vi.fps_numerator}/{vi.fps_denominator} fps')

        if png_dir and vi.pixel_type not in (AVS_CS_BGR32, AVS_CS_BGR24):
            print('  PNG export only supports RGB32 and RGB24 clips, add ConvertToRGB32()')
            png_dir = None

        ok = True
        if frames is None:
            frames = [0, vi.num_frames // 2, -1]
        # Negative frame numbers count from the end, like Python indices
        frame_numbers = sorted({n % vi.num_frames for n in frames
                                if -vi.num_frames <= n < vi.num_frames})
        for n in frame_numbers:
            frame = avs.avs_get_frame(clip, n)
            error = avs.avs_clip_get_error(clip)
            if not frame or error:
                message = error.decode(errors='replace') if error else 'No frame returned'
                print(f'  frame {n}: ERROR: {message}')
                ok = False
            else:
                if png_dir:
                    name = os.path.splitext(os.path.basename(script))[0]
                    path = os.path.join(png_dir, f'{name}_{n}.png')
                    write_png(path, vi.width, vi.height, frame_rgb_rows(avs, frame, vi))
                    print(f'  frame {n}: ok, wrote {path}')
                else:
                    print(f'  frame {n}: ok')
            if frame:
                avs.avs_release_video_frame(frame)
        return ok
    finally:
        if clip:
            avs.avs_release_clip(clip)
        if result is not None:
            avs.avs_release_value(result)
        avs.avs_delete_script_environment(env)


def frame_list(text):
    try:
        return [int(n) for n in text.split(',')]
    except ValueError:
        raise argparse.ArgumentTypeError(f'expected comma separated frame numbers: {text}')


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('scripts', nargs='+', metavar='script.avs')
    parser.add_argument('--frames', type=frame_list, metavar='N,N,...',
                        help='frames to render; negative numbers count from the end '
                        '(default: first, middle and last frame)')
    parser.add_argument('--png', metavar='DIR', help='write the rendered frames as PNG to DIR')
    parser.add_argument('--qt-bin', metavar='DIR', help="Qt's bin (Windows) or lib (Linux) directory, prepended to PATH or "
                        "LD_LIBRARY_PATH")
    parser.add_argument('--timeout', type=int, default=300, metavar='SECONDS',
                        help='per script (default: %(default)s)')
    # Internal: check a single script in this process
    parser.add_argument('--in-process', action='store_true', help=argparse.SUPPRESS)
    args = parser.parse_args()

    if args.in_process:
        return 0 if check_script(args.scripts[0], args.frames, args.png) else 1

    if args.qt_bin:
        variable = 'PATH' if sys.platform == 'win32' else 'LD_LIBRARY_PATH'
        os.environ[variable] = os.pathsep.join(
            filter(None, [os.path.abspath(args.qt_bin), os.environ.get(variable)]))
    # Otherwise, Qt writes its messages (including the reason for a qFatal()
    # abort) only to the debugger output when there is no console
    os.environ['QT_FORCE_STDERR_LOGGING'] = '1'
    if args.png:
        os.makedirs(args.png, exist_ok=True)
        args.png = os.path.abspath(args.png)

    # Run each script in its own process, so that a plugin that crashes or
    # hangs only fails its own script, and the crash can be reported.
    failed = []
    for script in args.scripts:
        command = [sys.executable, '-I', '-u', os.path.abspath(__file__), '--in-process', script]
        if args.frames:
            command += ['--frames=' + ','.join(map(str, args.frames))]
        if args.png:
            command += ['--png', args.png]
        try:
            completed = subprocess.run(command, timeout=args.timeout)
            if completed.returncode != 0:
                if completed.returncode != 1:
                    print(f'{script}: ERROR: Crashed with exit code '
                          f'{completed.returncode & 0xffffffff:#x}')
                failed.append(script)
        except subprocess.TimeoutExpired:
            print(f'{script}: ERROR: Timed out after {args.timeout} s')
            failed.append(script)
        sys.stdout.flush()

    if len(args.scripts) > 1:
        print(f'\n{len(args.scripts) - len(failed)} of {len(args.scripts)} scripts ok')
        for script in failed:
            print(f'  failed: {script}')
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main())
