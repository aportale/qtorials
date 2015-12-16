LoadPlugin("..\qtavisynth.dll")

function Blank()
{
    BlankClip(color = $ffffffff, length = 1000, width = 640, height = 480)
}

function ScreenCast()
{
    DirectShowSource("c:\qtorials_media\meet_boot2qt_documentation.avi").converttoyv24
}
