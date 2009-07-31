; This work is licensed under the Creative Commons
; Attribution-Noncommercial-Share Alike 3.0 Unported
; License. To view a copy of this license, visit
; http://creativecommons.org/licenses/by-nc-sa/3.0/
; or send a letter to Creative Commons,
; 171 Second Street, Suite 300, San Francisco,
; California, 94105, USA.

; This tool gets the selected wave range from Yamahas "Tiny Wave Editor"
; and types it in a format that can be used in the Qtorial scripts.
; Download the editor:
; http://www.yamaha.com/yamahavgn/ProductMedia/Software/TWE.exe

HotKeySet("{F7}", "TypeRange")

$winTitle = "TWE - "

Func FieldValue($idNumber)
    return ControlGetText($winTitle, "", "Static" & $idNumber)
EndFunc

Func WavPosition($fieldMinutes, $fieldSeconds, $fieldMilliseconds)
    $minutes = FieldValue($fieldMinutes)
    $seconds = $minutes * 60 + FieldValue($fieldSeconds)
    $milliseconds = FieldValue($fieldMilliseconds)
    return $seconds & "." & $milliseconds
EndFunc

Func StartPosition()
    return WavPosition(31, 32, 33)
EndFunc

Func EndPosition()
    return WavPosition(36, 37, 38)
EndFunc

Func SelectionRange()
    return StartPosition() & ", " & EndPosition()
EndFunc

Func TypeRange()
    Send(SelectionRange())
EndFunc

While 1
    Sleep(100)
WEnd
