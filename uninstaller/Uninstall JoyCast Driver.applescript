-- JoyCast Driver Uninstaller
-- Native macOS uninstaller application

set driverPath to "/Library/Audio/Plug-Ins/HAL/JoyCast.driver"
set appName to "JoyCast Driver"

-- Check if driver exists
tell application "System Events"
	set driverExists to exists folder driverPath
end tell

if not driverExists then
	display dialog appName & " is not installed on this Mac." buttons {"OK"} default button "OK" with icon note with title appName & " Uninstaller"
	return
end if

-- Confirm uninstallation
set userChoice to display dialog "Do you want to completely remove " & appName & " from your Mac?" buttons {"Cancel", "Uninstall"} default button "Cancel" cancel button "Cancel" with icon caution with title appName & " Uninstaller"

if button returned of userChoice is "Uninstall" then
	try
		-- Remove driver and restart CoreAudio
		do shell script "rm -rf " & quoted form of driverPath & " && killall -9 coreaudiod 2>/dev/null || true" with administrator privileges

		-- Wait for CoreAudio to restart
		delay 2

		-- Verify removal
		tell application "System Events"
			set stillExists to exists folder driverPath
		end tell

		if stillExists then
			display dialog "Failed to remove " & appName & "." & return & return & "Please try again or remove manually." buttons {"OK"} default button "OK" with icon stop with title appName & " Uninstaller"
		else
			display dialog appName & " has been successfully removed!" buttons {"OK"} default button "OK" with icon note with title appName & " Uninstaller"
		end if

	on error errMsg number errNum
		if errNum is -128 then
			-- User cancelled password dialog
			display dialog "Uninstallation cancelled." buttons {"OK"} default button "OK" with icon note with title appName & " Uninstaller"
		else
			display dialog "An error occurred:" & return & return & errMsg buttons {"OK"} default button "OK" with icon stop with title appName & " Uninstaller"
		end if
	end try
end if
