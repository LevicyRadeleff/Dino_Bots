#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

;Globals
Global $aDinoArray[34] = ["Acro","Albert","AlloAdultS","Anky","Austro","Ava","Bary","Camara","CarnoAdultS","CeratoAdultS","DiabloAdultS","DiloAdultS","DryoAdultS","GalliAdultS","GigaAdultS","GigaSubS","Herrera","MaiaAdultS","Oro","PachyAdultS","ParaAdultS","RexAdultS","RexSubS","Shant","Spino","Stego","SuchoAdultS","Taco","Theri","TrikeAdultS","TrikeSubS","UtahAdultS","Velo","DinoGold"]
Global $aGenderArray[3] = ["Male","Female","Gold"]


fMain()

Exit

Func fMain()
    $FirstBox = GUICreate("Program Choice", 200, 200)
    GUICtrlCreateLabel("What would you like to", 10, 1)
    GUICtrlCreateLabel("do today?", 10, 20)
    $Button1 = GUICtrlCreateButton("Remove Stacks", 50, 50, 100, 25, $WS_GROUP)
    $Button2 = GUICtrlCreateButton("Manage Giveaways", 50, 75, 100, 25, $WS_GROUP)
    $Button3 = GUICtrlCreateButton("Handle Donator Dinos", 37, 100, 125, 25, $WS_GROUP)
    $Button4 = GUICtrlCreateButton("Cancel", 50, 125, 100, 25, $WS_GROUP)
    GUISetState(@SW_SHOW)

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            Case $Button1
                GUISetState(@SW_HIDE)
                fRemoveAllStacks() ;This runs the old code, which allows the user's stacks to be edited. Really only useful for staff
                fRunOutput() ;This prints out the output file. All things before here should successfully edit the output file.
                ExitLoop
            Case $Button2
                GUISetState(@SW_HIDE)
                fGiveaway() ;This is the giveaway area, mostly used by Seq to add dinos to the giveaway file, or run a giveaway, cannot remove balance from here per dino
                ExitLoop
            Case $Button3
                GUISetState(@SW_HIDE)
                fDonator() ;The panel for editing donator requests, looks similar to Seq's panel but no option to add the dinos/money taken to the weekly giveaway file
                ExitLoop
            Case $Button4 ;Exit the program
                Exit
        EndSwitch
    WEnd
EndFunc

Func fRemoveAllStacks()
$discordID = InputBox("Discord ID", "Enter the users Discord ID")
$number = 0
$sBal = 4

$DinoBox = GUICreate("User Dino InputBox", 633, 447)
$UserDinoInput = GUICtrlCreateEdit("", 32, 24, 569, 353)
GUICtrlSetData(-1, "Copy & Paste User Dino List Here")
$Button11 = GUICtrlCreateButton("OK", 32, 400, 113, 25, $WS_GROUP)
$Button12 = GUICtrlCreateButton("Cancel", 480, 400, 121, 25, $WS_GROUP)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button11
            $sUserDinoInput_Value = GUICtrlRead($UserDinoInput)
            GUISetState(@SW_HIDE)
            ExitLoop
        Case $Button12
            Exit
    EndSwitch
WEnd

$huserInfo = FileOpen("userInfo.txt", 2)

FileWrite($huserInfo, $sUserDinoInput_Value & Chr(10))
FileClose($huserInfo)

$htempTxt = FileOpen("tempFile.txt", 2)

FileWrite($htempTxt, $discordID & Chr(10))
FileWrite($htempTxt, $number & Chr(10))
FileWrite($htempTxt, $sBal & Chr(10))

;TempFile.txt:
;dino.txt
;DiscordID
;Number
;0/1/2 (No Change, 10k, Pay for all Dinos), 4 (200k)
;

FileClose($htempTxt)

sleep(400)
Runwait(@ComSpec & " /c " & Chr(34) & @ScriptDir & "\stacksEditor.py" & Chr(34), @ScriptDir)
EndFunc

Func fRunOutput()
Local $i

$hOutputFile = FileOpen("output.txt", $FO_READ + $FO_FULLFILE_DETECT)

MsgBox ($MB_OK, "Completion", "Process Done, beginning discord input. Please click okay, then select the text input box on discord.")

sleep(10000)

For $i = 1 To _FileCountLines($hOutputFile)
    $line = FileReadLine($hOutputFile, $i)
    send("{!}a" & $line)
    send(Chr(10))
    sleep(2000)
Next

FileClose($hOutputFile)

MsgBox($MB_OK, "Success", "Process Complete, all dino deals sorted.")

EndFunc

Func fDonator()

EndFunc

Func fGiveaway()
    $GiveawayBox = GUICreate("Giveaway Menu", 200, 150)
    GUICtrlCreateLabel("Adding to the prize pool", 10, 1)
    GUICtrlCreateLabel("or completing a giveaway?", 10, 20)
    $Button5 = GUICtrlCreateButton("Add Prizes", 50, 50, 100, 25, $WS_GROUP)
    $Button6 = GUICtrlCreateButton("Run A Giveaway", 50, 75, 100, 25, $WS_GROUP)
    $Button7 = GUICtrlCreateButton("Cancel", 50, 100, 100, 25, $WS_GROUP)
    GUISetState(@SW_SHOW)

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            Case $Button5
                GUISetState(@SW_HIDE)
                fAddPrizes() ;This is to add dinos the community pot
                ExitLoop
            Case $Button6
                GUISetState(@SW_HIDE)
                ExitLoop
            Case $Button7 ;Exit the program
                Exit
        EndSwitch
    WEnd

EndFunc

Func fAddPrizes()
    ;When dinos are donated, here's where it's handled.
    ;Need to create a GUI to figure out who to add/remove stuff from and then put all of that in tempFile.txt

    $sDinoList = ""
    For $i = 0 To UBound($aDinoArray) - 1
        $sDinoList &= "|" & $aDinoArray[$i]
    Next

    $sGenderList = ""
    For $i = 0 To UBound($aGenderArray) - 1
        $sGenderList &= "|" & $aGenderArray[$i]
    Next

    ; Create a GUI
    $GiveawayBox = GUICreate("Community Prize Pot Menu", 500, 400)
    GUICtrlCreateLabel("Please Fill Out the Form Below", 10, 1)
    GUICtrlCreateLabel("Discord ID", 10, 32)
    GUICtrlCreateLabel("Dino", 140, 32)
    GUICtrlCreateLabel("Gender", 250, 32)
    GUICtrlCreateLabel("Amount To Add", 320, 25)
    GUICtrlCreateLabel("Use - for Removal", 320, 40)

    ;User ID Inputs
    $UserOneInput = GUICtrlCreateInput("UserID", 10, 60, 120, 20)
    $UserTwoInput = GUICtrlCreateInput("UserID", 10, 90, 120, 20)
    $UserThreeInput = GUICtrlCreateInput("UserID", 10, 120, 120, 20)
    $UserFourInput = GUICtrlCreateInput("UserID", 10, 150, 120, 20)
    $UserFiveInput = GUICtrlCreateInput("UserID", 10, 180, 120, 20)
    $UserSixInput = GUICtrlCreateInput("UserID", 10, 210, 120, 20)
    $UserSevenInput = GUICtrlCreateInput("UserID", 10, 240, 120, 20)
    $UserEightInput = GUICtrlCreateInput("UserID", 10, 270, 120, 20)
    $UserNineInput = GUICtrlCreateInput("UserID", 10, 300, 120, 20)
    $UserTenInput = GUICtrlCreateInput("UserID", 10, 330, 120, 20)

    ;DinoMenus
    $hUserOneCombo = GUICtrlCreateCombo("Dino", 140, 60, 100, 20)
    GUICtrlSetData($hUserOneCombo, $sDinoList)
    $hUserTwoCombo = GUICtrlCreateCombo("Dino", 140, 90, 100, 20)
    GUICtrlSetData($hUserTwoCombo, $sDinoList)
    $hUserThreeCombo = GUICtrlCreateCombo("Dino", 140, 120, 100, 20)
    GUICtrlSetData($hUserThreeCombo, $sDinoList)
    $hUserFourCombo = GUICtrlCreateCombo("Dino", 140, 150, 100, 20)
    GUICtrlSetData($hUserFourCombo, $sDinoList)
    $hUserFiveCombo = GUICtrlCreateCombo("Dino", 140, 180, 100, 20)
    GUICtrlSetData($hUserFiveCombo, $sDinoList)
    $hUserSixCombo = GUICtrlCreateCombo("Dino", 140, 210, 100, 20)
    GUICtrlSetData($hUserSixCombo, $sDinoList)
    $hUserSevenCombo = GUICtrlCreateCombo("Dino", 140, 240, 100, 20)
    GUICtrlSetData($hUserSevenCombo, $sDinoList)
    $hUserEightCombo = GUICtrlCreateCombo("Dino", 140, 270, 100, 20)
    GUICtrlSetData($hUserEightCombo, $sDinoList)
    $hUserNineCombo = GUICtrlCreateCombo("Dino", 140, 300, 100, 20)
    GUICtrlSetData($hUserNineCombo, $sDinoList)
    $hUserTenCombo = GUICtrlCreateCombo("Dino", 140, 330, 100, 20)
    GUICtrlSetData($hUserTenCombo, $sDinoList)

    ;GenderMenus

    $hUserOneGenderCombo = GUICtrlCreateCombo("Gender", 250, 60, 60, 20)
    GUICtrlSetData($hUserOneGenderCombo, $sGenderList)
    $hUserTwoGenderCombo = GUICtrlCreateCombo("Gender", 250, 90, 60, 20)
    GUICtrlSetData($hUserTwoGenderCombo, $sGenderList)
    $hUserThreeGenderCombo = GUICtrlCreateCombo("Gender", 250, 120, 60, 20)
    GUICtrlSetData($hUserThreeGenderCombo, $sGenderList)
    $hUserFourGenderCombo = GUICtrlCreateCombo("Gender", 250, 150, 60, 20)
    GUICtrlSetData($hUserFourGenderCombo, $sGenderList)
    $hUserFiveGenderCombo = GUICtrlCreateCombo("Gender", 250, 180, 60, 20)
    GUICtrlSetData($hUserFiveGenderCombo, $sGenderList)
    $hUserSixGenderCombo = GUICtrlCreateCombo("Gender", 250, 210, 60, 20)
    GUICtrlSetData($hUserSixGenderCombo, $sGenderList)
    $hUserSevenGenderCombo = GUICtrlCreateCombo("Gender", 250, 240, 60, 20)
    GUICtrlSetData($hUserSevenGenderCombo, $sGenderList)
    $hUserEightGenderCombo = GUICtrlCreateCombo("Gender", 250, 270, 60, 20)
    GUICtrlSetData($hUserEightGenderCombo, $sGenderList)
    $hUserNineGenderCombo = GUICtrlCreateCombo("Gender", 250, 300, 60, 20)
    GUICtrlSetData($hUserNineGenderCombo, $sGenderList)
    $hUserTenGenderCombo = GUICtrlCreateCombo("Gender", 250, 330, 60, 20)
    GUICtrlSetData($hUserTenGenderCombo, $sGenderList)

    ;AmountMenus
    $UserOneAmountInput = GUICtrlCreateInput("Amount", 320, 60, 60, 20)
    $UserTwoAmountInput = GUICtrlCreateInput("Amount", 320, 90, 60, 20)
    $UserThreeAmountInput = GUICtrlCreateInput("Amount", 320, 120, 60, 20)
    $UserFourAmountInput = GUICtrlCreateInput("Amount", 320, 150, 60, 20)
    $UserFiveAmountInput = GUICtrlCreateInput("Amount", 320, 180, 60, 20)
    $UserSixAmountInput = GUICtrlCreateInput("Amount", 320, 210, 60, 20)
    $UserSevenAmountInput = GUICtrlCreateInput("Amount", 320, 240, 60, 20)
    $UserEightAmountInput = GUICtrlCreateInput("Amount", 320, 270, 60, 20)
    $UserNineAmountInput = GUICtrlCreateInput("Amount", 320, 300, 60, 20)
    $UserTenAmountInput = GUICtrlCreateInput("Amount", 320, 330, 60, 20)

    ;Button
    $ButtonAddMore = GUICtrlCreateButton("Add More", 100, 360, 75, 25, $WS_GROUP)
    $ButtonContinue = GUICtrlCreateButton("Continue", 200, 360, 75, 25, $WS_GROUP)
    $ButtonCancel = GUICtrlCreateButton("Cancel", 300, 360, 75, 25, $WS_GROUP)

    GUISetState(@SW_SHOW)

    While 1
        $nMsg = GUIGetMsg()
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                Exit
            Case $ButtonAddMore
                ;Add to temp file and then run addPrizes again
                fAddToTempFile()
                fAddPrizes()
            Case $ButtonContinue
                ;Add to temp file, do not run addPrizes again
                fAddToTempFile()
                ;Do the runwait
                fRunOutput()
            Case $ButtonCancel
                Exit
        EndSwitch
    WEnd

    ;DiscordID,Dino,Gender,Amount
    ;Send that off to python to be added to giveaways.csv
    ;python returns with a serious of commands to run to remove the appropriate dinos
    ;call fRunOutput()

EndFunc

Func fAddToTempFile()

EndFunc

Func fGiveStuff()

EndFunc

Func fRunOutput()
    Local $i

    $hOutputFile = FileOpen("output.txt", $FO_READ + $FO_FULLFILE_DETECT)

    MsgBox ($MB_OK, "Completion", "Process Done, beginning discord input. Please click okay, then select the text input box on discord.")

    sleep(10000)

    For $i = 1 To _FileCountLines($hOutputFile)
        $line = FileReadLine($hOutputFile, $i)
        send("{!}a" & $line)
        send(Chr(10))
        sleep(2000)
    Next

    FileClose($hOutputFile)

    MsgBox($MB_OK, "Success", "Process Complete, all dino deals sorted.")

EndFunc
