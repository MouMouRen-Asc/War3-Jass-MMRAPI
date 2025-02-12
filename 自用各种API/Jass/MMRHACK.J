library MMRHACK
    globals
        constant integer NULL               = 0 // Reserved for developer's ease of use.
        hashtable MemHackTable              = InitHashtable( )
        integer iGameVersion                = 0
        integer pGameDLL                    = 0
        string PatchVersion                 = ""

        code Code                   // This is not used, it's here just to fool Jasshelper
        code l__Code
        integer Int                 // This is not used, it's here just to fool Jasshelper
        integer l__Int
        unit Unit                   // This is not used, it's here just to fool Jasshelper
        unit l__Unit
        
        integer Array               // This is not used, it's here just to fool Jasshelper
        integer array l__Array
        integer ArrayA              // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayA
        integer ArrayB              // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayB
        integer ArrayC              // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayC
        integer bytecode            // This is not used, it's here just to fool Jasshelper
        integer array l__bytecode
        integer Memory              // This is not used, it's here just to fool Jasshelper
        integer array l__Memory
        
        integer iBytecodeData               = 0
    endglobals

    //# +nosemanticerror
    function setCode takes code c returns nothing
        set l__Code = c

        return // Prevents Jasshelper from inlining this function
    endfunction

    //# +nosemanticerror
    function setInt takes integer i returns nothing
        set l__Int = i

        return // Prevents Jasshelper from inlining this function
    endfunction

    //# +nosemanticerror
    function setUnit takes unit u returns nothing
        set l__Unit = u

        return // Prevents JassHelper from inlining this function
    endfunction

    //# +nosemanticerror
    function TypecastCode takes nothing returns nothing
        local integer Code // Jasshelper will implicitly rename this to l__Code
        local code Int     // Jasshelper will implicitly rename this to l__Int
    endfunction

    //# +nosemanticerror
    function C2I takes code c returns integer
        call setCode( c )
        
        loop
            return l__Code
        endloop
        
        return 0
    endfunction

    //# +nosemanticerror
    function I2C takes integer i returns code
        call setInt( i )

        loop 
            return l__Int
        endloop

        return null
    endfunction

    //# +nosemanticerror
    function TypecastUnit takes nothing returns nothing
        local integer Unit  // Jasshelper will implicitly rename this to l__Unit
        local unit Int      // Jasshelper will implicitly rename this to l__Int
    endfunction

    //# +nosemanticerror
    function U2I takes unit u returns integer
        call setUnit( u )

        loop  
            return l__Unit
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function I2U takes integer i returns unit
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction

    function GetTlsIndex takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ) )
    endfunction

    //# +nosemanticerror
    function BitwiseNot takes integer i returns integer
        return 0xFFFFFFFF - i
    endfunction

    function ReadMemory takes integer address returns integer
        return l__Memory[ address / 4 ]
    endfunction

    function ReadUnrealMemory takes integer address returns integer
        if address * 4 < 0x7FFFFFFF and address > 0x500 then
            return l__Memory[ address ]
        endif

        return 0
    endfunction

    function WriteMemory takes integer address, integer value returns nothing
        set l__Memory[ address / 4 ] = value
    endfunction

    function WriteUnrealMemory takes integer address, integer value returns nothing
        if address > 0x500 and address * 4 < 0x7FFFFFFF then
            set l__Memory[ address ] = value
            return
        endif
    endfunction

    function GetByteFromInteger takes integer i, integer byteid returns integer
        local integer tmpval = i
        local integer retval = 0
        local integer byte1  = 0
        local integer byte2  = 0
        local integer byte3  = 0
        local integer byte4  = 0
        
        if tmpval < 0 then
            set tmpval = BitwiseNot( tmpval )
            set byte4  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte3  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte2  = 255 - ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte1  = 255 - tmpval
        else
            set byte4  =  ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte3  =  ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte2  =  ModuloInteger( tmpval, 256 )
            set tmpval = tmpval / 256
            set byte1  = tmpval
        endif

        if byteid == 1 then
            return byte1
        elseif byteid == 2 then
            return byte2
        elseif byteid == 3 then
            return byte3
        elseif byteid == 4 then
            return byte4
        endif

        return retval
    endfunction

    function CreateInteger1 takes integer byte1, integer byte2, integer byte3, integer byte4 returns integer
        local integer retval = byte1
        
        set retval = ( retval * 256 ) + byte2
        set retval = ( retval * 256 ) + byte3
        set retval = ( retval * 256 ) + byte4
        
        return retval
    endfunction

    function CreateIntegerFromTwoByOffset takes integer arg1, integer arg2, integer offset returns integer
        local integer array pBytes
        
        set pBytes[ 0 ] = GetByteFromInteger( arg1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( arg1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( arg1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( arg1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( arg2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( arg2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( arg2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( arg2, 1 )
        
        return CreateInteger1( pBytes[ offset + 3 ], pBytes[ offset + 2 ], pBytes[ offset + 1 ], pBytes[ offset + 0 ] )
    endfunction

    function CreateDoubleIntegerAndGetOne takes integer arg1, integer arg2, integer value, integer offset, boolean first returns integer
        local integer array pBytes

        set pBytes[ 0 ] = GetByteFromInteger( arg1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( arg1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( arg1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( arg1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( arg2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( arg2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( arg2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( arg2, 1 )

        set pBytes[ offset + 0 ] = GetByteFromInteger( value, 4 )
        set pBytes[ offset + 1 ] = GetByteFromInteger( value, 3 )
        set pBytes[ offset + 2 ] = GetByteFromInteger( value, 2 )
        set pBytes[ offset + 3 ] = GetByteFromInteger( value, 1 )

        if first then
            return CreateInteger1( pBytes[ 3 ], pBytes[ 2 ], pBytes[ 1 ], pBytes[ 0 ] )
        else
            return CreateInteger1( pBytes[ 7 ], pBytes[ 6 ], pBytes[ 5 ], pBytes[ 4 ] )
        endif
    endfunction

    function ReadRealMemorySafe takes integer addr returns integer
        local integer byteOffset = addr - ( addr / 4 * 4 )
        local integer firstAddr  = addr - byteOffset
        
        return CreateIntegerFromTwoByOffset( ReadMemory( firstAddr + 0x0 ), ReadMemory( firstAddr + 0x4 ), byteOffset )
    endfunction

    function ReadRealMemory takes integer address returns integer
        if address < 0x500 or address > 0x7FFFFFFF then // MINIMAL_ACCESSABLE_ADDRESS
            return 0
        endif

        if address / 4 * 4 != address then
            return ReadRealMemorySafe( address )
        else
            return ReadMemory( address )
        endif
    endfunction

    function WriteRealMemorySafe takes integer addr, integer val returns nothing
        local integer Int_1
        local integer Int_2
        local integer byteOffset = addr - ( addr / 4 * 4 )
        local integer firstAddr  = addr - byteOffset

        set Int_1 = ReadRealMemory( firstAddr )
        set Int_2 = ReadRealMemory( firstAddr + 0x4 )
        call WriteMemory( firstAddr + 0x0, CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, byteOffset, true ) )
        call WriteMemory( firstAddr + 0x4, CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, byteOffset, false ) )
    endfunction

    function WriteRealMemory takes integer address, integer value returns nothing
        if address < 0x500 or address > 0x7FFFFFFF then // MINIMAL_ACCESSABLE_ADDRESS = 0x500
            return
        endif

        //if address == LoadInteger( MemHackTable, StringHash( "Memory" ), StringHash( "LockedMemory" ) ) then
        //    return
        //endif

        if address / 4 * 4 != address then
            call WriteRealMemorySafe( address, value )
        else
            call WriteMemory( address, value )
        endif
    endfunction

    //# +nosemanticerror
    function InitBytecode takes integer id, integer k returns nothing
        set l__bytecode[  0 ] = 0x0C010900  // op: 0C(LITERAL), type: 09(integer array), reg: 01,
        set l__bytecode[  1 ] = k           // value: 0x2114D008
        set l__bytecode[  2 ] = 0x11010000  // op: 11(SETVAR), reg: 01
        set l__bytecode[  3 ] = id          // id of variable l__Memory
        set l__bytecode[  4 ] = 0x0C010400  // op: 0C(LITERAL), type: 04(integer), reg: 01, value: 0
        set l__bytecode[  6 ] = 0x27000000  // op: 27(RETURN)
        set l__bytecode[  8 ] = 0x07090000  // op: 07(GLOBAL), type: 09 (integer array) //Create new array
        set l__bytecode[  9 ] = 0x0000005E  // name: 5E("i") | old: C5F("stand")
        set l__bytecode[ 10 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 // Obtain the desired amount of bytes
        set l__bytecode[ 11 ] = id + 0x1    // id of variable bytecodedata (variable ids are sequential)
        set l__bytecode[ 12 ] = 0x12010100  // op: 12(SETARRAY), index=reg01, value=reg01 // Set index of the array, forcing allocation of memory
        set l__bytecode[ 13 ] = 0x0000005E  // name: 5E("i")
        set l__bytecode[ 14 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 // Read array variable as an integer
        set l__bytecode[ 15 ] = 0x0000005E  // name: 5E("i")
        set l__bytecode[ 16 ] = 0x11010000  // op: 11(SETVAR), reg: 01 //pass the value to the jass world
        set l__bytecode[ 17 ] = id + 0x1    // id of variable bytecodedata
        set l__bytecode[ 18 ] = 0x27000000  // op: 27(RETURN)
    endfunction

    //# +nosemanticerror
    function InitArray takes integer vtable returns nothing
        set l__Array[ 4 ] = 0
        set l__Array[ 1 ] = vtable
        set l__Array[ 2 ] = 0xFFFFFFFF
        set l__Array[ 3 ] = 0xFFFFFFFF
    endfunction

    //# +nosemanticerror
    function InitArrayA takes integer index, integer valueA returns nothing
        set l__ArrayA[ 1000 ]      = 0
        set l__ArrayA[ index + 3 ] = valueA
        set l__ArrayA[ index + 2 ] = valueA
        set l__ArrayA[ index + 1 ] = valueA
        set l__ArrayA[ index + 0 ] = valueA
        set l__ArrayA[ index - 1 ] = valueA
        set l__ArrayA[ index - 2 ] = valueA
        set l__ArrayA[ index - 3 ] = valueA
    endfunction

    //# +nosemanticerror
    function InitArrayB takes integer index, integer valueB returns nothing
        set l__ArrayB[ 1000 ]  = 0
        set l__ArrayB[ index ] = valueB
    endfunction

    //# +nosemanticerror
    function WriteArrayBMemory takes integer addr, integer value returns nothing
        set l__ArrayB[ addr ] = value
    endfunction

    //# +nosemanticerror
    function InitArrayC takes integer index, integer valueD returns nothing
        set l__ArrayC[ 1001 ]  = 0
        set l__ArrayC[ index ] = valueD
    endfunction

    //# +nosemanticerror
    function TypecastByteCode takes nothing returns nothing
        local integer bytecode // Jasshelper will implicitly rename this to l__bytecode
    endfunction

    //# +nosemanticerror
    function GetBytecodeAddress takes nothing returns integer
        loop
            return l__bytecode
        endloop
        
        return 0
    endfunction

    //# +nosemanticerror
     function TypecastMemoryArray takes nothing returns nothing
        local integer Memory // Jasshelper will implicitly rename this to l__Memory
    endfunction

    //# +nosemanticerror
    function GetMemoryArrayAddress takes nothing returns integer
        loop
            return l__Memory
        endloop
            
        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArray takes nothing returns nothing //typecast Array to integer
        local integer Array // Jasshelper will implicitly rename this to l__Array
    endfunction

    //# +nosemanticerror
    function GetArrayAddress takes nothing returns integer
        loop
            return l__Array 
        endloop
        
        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayA takes nothing returns nothing
        local integer ArrayA // Jasshelper will implicitly rename this to l__ArrayA
    endfunction

    //# +nosemanticerror
    function GetArrayAAddress takes nothing returns integer
        loop
            return l__ArrayA
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayB takes nothing returns nothing
        local integer ArrayB // Jasshelper will implicitly rename this to l__ArrayB
    endfunction

    //# +nosemanticerror
    function GetArrayBAddress takes nothing returns integer
        loop
             return l__ArrayB
        endloop
        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayC takes nothing returns nothing
        local integer ArrayC // Jasshelper will implicitly rename this to l__ArrayD
    endfunction 

    //# +nosemanticerror
    function GetArrayCAddress takes nothing returns integer
        loop
            return l__ArrayC
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function NewGlobal takes nothing returns integer
        return -0x005E0704  //op: 07(GLOBAL), type: 04(integer), name: 0x005E("i")
        return 0x00002700   //op: 27(RETURN)
    endfunction

    //# +nosemanticerror
    function SetGlobal takes nothing returns nothing
        //This will actually set the value of the global variable, not the local
        local integer i = 0x2114D008 // op: 21(SUB), result, register2, register3
    endfunction


    function UnlockMemEx takes nothing returns nothing
        local integer array i
        local integer offset
        local integer arrAaddr
        local integer arrBaddr
        local integer arrCaddr
        local integer pMemory
        local integer addr = GetTlsIndex( )
        local integer ver = iGameVersion
        local integer pUnlockCall1 = 0
        local integer pUnlockCall2 = 0
        local integer pUnlockJmp1  = 0
        local integer jassVM       = 0
        local integer jassTable    = 0

        set iGameVersion = 0

        if addr == 0 then
            call BJDebugMsg( "TlsIndex ERROR!" )            
            return
        else
            set addr = i[ addr / 4 ]
            if addr == 0 then
                call BJDebugMsg( "TLSIndex ERROR!" )
                return
            endif

            set addr = i[ ( addr + 0x14 ) / 4 ]
            if addr == 0 then
                call BJDebugMsg( "JassThreadLocal ERROR!" )
                return
            endif

            set addr = i[ ( addr + 0x90 ) / 4 ]
            if addr == 0 then
                call BJDebugMsg( "JassVMList ERROR!" )
                return
            endif

            set addr = i[ addr / 4 + 1 ]
            if addr == 0 then
                call BJDebugMsg( "JassVM ERROR!" )
                return
            endif
        endif
        set jassVM = addr //i[ i[ i[ i[ pJassEnvAddress / 4 ] / 4 + 5 ] / 4 + 36 ] / 4 + 1 ]

        set addr = i[ ( addr + 0x28A4 ) / 4 ]
        if addr == 0 then
            call BJDebugMsg( "stringAddressTable ERROR!" )
            return
        else
            set addr = i[ addr / 4 ]
            if addr == 0 then
                call BJDebugMsg( "CGameState ERROR!" )
                return
            endif
            
            set addr = i[ ( addr + 0x19C ) / 4 ]
            if addr == 0 then
                call BJDebugMsg( "handleList ERROR!" )
                return
            endif
        endif
        set jassTable = addr //i[ i[ i[ JassVM / 4 + 0x28A4 / 4 ] / 4 ] / 4 + 0x19C / 4 ]

        if PatchVersion == "1.27b" then
            set pUnlockCall1    = pGameDLL + 0x3F4C50 // *(_DWORD *)this + 164))(); main func
            set pUnlockCall2    = pGameDLL + 0x124142 // search v1 = a1 > 0.0; -> go to ida -> 3 functions below to push    esi
            set pUnlockJmp1     = pGameDLL + 0x684BA0 // Under "Async set local leader to %s %x:%x for player %d" | (v10 = 
    elseif PatchVersion == "1.28f" then
            set pUnlockCall1    = pGameDLL + 0x428D30
            set pUnlockCall2    = pGameDLL + 0x152802
            set pUnlockJmp1     = pGameDLL + 0x6B8D30
        endif

        call WriteMemory( 0, 0 )
        set pMemory = GetMemoryArrayAddress( ) // JassArray

        call InitArrayA( 0, 0 )
        set arrAaddr = GetArrayAAddress( )
        call InitArrayB( 0, 0 )
        set arrBaddr = GetArrayBAddress( )
        call InitArrayC( 0, 0 )
        set arrCaddr = GetArrayCAddress( )

        call InitArrayA( 0, i[ arrAaddr / 4 ] )
        call InitArrayB( 0, i[ arrBaddr / 4 ] )
        call InitArrayC( 0, i[ arrCaddr / 4 ] )

        set offset = ( i[ ( arrCaddr + 0xC ) / 4 ] + 4 ) - ( i[ ( arrBaddr + 0xC ) / 4 ] ) // JassTable - 1 ?
 
        call InitArrayC(  8, pUnlockCall1 ) // 1 + 0x1C / 4 // set l__ArrayC[ 8 ] = pUnlockCall1
        call InitArrayC( 42, pUnlockCall2 ) // 1 + 0xA4 / 4 // set l__ArrayC[ 42 ] = pUnlockCall2
        call InitArrayC( 24, pUnlockJmp1  ) // 1 + 0x5C / 4 // set l__ArrayC[ 24 ] = pUnlockJmp1

        call InitArrayC( 2, arrBaddr + 0x8 - offset )
        call InitArrayC( 1, arrBaddr + 0x8 )

        call InitArrayB( 1, i[ ( arrCaddr + 0xC ) / 4 ] + 4 ) // l__ArrayB[ 1 ] = 
        call InitArrayB( 2, pMemory )

        call InitArrayA( 4, i[ ( arrBaddr + 0xC ) / 4 ] + 4 )

        set addr = i[ ( arrAaddr + 0xC ) / 4 ]
        if addr == 0 then
            call BJDebugMsg( "addr ERROR!" )
            return
        endif
        set addr = ( addr + 0x10 )
        //set b = JassTable - ModuloInteger( addr, 3 ) // handleList
        set addr = ( ( addr - jassTable + 0xBFFFFC ) / 4 ) / 3 // Gets handleid of arrBaddr

        call SetUnitUserData( I2U( addr ), 23 )
        
        call WriteArrayBMemory( ( offset    + 0x0 ) / 4, 0xFFFFFFFF )
        call WriteArrayBMemory( ( offset    + 0x4 ) / 4, 0 )
        call WriteArrayBMemory( ( arrBaddr  + 0x4 ) / 4, 0xFFFFFFFF )

        call WriteArrayBMemory( ( pMemory + 0x4 ) / 4, 0xFFFFFFFF )
        call WriteArrayBMemory( ( pMemory + 0x8 ) / 4, 0xFFFFFFFF )
        call WriteArrayBMemory( ( pMemory + 0xC ) / 4, 0 )
        
        set iGameVersion = ver
    endfunction

    //# +nosemanticerror
    function UnlockMemory takes nothing returns nothing
        local integer array i
        local boolean IsExtra = false

        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function NewGlobal ) + 0x2 ) )
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function SetGlobal ) + 0x8 ) )
        // local array "i" can now read memory, but not write.
        call InitArray( 0 )
        set pGameDLL = i[ GetArrayAddress( ) / 4 ] // JassArray
        call InitArray( pGameDLL )

        set iGameVersion = pGameDLL - i[ pGameDLL / 4 ] // JassArray - JassArray::Free

        if iGameVersion == 0x5084A8 then
            set PatchVersion    = "1.24e"
            set pGameDLL        = pGameDLL - 0x9631B8
            call SaveInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ),       pGameDLL + 0xAF16A8 )
    elseif iGameVersion == 0x4F6E60 then
            set PatchVersion    = "1.26a"
            set pGameDLL        = pGameDLL - 0x951060
            call SaveInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ),       pGameDLL + 0xADA848 )
    elseif iGameVersion == 0x277890 then
            set PatchVersion    = "1.27a"
            set pGameDLL        = pGameDLL - 0xA63B30
            call SaveInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ),       pGameDLL + 0xBE3740 )
    elseif iGameVersion == 0x2C1554 then
            set PatchVersion    = "1.27b"
            set pGameDLL        = pGameDLL - 0xBD7214
            call SaveInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ),       pGameDLL + 0xD46118 )
            set IsExtra = true
    elseif iGameVersion == 0x2BF828 then
            set PatchVersion    = "1.28f"
            set pGameDLL        = pGameDLL - 0xB8A438
            call SaveInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ),       pGameDLL + 0xD0DEF8 )
            set IsExtra = true
        endif
        
        if PatchVersion != "" then
            // The bytecode unlocks the ability to read and write memory
            // with the "Memory" array

            if IsExtra then // 1.27b and higher required code execution to get access to bytecode.
                call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemEx ) + 0x8 ) )
            endif

            if iGameVersion != 0 then
                call InitBytecode( i[ ( C2I( function ReadMemory ) + 0x34 ) / 4 ], i[ ( GetArrayAddress( ) + 0xC ) / 4 ] + 0x4 )
                call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( i[ ( GetBytecodeAddress( ) + 0xC ) / 4 ] ) )

                call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "MemHackAPI v1.7.5 (Lite)" )
                call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Patch Version: " + PatchVersion )
                
                call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "TlsIndex: " + I2S( ReadRealMemory( LoadInteger( MemHackTable, StringHash( "Memory" ), StringHash( "TlsIndex" ) ) ) ) )
            endif
        endif
        
        
    endfunction

    function RunUnlockMem takes nothing returns nothing
        local force pg = CreateForce()
        call ForceAddPlayer( pg, Player( 0 ) )
        call ForForce( pg, I2C( C2I( function UnlockMemory ) + 0x8 ) )
    endfunction

    function InitTrig_MemoryHack takes nothing returns nothing
    // set bj_FORCE_PLAYER[ 0 ] = CreateForce( )
    // call ForceAddPlayer( bj_FORCE_PLAYER[ 0 ], Player( 0 ) )
    // call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemory ) + 0x8 ) )
    call TimerStart(CreateTimer(),0,false, function RunUnlockMem)
endfunction

endlibrary

