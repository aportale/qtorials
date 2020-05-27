LoadPlugin("..\qtavisynth.dll")

function Blank()
{
    BlankClip(color = $ffffffff, length = 1000, width = 640, height = 480)
}

function ScreenCast()
{
    ColorBars().converttoyv24.trim(1, 1000)
}
