#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

;Runwait(@ComSpec & "/c" & ">" & Chr(34) & @ScriptDir & "\stacksEditor.py" & Chr(34), @ScriptDir)
ShellExecuteWait(@ScriptDir & "\stacksEditor.py")
