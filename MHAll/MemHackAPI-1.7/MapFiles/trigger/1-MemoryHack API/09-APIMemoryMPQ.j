//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryMPQ
    globals
        integer pStorm279      = 0
        integer pExportFromMPQ = 0
    endglobals

    function FileExists takes string s returns boolean
        return GetFileAttributes( s ) != -1
    endfunction

    function GetFileSizeFromMPQ takes string source returns integer
        call WriteRealMemory( pReservedIntArg2, 0 )
        call WriteRealMemory( pReservedIntArg1, 0 )
        call std_call_5( ReadRealMemory( pStorm279 ), GetStringAddress( source ), pReservedIntArg2, pReservedIntArg1, 1, 0 )

        return ReadRealMemory( pReservedIntArg1 )
    endfunction

    function ExportFileFromMPQByAddr takes integer saddr, integer daddr returns integer
        if pExportFromMPQ > 0 then
            return fast_call_2( pExportFromMPQ, saddr, daddr )
        endif

        return 0
    endfunction

    function ExportFileFromMPQ takes string source, string dest returns boolean
        return ExportFileFromMPQByAddr( GetStringAddress( source ), GetStringAddress( dest ) ) > 0
    endfunction

    function LoadDllFromMPQ takes string source, string dest, string dllname returns boolean
        if ExportFileFromMPQ( source, dest ) then
            call LoadLibrary( dllname )
            return true
        endif

        return false
    endfunction

    function Init_APIMemoryMPQ takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                set pStorm279       = pGameDLL + 0x87F63C
                set pExportFromMPQ  = pGameDLL + 0x7386A0
        elseif PatchVersion == "1.26a" then
                set pStorm279       = pGameDLL + 0x86D5B8
                set pExportFromMPQ  = pGameDLL + 0x737F00
        elseif PatchVersion == "1.27a" then
                set pStorm279       = pGameDLL + 0x94E6C4
                set pExportFromMPQ  = pGameDLL + 0x702C50 // IDA Pro search text mov     edx, offset aWb ; "wb" -> look at the top align 10h -> push ebp and so on
        elseif PatchVersion == "1.27b" then
                set pStorm279       = pGameDLL + 0xA7C75C
                set pExportFromMPQ  = pGameDLL + 0x720390
        elseif PatchVersion == "1.28f" then
                set pStorm279       = pGameDLL + 0xA6B854
                set pExportFromMPQ  = pGameDLL + 0x754560
            endif
        endif
    endfunction
endlibrary

//===========================================================================
function InitTrig_APIMemoryMPQ takes nothing returns nothing
    //set gg_trg_APIMemoryMPQ = CreateTrigger(  )
endfunction
//! endnocjass
