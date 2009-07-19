; This work is licensed under the Creative Commons
; Attribution-Noncommercial-Share Alike 3.0 Unported
; License. To view a copy of this license, visit
; http://creativecommons.org/licenses/by-nc-sa/3.0/
; or send a letter to Creative Commons,
; 171 Second Street, Suite 300, San Francisco,
; California, 94105, USA.

$winTitle = "[REGEXPTITLE: - Sun VirtualBox\z]"
$winWidth = 960
$winHeight = 720
Opt("WinTitleMatchMode", 4)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

WinActivate($winTitle)
WinMove($winTitle, "", 0, 0, $winWidth  + 16, $winHeight + 79)
