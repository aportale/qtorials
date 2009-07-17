$winTitle = "[REGEXPTITLE: - Sun VirtualBox\z]"
$winWidth = 960
$winHeight = 720
Opt("WinTitleMatchMode", 4)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

WinActivate($winTitle)
WinMove($winTitle, "", 0, 0, $winWidth  + 16, $winHeight + 79)
