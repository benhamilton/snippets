use AppleScript version “2.4” – Yosemite (10.10) or later
use scripting additions
tell application “Safari”
	set _URLs to {}
	set _topWindow to window 1
	set _tabURLs to every tab of _topWindow
	repeat with _item in _tabURLs
		set end of _URLs to URL of _item
	end repeat
	set _targets to _URLs
	if (count of _URLs) > 1 then
		repeat with _URL in _URLs
			repeat with _target in _targets
				if _URL is not equal to _target then
					tell application "Hook"
						set x to _URL
						set _src to make bookmark with data x
						set y to _target
						set _tgt to make bookmark with data y

						hook _src and _tgt
					end tell
				end if
			end repeat
		end repeat
	else
		display dialog "There must be 2 or more tabs."
	end if
end tell

