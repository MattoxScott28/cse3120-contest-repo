.386
.stack 4096

; OPTION PROC:PRIVATE currently this raises an error when linking, we probably want them private but we will keep this commented out for now

;Board dimensions
MAP_WIDTH EQU 15
MAP_HEIGHT EQU 13





DisplayBoard PROTO
GetMove PROTO