@ECHO OFF
@REM ###########################################
@REM # Script file to run the flow 
@REM # 
@REM ###########################################
@REM #
@REM # Command line for ngdbuild
@REM #
ngdbuild -p xc7z020clg484-1 -nt timestamp -bm system.bmm "F:/Embedded-System-Design/Project/part3/implementation/system.ngc" -uc system.ucf system.ngd 

