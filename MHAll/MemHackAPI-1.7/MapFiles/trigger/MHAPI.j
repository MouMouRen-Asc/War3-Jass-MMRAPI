//! nocjass
native MergeUnits   takes integer qty, integer a, integer b, integer make returns boolean    // reserved native for call 4 integer function and return BOOLEAN value
native ConvertUnits takes integer qty, integer id returns boolean                            // reserved native for call 2 integer function and return BOOLEAN value (can be converted to int!)
native IgnoredUnits takes integer unitid returns integer                                     // reserved native for call 1 integer function and return integer value


library APIBasicUtils
    globals
        boolean IsPrint = false
        constant string sLetters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    endglobals

    function absI takes integer number returns integer
        if number < 0 then
            return -number
        endif

        return number
    endfunction

    function absF takes real r returns real
        if r < 0. then
            return -r
        endif

        return r
    endfunction

    function floorF takes real r returns real
        if r < 0. then
            return -I2R( R2I( -r ) )
        endif
        
        return I2R( R2I( r ) )
    endfunction

    function floorI takes integer i returns integer
        return R2I( floorF( I2R( i ) ) )
    endfunction

    function ceilF takes real r returns real
        if floorF( r ) == r then
            return r
        elseif r < 0. then
            return -( I2R( R2I( -r ) ) + 1. )
        endif
        
        return I2R( R2I( r ) ) + 1.
    endfunction

    function ceilI takes integer i returns integer
        return R2I( ceilF( I2R( i ) ) )
    endfunction

    function roundF takes real r returns real
        if r > 0. then
            return I2R( R2I( r + .5 ) )
        endif
        
        return I2R( R2I( r - .5 ) )
    endfunction

    function roundI takes integer i returns integer
        return R2I( roundF( I2R( i ) ) )
    endfunction

    function log takes integer number, integer base returns integer
        local integer id = 1

        if number > 0 then
            loop
                exitwhen number / base <= 1
                set id = id + 1
                set number = number / base
            endloop

            return id
        endif

        return 0
    endfunction

    function PowI takes integer x, integer power returns integer
        local integer y = x

        if power == 0 then
            set x = 1
    elseif power > 1 then
            loop
                set power = power - 1
                exitwhen power == 0
                set x = x * y
            endloop
        endif

        return x
    endfunction

    function B2S takes boolean flag returns string
        if flag then
            return "yes"
        endif
        
        return "no"
    endfunction

    function CharToId takes string input returns integer
        local integer pos = 0
        local string char

        loop
            set char = SubString( sLetters, pos, pos + 1 )
            exitwhen char == null or char == input
            set pos = pos + 1
        endloop

        if pos < 10 then
            return pos + 48
        elseif pos < 36 then
            return pos + 65 - 10
        endif

        return pos + 97 - 36
    endfunction

    function StringToId takes string input returns integer
        return ( ( CharToId( SubString( input, 0, 1 ) ) * 256 + CharToId( SubString( input, 1, 2 ) ) ) * 256 + CharToId( SubString( input, 2, 3 ) ) ) * 256 + CharToId( SubString( input, 3, 4 ) )
    endfunction

    function IdToChar takes integer input returns string
        local integer pos = input - 48

        if input >= 97 then
            set pos = input - 97 + 36
        elseif input >= 65 then
            set pos = input - 65 + 10
        endif

        return SubString( sLetters, pos, pos + 1 )
    endfunction

    function IdToString takes integer input returns string
        local integer result = input / 256
        local string char    = IdToChar( input - 256 * result )

        set input  = result / 256
        set char   = IdToChar( result - 256 * input ) + char
        set result = input / 256

        return IdToChar( result ) + IdToChar( input - 256 * result ) + char
    endfunction

    function GetIntHex takes integer i returns string
        local string result = ""
        local integer numb  = absI( i )

        if numb >= 0 and numb <= 15 then
            if numb <= 9 then
                set result = I2S( numb )
            elseif numb == 10 then
                set result = "A"
            elseif numb == 11 then
                set result = "B"
            elseif numb == 12 then
                set result = "C"
            elseif numb == 13 then
                set result = "D"
            elseif numb == 14 then
                set result = "E"
            elseif numb == 15 then
                set result = "F"
            endif
        endif

        return result
    endfunction

    function IntToHex takes integer i returns string
        local string result = ""
        local boolean ispos = i >= 0
        local integer numb  = absI( i )
        local integer j     = 0

        loop
            exitwhen numb == 0
            set j = numb - ( numb / 16 ) * 16
            set result = GetIntHex( j ) + result
            set numb = ( numb - j ) / 16
        endloop

        set result = "0x" + result

        if not ispos then
            set result = "-" + result
        endif

        return result
    endfunction

    function PrintData takes string path, string s, boolean flag returns nothing
        if not IsPrint then
            call PreloadGenClear( )
            call PreloadGenStart( )
            set IsPrint = true
        endif

        if IsPrint then
            call Preload( s )

            if flag then
                call PreloadGenEnd( path )
                set IsPrint = false
            endif
        endif
    endfunction
endlibrary
library APIAllTypecast
    globals
        code Code               // This is not used, it's here just to fool Jasshelper
        code l__Code
        integer Int             // This is not used, it's here just to fool Jasshelper
        integer l__Int
        string Str              // This is not used, it's here just to fool Jasshelper
        string l__Str
        boolean Bool            // This is not used, it's here just to fool Jasshelper
        boolean l__Bool
        handle Handle           // This is not used, it's here just to fool Jasshelper
        handle l__Handle
        unit Unit               // This is not used, it's here just to fool Jasshelper
        unit l__Unit
        ability Abil            // This is not used, it's here just to fool Jasshelper
        ability l__Abil
        trigger Trig            // This is not used, it's here just to fool Jasshelper
        trigger l__Trig
        integer Array           // This is not used, it's here just to fool Jasshelper
        integer array l__Array
        integer ArrayA          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayA
        integer ArrayB          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayB
        integer ArrayC          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayC
        integer ArrayD          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayD
        integer ArrayE          // This is not used, it's here just to fool Jasshelper
        integer array l__ArrayE
        integer bytecode        // This is not used, it's here just to fool Jasshelper
        integer array l__bytecode
        integer pbytecode
    endglobals

    //# +nosemanticerror
    function InitBytecode takes integer id, integer k returns nothing
        set l__bytecode[  0 ] = 0x0C010900  // op: 0C(LITERAL), type: 09(integer array), reg: 01,
        set l__bytecode[  1 ] = k           // value: 0x2114D008
        set l__bytecode[  2 ] = 0x11010000  // op: 11(SETVAR), reg: 01
        set l__bytecode[  3 ] = id          // id of variable l__Memory
        set l__bytecode[  4 ] = 0x0C010400  // op: 0C(LITERAL), type: 04(integer), reg: 01, value: 0
        set l__bytecode[  6 ] = 0x27000000  // op: 27(RETURN)
        set l__bytecode[  8 ] = 0x07090000  // op: 07(GLOBAL), type: 09 (integer array) //Create new array
        set l__bytecode[  9 ] = 0x005E      // name: 5E("i") | old: C5F("stand")
        set l__bytecode[ 10 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 //Obtain the desired amount of bytes
        set l__bytecode[ 11 ] = id + 0x1    // id of variable bytecodedata (variable ids are sequential)
        set l__bytecode[ 12 ] = 0x12010100  // op: 12(SETARRAY), index=reg01, value=reg01 //Set index of the array, forcing allocation of memory
        set l__bytecode[ 13 ] = 0x005E      // name: 5E("i")
        set l__bytecode[ 14 ] = 0x0E010400  // op: 0E(GETVAR), type: 04(integer), reg: 01 //Read array variable as an integer
        set l__bytecode[ 15 ] = 0x005E      // name: 5E("i")
        set l__bytecode[ 16 ] = 0x11010000  // op: 11(SETVAR), reg: 01 //pass the value to the jass world
        set l__bytecode[ 17 ] = id + 0x1    // id of variable bytecodedata
        set l__bytecode[ 18 ] = 0x27000000  // op: 27(RETURN)
    endfunction
    //# +nosemanticerror
    function Typecast takes nothing returns nothing
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
    function InitArray takes integer vtable returns nothing
        set l__Array[ 4 ] = 0
        set l__Array[ 1 ] = vtable
        set l__Array[ 2 ] = -1
        set l__Array[ 3 ] = -1
    endfunction
    //# +nosemanticerror
    function InitArrayA takes integer index, integer valueA returns nothing
        set l__ArrayA[ 1000 ]        = 0
        set l__ArrayA[ index + 3 ] = valueA
        set l__ArrayA[ index + 2 ] = valueA
        set l__ArrayA[ index + 1 ] = valueA
        set l__ArrayA[ index     ] = valueA
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
        local integer ii    = addr
        set l__ArrayB[ ii ] = value
    endfunction

    //# +nosemanticerror
    function InitArrayC takes integer valueC returns nothing
        set l__ArrayC[ 4 ] = 0
        set l__ArrayC[ 3 ] = valueC
        set l__ArrayC[ 2 ] = valueC
        set l__ArrayC[ 1 ] = valueC
        set l__ArrayC[ 0 ] = valueC
    endfunction

    //# +nosemanticerror
    function InitArrayD takes integer index, integer valueD returns nothing
        set l__ArrayD[ 1001 ]  = 0
        set l__ArrayD[ index ] = valueD
    endfunction

    //# +nosemanticerror
    function InitArrayE takes integer valueE returns nothing
        set l__ArrayE[ 4 ] = 0
        set l__ArrayE[ 3 ] = valueE
        set l__ArrayE[ 2 ] = valueE
        set l__ArrayE[ 1 ] = valueE
        set l__ArrayE[ 0 ] = valueE
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
        local integer ArrayC // Jasshelper will implicitly rename this to l__ArrayC
    endfunction 

    //# +nosemanticerror
    function GetArrayCAddress takes nothing returns integer
        loop
            return l__ArrayC
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayD takes nothing returns nothing
        local integer ArrayD // Jasshelper will implicitly rename this to l__ArrayD
    endfunction 

    //# +nosemanticerror
    function GetArrayDAddress takes nothing returns integer
        loop
            return l__ArrayD
        endloop

        return 0
    endfunction

    //# +nosemanticerror
    function TypecastArrayE takes nothing returns nothing
        local integer ArrayE // Jasshelper will implicitly rename this to l__ArrayE
    endfunction 

    //# +nosemanticerror
    function GetArrayEAddress takes nothing returns integer
        loop
            return l__ArrayE
        endloop

        return 0
    endfunction
    
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
    function setStr takes string s returns nothing
        set l__Str = s

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setBool takes boolean b returns nothing
        set l__Bool = b

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setHandle takes handle h returns nothing
        set l__Handle = h

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setUnit takes unit u returns nothing
        set l__Unit = u

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setAbility takes ability a returns nothing
        set l__Abil = a

        return // Prevents JassHelper from inlining this function
    endfunction
    //# +nosemanticerror
    function setTrig takes trigger t returns nothing
        set l__Trig = t

        return // Prevents Jasshelper from inlining this function
    endfunction
    //# +nosemanticerror
    function Typecast1 takes nothing returns nothing
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
    function Typecast2 takes nothing returns nothing
        local integer Str   // Jasshelper will implicitly rename this to l__Str
        local string Int    // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function SH2I takes string s returns integer
        call setStr( s )

        loop
            return l__Str
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2SH takes integer i returns string
        call setInt( i )

        loop 
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast3 takes nothing returns nothing
        local integer Bool // Jasshelper will implicitly rename this to l__Bool
        local boolean Int  // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function B2I takes boolean b returns integer
        call setBool( b )

        loop 
            return l__Bool
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2B takes integer i returns boolean
        call setInt( i )

        loop
            return l__Int
        endloop

        return false
    endfunction
    //# +nosemanticerror
    function Typecast4 takes nothing returns nothing
        local integer Handle    // Jasshelper will implicitly rename this to l__Handle
        local handle Int        // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function H2I takes handle h returns integer
        call setHandle( h )

        loop  
            return l__Handle
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2H takes integer i returns handle
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast5 takes nothing returns nothing
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
    //# +nosemanticerror
    function Typecast6 takes nothing returns nothing
        local integer Abil  // Jasshelper will implicitly rename this to l__Abil
        local ability Int   // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function A2I takes ability a returns integer
        call setAbility( a )

        loop  
            return l__Abil
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2A takes integer i returns ability
        call setInt( i )

        loop  
            return l__Int
        endloop

        return null
    endfunction
    //# +nosemanticerror
    function Typecast7 takes nothing returns nothing
        local integer Trig // Jasshelper will implicitly rename this to l__Trig
        local trigger Int  // Jasshelper will implicitly rename this to l__Int
    endfunction
    //# +nosemanticerror
    function T2I takes trigger t returns integer
        call setTrig( t )

        loop  
            return l__Trig
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function I2T takes integer i returns trigger
        call setInt( i )

        return l__Int
    endfunction
    //# +nosemanticerror
    function RealToIndex takes real r returns integer
        loop
            return r
        endloop

        return 0
    endfunction
    //# +nosemanticerror
    function CleanInt takes integer i returns integer
        return i
    endfunction
    //# +nosemanticerror
    function IndexToReal takes integer i returns real
        loop
            return i
        endloop

        return 0.
    endfunction
    //# +nosemanticerror
    function CleanReal takes real r returns real
        return r
    endfunction
    //# +nosemanticerror
    function GetRealFromMemory takes integer i returns real
        return CleanReal( IndexToReal( i ) )
    endfunction
    //# +nosemanticerror
    function SetRealIntoMemory takes real r returns integer
        return CleanInt( RealToIndex( r ) )
    endfunction
    //# +nosemanticerror
    function BitwiseNot takes integer i returns integer
        return 0xFFFFFFFF - i
    endfunction
    
    function Init_APITypecast takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif
        endif
    endfunction
endlibrary
library APIMemory
    globals
        constant integer NULL               = 0 // Reserved for developer's ease of use.
        hashtable MemHackTable              = InitHashtable( )

        integer iGameVersion                = 0
        integer pGameDLL                    = 0
        string PatchVersion                 = ""
        integer pMemory                     = 0
        integer array RJassNativesBuffer
        integer Memory // This is not used, it's here just to fool Jasshelper
        integer array l__Memory
        integer iBytecodeData

        integer pPointers                   = 0
        integer pWriteMemory                = 0
        integer pJassEnvAddress             = 0
        integer RJassNativesBufferSize      = 0

        integer JassVM                      = 0
        integer JassTable                   = 0

        integer pUnlockCall1                = 0
        integer pUnlockCall2                = 0
        integer pUnlockJmp1                 = 0
    endglobals

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
            set byte4  =  ModuloInteger( tmpval, 256)
            set tmpval = tmpval / 256
            set byte3  =  ModuloInteger( tmpval, 256)
            set tmpval = tmpval / 256
            set byte2  =  ModuloInteger( tmpval, 256)
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

    // addr 0x10000 data 1C 2C 8A 7D 6D 5F 5A 4C 6C 3C 8C 7A
    // read memory at 0x10003   ( 7D 6D 5F 5A )
    function CreateIntegerFromTwoByOffset takes integer LocalInteger1, integer LocalInteger2, integer offset returns integer
        local integer array pBytes
        
        set pBytes[ 0 ] = GetByteFromInteger( LocalInteger1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( LocalInteger1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( LocalInteger1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( LocalInteger1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( LocalInteger2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( LocalInteger2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( LocalInteger2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( LocalInteger2, 1 )
        
        return CreateInteger1( pBytes[ offset + 3 ], pBytes[ offset + 2 ], pBytes[ offset + 1 ], pBytes[ offset + 0 ] )
    endfunction

    function CreateDoubleIntegerAndGetOne takes integer LocalInteger1, integer LocalInteger2, integer value, integer offset, boolean first returns integer
        local integer array pBytes

        set pBytes[ 0 ] = GetByteFromInteger( LocalInteger1, 4 )
        set pBytes[ 1 ] = GetByteFromInteger( LocalInteger1, 3 )
        set pBytes[ 2 ] = GetByteFromInteger( LocalInteger1, 2 )
        set pBytes[ 3 ] = GetByteFromInteger( LocalInteger1, 1 )
        set pBytes[ 4 ] = GetByteFromInteger( LocalInteger2, 4 )
        set pBytes[ 5 ] = GetByteFromInteger( LocalInteger2, 3 )
        set pBytes[ 6 ] = GetByteFromInteger( LocalInteger2, 2 )
        set pBytes[ 7 ] = GetByteFromInteger( LocalInteger2, 1 )

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

    function ReadMemory takes integer address returns integer
        return l__Memory[ address / 4 ]
    endfunction

    function ReadRealMemorySafe takes integer addr returns integer
        local integer ByteOffset = addr - ( addr / 4 * 4 )
        local integer FirstAddr = addr - ByteOffset
        
        return CreateIntegerFromTwoByOffset( l__Memory[ FirstAddr / 4 ], l__Memory[ FirstAddr / 4 + 1 ] , ByteOffset )
    endfunction

    function ReadUnrealMemory takes integer address returns integer
        if address * 4 < 0x7Fffffff and address > 0x500 then
            return l__Memory[ address ]
        endif

        return 0
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

    function RMem takes integer address returns integer
        return ReadRealMemory( address )
    endfunction
    
    function ReadOffset takes integer pOff returns integer
        return ReadRealMemory( pGameDLL + pOff )
    endfunction

    function ReadOffsetUnsafe takes integer pOff returns integer
        return ReadUnrealMemory( ( pGameDLL + pOff ) / 4 )
    endfunction

    function ReadByte takes integer byte returns integer
        return GetByteFromInteger( ReadRealMemory( byte ), 4 )
    endfunction
    
    function ReadRealFloat takes integer address returns real
        return GetRealFromMemory( ReadRealMemory( address ) )
    endfunction

    function WriteMemory takes integer address, integer value returns nothing
        set l__Memory[ address / 4 ] = value
    endfunction

    function WriteRealMemorySafe takes integer addr, integer val returns nothing
        local integer Int_1
        local integer Int_2
        local integer ByteOffset = addr - ( addr / 4 * 4 )
        local integer FirstAddr = addr - ByteOffset

        set Int_1                           = ReadRealMemory( FirstAddr )
        set Int_2                           = ReadRealMemory( FirstAddr + 0x4 )
        set l__Memory[ FirstAddr / 4 ]      = CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, ByteOffset, true )
        set l__Memory[ FirstAddr / 4 + 1 ]  = CreateDoubleIntegerAndGetOne( Int_1, Int_2, val, ByteOffset, false )
    endfunction

    function WriteUnrealMemory takes integer address, integer value returns nothing
        if address > 0x500 and address * 4 < 0x7FFFFFFF then
            set l__Memory[ address ] = value
            return
        endif
    endfunction

    function WriteRealMemory takes integer address, integer value returns nothing
        if address < 0x500 or address > 0x7FFFFFFF then // MINIMAL_ACCESSABLE_ADDRESS = 0x500
            return
        endif

        if address == pWriteMemory then
            return
        endif

        if address / 4 * 4 != address then
            call WriteRealMemorySafe( address, value )
        else
            call WriteMemory( address, value )
        endif
    endfunction

    function WMem takes integer address, integer value returns nothing
        call WriteRealMemory( address, value )
    endfunction
    
    function WriteOffset takes integer pOff, integer value returns nothing
        call WriteRealMemory( pGameDLL + pOff, value )
    endfunction

    function WriteOffsetUnsafe takes integer pOff, integer value returns nothing
        call WriteUnrealMemory( pGameDLL + pOff, value )
    endfunction

    function WriteRealFloat takes integer address, real value returns nothing
        call WriteRealMemory( address, SetRealIntoMemory( value ) )
    endfunction
    //# +nosemanticerror
    function NewGlobal takes nothing returns integer
        return -0x005E0704  //op: 07(GLOBAL), type: 04(integer), name: 0x005E("i")
        return 0x2700       //op: 27(RETURN)
    endfunction

    //# +nosemanticerror
    function SetGlobal takes nothing returns nothing
        //This will actually set the value of the global variable, not the local
        local integer i = 0x2114D008
    endfunction

    function Malloc takes integer bytes returns integer
        set iBytecodeData = bytes / 4 + 0x4
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( l__Memory[ GetBytecodeAddress( ) / 4 + 0x3 ] + 0x20 ) )
        return ( ReadUnrealMemory( iBytecodeData / 4 + 0x3 ) + 0x4 ) / 4 * 4 // Address of data in the newly created array
    endfunction

    function ConvertPointer takes integer ptr returns integer
        local integer i = ReadRealMemory( ptr )

        if i < 0 then
            return ReadRealMemory( ReadRealMemory( pPointers + 0x2C ) - i * 8 + 0x4 ) //checkme
        endif

        return ReadRealMemory( ReadRealMemory( pPointers + 0xC ) + i * 8 + 0x4 )
    endfunction

    function ReadRealPointer1LVL takes integer addr, integer offset1 returns integer
        local integer retval = 0
        
        if addr > 0 then
            set retval = ReadRealMemory( addr )
            
            if addr > 0 then
                set retval = ReadRealMemory( retval + offset1 )
            else
                set retval = 0
            endif
        endif
        
        return retval
    endfunction

    function WriteRealPointer1LVL takes integer addr, integer offset1, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealMemory( addr )

            if addr > 0 then 
                call WriteRealMemory( retval + offset1, val )
            endif
        endif
    endfunction

    function ReadRealPointer2LVL takes integer addr, integer offset1, integer offset2 returns integer
        local integer retval = ReadRealPointer1LVL( addr, offset1 )
        
        if retval > 0 then
            set retval = ReadRealMemory( retval + offset2 )
        else
            set retval = 0
        endif
        
        return retval
    endfunction

    function WriteRealPointer2LVL takes integer addr, integer offset1, integer offset2, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer1LVL( addr, offset1 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset2, val )
            endif
        endif
    endfunction 

    function ReadRealPointer3LVL takes integer addr, integer offset1, integer offset2, integer offset3 returns integer
        local integer retval = ReadRealPointer2LVL( addr, offset1, offset2 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset3 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer3LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer2LVL( addr, offset1, offset2 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset3, val )
            endif
        endif
    endfunction

    function ReadRealPointer4LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4 returns integer
        local integer retval = ReadRealPointer3LVL( addr, offset1, offset2, offset3 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset4 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer4LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer3LVL( addr, offset1, offset2, offset3 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset4, val )
            endif
        endif
    endfunction

    function ReadRealPointer5LVL takes integer addr, integer offset1, integer offset2, integer offset3, integer offset4, integer offset5 returns integer
        local integer retval = ReadRealPointer4LVL( addr, offset1, offset2, offset3, offset4 )

        if retval > 0 then 
            set retval = ReadRealMemory( retval + offset5 )
        else
            set retval = 0
        endif

        return retval
    endfunction

    function WriteRealPointer5LVL takes integer addr, integer offset1, integer offset2,integer offset3, integer offset4,integer offset5, integer val returns nothing
        local integer retval = 0

        if addr > 0 then 
            set retval = ReadRealPointer4LVL( addr, offset1, offset2, offset3, offset4 )

            if addr > 0 then 
                call WriteRealMemory( retval + offset5, val )
            endif
        endif
    endfunction

    function IsJassNativeExists takes integer nativeaddress returns boolean
        local integer FirstAddress = ReadRealPointer2LVL( pJassEnvAddress, 0x14, 0x20 )
        local integer NextAddress = FirstAddress
        local integer i = 0

        loop 
            if ReadRealMemory( NextAddress + 0xC ) == nativeaddress then
                return NextAddress > 0
            endif
            
            set NextAddress = ReadRealMemory( NextAddress )
            if NextAddress == FirstAddress or NextAddress == 0 then
                return false
            endif
        endloop

        return false
    endfunction

    function CreateJassNativeHook takes integer oldaddress, integer newaddress returns integer
        local integer FirstAddress    = ReadRealPointer2LVL( pJassEnvAddress, 0x14, 0x20 )
        local integer NextAddress     = FirstAddress
        local integer i = 0
     
        if RJassNativesBufferSize > 0 then
            loop
                set i = i + 1
           
                if RJassNativesBuffer[ i * 3 - 0x3 ] == oldaddress or RJassNativesBuffer[ i * 3 - 0x2 ] == oldaddress or RJassNativesBuffer[ i * 3 - 0x3 ] == newaddress or RJassNativesBuffer[ i * 3 - 0x2 ] == newaddress then
                    call WriteRealMemory( RJassNativesBuffer[ i * 3 - 0x1 ], newaddress )
                    return RJassNativesBuffer[ i * 3 - 0x1 ]
                endif
           
                exitwhen i == RJassNativesBufferSize
            endloop
        endif
     
        loop
            if ReadRealMemory( NextAddress + 0xC ) < 0x3000 then
                return 0
            endif
            
            if ReadRealMemory( NextAddress + 0xC ) == oldaddress then
                call WriteRealMemory( NextAddress + 0xC, newaddress )

                if RJassNativesBufferSize < 100 then
                    set RJassNativesBufferSize = RJassNativesBufferSize + 1
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x1 ] = NextAddress + 0xC
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x2 ] = oldaddress
                    set RJassNativesBuffer[ RJassNativesBufferSize * 3 - 0x3 ] = newaddress
                endif
           
                return NextAddress + 0xC
            endif
       
            set NextAddress = ReadRealMemory( NextAddress )
            if NextAddress == FirstAddress or NextAddress == 0 then
                return 0
            endif
        endloop
        
        return 0
    endfunction

    function GetJassVM takes integer id returns integer
        local integer result = 0

        if pJassEnvAddress > 0 then
            set result = ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( pJassEnvAddress ) + 0x14 ) + 0x90 ) + 0x4 * id )

            if id == 1 then
                if JassVM <= 0 then
                    set JassVM = result
                endif
            endif
        endif

        return result
    endfunction

    function GetJassTable takes nothing returns integer
        local integer jvm = GetJassVM( 1 )

        if jvm > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( jvm + 0x28A4 ) ) + 0x19C )
        endif

        return 0
    endfunction

    function GetStringAddress takes string s returns integer
        local integer jvm = GetJassVM( 1 )

        if jvm > 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( jvm + 0x2874 ) + 0x8 ) + SH2I( s ) * 0x10 + 0x8 ) + 0x1C )
        endif

        return 0
    endfunction

    function BitwiseOperation takes integer memaddr, integer arg1, integer arg2 returns integer
        local integer addr     = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ) )
        local integer func     = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "ConvertUnits" ) )
        local integer retval   = 0

        if addr != 0 and memaddr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, memaddr )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "ConvertUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, memaddr )
                set retval = B2I( ConvertUnits( arg1, arg2 ) )
                call WriteRealMemory( func, addr )
            endif
        endif

        return retval
    endfunction
    
    function ExecuteBytecode takes integer memaddr returns integer
        local integer addr     = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ) )
        local integer func     = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "IgnoredUnits" ) )
        local integer pOffset1 = 0

        if addr != 0 and memaddr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, memaddr )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "IgnoredUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, memaddr )
                set pOffset1 = IgnoredUnits( 0 )
                call WriteRealMemory( func, addr )
            endif
        endif

        return pOffset1
    endfunction    

    function AllocateExecutableMemory takes integer size returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ) )
        local integer func   = LoadInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "MergeUnits" ) )
        local integer valloc = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ) )
        local integer retval = 0

        if valloc != 0 and addr != 0 then
            if func == 0 then
                set func = CreateJassNativeHook( addr, valloc )
                call SaveInteger( MemHackTable, StringHash( "MemCall" ), StringHash( "MergeUnits" ), func )
            endif

            if func != 0 then
                call WriteRealMemory( func, valloc )
                set retval = B2I( MergeUnits( 0, size + 4, 0x3000, 0x40 ) ) // addr (leave as 0 for autogeneration), size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE
                call WriteRealMemory( func, addr )
            endif

            if retval != 0 then
                return ( retval + 0x4 ) / 4 * 4
            endif
        endif

        return 0
    endfunction

    function AllocatePointerArray takes string name, integer id, integer size returns nothing
        if not HaveSavedInteger( MemHackTable, StringHash( name ), id ) then
            call SaveInteger( MemHackTable, StringHash( name ), id, Malloc( size ) )
            call SaveInteger( MemHackTable, StringHash( name + "Size" ), id, size )
        endif
    endfunction

    //# +nosemanticerror
    function InitMemoryArray takes integer id, integer val returns nothing
        set l__Memory[ id ] = val
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

    function UnlockMemEx takes nothing returns nothing
        local integer array i
        local integer a
        local integer b
        local integer offset

        call InitArrayA( 0, 0 )
        call InitArrayA( 0, i[ GetArrayAAddress( ) / 4 ] )
        call InitArrayB( 0, 0 )
        call InitArrayB( 0, i[ GetArrayBAddress( ) / 4 ] )
        call InitArrayC( 0 )
        call InitArrayC( i[ GetArrayCAddress( ) / 4 ] )
        call InitArrayD( 0, 0 )
        call InitArrayD( 0, i[ GetArrayDAddress( ) / 4 ] )
        call InitArrayE( 0 )
        call InitArrayE( i[ GetArrayEAddress( ) / 4 ] )

        set JassVM = i[ i[ i[ i[ pJassEnvAddress / 4 ] / 4 + 5 ] / 4 + 36 ] / 4 + 1 ]

        if JassVM > 0 then
            set JassTable = i[ i[ i[ JassVM / 4 + 0x28A4 / 4 ] / 4 ] / 4 + 0x19C / 4 ]

            if JassTable > 0 then
                set offset = ( i[ GetArrayDAddress( ) / 4 + 3 ] + 4 ) - ( i[ GetArrayBAddress( ) / 4 + 3 ] )
                
                call InitArrayD( 1 + 0x1C / 4, pUnlockCall1 )
                call InitArrayD( 1 + 0xA4 / 4, pUnlockCall2 )
                call InitArrayD( 1 + 0x5C / 4, pUnlockJmp1 )
                call InitArrayD( 1 + 0x04 / 4, GetArrayBAddress( ) - offset + 0x8 )
                call InitArrayD( 1, GetArrayBAddress( ) + 0x8 )
                call InitArrayB( 1, i[ GetArrayDAddress( ) / 4 + 3 ] + 1 * 4 )
                call InitArrayB( 2, pMemory )
                call InitArrayA( 4, i[ GetArrayBAddress( ) / 4 + 3 ] + 4 )

                set b = JassTable - ModuloInteger( i[ GetArrayAAddress( ) / 4 + 3 ] / 4 + 4, 3 )
                set a = ( i[ GetArrayAAddress( ) / 4 + 3 ] / 4 + 4 - b / 4 + 0x2FFFFF ) / 3

                call SetUnitUserData( I2U( a ), 23 )
                call WriteArrayBMemory( 0 + offset / 4, 0xFFFFFFFF )
                call WriteArrayBMemory( 1 + offset / 4, 0 )
                call WriteArrayBMemory( 1 + GetArrayBAddress( ) / 4, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 1, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 2, 0xFFFFFFFF )
                call WriteArrayBMemory( pMemory / 4 + 3, 0 )
            endif
        endif
    endfunction

    //# +nosemanticerror
    function UnlockMemory takes nothing returns nothing
        local integer array i
        local boolean IsExtra = false

        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function NewGlobal ) + 0x2 ) )
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function SetGlobal ) + 0x8 ) )
        // local array "i" can now read memory, but not write.
        call InitArray( 0 )
        set pGameDLL = i[ GetArrayAddress( ) / 4 ]
        call InitArray( pGameDLL )
        call InitMemoryArray( 10, 0 )
        set pMemory = GetMemoryArrayAddress( )
        set iGameVersion = pGameDLL - i[ pGameDLL / 4 ]

        if iGameVersion == 0x5084A8 then
            set PatchVersion    = "1.24e"
            set pGameDLL        = pGameDLL - 0x9631B8
            set pJassEnvAddress = pGameDLL + 0xAF16A8
            set pWriteMemory    = pGameDLL + 0x9B26C0
            set pPointers       = ReadRealMemory( pGameDLL + 0xACE5E0 )
    elseif iGameVersion == 0x4F6E60 then
            set PatchVersion    = "1.26a"
            set pGameDLL        = pGameDLL - 0x951060
            set pJassEnvAddress = pGameDLL + 0xADA848
            set pWriteMemory    = pGameDLL + 0xBE6188
            set pPointers       = ReadRealMemory( pGameDLL + 0xAB7788 )
    elseif iGameVersion == 0x277890 then
            set PatchVersion    = "1.27a"
            set pGameDLL        = pGameDLL - 0xA63B30
            set pJassEnvAddress = pGameDLL + 0xBE3740
            set pWriteMemory    = pGameDLL + 0xAB5948
            set pPointers       = ReadRealMemory( pGameDLL + 0xBE40A8 )
    elseif iGameVersion == 0x2C1554 then
            set PatchVersion    = "1.27b"
            set pGameDLL        = pGameDLL - 0xBD7214
            set pJassEnvAddress = pGameDLL + 0xD46118 // Inside ExecuteFunc | under Concurrency::details::ContextBase dword_... = v3
            set pWriteMemory    = pGameDLL + 0xC2E428 // CBuffDrunkenHaze::`RTTI Base Class Array' -> ??_R2CBuffDrunkenHaze@@8
            set pPointers       = ReadRealMemory( pGameDLL + 0xD68610 ) // (int)"Occlusion", (int)"BuildingsOcclude", 0); -> & 0x7FFFFFFF) < *(_DWORD *)(dword_6F... + 60
            set pUnlockCall1    = pGameDLL + 0x3F4C50 // *(_DWORD *)this + 164))(); main func
            set pUnlockCall2    = pGameDLL + 0x124142 // search v1 = a1 > 0.0; -> go to ida -> 3 functions below to push    esi
            set pUnlockJmp1     = pGameDLL + 0x684BA0 // Under "Async set local leader to %s %x:%x for player %d" | (v10 = 
            set IsExtra         = true
    elseif iGameVersion == 0x2BF828 then
            set PatchVersion    = "1.28f"
            set pGameDLL        = pGameDLL - 0xB8A438
            set pJassEnvAddress = pGameDLL + 0xD0DEF8
            set pWriteMemory    = pGameDLL + 0xBEAF90
            set pPointers       = ReadRealMemory( pGameDLL + 0xD30448 )
            set pUnlockCall1    = pGameDLL + 0x428D30
            set pUnlockCall2    = pGameDLL + 0x152802
            set pUnlockJmp1     = pGameDLL + 0x6B8D30
            set IsExtra         = true
        else
            set iGameVersion    = 0
        endif

        // The bytecode unlocks the ability to read and write memory
        // with the "Memory" array

        if IsExtra then // 1.27b and higher required code execution to get access to bytecode.
            call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemEx ) + 0x8 ) )
        endif
        
        call InitBytecode( i[ ( C2I( function ReadMemory ) + 0x34 ) / 4 ], i[ ( GetArrayAddress( ) + 0xC ) / 4 ] + 0x4 )
        call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( i[ ( GetBytecodeAddress( ) + 0xC ) / 4 ] ) )
    endfunction

    function Init_APIMemory takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x2DDE40 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x2DD9A0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x2DDE00 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x2DDB70 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x2DE730 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x3CB5D0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x3CB650 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x2DD320 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x2DCE80 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x2DD2E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x2DD050 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x2DDC10 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x3CAA90 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x3CAB10 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x891F20 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x890FB0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x88E350 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x890750 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x88CFE0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x1F0710 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x1F04D0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x9BD020 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x9BC0B0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x9B9450 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x9BB850 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x9B80E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x20E150 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x20DF10 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "MergeUnits" ),   pGameDLL + 0x971FB0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "IgnoredUnits" ), pGameDLL + 0x971040 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "ConvertUnits" ), pGameDLL + 0x96E3E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "GetUnitCount" ), pGameDLL + 0x9707E0 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "AttackMoveXY" ), pGameDLL + 0x96D070 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadInteger" ),  pGameDLL + 0x240940 )
                call SaveInteger( MemHackTable, StringHash( "JassNative" ), StringHash( "LoadBoolean" ),  pGameDLL + 0x240700 )
            endif

            call AllocatePointerArray( "StringArray", 0, 3000 )
            call AllocatePointerArray( "PointerArray", 0, 0x10 )
        endif
    endfunction
endlibrary
library APIMemoryAllCalls
    // Explanation:
    // We write assembler in a reversed order, since that is how our written memory will translate to machine code
    // Example: 0xB9F68B56 which is B9 F6 8B 56 => but in fact it will be 0x568BF6B9 or 56 8B F6 B9
    // To translate machine code to asm you can use: https://defuse.ca/online-x86-assembler.htm#disassembly2
    function fast_call_0 takes integer funcaddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x0, 0xBEF68B56 ) // push esi | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x8, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov esi, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr +  0x0, 0xB9F68B56 ) // push esi | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr +  0x8, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x10, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr +  0x4, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr +  0xC, funcaddr ) // mov esi, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0xBAF68B56 ) // push esi | mov esi, esi | edx (arg2)
                call WriteRealMemory( addr + 0x08, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x10, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x18, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )      // mov edx arg2
            call WriteRealMemory( addr + 0x0C, arg1 )      // mov ecx arg1
            call WriteRealMemory( addr + 0x14, funcaddr )  // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg3
                call WriteRealMemory( addr + 0x08, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x10, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x18, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x20, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function fast_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg4
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x10, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x18, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x20, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x28, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg5
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x18, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x20, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x28, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x30, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg6
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x20, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x28, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x30, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x38, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x24, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x2C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_7 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_7" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg7
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x28, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x30, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x38, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x40, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x0C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x14, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x1C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x24, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x2C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x34, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x3C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_8 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_8" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg8
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x30, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x38, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x40, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x48, 0xC35ED6FF ) // call esi | pop esi | ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg8 )     // push arg8
            call WriteRealMemory( addr + 0x0C, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x14, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x1C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x24, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x2C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x34, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x3C, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x44, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_9 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_9" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg9
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x38, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x40, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x48, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x50, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg9 )     // push arg9
            call WriteRealMemory( addr + 0x0C, arg8 )     // push arg8
            call WriteRealMemory( addr + 0x14, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x1C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x24, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x2C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x34, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x3C, arg2 )     // mov edx arg2
            call WriteRealMemory( addr + 0x44, arg1 )     // mov ecx arg1
            call WriteRealMemory( addr + 0x4C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_10 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_10" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg10
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x40, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x48, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x50, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x58, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x0C, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x14, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x1C, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x24, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x2C, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x34, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x3C, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x44, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x4C, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x54, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_11 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_11" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg11
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x48, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x50, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x58, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x60, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x0C, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x14, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x1C, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x24, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x2C, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x34, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x3C, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x44, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x4C, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x54, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x5C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function fast_call_12 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_12" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg12
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg11
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x50, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x58, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x60, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x68, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg12 )    // push arg12
            call WriteRealMemory( addr + 0x0C, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x14, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x1C, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x24, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x2C, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x34, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x3C, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x44, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x4C, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x54, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x5C, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x64, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function fast_call_13 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12, integer arg13 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "fast_call_13" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68F68B56 ) // push esi | mov esi, esi | push arg13
                call WriteRealMemory( addr + 0x08, 0x68F68B90 ) // nop | move esi, esi | push arg12
                call WriteRealMemory( addr + 0x10, 0x68F68B90 ) // nop | move esi, esi | push arg11
                call WriteRealMemory( addr + 0x18, 0x68F68B90 ) // nop | move esi, esi | push arg10
                call WriteRealMemory( addr + 0x20, 0x68F68B90 ) // nop | move esi, esi | push arg9
                call WriteRealMemory( addr + 0x28, 0x68F68B90 ) // nop | move esi, esi | push arg8
                call WriteRealMemory( addr + 0x30, 0x68F68B90 ) // nop | move esi, esi | push arg7
                call WriteRealMemory( addr + 0x38, 0x68F68B90 ) // nop | move esi, esi | push arg6
                call WriteRealMemory( addr + 0x40, 0x68F68B90 ) // nop | move esi, esi | push arg5
                call WriteRealMemory( addr + 0x48, 0x68F68B90 ) // nop | move esi, esi | push arg4
                call WriteRealMemory( addr + 0x50, 0x68F68B90 ) // nop | move esi, esi | push arg3
                call WriteRealMemory( addr + 0x58, 0xBAF68B90 ) // nop | mov esi, esi | mov edx (arg2)
                call WriteRealMemory( addr + 0x60, 0xB9F68B90 ) // nop | mov esi, esi | mov ecx (arg1)
                call WriteRealMemory( addr + 0x68, 0xBEF68B90 ) // nop | mov esi, esi | mov esi (funcaddr)
                call WriteRealMemory( addr + 0x70, 0xC35ED6FF ) // call esi | pop esi | ret
            endif

            call WriteRealMemory( addr + 0x04, arg13 )    // push arg13
            call WriteRealMemory( addr + 0x0C, arg12 )    // push arg12
            call WriteRealMemory( addr + 0x14, arg11 )    // push arg11
            call WriteRealMemory( addr + 0x1C, arg10 )    // push arg10
            call WriteRealMemory( addr + 0x24, arg9  )    // push arg9
            call WriteRealMemory( addr + 0x2C, arg8  )    // push arg8
            call WriteRealMemory( addr + 0x34, arg7  )    // push arg7
            call WriteRealMemory( addr + 0x3C, arg6  )    // push arg6
            call WriteRealMemory( addr + 0x44, arg5  )    // push arg5
            call WriteRealMemory( addr + 0x4C, arg4  )    // push arg4
            call WriteRealMemory( addr + 0x54, arg3  )    // push arg3
            call WriteRealMemory( addr + 0x5C, arg2  )    // mov edx arg2
            call WriteRealMemory( addr + 0x64, arg1  )    // mov ecx arg1
            call WriteRealMemory( addr + 0x6C, funcaddr ) // mov esi, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function this_call_0 takes integer pfuncaddr, integer arg1 returns integer
        return fast_call_1( pfuncaddr, 0 )
    endfunction
    
    function this_call_1 takes integer pfuncaddr, integer arg1 returns integer
        return fast_call_2( pfuncaddr, arg1, 0 )
    endfunction

    function this_call_2 takes integer pfuncaddr, integer arg1, integer arg2 returns integer
        return fast_call_3( pfuncaddr, arg1, 0, arg2 )
    endfunction

    function this_call_3 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3 returns integer
        return fast_call_4( pfuncaddr, arg1, 0, arg2, arg3 )
    endfunction

    function this_call_4 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4 returns integer
        return fast_call_5( pfuncaddr, arg1, 0, arg2, arg3, arg4 )
    endfunction

    function this_call_5 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5 returns integer
        return fast_call_6( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5 )
    endfunction

    function this_call_6 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        return fast_call_7( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6 )
    endfunction

    function this_call_7 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        return fast_call_8( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7 )
    endfunction

    function this_call_8 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8 returns integer
        return fast_call_9( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8 )
    endfunction

    function this_call_9 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9 returns integer
        return fast_call_10( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 )
    endfunction

    function this_call_10 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10 returns integer
        return fast_call_11( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
    endfunction

    function this_call_11 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11 returns integer
        return fast_call_12( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 )
    endfunction

    function this_call_12 takes integer pfuncaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7, integer arg8, integer arg9, integer arg10, integer arg11, integer arg12 returns integer
        return fast_call_13( pfuncaddr, arg1, 0, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 )
    endfunction

    function std_call_0 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x0, 0xB9519090 ) // push ecx | nop, nop
                call WriteRealMemory( addr + 0x8, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov ecx, funcaddr
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction
    
    function std_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx | mov ecx, ecx | push (arg1)
                call WriteRealMemory( addr + 0x08, 0xB990C98B ) // mov ecx, ecx | nop | mov ecx (funcaddr)
                call WriteRealMemory( addr + 0x10, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif
            
            call WriteRealMemory( addr + 0x04, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x0C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x18, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )     // push arg1
            call WriteRealMemory( addr + 0x0C, arg1 )     // push arg2
            call WriteRealMemory( addr + 0x14, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x20, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov ecx, funcaddr
            
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x28, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function std_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg2
            call WriteRealMemory( addr + 0x24, arg2 )     // push arg1
            call WriteRealMemory( addr + 0x2C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_0 takes integer funcaddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_0" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x0, 0xB9C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x8, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0xC, 0xCCC35904 ) // 0x4, pop ecx, ret, int3
            endif

            call WriteRealMemory( addr + 0x4, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function c_call_1 takes integer funcaddr, integer arg1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_1" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x10, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x14, 0xCCC35904 ) // a0x4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x0C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif
        
        return 0
    endfunction

    function c_call_2 takes integer funcaddr, integer arg1, integer arg2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_2" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0xB990C98B ) // mov ecx,ecx , nop
                call WriteRealMemory( addr + 0x18, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x1C, 0xCCC35908 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x0C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x14, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_3 takes integer funcaddr, integer arg1, integer arg2, integer arg3 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_3" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0xB990C98B ) // mov ecx,ecx, nop
                call WriteRealMemory( addr + 0x20, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x24, 0xCCC3590C ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x0C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x14, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x1C, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_4 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_4" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x28, 0xC483D1FF ) // call ecx, add esp
                call WriteRealMemory( addr + 0x2C, 0xCCC35910 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x0C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x14, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x1C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x24, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_5 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_5" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x34, 0xCCC35914 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x0C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x14, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x1C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x24, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x2C, funcaddr ) // mov ecx, funcaddr
            
            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function c_call_6 takes integer funcaddr, integer arg1, integer arg2, integer arg3 , integer arg4, integer arg5 , integer arg6 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "c_call_6" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then 
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x30, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xC483D1FF ) // call ecx, add esp, 
                call WriteRealMemory( addr + 0x3C, 0xCCC35918 ) // 4, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x0C, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x14, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x1C, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x24, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x2C, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x34, funcaddr ) // mov ecx, funcaddr

            return ExecuteBytecode( addr )
        endif

        return 0
    endfunction

    function GetModuleHandleByAddr takes integer pDll returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ) )

        if addr != 0 then
            return std_call_1( addr, pDll )
        endif

        return 0
    endfunction
    
    function GetModuleHandle takes string nDllName returns integer
        return GetModuleHandleByAddr( GetStringAddress( nDllName ) )
    endfunction

    function GetModuleProcAddressByAddr takes integer pDll, integer pFunc returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ) )

        if addr != 0 then
            return std_call_2( addr, GetModuleHandleByAddr( pDll ), pFunc )
        endif
        
        return 0
    endfunction
    
    function GetModuleProcAddress takes string nDllName, string nProcName returns integer
        return GetModuleProcAddressByAddr( GetStringAddress( nDllName ), GetStringAddress( nProcName ) )
    endfunction

    function GetFuncFromDll takes string libname, string funcname, boolean save returns integer
        local integer l_hash = StringHash( libname )
        local integer f_hash = StringHash( funcname )
        local integer addr   = LoadInteger( MemHackTable, l_hash, f_hash )

        if addr == 0 then
            set addr = GetModuleProcAddress( libname, funcname )
        endif

        if addr != 0 and save then
            if not HaveSavedInteger( MemHackTable, l_hash, f_hash ) then
                call SaveInteger( MemHackTable, l_hash, f_hash, addr )
            endif
        endif

        return addr
    endfunction

    function VirtualAlloc takes integer pRealOffset, integer pMemSize, integer alloctype, integer pProtectFlag returns integer // 0, size + 4, 0x3000, 0x40
        local integer addr = GetFuncFromDll( "Kernel32.dll", "VirtualAlloc", true )

        if addr != 0 then
            return std_call_4( addr, pRealOffset, pMemSize, alloctype, pProtectFlag )
        endif

        return 0
    endfunction

    function VirtualProtect takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "VirtualProtect", true )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 then
            call std_call_4( addr, pRealOffset, pMemSize, pProtectFlag, arg )
            return ReadRealMemory( arg )
        endif

        return 0
    endfunction

    function CopyMemory takes integer dest, integer src, integer size returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ) )

        if addr != 0 then
            return c_call_3( addr, dest, src, size )
        endif

        return 0
    endfunction

    function AllocExecMemEx takes string funcname, string childName, integer size returns nothing
        local integer i      = 0
        local integer f_hash = StringHash( funcname )
        local integer c_hash = StringHash( childName )
        local integer addr   = LoadInteger( MemHackTable, f_hash, c_hash )

        if addr == 0 then
            set addr = AllocateExecutableMemory( size )

            if addr != 0 then
                call SaveInteger( MemHackTable, f_hash, c_hash, addr )

                loop
                    exitwhen i == size
                    call WriteRealMemory( addr + i, 0 )
                    set i = i + 0x4
                endloop
            endif
        endif
    endfunction

    function AllocFunctionCall takes string funcname, integer size returns nothing
        call AllocExecMemEx( funcname, "function", size )
    endfunction

    function ReallocateCallMemory takes nothing returns nothing
        local integer i   = 0

        if PatchVersion != "" then
            call AllocFunctionCall( "fast_call_0",  0x0C )
            call AllocFunctionCall( "fast_call_1",  0x14 )
            call AllocFunctionCall( "fast_call_2",  0x1C )
            call AllocFunctionCall( "fast_call_3",  0x24 )
            call AllocFunctionCall( "fast_call_4",  0x2C )
            call AllocFunctionCall( "fast_call_5",  0x34 )
            call AllocFunctionCall( "fast_call_6",  0x3C )
            call AllocFunctionCall( "fast_call_7",  0x44 )
            call AllocFunctionCall( "fast_call_8",  0x4C )
            call AllocFunctionCall( "fast_call_9",  0x5C )
            call AllocFunctionCall( "fast_call_10", 0x64 )
            call AllocFunctionCall( "fast_call_11", 0x6C )
            call AllocFunctionCall( "fast_call_12", 0x74 )
            call AllocFunctionCall( "fast_call_13", 0x7C )

            call AllocFunctionCall( "std_call_0", 0x0C )
            call AllocFunctionCall( "std_call_1", 0x14 )
            call AllocFunctionCall( "std_call_2", 0x1C )
            call AllocFunctionCall( "std_call_3", 0x24 )
            call AllocFunctionCall( "std_call_4", 0x2C )
            call AllocFunctionCall( "std_call_5", 0x34 )
            call AllocFunctionCall( "std_call_6", 0x3C )

            call AllocFunctionCall( "c_call_0", 0x10 )
            call AllocFunctionCall( "c_call_1", 0x18 )
            call AllocFunctionCall( "c_call_2", 0x20 )
            call AllocFunctionCall( "c_call_3", 0x28 )
            call AllocFunctionCall( "c_call_4", 0x30 )
            call AllocFunctionCall( "c_call_5", 0x38 )
            call AllocFunctionCall( "c_call_6", 0x40 )
        endif
    endfunction

    function AllocateCallMemory takes nothing returns nothing
        call ReallocateCallMemory( ) // AllocateExecutableMemory( 37000 )
    endfunction
    
    function Init_APIMemoryCalls takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x87F204 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x87F2BC ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x87F134 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x87F47C ) )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x86D1D0 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x86D280 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x86D0F4 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x86D3CC ) )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0x94E184 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0x94E168 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0x94E270 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0x94E468 ) )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0xA7C28C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0xA7C17C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0xA7C2D0 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0xA7C504 ) )

        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetModuleHandleA" ), ReadRealMemory( pGameDLL + 0xA6B378 ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "GetProcAddress" ),   ReadRealMemory( pGameDLL + 0xA6B24C ) )
                call SaveInteger( MemHackTable, StringHash( "Kernel32.dll" ), StringHash( "VirtualAlloc" ),     ReadRealMemory( pGameDLL + 0xA6B2B8 ) )

                call SaveInteger( MemHackTable, StringHash( "CLanguage" ), StringHash( "memcpy" ), ReadRealMemory( pGameDLL + 0xA6B3DC ) )
            endif

            call AllocateCallMemory( )
        endif
    endfunction
endlibrary
library APIMemoryBitwise
    function GetGameTypeSupported takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ) )

        if addr != 0 then
            return ReadRealPointer2LVL( addr, 0x30, 0x30 )
        endif
    
        return 0
    endfunction

    function Player2Flag takes player p returns integer
        return R2I( Pow( 2, GetPlayerId( p ) ) )
    endfunction

    function IsFlagBitSet takes integer flags, integer bit returns boolean
        return flags / bit * 2147483648 != 0
    endfunction

    function ShiftLeftForBits takes integer byte, integer shiftval returns integer
        return byte * ( PowI( 2, shiftval ) )
    endfunction
    
    function ShiftRightForBits takes integer byte, integer shiftval returns integer
        return byte / ( PowI( 2, shiftval ) )
    endfunction
    
    function ShiftLeftForBytes takes integer byte, integer shiftval returns integer
        return ShiftLeftForBits( byte, shiftval * 8 )
    endfunction
    
    function ShiftRightForBytes takes integer byte, integer shiftval returns integer
        return ShiftRightForBits( byte, shiftval * 8 )
    endfunction

    function BitwiseOr takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "OR" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isOR" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isOR" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D009 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function BitwiseXor takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "XOR" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isXOR" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isXOR" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D031 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function BitwiseAnd takes integer arg1, integer arg2 returns integer
        local integer addr   = LoadInteger( MemHackTable, StringHash( "Bitwise" ), StringHash( "AND" ) )

        if not LoadBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isAND" ) ) then
            call SaveBoolean( MemHackTable, StringHash( "Bitwise" ), StringHash( "isAND" ), true )
            call WriteRealMemory( addr + 0x0, 0x0424448B )
            call WriteRealMemory( addr + 0x4, 0x0824548B )
            call WriteRealMemory( addr + 0x8, 0xCCC3D021 )
        endif

        return BitwiseOperation( addr, arg1, arg2 )
    endfunction

    function Init_APIMemoryBitwise takes nothing returns nothing
        local integer i = 0

        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
        elseif PatchVersion == "1.26a" then
        elseif PatchVersion == "1.27a" then
        elseif PatchVersion == "1.27b" then
        elseif PatchVersion == "1.28f" then
            endif

            call AllocExecMemEx( "Bitwise",  "OR", 0xC )
            call AllocExecMemEx( "Bitwise", "XOR", 0xC )
            call AllocExecMemEx( "Bitwise", "AND", 0xC )
        endif
    endfunction
endlibrary
library APIMemoryForString
    function ToJString takes integer pCString returns string
        local integer addr = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ) )

        if addr != 0 and pCString != 0 then
            return I2SH( this_call_1( addr, pCString ) )
        endif

        return null
    endfunction

    function WriteCString takes integer pAddr, string text returns nothing
        call WriteRealMemory( pAddr, GetStringAddress( text ) )
    endfunction

    function ConvertNullTerminatedStringToString takes integer pNullTerminatedString returns string
        return ToJString( pNullTerminatedString )
    endfunction

    function WriteNullTerminatedString takes string s, integer pAddr returns nothing
        call WriteRealMemory( pAddr, GetStringAddress( s ) )
    endfunction
    
    function SearchStringValueAddress takes string str returns integer
        local integer addr1   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ) )
        local integer addr2   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ) )
        local integer addr3   = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ) )
        local integer s_addr  = 0
        local integer retaddr = 0

        if addr1 != 0 and addr2 != 0 and addr3 != 0 then
            set s_addr = GetStringAddress( str )
            
            if s_addr != 0 then
                set retaddr = this_call_2( addr1, addr2, s_addr )

                if retaddr == 0 or ReadRealMemory( retaddr + 0x1C ) == 0 then 
                    set retaddr = this_call_2( addr1, addr3, s_addr )
                endif

                if retaddr != 0 and ReadRealMemory( retaddr + 0x1C ) != 0 then
                    return ReadRealMemory( retaddr + 0x1C )
                endif
            endif
        endif

        return 0
    endfunction

    function SearchStringValue takes string str returns string
        return ToJString( SearchStringValueAddress( str ) )
    endfunction

    function ReplaceStringValue takes string str, integer newstraddress, integer str_len returns nothing
         local integer retaddr = SearchStringValueAddress( str )

         call CopyMemory( retaddr, newstraddress, str_len )
    endfunction

    function sprintf_Ex takes string format, integer arg1, integer arg2, integer arg3, integer arg4, integer argsize returns string
        local integer addr = LoadInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ) )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 then
            if mem != 0 then
                call WriteRealMemory( mem, 0 )

                if argsize == 1 then
                    call c_call_3( addr, mem, GetStringAddress( format ), arg1 )
            elseif argsize == 2 then
                    call c_call_4( addr, mem, GetStringAddress( format ), arg1, arg2 )
            elseif argsize == 3 then
                    call c_call_5( addr, mem, GetStringAddress( format ), arg1, arg2, arg3 )
            elseif argsize == 4 then
                    call c_call_6( addr, mem, GetStringAddress( format ), arg1, arg2, arg3, arg4 )
                endif

                return ToJString( mem )
            endif
        endif

        return ""
    endfunction
    
    function sprintf_1 takes string format, integer arg1 returns string
        return sprintf_Ex( format, arg1, 0, 0, 0, 1 )
    endfunction

    function sprintf_2 takes string format, integer arg1, integer arg2 returns string
        return sprintf_Ex( format, arg1, arg2, 0, 0, 2 )
    endfunction

    function sprintf_3 takes string format, integer arg1, integer arg2, integer arg3 returns string
        return sprintf_Ex( format, arg1, arg2, arg3, 0, 3 )
    endfunction

    function sprintf_4 takes string format, integer arg1, integer arg2, integer arg3, integer arg4 returns string
        return sprintf_Ex( format, arg1, arg2, arg3, arg4, 4 )
    endfunction
    
    function Init_APIMemoryString takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x3BB560 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x5C9670 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xAE409C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xAE4074 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x87F3AC ) )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x3BAA20 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x5C8ED0 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xACD23C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xACD214 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x86D32C ) )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x1DA520 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x06B030 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xBB9CD4 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xBB9CAC )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0x94E464 ) )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x1F7F60 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x0BF020 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xD4776C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xD47744 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0xA7C500 ) )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "TojString" ),      pGameDLL + 0x22A770 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchValue" ),    pGameDLL + 0x0ED810 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress1" ), pGameDLL + 0xD0F54C )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "SearchAddress2" ), pGameDLL + 0xD0F524 )
                call SaveInteger( MemHackTable, StringHash( "StringAPI" ), StringHash( "sprintf" ),        ReadRealMemory( pGameDLL + 0xA6B3E0 ) )
            endif
        endif
    endfunction
endlibrary
library APIMemoryKernel
    function IsBadReadPtr takes integer pointer, integer size returns boolean
        local integer addr = GetFuncFromDll( "Kernel32.dll", "IsBadReadPtr", true )

        if addr != 0 then
            return std_call_2( addr, pointer, size ) == 0
        endif

        return false
    endfunction
    
    // 0 - milisecond | 1 - Sec | 2 - Minutes | 3 - Hours | 4 - Day | 5 - Day of Week | 6 - Month | 7 - Year
    function GetLocalTime takes integer timeId returns integer
        local integer addr   = GetFuncFromDll( "Kernel32.dll", "GetLocalTime", true )
        local integer mem    = 0
        local integer pOff   = 0
        local integer memval = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "SysTimeMem" ) )
            
            if mem != 0 then
                call std_call_1( addr, mem )

                if timeId >= 0 and timeId <= 7 then
                    set memval = ReadRealMemory( mem + ( 0xE - timeId * 2 ) )

                    if memval > 0 then
                        return CreateInteger1( 0, 0, GetByteFromInteger( memval, 3 ), GetByteFromInteger( memval, 4 ) )
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function GetCurrentProcessId takes nothing returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetCurrentProcessId", true )

        if addr != 0 then
            return c_call_1( addr, 0 )
        endif

        return 0
    endfunction

    function ReadStringFromFile takes string sfile, string ssection, string skey, string sdefval returns string
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetPrivateProfileStringA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )
        local integer size = LoadInteger( MemHackTable, StringHash( "StringArraySize" ), 0 )

        if addr != 0 and mem != 0 and size != 0 then
            call std_call_6( addr, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sdefval ), mem, size, GetStringAddress( sfile ) )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function WriteStringToFile takes string sfile, string ssection, string skey, string sval returns nothing
        local integer addr = GetFuncFromDll( "Kernel32.dll", "WritePrivateProfileStringA", true )

        if addr != 0 then 
            call std_call_4( addr, GetStringAddress( ssection ), GetStringAddress( skey ), GetStringAddress( sval ), GetStringAddress( sfile ) )
        endif
    endfunction

    function GetFileAttributes takes string s returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "GetFileAttributesA", true )

        if addr != 0 then
            return std_call_1( addr, GetStringAddress( s ) )
        endif
     
        return 0
    endfunction

    function LoadLibrary takes string nDllName returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "LoadLibraryA", true )

        if addr != 0 then
            return std_call_1( addr, GetStringAddress( nDllName ) )
        endif

        return 0
    endfunction

    function MessageBox takes string message, string caption returns nothing
        local integer addr = GetFuncFromDll( "User32.dll", "MessageBoxA", true )

        if addr != 0 then
            call std_call_4( addr, 0, GetStringAddress( message ), GetStringAddress( caption ), 0 )
        endif
    endfunction

    function FindWindowByAddr takes integer c_addr, integer w_addr returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "FindWindowA", true )

        if addr != 0 then
            return std_call_2( addr, c_addr, w_addr )
        endif

        return 0
    endfunction
    
    function FindWindow takes string class, string window returns integer
        local integer c_addr = 0
        local integer w_addr = 0

        if class != "" then
            set c_addr = GetStringAddress( class )
        endif
        
        if window != "" then
            set w_addr = GetStringAddress( window )
        endif

        return FindWindowByAddr( c_addr, w_addr )
    endfunction

    function FindWindowExByAddr takes integer hwid1, integer hwid2, integer c_addr, integer w_addr returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "FindWindowExA", true )

        if addr != 0 then
            return std_call_4( addr, hwid1, hwid2, c_addr, w_addr )
        endif

        return 0
    endfunction

    function FindWindowEx takes integer hwid1, integer hwid2, string class, string window returns integer
        local integer c_addr = 0
        local integer w_addr = 0

        if class != "" then
            set c_addr = GetStringAddress( class )
        endif

        if window != "" then
            set w_addr = GetStringAddress( window )
        endif

        return FindWindowExByAddr( hwid1, hwid2, c_addr, w_addr )
    endfunction

    function GetWindowClassName takes integer hwid returns string
        local integer addr = GetFuncFromDll( "User32.dll", "GetClassNameA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 and mem != 0 and hwid != 0 then
            call std_call_3( addr, hwid, mem, 260 )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function GetWindowText takes integer hwid returns string
        local integer addr = GetFuncFromDll( "User32.dll", "GetWindowTextA", true )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "StringArray" ), 0 )

        if addr != 0 and mem != 0 and hwid != 0 then
            call std_call_3( addr, hwid, mem, 260 )
            return ToJString( mem )
        endif

        return ""
    endfunction

    function GetSystemMetrics takes integer id returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetSystemMetrics", true )

        if addr != 0 then
            return std_call_1( addr, id )
        endif

        return 0
    endfunction

    function GetScreenWidth takes nothing returns integer
        return GetSystemMetrics( 0 )
    endfunction

    function GetScreenHeight takes nothing returns integer
        return GetSystemMetrics( 1 )
    endfunction

    function GetWindowRect takes integer hwnd returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetWindowRect", true )
        local integer mem  = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ) )

            if mem != 0 then
                // RECT structure
                // 0x0 = pWindowRect.left
                // 0x4 = pWindowRect.top
                // 0x8 = pWindowRect.right
                // 0xC = pWindowRect.bottom
                return std_call_2( addr, hwnd, mem )
            endif
        endif

        return 0
    endfunction
    
    function GetWindowRectStruct takes integer hwnd returns integer
        local integer pWRect = GetWindowRect( hwnd )

        if pWRect != 0 then
            return LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ) )
        endif

        return 0
    endfunction

    function GetWindowX takes integer hwnd returns integer
        local integer pWRect = GetWindowRectStruct( hwnd )

        if pWRect != 0 then
            return ReadRealMemory( pWRect + 0x0 )
        endif

        return 0
    endfunction

    function GetWindowY takes integer hwnd returns integer
        local integer pWRect = GetWindowRectStruct( hwnd )

        if pWRect > 0 then
            return ReadRealMemory( pWRect + 0x4 )
        endif

        return 0
    endfunction
    
    function ScreenToClient takes integer hwnd, integer lpPoint returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "ScreenToClient", true )

        if addr != 0 then
            return std_call_2( addr, hwnd, lpPoint )
        endif

        return 0
    endfunction

    function GetCursorPos takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetCursorPos", true )
        local integer mem  = 0

        if addr != 0 then
            set mem = LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ) )

            if mem != 0 then
                // tagPOINT structure
                // 0x0 = pCursorCoords.x
                // 0x4 = pCursorCoords.y
                return std_call_1( addr, mem )
            endif
        endif

        return 0
    endfunction

    function GetCursorPosStruct takes nothing returns integer
        if GetCursorPos( ) != 0 then
            return LoadInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ) )
        endif

        return 0
    endfunction

    function PostMessage takes integer hwnd, integer msg, integer wparam, integer lparam returns nothing
        local integer addr = GetFuncFromDll( "User32.dll", "PostMessageA", true )

        if addr != 0 then
            call std_call_4( addr, hwnd, msg, wparam, lparam )
        endif

        //call PostMessage( pHWND_WC3, 0x0100, 0x0D, 0 )
        //call PostMessage( pHWND_WC3, 0x0101, 0x0D, 0 )
    endfunction

    function ShellExecute takes string command, string path, string args returns nothing
        local integer addr = GetFuncFromDll( "Shell32.dll", "ShellExecuteA", true )

        if addr != 0 then // call ShellExecute( "open", url, "" )
            call std_call_6( addr, 0, GetStringAddress( command ), GetStringAddress( path ), GetStringAddress( args ), 0, 0 )
        endif
    endfunction

    function GetAsyncKeyState takes integer vk_key_code returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetAsyncKeyState", true )

        if addr != 0 then
            return std_call_1( addr, vk_key_code )
        endif

        return 0
    endfunction

    function IsKeyPressed takes integer vk_key_code returns boolean
        // IsKeyPressed( VK_LMENU ) | VK_LMENU = 0xA4 | https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
        return BitwiseAnd( GetAsyncKeyState( vk_key_code ), 0x8000 ) > 0
    endfunction

    function ClearBenchmark takes nothing returns nothing
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ), 0 )
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "EndTime" ),   0 )
    endfunction

    function StartBenchmark takes nothing returns integer
        local integer time = GetLocalTime( 0 )
        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ), time )
        return time
    endfunction

    function StopBenchmark takes nothing returns integer
        local integer startime = LoadInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "StartTime" ) )
        local integer endtime  = GetLocalTime( 0 )
        local integer result   = endtime - startime

        call SaveInteger( MemHackTable, StringHash( "BenchmarkAPI" ), StringHash( "EndTime" ), endtime )
        return result
    endfunction

    function Init_APIMemoryKernel takes nothing returns nothing
        if PatchVersion != "" then
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "SysTimeMem" ),     Malloc( 0x28 ) )
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "WindowRectMem" ),  Malloc( 0x10 ) )
            call SaveInteger( MemHackTable, StringHash( "KernelAPI" ), StringHash( "CursorCoordMem" ), Malloc( 0x08 ) )
            call ClearBenchmark( )
        endif
    endfunction
endlibrary
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
library APIMemoryHStormDLL
    globals
        integer pStormDLL = 0
    endglobals

    function StormLoadFile takes string filename, integer ppBuffer, integer pSize, integer extraSizeToAllocate, integer pOverlapped returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 then
            call WriteRealMemory( arg + 0x0, ppBuffer )
            call WriteRealMemory( arg + 0x4, pSize )
            return std_call_5( addr, GetStringAddress( filename ), arg + 0x0, arg + 0x4, 1, 0 )
        endif

        return 0
    endfunction
    
    function StormAllocateMemory takes integer size, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ) )

        if addr != 0 and size > 0 then
            return std_call_4( addr, size, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction

    function StormFreeMemory takes integer memaddr, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ) )

        if addr != 0 and memaddr != 0 then
            return std_call_4( addr, memaddr, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction

    function StormGetMemorySize takes integer memaddr, string name, integer unk_1 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ) )

        if addr != 0 and memaddr != 0 then
           return std_call_3( addr, memaddr, GetStringAddress( name ), unk_1 )
        endif

        return 0
    endfunction

    function StormReallocateMemory takes integer memaddr, integer size, string name, integer unk_1, integer unk_2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ) )

        if addr != 0 and memaddr != 0 and size > 0 then
            return std_call_5( addr, memaddr, size, GetStringAddress( name ), unk_1, unk_2 )
        endif

        return 0
    endfunction
    
    function Init_APIMemoryStormDLL takes nothing returns nothing
        if PatchVersion != "" then
            set pStormDLL = GetModuleHandle( "Storm.dll" )

            if pStormDLL != 0 then
                if PatchVersion == "1.24e" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x01CF30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x025F30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x024880 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x024AD0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x026230 )
            elseif PatchVersion == "1.26a" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x01CF30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x025F30 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x024880 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x024AD0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x026230 )
            elseif PatchVersion == "1.27a" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x022660 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02B830 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02BE40 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02C000 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02C8B0 )
            elseif PatchVersion == "1.27b" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x0224E0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02B6D0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02BCE0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02BEA0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02C760 )
            elseif PatchVersion == "1.28f" then
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SFile::Load" ),   pStormDLL + 0x022A50 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Alloc" ),   pStormDLL + 0x02BC10 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::Free" ),    pStormDLL + 0x02C220 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::GetSize" ), pStormDLL + 0x02C3E0 )
                    call SaveInteger( MemHackTable, StringHash( "StormDll" ), StringHash( "SMem::ReAlloc" ), pStormDLL + 0x02CC90 )
                endif
            endif
        endif
    endfunction
endlibrary
library APIMemoryMPQ
    function FileExists takes string s returns boolean
        return GetFileAttributes( s ) != -1
    endfunction

    function GetFileSizeFromMPQ takes string source returns integer
        return StormLoadFile( source, 0, 0, 1, 0 )
    endfunction

    function ExportFileFromMPQByAddr takes integer saddr, integer daddr returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ) )

        if addr != 0 and saddr != 0 and daddr != 0 then
            return fast_call_2( addr, saddr, daddr )
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
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x7386A0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x737F00 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x702C50 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x720390 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "MPQAPI" ), StringHash( "ExportFile" ), pGameDLL + 0x754560 )
            endif
        endif
    endfunction
endlibrary
library APIMemoryhStormDLL
    globals
        integer pStormDLL                   = 0
        integer pStormAllocateMemory        = 0
        integer pStormFreeMemory            = 0
        integer pStormGetMemorySize         = 0
        integer pStormReallocateMemory      = 0
    endglobals

    function StormAllocateMemory takes integer size, string name, integer unk_1, integer unk_2 returns integer
        if pStormAllocateMemory > 0 then
            if size > 0 then
                return std_call_4( pStormAllocateMemory, size, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction

    function StormFreeMemory takes integer addr, string name, integer unk_1, integer unk_2 returns integer
        if pStormFreeMemory > 0 then
            if addr > 0 then
                return std_call_4( pStormFreeMemory, addr, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction

    function StormGetMemorySize takes integer addr, string name, integer unk_1 returns integer
        if pStormGetMemorySize > 0 then
            if addr > 0 then
                return std_call_3( pStormGetMemorySize, addr, GetStringAddress( name ), unk_1 )
            endif
        endif

        return 0
    endfunction

    function StormReallocateMemory takes integer addr, integer size, string name, integer unk_1, integer unk_2 returns integer
        if pStormReallocateMemory > 0 then
            if size > 0 and size > 0 then
                return std_call_5( pStormReallocateMemory, addr, size, GetStringAddress( name ), unk_1, unk_2 )
            endif
        endif

        return 0
    endfunction
    
    function Init_APIMemoryStormDLL takes nothing returns nothing
        if PatchVersion != "" then
            set pStormDLL = GetModuleHandle( "Storm.dll" )

            if pStormDLL > 0 then
                if PatchVersion == "1.24e" then
                    set pStormAllocateMemory    = pStormDLL + 0x025F30
                    set pStormFreeMemory        = pStormDLL + 0x024880
                    set pStormGetMemorySize     = pStormDLL + 0x024AD0
                    set pStormReallocateMemory  = pStormDLL + 0x026230
            elseif PatchVersion == "1.26a" then
                    set pStormAllocateMemory    = pStormDLL + 0x025F30
                    set pStormFreeMemory        = pStormDLL + 0x024880
                    set pStormGetMemorySize     = pStormDLL + 0x024AD0
                    set pStormReallocateMemory  = pStormDLL + 0x026230
            elseif PatchVersion == "1.27a" then
                    set pStormAllocateMemory    = pStormDLL + 0x02B830 // Storm_401
                    set pStormFreeMemory        = pStormDLL + 0x02BE40 // Storm_403
                    set pStormGetMemorySize     = pStormDLL + 0x02C000 // Storm_404
                    set pStormReallocateMemory  = pStormDLL + 0x02C8B0 // Storm_405
            elseif PatchVersion == "1.27b" then
                    set pStormAllocateMemory    = pStormDLL + 0x02B6D0
                    set pStormFreeMemory        = pStormDLL + 0x02BCE0
                    set pStormGetMemorySize     = pStormDLL + 0x02BEA0
                    set pStormReallocateMemory  = pStormDLL + 0x02C760
            elseif PatchVersion == "1.28f" then
                    set pStormAllocateMemory    = pStormDLL + 0x02BC10
                    set pStormFreeMemory        = pStormDLL + 0x02C220
                    set pStormGetMemorySize     = pStormDLL + 0x02C3E0
                    set pStormReallocateMemory  = pStormDLL + 0x02CC90
                endif
            endif
        endif
    endfunction
endlibrary
library APIMemoryGameData
    globals
        hashtable htObjectDataPointers = InitHashtable( )
    endglobals

    function SaveCode takes hashtable ht, integer parentKey, integer childKey, code c returns nothing
        if ht != null then
            call SaveInteger( ht, parentKey, childKey, C2I( c ) )
        endif
    endfunction

    function LoadCode takes hashtable ht, integer parentKey, integer childKey returns code
        if ht != null then
            return I2C( LoadInteger( ht, parentKey, childKey ) )
        endif

        return null
    endfunction
    
    function GetGameStateInstance takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ) )
    endfunction

    function GetTempestThread takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ) )
    endfunction

    function ConvertHandleId takes integer handleid returns integer
        local integer addr = GetGameStateInstance( )

        if addr != 0 and handleid != 0 then
            return ReadRealMemory( ReadRealMemory( ReadRealMemory( ReadRealMemory( addr ) + 0x1C ) + 0x19C ) + handleid * 0xC - 0x2FFFFF * 4 )
        endif

        return 0
    endfunction
    
    function ConvertHandle takes handle h returns integer
        return ConvertHandleId( GetHandleId( h ) )
    endfunction

    function GetGameDataNode takes nothing returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ) )
        local integer pData = GetGameStateInstance( )

        if addr != 0 and pData != 0 then
            return this_call_1( addr, pData )
        endif

        return 0
    endfunction

    function HandleIdToObject takes integer handleid returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ) )
        local integer pData = GetGameDataNode( )

        if addr != 0 and pData != 0 then
            return this_call_2( addr, pData, handleid )
        endif
        
        return 0
    endfunction
    
    function ObjectToHandleId takes integer pAgent returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ) )
        local integer pData = GetGameDataNode( )

        if addr != 0 and pData != 0 then
            return this_call_3( addr, pData, pAgent, 0 )
        endif
        
        return 0
    endfunction

    function GetAgentType takes handle h returns integer
        // returns code of the handle's type
        // +w3u for unit, +tmr for timer, +trg for trigger, +arg for region, etc...
 
        local integer func = ReadRealMemory( ReadRealMemory( ConvertHandle( h ) ) + 0x1C )
        return ReadRealMemory( func ) / 0x100 + ReadRealMemory( func + 0x4 ) * 0x1000000
    endfunction

    function ObjectToAbility takes integer pObject returns ability
        local integer pAbil = 0

        if pObject > 0 then
            set pAbil = ObjectToHandleId( pObject )

            if pAbil > 0 then
                return I2A( pAbil )
            endif
        endif

        return null
    endfunction
    
    function ObjectToUnit takes integer pUnit returns unit
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ) )

        if addr != 0 and pUnit != 0 then
            set pUnit = fast_call_1( addr, pUnit )

            if pUnit != 0 then
                return I2U( pUnit )
            endif
        endif

        return null
    endfunction
    
    function GetAgentHashKey takes integer agentId returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ) )
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer pData = 0

        if addr != 0 and arg != 0 and agentId != 0 then
            call WriteRealMemory( arg, agentId )
            set pData = this_call_1( addr, arg )
        endif

        return pData
    endfunction

    function GetAgentUIDefById takes integer agentId returns integer // Only use this on Abilities
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ) )

        if addr != 0 and agentId != 0 then
            return this_call_1( addr, agentId )
        endif

        return 0
    endfunction

    function GetAgileDataNodeById takes integer pDataNode, integer agentId returns integer
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ) )
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer pData = GetAgentHashKey( agentId )

        if addr != 0 and arg != 0 and pData != 0 then
            return this_call_3( addr, pDataNode, pData, arg )
        endif

        return 0
    endfunction

    function GetWidgetUIDefById takes integer wid returns integer // Units/Destructables/Items (aka widgets)
        local integer addr  = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ) )

        if addr != 0 and wid != 0 then
            return this_call_1( addr, wid )
        endif

        return 0
    endfunction

    function jUnitToCUnit takes unit u returns integer // Address formerly
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ) )

        if addr != 0 then
            return this_call_1( addr, GetHandleId( u ) )
        endif

        return 0
    endfunction

    function GetCObjectFromHashEx takes integer pHash1, integer pHash2 returns integer // call of sub_6F03FA30 (1.26a)
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ) )

        if addr != 0 and pHash1 != 0xFFFFFFFF and pHash2 != 0xFFFFFFFF then
            return fast_call_2( addr, pHash1, pHash2 )
        endif

        return 0
    endfunction

    function GetCObjectFromHashGroupEx takes integer pHashGroup returns integer // Simplified version of GetCObjectFromHashEx, uses a pointer to HashGroup
        if pHashGroup > 0 then
            return GetCObjectFromHashEx( ReadRealMemory( pHashGroup + 0x0 ), ReadRealMemory( pHashGroup + 0x4 ) )
        endif

        return 0
    endfunction

    function GetCObjectFromHash takes integer pHash1, integer pHash2 returns integer // Jass Variant of sub_6F03FA30 (126a)
        local integer addr  = GetTempestThread( )
        local integer pOff1 = 0x2C

        if addr != 0 then
            if BitwiseAnd( pHash1, pHash2 ) == -1 then
                return 0
            endif

            if pHash1 >= 0 then
                set pOff1 = 0xC
            endif

            set pOff1 = ReadRealMemory( addr ) + pOff1
            set pOff1 = ReadRealMemory( pOff1 )

            if pOff1 == 0 then
                return 0
            endif

            set pOff1 = ReadRealMemory( pOff1 + 0x8 * pHash1 + 0x4 )

            if pOff1 == 0 or ReadRealMemory( pOff1 + 0x18 ) != pHash2 then
                return 0
            endif

            return pOff1
        endif

        return 0
    endfunction

    function GetCAgentFromHash takes integer pHash1, integer pHash2 returns integer // Jass Variant of sub_6F4786B0 (126a) || pass the read values, not the pointers.
        local integer pOff1 = GetCObjectFromHash( pHash1, pHash2 )

        if pOff1 == 0 or ReadRealMemory( pOff1 + 0x20 ) > 0 then
            return 0
        endif

        return ReadRealMemory( pOff1 + 0x54 )
    endfunction

    function GetCObjectFromHashGroup takes integer pHashGroup returns integer
        // Alternative to GetCObjectFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        local integer addr     = GetTempestThread( )
        local integer pOffset1 = pHashGroup
        local integer pOffset2

        if addr != 0 and pHashGroup != 0 then
            set pOffset2 = ReadRealMemory( addr )

            if pOffset2 > 0 then
                set pOffset1 = ReadRealMemory( pOffset1 )
                set pOffset2 = ReadRealMemory( pOffset2 + 0xC )
                set pOffset2 = ReadRealMemory( ( pOffset1 * 0x8 ) + pOffset2 + 0x4 )
                return pOffset2
            endif
        endif

        return 0
    endfunction

    function GetCObjectFromHashGroup2 takes integer pHash returns integer
        if pHash > 0 then
            return GetCObjectFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        endif

        return 0
    endfunction

    function GetUnitAddressFloatsRelated takes integer pObject, integer offset returns integer
         // Left here for compatibility reasons, use GetObjectFromHashGroup( pObject + offset ) instead.
        if pObject > 0 then
            return GetCObjectFromHashGroup( pObject + offset )
        endif

        return 0
    endfunction

    function GetAgentTimerCooldown takes integer pTimer returns real
        local integer pData = 0
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pTimer != 0 and arg != 0 then
            set pData = ReadRealMemory( pTimer )

            if pData != 0 then
                call WriteRealMemory( arg, 0 )
                call this_call_2( ReadRealMemory( pData + 0x18 ), pTimer, arg )
                return ReadRealFloat( arg )
            endif
        endif

        return -1. // to ensure failure
    endfunction

    function GetAgentTimerExtendedCooldown takes integer pTimerExt returns real
        local integer pData = 0
        local integer arg   = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pTimerExt != 0 and arg != 0 then
            set pData = ReadRealMemory( pTimerExt )

            if pData != 0 then
                call WriteRealMemory( arg + 0x0, 0 )
                call WriteRealMemory( arg + 0x4, 0 )
                call this_call_2( ReadRealMemory( pData + 0x10 ), pTimerExt, arg + 0x0 )
                call this_call_2( ReadRealMemory( pData + 0x1C ), pTimerExt, arg + 0x4 )
                return ReadRealFloat( arg + 0x0 ) - ReadRealFloat( arg + 0x4 )
            endif
        endif

        return -1. // to ensure failure
    endfunction
    
    function Init_APIMemoryGameData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),         pGameDLL + 0xACD44C )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),     pGameDLL + 0xACE5E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),      pGameDLL + 0x3BE7F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),       pGameDLL + 0x3A8BA0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),    pGameDLL + 0x428B90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),    pGameDLL + 0x4317C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),        pGameDLL + 0x4C9020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),  pGameDLL + 0x46F230 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),    pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),    pGameDLL + 0x32D3C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),     pGameDLL + 0x32D420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),      pGameDLL + 0x2DD760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ), pGameDLL + 0x040770 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),         pGameDLL + 0xAB65F4 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),     pGameDLL + 0xAB7788 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),      pGameDLL + 0x3BDCB0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),       pGameDLL + 0x3A8060 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),    pGameDLL + 0x428050 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),    pGameDLL + 0x430C80 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),        pGameDLL + 0x4C8520 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),  pGameDLL + 0x46E720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),    pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),    pGameDLL + 0x32C880 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),     pGameDLL + 0x32C8E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),      pGameDLL + 0x2DCC40 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ), pGameDLL + 0x03FA30 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),         pGameDLL + 0xBE4238 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),     pGameDLL + 0xBE40A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),      pGameDLL + 0x1D1550 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),       pGameDLL + 0x1C3200 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),    pGameDLL + 0x268380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),    pGameDLL + 0x2651D0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),        pGameDLL + 0x17A710 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),  pGameDLL + 0x0352A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),    pGameDLL + 0x021BD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),    pGameDLL + 0x327020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),     pGameDLL + 0x322C30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),      pGameDLL + 0x88F250 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ), pGameDLL + 0x037350 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),         pGameDLL + 0xD687A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),     pGameDLL + 0xD68610 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),      pGameDLL + 0x1EEF90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),       pGameDLL + 0x1E0D70 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),    pGameDLL + 0x285FE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),    pGameDLL + 0x282E30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),        pGameDLL + 0x198420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),  pGameDLL + 0x052480 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),    pGameDLL + 0x03ECD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),    pGameDLL + 0x344760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),     pGameDLL + 0x340380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),      pGameDLL + 0x9BA350 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ), pGameDLL + 0x054530 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),         pGameDLL + 0xD305E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),     pGameDLL + 0xD30448 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),      pGameDLL + 0x2217A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),       pGameDLL + 0x2135F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),    pGameDLL + 0x2B8490 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),    pGameDLL + 0x2B52E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),        pGameDLL + 0x1CACC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),  pGameDLL + 0x07BFE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),    pGameDLL + 0x069D60 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),    pGameDLL + 0x378720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),     pGameDLL + 0x374340 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),      pGameDLL + 0x96F2E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ), pGameDLL + 0x07E090 )
            endif

            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ), Malloc( 0x8 ) )
            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector3" ), Malloc( 0xC ) )
        endif
    endfunction
endlibrary
library APIMemoryWC3GameUI
    globals
        integer pGameUI         = 0
        integer pWorldFrameWar3 = 0
    endglobals

    function GetGameUI takes integer bInit, integer bRelease returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ) )

        if addr != 0 then
            return fast_call_2( addr, bInit, bRelease )
        endif

        return 0
    endfunction

    function GetRootFrame takes nothing returns integer
        if pGameUI != 0 then
            return pGameUI + 0xB4 //180
        endif

        return 0
    endfunction

    // Frame Game API Engine
    function GetUIWorldFrameWar3 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3BC ) // if ReadRealMemory( GetUIWorldFrameWar3 + 0x1AC ) == 9 ???
        endif

        return 0
    endfunction

    function GetUIMinimap takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3C0 )
        endif

        return 0
    endfunction

    function GetUIInfoBar takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3C4 )
        endif

        return 0
    endfunction

    function GetUICommandBar takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3C8 )
        endif

        return 0
    endfunction

    function GetUIResourceBarFrame takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3CC )
        endif

        return 0
    endfunction

    function GetUIUpperButtonBarFrame takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3D0 )
        endif

        return 0
    endfunction

    function GetUIUnknown1 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3D4 ) // ?
        endif

        return 0
    endfunction

    function GetUIClickableBlock takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3D8 )
        endif

        return 0
    endfunction

    function GetUIHeroBar takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3DC )
        endif

        return 0
    endfunction

    function GetUIPeonBar takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3E0 )
        endif

        return 0
    endfunction

    function GetUIMessage takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3E4 )
        endif

        return 0
    endfunction

    function GetUIUnitMessage takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3E8 )
        endif

        return 0
    endfunction

    function GetUIChatMessage takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3EC )
        endif

        return 0
    endfunction

    function GetUITopMessage takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3F0 )
        endif

        return 0
    endfunction

    function GetUIPortrait takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3F4 )
        endif

        return 0
    endfunction

    function GetUITimeOfDayIndicator takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3F8 )
        endif

        return 0
    endfunction

    function GetUIChatEditBar takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x3FC )
        endif

        return 0
    endfunction

    function GetUICinematicPanel takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x400 )
        endif

        return 0
    endfunction

    function GetUIUnknown2 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x404 ) // ?
        endif

        return 0
    endfunction

    function GetUIMinimapButton1 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x408 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton2 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x40C )
        endif

        return 0
    endfunction

    function GetUIMinimapButton3 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x410 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton4 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x414 )
        endif

        return 0
    endfunction

    function GetUIMinimapButton5 takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x418 )
        endif

        return 0
    endfunction

    function GetUIFrameB takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x41C )
        endif

        return 0
    endfunction

    function GetUIMouseBorders takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x420 )
        endif

        return 0
    endfunction

    function GetUIFrameA takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x424 )
        endif

        return 0
    endfunction

    function GetUISimpleConsole takes nothing returns integer
        if pGameUI != 0 then
            return ReadRealMemory( pGameUI + 0x428 )
        endif

        return 0
    endfunction

    function GetPanelButton takes integer pFrame, integer row, integer column returns integer
        if pFrame > 0 then
            return ReadRealMemory( ReadRealMemory( 0x10 * row + ReadRealMemory( pFrame + 0x154 ) + 0x8 ) + 0x4 * column )
        endif

        return 0
    endfunction

    function GetMinimapButton takes integer id returns integer
        local integer pMiniMap = GetUIMinimap( )

        if pMiniMap > 0 then
            if id >= 0 and id <= 4 then 
                return ReadRealMemory( pMiniMap + id * 4 )
            endif
        endif

        return 0
    endfunction

    function GetUpperButtonBarButton takes integer id returns integer
        local integer pOff              = 0
        local integer pUpperButtonBar   = GetUIUpperButtonBarFrame( )

        if pUpperButtonBar > 0 then
            if id == 0 then
                set pOff = 0x138
            elseif id == 1 then
                set pOff = 0x130
            elseif id == 2 then
                set pOff = 0x134
            elseif id == 3 then
                set pOff = 0x160
            endif

            if pOff > 0 then
                return ReadRealMemory( pUpperButtonBar + pOff )
            endif
        endif

        return 0
    endfunction

    function GetSkillBarButtonXY takes integer row, integer column returns integer
        local integer pCommandBar = GetUICommandBar( )

        if pCommandBar > 0 then
            if row >= 0 and row <= 2 and column >= 0 and column <= 3 then
                return GetPanelButton( pCommandBar, row, column )
            endif
        endif

        return 0
    endfunction
	
    function GetSkillBarButton takes integer id returns integer
        local integer pUIBar = GetUICommandBar( )
        local integer pSkillBar = 0

        if pUIBar > 0 then
            if id >= 0 and id <= 11 then
                set pSkillBar = ReadRealMemory( pUIBar + 0x154 )

                if pSkillBar > 0 then
                    return ReadRealMemory( ReadRealMemory( pSkillBar + 0x8 ) ) + id * 0x1C0
                endif
            endif
        endif

        return 0
    endfunction

    function GetItemBarButton takes integer id returns integer
        local integer pInfoBar = GetUIInfoBar( )
        local integer pItemBar = 0

        if pInfoBar > 0 then
            if id >= 0 and id <= 5 then
                set pItemBar = ReadRealMemory( pInfoBar + 0x148 )

                if pItemBar > 0 then
                    //return ReadRealMemory( ReadRealMemory( pItemBar + 0x130 ) + id * 0x8 + 0x4 )
                    return ReadRealMemory( ReadRealMemory( pItemBar + 0x130 ) + 0x4 ) + id * 0x1C0
                endif
            endif
        endif

        return 0
    endfunction
    
    function GetCommandBarButton takes integer id returns integer
        if id >= 0 and id <= 11 then
            return GetSkillBarButton( id )
    elseif id >= 12 and id <= 17 then
            return GetSkillBarButton( id - 12 )
        endif

        return 0
    endfunction

    function GetHeroBarButton takes integer id returns integer
        local integer pHeroBar = GetUIHeroBar( )

        if pHeroBar > 0 then
            if id >= 0 and id <= 6 then
                return GetPanelButton( pHeroBar, id, 0 )
            endif
        endif

        return 0
    endfunction
    
    function GetHeroBarHealthBar takes integer id returns integer
        local integer pHeroBar = GetHeroBarButton( id )
        
        if pHeroBar > 0 then
            return ReadRealMemory( pHeroBar + 0x1CC )
        endif

        return 0
    endfunction

    function GetHeroBarManaBar takes integer id returns integer
        local integer pHeroBar = GetHeroBarButton( id )
        
        if pHeroBar > 0 then
            return ReadRealMemory( pHeroBar + 0x1D0 )
        endif

        return 0
    endfunction

    function UpdateGameUI takes nothing returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ) )

        if addr != 0 then
            call this_call_1( addr, 0 )
        endif
    endfunction

    function GetFrameType takes integer pFrame returns integer
        if pFrame > 0 then
            return LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), ReadRealMemory( pFrame ) )
        endif

        return 0
    endfunction
    
    function LoadImageTexture takes string texturepath, integer flag1, integer flag2 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and arg != 0 and texturepath != "" then
            call WriteRealMemory( arg + 0x0, 0 )
            call WriteRealMemory( arg + 0x4, 0 )
            return fast_call_3( addr, GetStringAddress( texturepath ), arg + 0x0, arg + 0x4 )
        endif

        return 0
    endfunction

    function UnloadImageTexture takes integer pTexture returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ) )

        if addr != 0 and pTexture != 0 then
            return this_call_1( addr, pTexture )
        endif

        return 0
    endfunction
    
    function SetWar3MapMap takes string minimap returns integer
        local integer pMiniMap      = GetUIMinimap( )
        local integer pTexture      = 0
        local integer pOldTexture   = 0

        if pMiniMap != 0 and minimap != "" then
          set pTexture = LoadImageTexture( minimap, 0, 0 )

            if pTexture != 0 then
                set pOldTexture = ReadRealMemory( pMiniMap + 0x17C ) // if 1.29+ then 0x188

                if pOldTexture != 0 then
                    call WriteRealMemory( pMiniMap + 0x17C, pTexture )
                    return UnloadImageTexture( pOldTexture )
                else
                    return UnloadImageTexture( pTexture )
                endif
            endif
        endif

        return 0
    endfunction

    function Init_APIMemoryGameUI takes nothing returns nothing
        if PatchVersion != "" then
           if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ), pGameDLL + 0x301250 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ),    pGameDLL + 0x333240 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ),   pGameDLL + 0x7283A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ), pGameDLL + 0x4DECB0 )
                set pWorldFrameWar3           = pGameDLL + 0x9536A8
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ), pGameDLL + 0x300710 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ),    pGameDLL + 0x332700 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ),   pGameDLL + 0x727C00 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ), pGameDLL + 0x4DE1B0 )
                set pWorldFrameWar3           = pGameDLL + 0x941550
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ), pGameDLL + 0x34F3A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ),    pGameDLL + 0x3599F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ),   pGameDLL + 0x6FEA00 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ), pGameDLL + 0x197AB0 )
                set pWorldFrameWar3           = pGameDLL + 0x98DCD0
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ), pGameDLL + 0x36CB20 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ),    pGameDLL + 0x377190 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ),   pGameDLL + 0x71C150 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ), pGameDLL + 0x1B57E0 )
                set pWorldFrameWar3           = pGameDLL + 0xABB66C
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "GetInstance" ), pGameDLL + 0x3A0B70 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UpdateUI" ),    pGameDLL + 0x3AB2A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "LoadImage" ),   pGameDLL + 0x750320 )
                call SaveInteger( MemHackTable, StringHash( "CGameUI" ), StringHash( "UnloadImage" ), pGameDLL + 0x1E8060 )
                set pWorldFrameWar3           = pGameDLL + 0xAAC008
            endif

            set pGameUI = GetGameUI( 0, 0 )
        endif
    endfunction
endlibrary
library APIMemoryWC3GameUIButton
    function IsCommandButton takes integer pButton returns boolean
        return GetFrameType( pButton ) == 4
    endfunction

    function GetButtonData takes integer pCommandButton returns integer
        if IsCommandButton( pCommandButton ) then
            return ReadRealMemory( pCommandButton + 0x190 )
        endif

        return 0
    endfunction

    function GetButtonGoldCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x58C )
        endif

        return -1
    endfunction

    function GetButtonLumberCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x590 )
        endif

        return -1
    endfunction

    function GetButtonManaCost takes integer pCommandButton returns integer
        local integer pButton = GetButtonData( pCommandButton )

        if pButton > 0 then
            return ReadRealMemory( pButton + 0x594 )
        endif

        return -1
    endfunction

    function GetButtonCooldownOld takes integer pCommandButton returns real
        local integer pAbil     = 0
        local integer pAbilId   = 0
        local integer pOrderId  = 0
        local integer goldcost  = 0
        local integer pAbilVal2 = 0
        local integer pButton   = 0
        local real prAbilVal1   = 0.
        local real prAbilVal2   = 0.

        if IsCommandButton( pCommandButton ) then
            set pButton = ReadRealMemory( pCommandButton + 0x190 )

            if pButton > 0 then
                set pAbil    = ReadRealMemory( pButton + 0x6D4 )
                set pAbilId  = ReadRealMemory( pButton + 0x4   )
                set pOrderId = ReadRealMemory( pButton + 0x8   )
                set goldcost = ReadRealMemory( pButton + 0x58C )

                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton = " + IntToHex( pButton ) )
                //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pButton + 0x6D4 = " + IntToHex( pAbil ) )

                if pAbil != 0 and pAbilId != 'AHer' and pAbilId != 'Amai' and pAbilId != 'Asei' and pAbilId != 'Asel' then //  and goldcost == 0
                    set pAbil = ReadRealMemory( pAbil + 0xDC )
                    //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "pAbil + 0xDC = " + IntToHex( pAbil ) )

                    if pAbil > 0 then
                        set pAbilVal2 = ReadRealMemory( pAbil + 0x0C )
                        //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "ReadRealMemory( pAbil + 0x0C ) = " + IntToHex( pAbilVal2 ) )

                        if pAbilVal2 > 0 then
                            set prAbilVal1 = GetRealFromMemory( ReadRealMemory( pAbil + 0x04 ) )
                            set prAbilVal2 = GetRealFromMemory( ReadRealMemory( pAbilVal2 + 0x40 ) )
                            
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal1 = " + R2S( pAbilVal2 ) )
                            //call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "prAbilVal2 = " + R2S( pAbilVal2 ) )
                            return prAbilVal1 - prAbilVal2
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction

    function GetButtonCooldown takes integer pCommandButton, boolean addcheck returns real
        local integer i           = 0
        local integer pAbil       = 0
        local integer pAbilId     = 0
        local integer flag        = 0
        local integer pOrderId    = 0
        local integer pButtonData = 0
        local integer pTimer      = 0
        local integer pObj        = 0
        local integer arg         = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if IsCommandButton( pCommandButton ) then
            set pButtonData = ReadRealMemory( pCommandButton + 0x190 )

            if pButtonData != 0 then
                set pOrderId = ReadRealMemory( pButtonData + 0x8   )
                set flag     = ReadRealMemory( pButtonData + 0x10  )
                set pAbil    = ReadRealMemory( pButtonData + 0x6D4 )

                if pAbil != 0 then
                     set pAbilId  = ReadRealMemory( pAbil + 0x34 )

                    if pAbilId == 0 or pAbilId == 'AHer' or pAbilId == 'Apit' or pAbilId == 'Asid' or pAbilId == 'Asud' then
                        return 0.
                elseif pAbilId == 'Amai' or pAbilId == 'Asei' or pAbilId == 'Asel' then
                        loop
                            exitwhen i > 12
                            set pObj = ReadRealMemory( pAbil + 0xCC + i * 0x4 )

                            if pObj == pOrderId then
                                // to check for charges -> ReadRealFloat( ReadRealMemory( pAbil + 0x100 + i * 4 ) + 0xC )

                                if ReadRealFloat( pAbil + 0x1C4 + i * 0x1C + 0xC ) != .0 then
                                    set pTimer = pAbil + 0x1C4 + i * 0x1C
                                else
                                    set pTimer = pAbil + 0x318 + i * 0x1C
                                endif

                                if pTimer != 0 then
                                    call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                    return ReadRealFloat( arg + 0x4 )
                                endif
                                exitwhen true
                            endif
                            set i = i + 1
                        endloop
                    else
                        if addcheck and flag == 0x2000401 then
                            return 0.
                        endif

                        set flag = ReadRealMemory( pAbil + 0x20 )

                        if BitwiseAnd( flag, 0x200 ) != 0 and BitwiseAnd( flag, 0x400 ) == 0 then
                            set pTimer = pAbil + 0xD0

                            if pTimer != 0 then
                                call this_call_2( ReadRealMemory( ReadRealMemory( pTimer ) + 0x18 ), pTimer, arg + 0x4 )
                                return ReadRealFloat( arg + 0x4 )
                            endif
                        endif
                    endif
                endif
            endif
        endif

        return 0.
    endfunction
    
    function IsButtonOnCooldown takes integer pCommandButton returns boolean
        return GetButtonCooldown( pCommandButton, true ) > 0.
    endfunction

    function AddFrameType takes string name, integer vtype, integer pVtable, integer pVTableObj returns nothing
        local integer hid = StringHash( "FrameTypeTable" )

        call SaveStr(     MemHackTable, hid, pGameDLL + pVtable,    name  )
        call SaveStr(     MemHackTable, hid, pGameDLL + pVTableObj, name  )
        call SaveInteger( MemHackTable, hid, pGameDLL + pVtable,    vtype )
        call SaveInteger( MemHackTable, hid, pGameDLL + pVTableObj, vtype )
    endfunction

    function Init_APIMemoryGameUIButton takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x98109C, 0x981074 )
                    call AddFrameType( "CButtonFrame",                  2, 0x9813A4, 0x98137C )
                    call AddFrameType( "CChatMode",                     3, 0x94CA1C, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x94EA04, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x9822E4, 0x9822B8 )
                    call AddFrameType( "CEditBox",                      6, 0x980994, 0x980968 )
                    call AddFrameType( "CFrame",                        7, 0x97FB5C, 0x97FB34 )
                    call AddFrameType( "CFloatingFrame",                8, 0x98175C, 0x981730 )
                    call AddFrameType( "CGameUI",                       9, 0x94847C, 0x948454 )
                    call AddFrameType( "CHeroBarButton",               10, 0x951A34, 0x951A14 )
                    call AddFrameType( "CHighlightFrame",              11, 0x98161C, 0x9815F4 )
                    call AddFrameType( "CLayoutFrame",                 12, 0x97FAF0, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x98150C, 0x9814E4 )
                    call AddFrameType( "CMinimap",                     14, 0x952184, 0x95215C )
                    call AddFrameType( "CModelFrame",                  15, 0x981254, 0x98122C )
                    call AddFrameType( "CPortraitButton",              16, 0x95233C, 0x952314 )
                    call AddFrameType( "CScreenFrame",                 17, 0x97FD24, 0x97FCFC )
                    call AddFrameType( "CSimpleButton",                18, 0x97F934, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x9800AC, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x97FC5C, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x980AAC, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x97FA2C, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x980F1C, 0x980EF4 )
                    call AddFrameType( "CSpriteFrame",                 25, 0x98022C, 0x980200 )
                    call AddFrameType( "CStatBar",                     26, 0x95075C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x980C7C, 0x980C54 )
                    call AddFrameType( "CTextButtonFrame",             28, 0x980DBC, 0x980D90 )
                    call AddFrameType( "CTextFrame",                   29, 0x98065C, 0x980630 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x9517E4, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x9536D4, 0x9536A8 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x96EA84, 0x96EA58 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x96C164, 0x96C138 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x96E944, 0x96E918 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x96BFDC, 0x96BFB4 )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x96EBC4, 0x96EB98 )
                    call AddFrameType( "CSlashChatBox",                37, 0x96FC44, 0x96FC1C )
                    call AddFrameType( "CTimerTextFrame",              38, 0x96C6BC, 0x96C690 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x980134, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x981F0C, 0x981EE4 )
                    call AddFrameType( "CUpperButtonBar",              41, 0x94E544, 0x94E524 )
                    call AddFrameType( "CResourceBar",                 42, 0x94F38C, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x94DE8C, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x951D64, 0x951D48 )
                    call AddFrameType( "CHeroBar",                     45, 0x951ACC, 0x951AB0 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x951FBC, 0x951F90 )
                    call AddFrameType( "CInfoBar",                     47, 0x9527C4, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x94E1B4, 0x94E188 )
                    call AddFrameType( "CProgressIndicator",           49, 0x94A4AC, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x951B7C, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x94F7E4, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x94EFB4, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x94D624, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x94D4D4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x94D3E4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x94D36C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x94D2F4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x94D27C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x94D204, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x94D18C, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x94F0EC, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x94FFFC, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x94F06C, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x9800E8, 0x000000 )
                endif
            elseif PatchVersion == "1.26a" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x96F3F4, 0x96F3CC )
                    call AddFrameType( "CButtonFrame",                  2, 0x96F6FC, 0x96F6D4 )
                    call AddFrameType( "CChatMode",                     3, 0x93A8BC, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x93EBC4, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x97063C, 0x970610 )
                    call AddFrameType( "CEditBox",                      6, 0x96ECEC, 0x96ECC0 )
                    call AddFrameType( "CFrame",                        7, 0x96DEB4, 0x96DE8C )
                    call AddFrameType( "CFloatingFrame",                8, 0x96FAB4, 0x96FA88 )
                    call AddFrameType( "CGameUI",                       9, 0x93631C, 0x9362F4 )
                    call AddFrameType( "CHeroBarButton",               10, 0x93F8DC, 0x93F8BC )
                    call AddFrameType( "CHighlightFrame",              11, 0x96F974, 0x96F94C )
                    call AddFrameType( "CLayoutFrame",                 12, 0x96DE48, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x96F864, 0x96F83C )
                    call AddFrameType( "CMinimap",                     14, 0x94002C, 0x940004 )
                    call AddFrameType( "CModelFrame",                  15, 0x96F5AC, 0x96F584 )
                    call AddFrameType( "CPortraitButton",              16, 0x9401E4, 0x9401BC )
                    call AddFrameType( "CScreenFrame",                 17, 0x96E07C, 0x96E054 )
                    call AddFrameType( "CSimpleButton",                18, 0x96DC8C, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x96E404, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x96DFB4, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x96EE04, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x96DD84, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x96F274, 0x96F24C )
                    call AddFrameType( "CSpriteFrame",                 25, 0x96E584, 0x96E558 )
                    call AddFrameType( "CStatBar",                     26, 0x93E604, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x96EFD4, 0x96EFAC )
                    call AddFrameType( "CTextButtonFrame",             28, 0x96F114, 0x96F0E8 )
                    call AddFrameType( "CTextFrame",                   29, 0x96E9B4, 0x96E988 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x93F68C, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x94157C, 0x941550 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x95C92C, 0x95C900 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x95A00C, 0x959FE0 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x95C7EC, 0x95C7C0 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x959E84, 0x959E5C )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x95CA6C, 0x95CA40 )
                    call AddFrameType( "CSlashChatBox",                37, 0x95DAEC, 0x95DAC4 )
                    call AddFrameType( "CTimerTextFrame",              38, 0x95A564, 0x95A538 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x96E48C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x970264, 0x97023C )
                    call AddFrameType( "CUpperButtonBar",              41, 0x93C3E4, 0x93C3C4 )
                    call AddFrameType( "CResourceBar",                 42, 0x93D22C, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x93BD2C, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x93FC0C, 0x93FBF0 )
                    call AddFrameType( "CHeroBar",                     45, 0x93F974, 0x93F958 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x93FE64, 0x93FE38 )
                    call AddFrameType( "CInfoBar",                     47, 0x94066C, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x93C054, 0x93C028 )
                    call AddFrameType( "CProgressIndicator",           49, 0x93834C, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x93FA24, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x93D684, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x93CE54, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x93B4C4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x93B374, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x93B284, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x93B20C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x93B194, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x93B11C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x93B0A4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x93B02C, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x93CF8C, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x93DE9C, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x93CF0C, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x96E440, 0x000000 )
                endif
        elseif PatchVersion == "1.27a" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0x95AC3C, 0x95AD38 )
                    call AddFrameType( "CButtonFrame",                  2, 0x95B318, 0x95B42C )
                    call AddFrameType( "CChatMode",                     3, 0x98FB4C, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0x98F6A8, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0x95D0BC, 0x95D1AC )
                    call AddFrameType( "CEditBox",                      6, 0x95BCBC, 0x95BDD4 )
                    call AddFrameType( "CFrame",                        7, 0x95A760, 0x95A848 )
                    call AddFrameType( "CFloatingFrame",                8, 0x95D1D4, 0x95D2BC )
                    call AddFrameType( "CGameUI",                       9, 0x98C3EC, 0x98C4D4 )
                    call AddFrameType( "CHeroBarButton",               10, 0x990E44, 0x990EBC )
                    call AddFrameType( "CHighlightFrame",              11, 0x95ADD4, 0x95AEBC )
                    call AddFrameType( "CLayoutFrame",                 12, 0x95CB54, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0x95AF28, 0x95B010 )
                    call AddFrameType( "CMinimap",                     14, 0x99244C, 0x992538 )
                    call AddFrameType( "CModelFrame",                  15, 0x95AAE4, 0x95ABE0 )
                    call AddFrameType( "CPortraitButton",              16, 0x9922FC, 0x992424 )
                    call AddFrameType( "CScreenFrame",                 17, 0x95D2E4, 0x95D3CC )
                    call AddFrameType( "CSimpleButton",                18, 0x95C9A4, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0x95CE00, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0x95C8A4, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0x95CE64, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0x95CF38, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0x95B468, 0x95B584 )
                    call AddFrameType( "CSpriteFrame",                 25, 0x95A8A4, 0x95A994 )
                    call AddFrameType( "CStatBar",                     26, 0x98F52C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0x95C610, 0x95C724 )
                    call AddFrameType( "CTextButtonFrame",             28, 0x95BF60, 0x95C074 )
                    call AddFrameType( "CTextFrame",                   29, 0x95B050, 0x95B164 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0x98F364, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0x98DCD0, 0x98DDB8 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0x975D40, 0x975E54 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0x975E7C, 0x975F90 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0x977A44, 0x977B58 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0x975FB8, 0x9760CC )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0x9760F4, 0x97620C )
                    call AddFrameType( "CSlashChatBox",                37, 0x977278, 0x977390 )
                    call AddFrameType( "CTimerTextFrame",              38, 0x979FBC, 0x97A0D0 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0x95CABC, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0x95B1B0, 0x95B2B8 )
                    call AddFrameType( "CUpperButtonBar",              41, 0x98EF64, 0x98EFD4 )
                    call AddFrameType( "CResourceBar",                 42, 0x993E54, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0x992D68, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0x992C60, 0x992CD4 )
                    call AddFrameType( "CHeroBar",                     45, 0x990ED8, 0x990F4C )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0x994620, 0x994710 )
                    call AddFrameType( "CInfoBar",                     47, 0x99197C, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0x994510, 0x9945F8 )
                    call AddFrameType( "CProgressIndicator",           49, 0x98B0E4, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0x991010, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0x98F438, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0x991778, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0x9916F8, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0x991584, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0x991510, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0x99149C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0x991428, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0x9913B4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0x991340, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0x9912CC, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0x991678, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0x99116C, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0x9915F8, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0x95CDC4, 0x000000 )
                endif
        elseif PatchVersion == "1.27b" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0xA8B5AC, 0xA8B6A8 )
                    call AddFrameType( "CButtonFrame",                  2, 0xA8BC88, 0xA8BD9C )
                    call AddFrameType( "CChatMode",                     3, 0xABD488, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0xABCFF4, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0xA8DA14, 0xA8DB04 )
                    call AddFrameType( "CEditBox",                      6, 0xA8C62C, 0xA8C744 )
                    call AddFrameType( "CFrame",                        7, 0xA8B0D0, 0xA8B1B8 )
                    call AddFrameType( "CFloatingFrame",                8, 0xA8DB2C, 0xA8DC14 )
                    call AddFrameType( "CGameUI",                       9, 0xAB9D90, 0xAB9E78 )
                    call AddFrameType( "CHeroBarButton",               10, 0xABE768, 0xABE7E0 )
                    call AddFrameType( "CHighlightFrame",              11, 0xA8B744, 0xA8B82C )
                    call AddFrameType( "CLayoutFrame",                 12, 0xA8D4B4, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0xA8B898, 0xA8B980 )
                    call AddFrameType( "CMinimap",                     14, 0xAB0EE4, 0xAB0FD4 )
                    call AddFrameType( "CModelFrame",                  15, 0xA8B454, 0xA8B550 )
                    call AddFrameType( "CPortraitButton",              16, 0xABFBC0, 0xABFCE8 )
                    call AddFrameType( "CScreenFrame",                 17, 0xA8DC3C, 0xA8DD24 )
                    call AddFrameType( "CSimpleButton",                18, 0xA8D304, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0xA8D760, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0xA8D204, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0xA8D7C4, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0xA8D88C, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0xA8BDD8, 0xA8BEF4 )
                    call AddFrameType( "CSpriteFrame",                 25, 0xA8B214, 0xA8B304 )
                    call AddFrameType( "CStatBar",                     26, 0xABCE78, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0xA8CF7C, 0xA8D090 )
                    call AddFrameType( "CTextButtonFrame",             28, 0xA8C8CC, 0xA8C9E0 )
                    call AddFrameType( "CTextFrame",                   29, 0xA8B9C0, 0xA8BAD4 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0xABCCC8, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0xABB66C, 0xABB754 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0xAA3D00, 0xAA3E14 )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0xAA3E3C, 0xAA3F50 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0xAA59C0, 0xAA5AD4 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0xAA3F78, 0xAA408C )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0xAA40B4, 0xAA41CC )
                    call AddFrameType( "CSlashChatBox",                37, 0xAA5238, 0xAA5350 )
                    call AddFrameType( "CTimerTextFrame",              38, 0xAA7E70, 0xAA7F84 )
                    call AddFrameType( "CSimpleStatusBar",             39, 0xA8D41C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0xA8BB20, 0xA8BC28 )
                    call AddFrameType( "CUpperButtonBar",              41, 0xABC8D8, 0xABC948 )
                    call AddFrameType( "CResourceBar",                 42, 0xAC16A8, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0xAC05FC, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0xAC0504, 0xAC0578 )
                    call AddFrameType( "CHeroBar",                     45, 0xABE7FC, 0xABE870 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0xAC1E58, 0xAC1F48 )
                    call AddFrameType( "CInfoBar",                     47, 0xABF288, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0xAC1D48, 0xAC1E30 )
                    call AddFrameType( "CProgressIndicator",           49, 0xAB8BE8, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0xABE924, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0xABCD94, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0xABF084, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0xABF004, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0xABEE90, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0xABEE1C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0xABEDA8, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0xABED34, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0xABECC0, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0xABEC4C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0xABEBD8, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0xABEF84, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0xABEA78, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0xABEF04, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0xA8D724, 0x000000 )
                endif
        elseif PatchVersion == "1.28f" then
                if true then // Generation of Frame Type Table
                    call AddFrameType( "CBackdropFrame",                1, 0xA7AFBC, 0xA7B0B8 )
                    call AddFrameType( "CButtonFrame",                  2, 0xA7B698, 0xA7B7AC )
                    call AddFrameType( "CChatMode",                     3, 0xAADE54, 0x000000 )
                    call AddFrameType( "CCommandButton",                4, 0xAAD9B8, 0x000000 )
                    call AddFrameType( "CCursorFrame",                  5, 0xA7D42C, 0xA7D51C )
                    call AddFrameType( "CEditBox",                      6, 0xA7C03C, 0xA7C154 )
                    call AddFrameType( "CFrame",                        7, 0xA7AAE0, 0xA7ABC8 )
                    call AddFrameType( "CFloatingFrame",                8, 0xA7D544, 0xA7D62C )
                    call AddFrameType( "CGameUI",                       9, 0xAAA730, 0xAAA818 )
                    call AddFrameType( "CHeroBarButton",               10, 0xAAF130, 0xAAF1A8 )
                    call AddFrameType( "CHighlightFrame",              11, 0xA7B154, 0xA7B23C )
                    call AddFrameType( "CLayoutFrame",                 12, 0xA7CEC4, 0x000000 )
                    call AddFrameType( "CMessageFrame",                13, 0xA7B2A8, 0xA7B390 )
                    call AddFrameType( "CMinimap",                     14, 0xAB0704, 0xAB07F0 )
                    call AddFrameType( "CModelFrame",                  15, 0xA7AE64, 0xA7AF60 )
                    call AddFrameType( "CPortraitButton",              16, 0xAB05B4, 0xAB06DC )
                    call AddFrameType( "CScreenFrame",                 17, 0xA7D654, 0xA7D73C )
                    call AddFrameType( "CSimpleButton",                18, 0xA7CD14, 0x000000 )
                    call AddFrameType( "CSimpleFontString",            19, 0xA7D178, 0x000000 )
                    call AddFrameType( "CSimpleFrame",                 20, 0xA7CC14, 0x000000 )
                    call AddFrameType( "CSimpleGlueFrame",             21, 0xA7D1DC, 0x000000 )
                    call AddFrameType( "CUknown_1",                    22, 0x000000, 0x000000 )
                    call AddFrameType( "CSimpleMessageFrame",          23, 0xA7D2A8, 0x000000 )
                    call AddFrameType( "CSlider",                      24, 0xA7B7E8, 0xA7B904 )
                    call AddFrameType( "CSpriteFrame",                 25, 0xA7AC24, 0xA7AD14 )
                    call AddFrameType( "CStatBar",                     26, 0xAAD83C, 0x000000 )
                    call AddFrameType( "CTextArea",                    27, 0xA7C98C, 0xA7CAA0 )
                    call AddFrameType( "CTextButtonFrame",             28, 0xA7C2DC, 0xA7C3F0 )
                    call AddFrameType( "CTextFrame",                   29, 0xA7B3D0, 0xA7B4E4 )
                    call AddFrameType( "CUberToolTipWar3",             30, 0xAAD684, 0x000000 )
                    call AddFrameType( "CWorldFrameWar3",              31, 0xAAC008, 0xAAC0F0 )
                    call AddFrameType( "CGlueButtonWar3",              32, 0xA93B68, 0xA93C7C )
                    call AddFrameType( "CGlueTextButtonWar3",          33, 0xA93CA4, 0xA93DB8 )
                    call AddFrameType( "CGlueCheckBoxWar3",            34, 0xA95844, 0xA95958 )
                    call AddFrameType( "CGluePopupMenuWar3",           35, 0xA93DE0, 0xA93EF4 )
                    call AddFrameType( "CGlueEditBoxWar3",             36, 0xA93F1C, 0xA94034 )
                    call AddFrameType( "CSlashChatBox",                37, 0xA950A0, 0xA951B8 )
                    call AddFrameType( "CTimerTextFrame",              38, 0xA97D38, 0xA97E4C )
                    call AddFrameType( "CSimpleStatusBar",             39, 0xA7CE2C, 0x000000 )
                    call AddFrameType( "CStatusBar",                   40, 0xA7B530, 0xA7B638 )
                    call AddFrameType( "CUpperButtonBar",              41, 0xAAD28C, 0xAAD2FC )
                    call AddFrameType( "CResourceBar",                 42, 0xAB20D4, 0x000000 )
                    call AddFrameType( "CSimpleConsole",               43, 0xAB1008, 0x000000 )
                    call AddFrameType( "CPeonBar",                     44, 0xAB0F08, 0xAB0F7C )
                    call AddFrameType( "CHeroBar",                     45, 0xAAF1C4, 0xAAF238 )
                    call AddFrameType( "CTimeOfDayIndicator",          46, 0xAB2890, 0xAB2980 )
                    call AddFrameType( "CInfoBar",                     47, 0xAAFC58, 0x000000 )
                    call AddFrameType( "CTimeCover",                   48, 0xAB2780, 0xAB2868 )
                    call AddFrameType( "CProgressIndicator",           49, 0xAA950C, 0x000000 )
                    call AddFrameType( "CHeroLevelBar",                50, 0xAAF2F0, 0x000000 )
                    call AddFrameType( "CBuildTimeIndicator",          51, 0xAAD750, 0x000000 )
                    call AddFrameType( "CInfoPanelDestructableDetail", 52, 0xAAFA54, 0x000000 )
                    call AddFrameType( "CInfoPanelItemDetail",         53, 0xAAF9D4, 0x000000 )
                    call AddFrameType( "CInfoPanelIconAlly",           54, 0xAAF860, 0x000000 )
                    call AddFrameType( "CInfoPanelIconHero",           55, 0xAAF7EC, 0x000000 )
                    call AddFrameType( "CInfoPanelIconGold",           56, 0xAAF778, 0x000000 )
                    call AddFrameType( "CInfoPanelIconFood",           57, 0xAAF704, 0x000000 )
                    call AddFrameType( "CInfoPanelIconRank",           58, 0xAAF690, 0x000000 )
                    call AddFrameType( "CInfoPanelIconArmor",          59, 0xAAF61C, 0x000000 )
                    call AddFrameType( "CInfoPanelIconDamage",         60, 0xAAF5A8, 0x000000 )
                    call AddFrameType( "CInfoPanelCargoDetail",        61, 0xAAF954, 0x000000 )
                    call AddFrameType( "CInfoPanelBuildingDetail",     62, 0xAAF448, 0x000000 )
                    call AddFrameType( "CInfoPanelUnitDetail",         63, 0xAAF8D4, 0x000000 )
                    call AddFrameType( "CSimpleTexture",               64, 0xA7D13C, 0x000000 )
                endif
            endif
        endif
    endfunction
endlibrary
library APIMemoryWC3GameWindow
    // Window API Engine
    function GetWindowWidth takes nothing returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ) )
    
        if addr != 0 then
            return ReadRealFloat( addr )
        endif

        return 0.
    endfunction

    function GetWindowHeight takes nothing returns real
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ) )

        if addr != 0 then
            return ReadRealFloat( addr )
        endif

        return 0.
    endfunction
    
    function GetWindowCenterX takes nothing returns real
        return GetWindowX( LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) ) ) + GetWindowWidth( ) * 0.5
    endfunction

    function GetWindowCenterY takes nothing returns real
        return GetWindowY( LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) ) ) + GetWindowHeight( ) * 0.5
    endfunction

    function GetWarcraftWindow takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ) )
        local integer hwnd = 0

        if addr != 0 then
            set hwnd = this_call_1( addr, 0 )
        else
            set hwnd = FindWindow( "Warcraft III", "Warcraft III" )
        endif

        return hwnd
    endfunction
    
    function FromPixelX takes integer i returns real
        return i * 0.8 / GetWindowWidth( )
    endfunction

    function FromPixelY takes integer i returns real
        return i * 0.6 / GetWindowHeight( )
    endfunction
    //===========================================

    function Init_APIMemoryGameWindow takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xAF577C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xAF5778 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x6BB510 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xADE91C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xADE918 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x6BAD70 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xBBA22C )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xBBA228 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x14D670 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xD47CC4 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xD47CC0 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x08B0A0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Width" ),     pGameDLL + 0xD0FAB4 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Height" ),    pGameDLL + 0xD0FAB0 )
                call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "GetWindow" ), pGameDLL + 0x0B49B0 )
            endif

            call SaveInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ), GetWarcraftWindow( ) )
        endif
    endfunction
endlibrary
library MemoryHackConstantsAPI
    function IsOPLimitRemoved takes nothing returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "GetData" ) )

        if addr != 0 then
            return ReadRealMemory( addr ) == 0x6A570FFF // 6A570004
        endif

        return false
    endfunction

    function EnableOPLimitEx takes boolean flag, integer id returns nothing
        local integer addr           = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr" + I2S( id ) ) )
        local integer oldvalue       = LoadInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( id ) ) )
        local integer value          = 0
        local integer oldprotection1 = 0

        if addr != 0 then
            if oldvalue == 0 then
                set oldvalue = ReadRealMemory( addr )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( id ) ), ReadRealMemory( addr ) )
            endif

            if oldvalue != 0 then
                if flag then
                    set value = oldvalue
                else
                    set value = 0x6A570FFF
                endif

                set oldprotection1 = ChangeOffsetProtection( addr, 0x4, 0x40 )
                call WriteRealMemory( addr, value )
                //call BJDebugMsg( "ReadRealMemory( addr " + I2S( id ) + " ) = " + IntToHex( ReadRealMemory( addr ) ) )
                call ChangeOffsetProtection( addr, 0x4, oldprotection1 )
            endif
        endif
    endfunction
    
    function EnableOPLimit takes boolean flag returns nothing
        local integer i = 1

        loop
            exitwhen i > 9
            call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Value" + I2S( i ) ), 0x0 )
            call EnableOPLimitEx( flag, i )
            set i = i + 1
        endloop
    endfunction
    
    function Init_MemHackConstantsAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A8ECC )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DED64 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E1718 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E1728 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B5F02 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B5FC1 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B5FF3 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x460489 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x460818 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x3A838C ) // addr4
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x2DE244 ) // ScriptRunFunctionById limit1
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x2E0BF8 ) // ScriptRunFunctionById limit2
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x2E0C08 ) // ScriptRunFunction "main" limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x3B53C2 ) // jPreloader Limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x3B5481 ) // config limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x3B54B3 ) // main limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x45F979 ) // call limit
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x45FD08 ) // call native limit?
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1BFB4B )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x1E9A01 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x1EF713 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x1F224D )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x7F1975 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x7F2A1C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x8909F7 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x890A07 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x8920A6 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x1DD83B )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x207451 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x20D153 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x20FECD )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x91B3B5 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x91C3EC )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x9BBAF7 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x9BBB07 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x9BD1A6 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr1" ), pGameDLL + 0x2100BB )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr2" ), pGameDLL + 0x239C21 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr3" ), pGameDLL + 0x23F943 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr4" ), pGameDLL + 0x24255C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr5" ), pGameDLL + 0x8D0305 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr6" ), pGameDLL + 0x8D133C )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr7" ), pGameDLL + 0x970A87 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr8" ), pGameDLL + 0x970A97 )
                call SaveInteger( MemHackTable, StringHash( "OPLimit" ), StringHash( "Addr9" ), pGameDLL + 0x972136 )
            endif

            
        endif
    endfunction
endlibrary
library MHMain requires APIBasicUtils,APIAllTypecast,APIMemory,APIMemoryAllCalls,APIMemoryBitwise,APIMemoryForString,APIMemoryKernel,APIMemoryMPQ,APIMemoryHStormDLL
    function RunMh takes nothing returns nothing
        
    endfunction
endlibrary

//! endnocjass