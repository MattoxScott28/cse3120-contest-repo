INCLUDE Irvine32.inc
INCLUDE Bomberman.inc

ExitProcess PROTO, dwExitCode:DWORD

.data

.code
main PROC

    INVOKE ExitProcess, 0

main ENDP
END main
