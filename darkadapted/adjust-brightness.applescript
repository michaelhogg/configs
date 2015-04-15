set MIN_VALUE to 64
set MAX_VALUE to 255
set STEP_SIZE to 30

set RED_FACTOR   to 1.0
set GREEN_FACTOR to 0.635
set BLUE_FACTOR  to 0.295

on brighter(brightness)
    global MAX_VALUE, STEP_SIZE
    set brightness to brightness + STEP_SIZE
    if brightness > MAX_VALUE then
        set brightness to MAX_VALUE
    end if
    return brightness
end brighter

on darker(brightness)
    global MIN_VALUE, STEP_SIZE
    set brightness to brightness - STEP_SIZE
    if brightness < MIN_VALUE then
        set brightness to MIN_VALUE
    end if
    return brightness
end darker

tell application "DarkAdapted"
    set rgb to getGamma
end tell

set oldDelimiters to AppleScript's text item delimiters
set AppleScript's text item delimiters to ","
set rgb to every text item of rgb
set AppleScript's text item delimiters to oldDelimiters

set red   to (item 1 of rgb as integer)
set green to (item 2 of rgb as integer)
set blue  to (item 3 of rgb as integer)

# log "old rgb = " & red & "," & green & "," & blue

set brightness to brighter(red)
# set brightness to darker(red)

set red   to (brightness * RED_FACTOR)   as integer
set green to (brightness * GREEN_FACTOR) as integer
set blue  to (brightness * BLUE_FACTOR)  as integer

set newrgb to "" & red & "," & green & "," & blue

# log "new rgb = " & newrgb

tell application "DarkAdapted"
    setGamma value newrgb
end tell
