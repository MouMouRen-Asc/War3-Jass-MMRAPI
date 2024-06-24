//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
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

        if numb != 0 then
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
        else
            set result = "0x00"
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
//! endnocjass


//TESH.scrollpos=77
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass


//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
native MergeUnits   takes integer qty, integer a, integer b, integer make returns boolean    // reserved native for call 4 integer function and return BOOLEAN value
native ConvertUnits takes integer qty, integer id returns boolean                            // reserved native for call 2 integer function and return BOOLEAN value (can be converted to int!)
native IgnoredUnits takes integer unitid returns integer                                     // reserved native for call 1 integer function and return integer value

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
        if address * 4 < 0x7FFFFFFF and address > 0x500 then
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
//! endnocjass


//TESH.scrollpos=60
//TESH.alwaysfold=0
//! nocjass
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

    function std_call_0 takes integer funcaddr returns integer
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

    function std_call_7 takes integer funcaddr, integer arg1, integer arg2, integer arg3, integer arg4, integer arg5, integer arg6, integer arg7 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "std_call_7" ), StringHash( "function" ) )

        if addr != 0 then
            if ReadRealMemory( addr ) == 0 then
                call WriteRealMemory( addr + 0x00, 0x68C98B51 ) // push ecx, mov ecx, ecx
                call WriteRealMemory( addr + 0x08, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x10, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x18, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x20, 0x6890C98B ) // mov ecx, ecx
                call WriteRealMemory( addr + 0x28, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x30, 0x6890C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x38, 0xB990C98B ) // mov ecx, ecx, nop
                call WriteRealMemory( addr + 0x40, 0xC359D1FF ) // call ecx, pop ecx, ret
            endif

            call WriteRealMemory( addr + 0x04, arg7 )     // push arg7
            call WriteRealMemory( addr + 0x0C, arg6 )     // push arg6
            call WriteRealMemory( addr + 0x14, arg5 )     // push arg5
            call WriteRealMemory( addr + 0x1C, arg4 )     // push arg4
            call WriteRealMemory( addr + 0x24, arg3 )     // push arg3
            call WriteRealMemory( addr + 0x2C, arg2 )     // push arg2
            call WriteRealMemory( addr + 0x34, arg1 )     // push arg1
            call WriteRealMemory( addr + 0x3C, funcaddr ) // mov ecx, funcaddr

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
                call WriteRealMemory( addr + 0xC, 0xCCC35900 ) // 0x0, pop ecx, ret
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
                call WriteRealMemory( addr + 0x14, 0xCCC35904 ) // 0x4, pop ecx, ret
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
            call AllocFunctionCall( "std_call_7", 0x44 )

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
//! endnocjass


//TESH.scrollpos=30
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass


//TESH.scrollpos=3
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass


//TESH.scrollpos=364
//TESH.alwaysfold=0
//! nocjass
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
    
    function CreateDirectory takes string directorypath, integer securityAttributes returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CreateDirectoryA", true )
        
        if addr != 0 then
            return std_call_2( addr, GetStringAddress( directorypath ), securityAttributes )
        endif
        
        return 0
    endfunction

    function CreateFile takes string filename, integer accessType, integer shareMode, integer securityAttributes, integer creationDisposition, integer flags, integer templateFile returns integer
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CreateFileA", true )

        if addr != 0 then
            // explanations here: https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
            return std_call_7( addr, GetStringAddress( filename ), accessType, shareMode, securityAttributes, creationDisposition, flags, templateFile )
        endif

        return 0
    endfunction
    
    function CreateFileSimple takes string filename returns integer
        return CreateFile( filename, 0xC0000000, 0x00000002, 0, 0x1, 0x80, 0 )
    endfunction
    
    function CloseHandle takes integer hHandle returns nothing
        local integer addr = GetFuncFromDll( "Kernel32.dll", "CloseHandle", true )

        if addr != 0 and hHandle != 0 then
            // explanations here: https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea
            call std_call_1( addr, hHandle )
        endif
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

    // Window API
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

    function GetActiveWindow takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetActiveWindow", true )
        
        if addr != 0 then
            return std_call_0( addr )
        endif

        return 0
    endfunction

    function GetForegroundWindow takes nothing returns integer
        local integer addr = GetFuncFromDll( "User32.dll", "GetForegroundWindow", true )

        if addr != 0 then
            return std_call_0( addr )
        endif

        return 0
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

    function PostMessage takes integer hwnd, integer msg, integer wparam, integer lparam returns nothing
        local integer addr = GetFuncFromDll( "User32.dll", "PostMessageA", true )

        if addr != 0 then
            call std_call_4( addr, hwnd, msg, wparam, lparam )
        endif

        //call PostMessage( pHWND_WC3, 0x0100, 0x0D, 0 )
        //call PostMessage( pHWND_WC3, 0x0101, 0x0D, 0 )
    endfunction
    //

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
//! endnocjass

//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryRestorer
    function AddNewOffsetToRestore takes integer offsetaddress, integer offsetdefaultdata returns nothing
        local integer len
        local integer i
        local integer arr_hash  = StringHash( "MemRestorerArray" )
        local integer addr_hash = StringHash( "MemRestorerArrayAddr" )
        local integer val_hash  = StringHash( "MemRestorerArrayValue" )

        if offsetaddress == 0 or LoadBoolean( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "IsGameClosing" ) ) then
            return
        endif

        set len = LoadInteger( MemHackTable, arr_hash, StringHash( "Length" ) )
        set i = len
        loop
            exitwhen i == 0

            if LoadInteger( MemHackTable, addr_hash, i ) == offsetaddress then
                return
            endif

            set i = i - 1
        endloop

        set len = len + 1
        call SaveInteger( MemHackTable, addr_hash, len, offsetaddress )
        call SaveInteger( MemHackTable, val_hash, len, offsetdefaultdata )
        call SaveInteger( MemHackTable, arr_hash, StringHash( "Length" ), len )
    endfunction

    function ChangeOffsetProtection takes integer pRealOffset, integer pMemSize, integer pProtectFlag returns integer
        local integer addr   = GetFuncFromDll( "Kernel32.dll", "VirtualProtect", true )
        local integer a
        local integer nIndex = 0

        if addr != 0 then
            call AddNewOffsetToRestore( pRealOffset, ReadRealMemory( pRealOffset ) )

            if pMemSize > 0x4 then
                set nIndex = pMemSize / 0x4 - 0x1
                set a = pRealOffset
                loop
                    exitwhen nIndex < 0x1
                    set a = a + 0x4
                    call AddNewOffsetToRestore( a, ReadRealMemory( a ) )
                    set nIndex = nIndex - 0x1
                endloop
            endif

            return VirtualProtect( pRealOffset, pMemSize, pProtectFlag )
        endif

        return 0
    endfunction

    function PatchRealMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprot = 0
        
        if addr != 0 then
            set oldprot = VirtualProtect( addr, size, 0x40 )
            call WriteRealMemory( addr, val )
            call VirtualProtect( addr, size, oldprot )
        endif
    endfunction

    function PatchRealMemory takes integer addr, integer val returns nothing
        call PatchRealMemoryEx( addr, val, 0x4 )
    endfunction

    function PatchMemoryEx takes integer addr, integer val, integer size returns nothing
        local integer oldprot = 0
        
        if addr != 0 then
            set oldprot = VirtualProtect( addr, size, 0x40 )
            call WriteMemory( addr, val )
            call VirtualProtect( addr, size, oldprot )
        endif
    endfunction

    function PatchMemory takes integer addr, integer val returns nothing
        call PatchMemoryEx( addr, val, 0x4 )
    endfunction
    
    function RestoreAllMemory takes nothing returns nothing
        local integer i         = LoadInteger( MemHackTable, StringHash( "MemRestorerArray" ), StringHash( "Length" ) )
        local integer addr_hash = StringHash( "MemRestorerArrayAddr" )
        local integer val_hash  = StringHash( "MemRestorerArrayValue" )
        local integer oldprot

        call SaveBoolean( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "IsGameClosing" ), true )
        loop
            exitwhen i < 1
            set oldprot = ChangeOffsetProtection( LoadInteger( MemHackTable, addr_hash, i ), 0x4, 0x40 )
            call WriteRealMemory( LoadInteger( MemHackTable, addr_hash, i ), LoadInteger( MemHackTable, val_hash, i ) )
            call ChangeOffsetProtection( LoadInteger( MemHackTable, addr_hash, i ), 0x4, oldprot )
            set i = i - 1
        endloop
    endfunction

    function InitExtrasPageDisplayOnExit takes integer pTriggerHandle returns nothing
        local integer pTriggerExecute = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ) )
        local integer pExtrasPage     = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ) )
        local integer pFinalTableHook = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageMemory" ) )
        local integer oldprot         = 0

        if pTriggerExecute != 0 and pExtrasPage != 0 and pFinalTableHook == 0 then
            set pFinalTableHook = AllocateExecutableMemory( 0x1C ) // Old memory size = 60 * 0x4 | size reduced to the amount it actually occupies, aka last offset + 0x4 -> pFinalTableHook + 0x18 => 0x1C

            if pFinalTableHook != 0 then
                set oldprot   = VirtualProtect( pExtrasPage, 0x8, 0x40 )

                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageMemory" ), pFinalTableHook )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal1" ), ReadRealMemory( pExtrasPage + 0x0 ) )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal2" ), ReadRealMemory( pExtrasPage + 0x4 ) )

                call WriteRealMemory( pExtrasPage     + 0x00, 0xE9E9E9E9 )                                     // jmp | jmp | jmp | jmp
                call WriteRealMemory( pExtrasPage     + 0x01, pFinalTableHook - ( pExtrasPage + 0x1 ) - 0x4 )  // redirection to new address
                call WriteRealMemory( pFinalTableHook + 0x00, 0x68609090 )                                     // nop | nop | pusha | push (pTriggerHandle)
                call WriteRealMemory( pFinalTableHook + 0x04, pTriggerHandle )                                 // argument getting pushed
                call WriteRealMemory( pFinalTableHook + 0x08, 0xB890C08B )                                     // mov eax, eax | nop | mov eax, pTriggerExecute
                call WriteRealMemory( pFinalTableHook + 0x0C, pTriggerExecute )                                // argument getting moved into eax
                call WriteRealMemory( pFinalTableHook + 0x10, 0xC483D0FF )                                     // call eax | add esp, 0x4
                call WriteRealMemory( pFinalTableHook + 0x14, 0xE9906104 )                                     // 0x4 | popa | nop | jmp (pExtrasPage)
                call WriteRealMemory( pFinalTableHook + 0x18, pExtrasPage - ( pFinalTableHook + 0x18 ) - 0x4 ) // argument that we jump to
                call VirtualProtect( pExtrasPage, 0x8, oldprot )                                               // Restoring original Memory Protection Method
            endif
        endif
    endfunction

    function DisplayExtrasPageDisplayOnExit takes nothing returns nothing
        local integer pExtrasPage = LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ) )
        local integer oldprot     = 0

        if pExtrasPage != 0 then
            set oldprot = VirtualProtect( pExtrasPage, 0x8, 0x40 )
            call WriteRealMemory( pExtrasPage + 0x0, LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal1" ) ) )
            call WriteRealMemory( pExtrasPage + 0x4, LoadInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPageVal2" ) ) )
            call VirtualProtect( pExtrasPage, 0x8, oldprot )
            call RestoreAllMemory( )
        endif
    endfunction

    function Init_RestoreMemoryOnExit takes trigger t returns nothing
        call TriggerAddAction( t, function DisplayExtrasPageDisplayOnExit )
        call InitExtrasPageDisplayOnExit( GetHandleId( t ) )
    endfunction
    
    function Init_APIMemoryRestorer takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x3C4A80 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x5C48C0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x3C3F40 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x5C4120 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x1F9100 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2847F0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x216D90 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2A23E0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "TriggerExecute" ), pGameDLL + 0x249410 )
                call SaveInteger( MemHackTable, StringHash( "MemRestorerAPI" ), StringHash( "ExtrasPage" ),     pGameDLL + 0x2D4940 )
            endif

            call SaveInteger( MemHackTable, StringHash( "MemRestorerArray" ), StringHash( "Length" ), 0 )
            call Init_RestoreMemoryOnExit( CreateTrigger( ) )
        endif
    endfunction
endlibrary
//! endnocjass


//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass


//TESH.scrollpos=6
//TESH.alwaysfold=0
//! nocjass
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

    function LoadDllFromMPQEx takes string source, string dest, string dllname returns boolean
        if ExportFileFromMPQ( source, dest ) then
            call LoadLibrary( dllname )
            return true
        endif

        return false
    endfunction

    function LoadDllFromMPQ takes string dllname returns boolean
        return LoadDllFromMPQEx( dllname, dllname, dllname )
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
//! endnocjass


//TESH.scrollpos=81
//TESH.alwaysfold=0
library APIMemoryFrameData
    function GetFrameType takes integer pFrame returns integer
        if pFrame != 0 then
            return LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), ReadRealMemory( pFrame ) )
        endif

        return 0
    endfunction

    function GetFrameTypeName takes integer pFrame returns string
        if pFrame != 0 then
            return LoadStr( MemHackTable, StringHash( "FrameTypeTable" ), ReadRealMemory( pFrame ) )
        endif

        return ""
    endfunction

    function GetFrameTypeNameByIndex takes integer index returns string
        if index > 0 then
            return LoadStr( MemHackTable, StringHash( "FrameTypeTable" ), index )
        endif

        return ""
    endfunction

    function GetFrameLayoutAddress takes integer pFrame returns integer
        local integer fid = GetFrameType( pFrame )

        if fid != 0 then
            return LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), fid + 0x1000 )
        endif

        return 0
    endfunction

    function GetFrameHasLayout takes integer pFrame returns boolean
        return GetFrameLayoutAddress( pFrame ) != 0
    endfunction

    function GetFrameLayoutByType takes integer pFrame, integer fid returns integer
        local boolean haslayout = false
        local string f_name1 = ""

        if fid != 0 then
            set f_name1 = GetFrameTypeName( pFrame )
            set haslayout = LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), fid + 0x1000 ) != 0 and f_name1 != "CHeroBar" and f_name1 != "CPeonBar" and f_name1 != "CUpperButtonBar" and f_name1 != "CResourceBar"

            if not haslayout or ReadRealMemory( pFrame ) != LoadInteger( MemHackTable, StringHash( "FrameTypeTable" ), fid ) then
                return pFrame
            else
                return pFrame + 0xB4 // if 1.29+ 0xBC
            endif
        endif

        return 0
    endfunction

    function GetFrameLayout takes integer pFrame returns integer
        return GetFrameLayoutByType( pFrame, GetFrameType( pFrame ) )
    endfunction

    function IsFrameLayoutByType takes integer pFrame, integer fid returns boolean
        return GetFrameLayoutByType( pFrame, fid ) == pFrame
    endfunction

    function IsFrameLayout takes integer pFrame returns boolean
        return GetFrameLayout( pFrame ) == pFrame
    endfunction

    function AddFrameType takes string name, integer vtype, integer pVtable, integer pVTableObj returns nothing
        local integer hid = StringHash( "FrameTypeTable" )

        if pVtable != 0 then
            call SaveStr(     MemHackTable, hid, vtype,          name  )
            call SaveInteger( MemHackTable, hid, vtype,          pGameDLL + pVtable )

            call SaveStr(     MemHackTable, hid, pGameDLL + pVtable,    name  )
            call SaveInteger( MemHackTable, hid, pGameDLL + pVtable,    vtype )

            if pVTableObj != 0 then
                call SaveInteger( MemHackTable, hid, vtype + 0x1000, pGameDLL + pVTableObj )

                call SaveInteger( MemHackTable, hid, pGameDLL + pVTableObj, vtype )
                call SaveStr(     MemHackTable, hid, pGameDLL + pVTableObj, name  )
            endif
        endif
    endfunction
    
    function Init_APIMemoryFrameData takes nothing returns nothing
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

//TESH.scrollpos=116
//TESH.alwaysfold=0
//! nocjass
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
            return this_call_1( addr, ReadRealMemory( pData ) )
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

    function GetCAgentFromHashGroup takes integer pHash returns integer // Jass Variant of sub_6F4786B0 (126a) || pass the read values, not the pointers.
        local integer pData = 0

        if pHash != 0 then
            return GetCAgentFromHash( ReadRealMemory( pHash + 0x0 ), ReadRealMemory( pHash + 0x4 ) )
        endif

        return 0
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

    function GetSmartPositionAxis takes integer pSmartPos returns integer // x,y -> pvector2 -> x = ReadRealFloat( pvector2 + 0x0 ) | y = ReadRealFloat( pvector2 + 0x4 )
        local integer addr      = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ) )
        local integer pvector2  = 0
        
        if pSmartPos != 0 and addr != 0 then
            set pvector2 = LoadInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ) )
            call this_call_2( addr, pSmartPos, pvector2 )
            return pvector2
        endif

        return 0
    endfunction

    function SetSmartPositionAxisEx takes integer pSmartPos, real x, real y, integer flag returns integer
        local integer addr      = LoadInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ) )
        local integer pvector2  = 0
        
        if pSmartPos != 0 and addr != 0 then
            set pvector2 = LoadInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ) )
            call WriteRealFloat( pvector2 + 0x0, x )
            call WriteRealFloat( pvector2 + 0x4, y )
            return this_call_3( addr, pSmartPos, pvector2, flag )
        endif

        return 0
    endfunction

    function SetSmartPositionAxis takes integer pSmartPos, real x, real y returns integer
        return SetSmartPositionAxisEx( pSmartPos, x, y, 1 )
    endfunction

    function Init_APIMemoryGameData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xACD44C )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xACE5E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x3BE7F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x3A8BA0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x428B90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x4317C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x4C9020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x46F230 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x32D3C0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x32D420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x2DD760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x040770 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x474E00 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x474D60 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xAB65F4 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xAB7788 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x3BDCB0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x3A8060 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x428050 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x430C80 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x4C8520 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x46E720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x001EC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x32C880 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x32C8E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x2DCC40 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x03FA30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x4742F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x474250 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xBE4238 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xBE40A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x1D1550 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x1C3200 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x268380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x2651D0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x17A710 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x0352A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x021BD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x327020 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x322C30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x88F250 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x037350 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x03D790 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x03F020 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xD687A8 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xD68610 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x1EEF90 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x1E0D70 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x285FE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x282E30 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x198420 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x052480 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x03ECD0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x344760 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x340380 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x9BA350 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x054530 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x058900 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x05C200 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GameState" ),               pGameDLL + 0xD305E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "TempestThread" ),           pGameDLL + 0xD30448 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "jUnitToCUnit" ),            pGameDLL + 0x2217A0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetDataNode" ),             pGameDLL + 0x2135F0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "ConvertPointer" ),          pGameDLL + 0x2B8490 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GenerateHandle" ),          pGameDLL + 0x2B52E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetHashKey" ),              pGameDLL + 0x1CACC0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileDataNode" ),        pGameDLL + 0x07BFE0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgileUINode" ),          pGameDLL + 0x069D60 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetWidgetUIDef" ),          pGameDLL + 0x378720 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetAgentUIDef" ),           pGameDLL + 0x374340 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "CUnitTojUnit" ),            pGameDLL + 0x96F2E0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetObjectFromHash" ),       pGameDLL + 0x07E090 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "GetSmartPositionAxis" ),    pGameDLL + 0x0844D0 )
                call SaveInteger( MemHackTable, StringHash( "CGameWar3" ), StringHash( "SetSmartPositionAxis" ),    pGameDLL + 0x085D70 )
            endif

            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector2" ), Malloc( 0x8 ) )
            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector3" ), Malloc( 0xC ) )
            call SaveInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Matrix3x3" ), Malloc( 0x24 ) )
        endif
    endfunction
endlibrary
//! endnocjass


//TESH.scrollpos=247
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass

//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library APIMemoryWC3GameUIButton
    function IsCommandButton takes integer pButton returns boolean
        return GetFrameTypeName( pButton ) == "CCommandButton"
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

    function Init_APIMemoryGameUIButton takes nothing returns nothing
        
    endfunction
endlibrary
//! endnocjass

//TESH.scrollpos=21
//TESH.alwaysfold=0
//! nocjass
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
//! endnocjass


//TESH.scrollpos=9
//TESH.alwaysfold=0
//! nocjass
library APIMemoryUtilityLibraryAPI
    function GetUtilityLibraryHashtable takes nothing returns hashtable
        return LoadHashtableHandle( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "HashTable" ) )
    endfunction

    function InitHashtableListener takes hashtable ht returns boolean
        local integer addr = GetFuncFromDll( "UtilityLibrary.dll", "InitHashtableListener", true )

        if addr != 0 and ht != null then
            call c_call_1( addr, GetHandleId( ht ) )
            return true
        endif

        return false
    endfunction

    function RemoveHashtableListeners takes nothing returns boolean
        local integer addr = GetFuncFromDll( "UtilityLibrary.dll", "RemoveHashtableListeners", true )

        if addr != 0 then
            call c_call_0( addr )
            return true
        endif

        return false
    endfunction
    
    function Init_APIMemoryUtilityLibraryAPI takes nothing returns nothing
        if PatchVersion != "" then
            if LoadDllFromMPQ( "UtilityLibrary.dll" ) then
                call SaveHashtableHandle( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "HashTable" ), InitHashtable( ) )
                // call SaveInteger( MemHackTable, StringHash( "UtilityLibrary.dll" ), StringHash( "Module" ), GetModuleHandle( "UtilityLibrary.dll" ) )
                call InitHashtableListener( GetUtilityLibraryHashtable( ) )
            endif
        endif
    endfunction
endlibrary
//! endnocjass

library InMHCore requires APIBasicUtils,APIAllTypecast,APIMemory,APIMemoryAllCalls,APIMemoryBitwise,APIMemoryForString,APIMemoryKernel,APIMemoryRestorer,APIMemoryHStormDLL,APIMemoryMPQ,APIMemoryFrameData,APIMemoryGameData,APIMemoryWC3GameUI,APIMemoryWC3GameUIButton,APIMemoryWC3GameWindow,APIMemoryUtilityLibraryAPI

    function RunMhCore takes nothing returns nothing
            set bj_FORCE_PLAYER[ 0 ] = CreateForce( )
            call ForceAddPlayer( bj_FORCE_PLAYER[ 0 ], Player( 0 ) )
            call ForForce( bj_FORCE_PLAYER[ 0 ], I2C( C2I( function UnlockMemory ) + 0x8 ) )
        
        
        if PatchVersion != "" then
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "MemHackAPI v1.7" )
            call DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, "Patch Version: " + PatchVersion )
            


            call Init_APITypecast()
            call Init_APIMemory()
            call Init_APIMemoryUtilityLibraryAPI()
            call Init_APIMemoryCalls()
            call Init_APIMemoryBitwise()
            call Init_APIMemoryString()
            call Init_APIMemoryKernel()
            call Init_APIMemoryRestorer()
            call Init_APIMemoryStormDLL()
            call Init_APIMemoryMPQ()
            call Init_APIMemoryFrameData()
            call Init_APIMemoryGameData()
            call Init_APIMemoryGameUI()
            call Init_APIMemoryGameWindow()
            call Init_APIMemoryUtilityLibraryAPI()
        else
        endif
    endfunction
endlibrary
////////////////////////////////////////内核部分分割线，上面是内核部分//////////////////////////////////////////////////////////////////////////


////////////////////Farme///////////////////
//TESH.scrollpos=27
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCFrameBackDropAPI requires InMHCore
    function AllocateCBackdropFrameMemory takes nothing returns integer
        return StormAllocateMemory( 0x1DC, "MemHackCBackdropFrame", 4, 0 )
    endfunction
    
    function CreateCBackdropFrameEx takes integer pBackDrop, integer pParent, integer createContext, integer priority returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ) )

        if addr != 0 and pBackDrop != 0 then
            return this_call_4( addr, pBackDrop, pParent, createContext, priority )
        endif

        return 0
    endfunction
    
    function CreateCBackdropFrame takes integer pParent, integer priority returns integer
        return CreateCBackdropFrameEx( AllocateCBackdropFrameMemory( ), pParent, 0, priority )
    endfunction
    
    function LoadCBackDropFrameTexture takes string texturepath, boolean create returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ) )

        if addr != 0 and texturepath != "" then
            return std_call_2( addr, GetStringAddress( texturepath ), B2I( create ) )
        endif

        return 0
    endfunction

    function SetCBackDropFrameTexture takes integer pFrame, string texturepath, boolean flag returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ) )
        local string f_name = ""

        if addr != 0 and pFrame != 0 then
            set f_name = GetFrameTypeName( pFrame )

            if f_name == "CBackdropFrame" then // 1
                return this_call_6( addr, pFrame, GetStringAddress( texturepath ), 0, B2I( flag ), 0, 1 )
            endif
        endif

        return 0
    endfunction

    function Init_MemHackCBackDropFrameAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x621670 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x621780 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x621A70 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x620ED0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x620FE0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x6212D0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x0A4700 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x0A4AE0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x0A62A0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x0F8460 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x0F8840 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x0FA000 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "Create" ),      pGameDLL + 0x126AD0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "LoadTexture" ), pGameDLL + 0x126EB0 )
                call SaveInteger( MemHackTable, StringHash( "CBackDropFrame" ), StringHash( "SetTexture" ),  pGameDLL + 0x128670 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass




/////////////////////////粒子///////////////////

//TESH.scrollpos=557
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCASpriteBaseAPI requires InMHCore
    function GetSpriteBaseType takes integer pSpriteBase returns integer
        local integer vtable = 0

        if pSpriteBase != 0 then
            set vtable = ReadRealMemory( pSpriteBase )

            if vtable != 0 then
                if vtable == LoadInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableBase" ) ) then
                    return 1
            elseif vtable == LoadInteger( MemHackTable, StringHash( "CSpriteMini" ), StringHash( "vtableExt" ) ) then
                    return 1
            elseif vtable == LoadInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableBase" ) ) then
                    return 2
            elseif vtable == LoadInteger( MemHackTable, StringHash( "CSpriteUber" ), StringHash( "vtableExt" ) ) then
                    return 2
                endif
            endif
        endif

        return 0
    endfunction

    function GetSpriteBaseModelComplex takes integer pSpriteBase returns integer
        //pSpriteBase->pModelComplex | pSpriteBase[8]
        if pSpriteBase != 0 then
            return ReadRealMemory( pSpriteBase + 0x20 )
        endif

        return 0
    endfunction

    function GetSpriteBaseAnimComplex takes integer pSpriteBase returns integer
        // pModelComplex->pAnimationComplex | pModelComplex[38]
        local integer pData = GetSpriteBaseModelComplex( pSpriteBase )

        if pData != 0 then
            return ReadRealMemory( pSpriteBase + 0x98 )
        endif

        return 0
    endfunction
    
    function GetSpriteBaseFloat takes integer pSpriteBase, integer offset returns real
        if pSpriteBase != 0 then
            return ReadRealFloat( pSpriteBase + offset )
        endif

        return 0.
    endfunction

    function SetSpriteBaseFloat takes integer pSpriteBase, integer offset, real value returns real
        if pSpriteBase != 0 then
            call WriteRealFloat( pSpriteBase + offset, value )
        endif

        return 0.
    endfunction

    function GetSpriteBaseX takes integer pSpriteBase returns real
        local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0
        
        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set offset = 0x88
            else
                set offset = 0xC0
            endif

            return GetSpriteBaseFloat( pSpriteBase, offset )
        endif

        return 0.
    endfunction

    function SetSpriteBaseX takes integer pSpriteBase, real x returns nothing
        local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0

		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x88
			else
				set offset = 0xC0
			endif

			call SetSpriteBaseFloat( pSpriteBase, offset, x )
		endif
    endfunction

    function GetSpriteBaseY takes integer pSpriteBase returns real
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0
        
		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x8C
			else
				set offset = 0xC4
			endif

			return GetSpriteBaseFloat( pSpriteBase, offset )
		endif

		return 0.
    endfunction

    function SetSpriteBaseY takes integer pSpriteBase, real y returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0

		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x8C
			else
				set offset = 0xC4
			endif

			call SetSpriteBaseFloat( pSpriteBase, offset, y )
		endif
    endfunction

    function GetSpriteBaseZ takes integer pSpriteBase returns real
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0

		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x90
			else
				set offset = 0xC8
			endif

			return GetSpriteBaseFloat( pSpriteBase, offset )
		endif

		return 0.
    endfunction

    function SetSpriteBaseZ takes integer pSpriteBase, real z returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0

		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x90
			else
				set offset = 0xC8
			endif

			call SetSpriteBaseFloat( pSpriteBase, offset, z )
		endif
    endfunction

    function SetSpriteBasePosition takes integer pSpriteBase, real x, real y, real z returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set offset = pSpriteBase + 0x88
            else
                set offset = pSpriteBase + 0xC0
            endif

            call WriteRealFloat( pSpriteBase + 0x0, x )
            call WriteRealFloat( pSpriteBase + 0x4, y )
            call WriteRealFloat( pSpriteBase + 0x8, z )
        endif
    endfunction    

    function GetSpriteBaseTimeScale takes integer pSpriteBase returns real
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer pData = 0
        
		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
                set pData = GetSpriteBaseAnimComplex( pSpriteBase )

                if pData != 0 then
                    return ReadRealFloat( pSpriteBase + 0x48 ) // pAnimationComplex->timescale | pAnimationComplex[18]
                endif
			else
				return ReadRealFloat( pSpriteBase + 0x190 )
			endif
		endif

        return 0.
    endfunction

    function SetSpriteBaseTimeScale takes integer pSpriteBase, real timescale returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer pData = 0

		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
                set pData = GetSpriteBaseAnimComplex( pSpriteBase )

                if pData != 0 then
                    call WriteRealFloat( pSpriteBase + 0x48, timescale ) // pAnimationComplex->timescale | pAnimationComplex[18]
                endif
			else
				call WriteRealFloat( pSpriteBase + 0x190, timescale )
			endif
		endif
    endfunction

    function GetSpriteBaseScale takes integer pSpriteBase returns real
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0
        
		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x94
			else
				set offset = 0xE8
			endif

			return ReadRealFloat( pSpriteBase + offset )
		endif
		
		return 0.
    endfunction

    function SetSpriteBaseScale takes integer pSpriteBase, real scale returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer offset = 0
        
		if s_type == 1 or s_type == 2 then
			if s_type == 1 then
				set offset = 0x94
			else
				set offset = 0xE8
			endif

			call WriteRealFloat( pSpriteBase + offset, scale )
		endif
    endfunction

    function SetSpriteBaseMaterialScale takes integer pSpriteBase, real scaleX, real scaleY, real scaleZ returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer pMatrix = 0
        
        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

			call WriteRealFloat( pMatrix + 0x00, scaleX )
            call WriteRealFloat( pMatrix + 0x10, scaleY )
            call WriteRealFloat( pMatrix + 0x20, scaleZ )
		endif
    endfunction

    function UpdateSpriteBase takes integer pSpriteBase returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 then
            call this_call_1( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x14 ), pSpriteBase )
        endif
    endfunction

    function SetSpriteBasePositionEx takes integer pSpriteBase, real x, real y, real z returns nothing
        local integer pvector3 = 0
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 then
            set pvector3 = LoadInteger( MemHackTable, StringHash( "CustomData" ), StringHash( "Vector3" ) )
            call WriteRealFloat( pvector3 + 0x0, x )
            call WriteRealFloat( pvector3 + 0x4, y )
            call WriteRealFloat( pvector3 + 0x8, z )

            call this_call_2( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x1C ), pSpriteBase, pvector3 )
        endif
    endfunction

    function SetSpriteBaseScaleEx takes integer pSpriteBase, real scale returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 then
            call this_call_2( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x24 ), pSpriteBase, SetRealIntoMemory( scale ) )
        endif
    endfunction

    function SetSpriteBaseTimeScaleEx takes integer pSpriteBase, real timescale returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 then
            call this_call_2( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x28 ), pSpriteBase, SetRealIntoMemory( timescale ) )
        endif
    endfunction

    function SetSpriteBaseColourEx takes integer pSpriteBase, integer colour, boolean flag returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )
        local integer arg    = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if arg != 0 and ( s_type == 1 or s_type == 2 ) then
            call WriteRealMemory( arg + 0x0, colour )
            call this_call_2( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x30 ), pSpriteBase, arg + 0x0 )

            if flag then
                call UpdateSpriteBase( pSpriteBase )
            endif
        endif
    endfunction

    function SetSpriteBaseAlphaEx takes integer pSpriteBase, integer alpha, boolean flag returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 and alpha >= 0 and alpha <= 0xFF then
            call this_call_2( ReadRealMemory( ReadRealMemory( pSpriteBase ) + 0x34 ), pSpriteBase, alpha )

            if flag then
                call UpdateSpriteBase( pSpriteBase )
            endif
        endif
    endfunction

    function SetSpriteBaseAnimationByIndexWithRarity takes integer pSpriteBase, integer index, integer rarity returns nothing
        local integer addr   = LoadInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ) )
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if addr != 0 and ( s_type == 1 or s_type == 2 ) then
            call fast_call_3( addr, pSpriteBase, index, rarity )
        endif
    endfunction
    
    function SetSpriteBaseAnimationByIndex takes integer pSpriteBase, integer index returns nothing
        call SetSpriteBaseAnimationByIndexWithRarity( pSpriteBase, index, 0 )
    endfunction

    // Effect Rotation API Radians
    function GetSpriteBaseYawRad takes integer pSpriteBase returns real // Z | Yaw | returns Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            set r11   = ReadRealFloat( pMatrix +  0x0 )
            set r21   = ReadRealFloat( pMatrix +  0xC )
            set r31   = ReadRealFloat( pMatrix + 0x18 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw   = -Atan2( r21, r11 )

            if yaw < 0 then
                set yaw = 6.28319 + yaw
            endif
        endif

        return yaw
    endfunction

    function GetSpriteBasePitchRad takes integer pSpriteBase returns real // Y | returns Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x7C
            else
                set pMatrix = pSpriteBase + 0x120
            endif

            set r31   = ReadRealFloat( pMatrix + 0x0 )
            set r32   = ReadRealFloat( pMatrix + 0x4 )
            set r33   = ReadRealFloat( pMatrix + 0x8 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )

            if r31 < 0. and r33 > 0. then
                set pitch = pitch
        elseif r31 < 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 > 0. then
                set pitch = 6.28319 + pitch
            endif
        endif
        
        return pitch
    endfunction

    function GetSpriteBaseRollRad takes integer pSpriteBase returns real // X | returns Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x7C
            else
                set pMatrix = pSpriteBase + 0x120
            endif

            set r31     = ReadRealFloat( pMatrix + 0x0 )
            set r32     = ReadRealFloat( pMatrix + 0x4 )
            set r33     = ReadRealFloat( pMatrix + 0x8 )
            set pitch   = -Asin( r31 )
            set roll    = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            if roll < 0. then
                set roll = 6.28319 + roll
            endif
        endif
        
        return roll
    endfunction

    function GetSpriteBaseFacingRad takes integer pSpriteBase returns real // Z | Yaw | returns Degrees!
        return GetSpriteBaseYawRad( pSpriteBase )
    endfunction

    function SetSpriteBaseSpaceRotationRad takes integer pSpriteBase, real yaw, real pitch, real roll returns nothing
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real Sx = Sin( roll )
        local real Sy = Sin( pitch )
        local real Sz = Sin( -yaw )
        local real Cx = Cos( roll )
        local real Cy = Cos( pitch )
        local real Cz = Cos( -yaw )

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            call WriteRealFloat( pMatrix +  0x0, Cy * Cz )
            call WriteRealFloat( pMatrix +  0x4, -Cy * Sz )
            call WriteRealFloat( pMatrix +  0x8, Sy )
            call WriteRealFloat( pMatrix +  0xC, Cz * Sx * Sy + Cx * Sz )
            call WriteRealFloat( pMatrix + 0x10, Cx * Cz - Sx * Sy * Sz )
            call WriteRealFloat( pMatrix + 0x14, -Cy * Sx )
            call WriteRealFloat( pMatrix + 0x18, -Cx * Cz * Sy + Sx * Sz )
            call WriteRealFloat( pMatrix + 0x1C, Cz * Sx + Cx * Sy * Sz )
            call WriteRealFloat( pMatrix + 0x20, Cx * Cy )
        endif
    endfunction

    function SetSpriteBaseYawRad takes integer pSpriteBase, real angle returns nothing // Z Yaw | In Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x7C
            else
                set pMatrix = pSpriteBase + 0x120
            endif

            set r31      = ReadRealFloat( pMatrix + 0x0 )
            set r32      = ReadRealFloat( pMatrix + 0x4 )
            set r33      = ReadRealFloat( pMatrix + 0x8 )
            set pitch    = -Asin( r31 ) //Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set roll     = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            call SetSpriteBaseSpaceRotationRad( pSpriteBase, angle, pitch, roll )
        endif
    endfunction

    function SetSpriteBasePitchRad takes integer pSpriteBase, real angle returns nothing // Y | In Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r11          = 0.
        local real r21          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real yaw          = 0.
        local real roll         = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            set r11     = ReadRealFloat( pMatrix + 0x0 )
            set r21     = ReadRealFloat( pMatrix + 0xC )
            set r32     = ReadRealFloat( pMatrix + 0x1C )
            set r33     = ReadRealFloat( pMatrix + 0x20 )
            set yaw     = Atan2( r21 / Cos( angle ), r11 / Cos( angle ) )
            set roll    = Atan2( r32 / Cos( angle ), r33 / Cos( angle ) )

            call SetSpriteBaseSpaceRotationRad( pSpriteBase, yaw, angle, roll )
        endif
    endfunction

    function SetSpriteBaseRollRad takes integer pSpriteBase, real angle returns nothing // X | In Degrees!
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            set r11     = ReadRealFloat( pMatrix +  0x0 )
            set r21     = ReadRealFloat( pMatrix +  0xC )
            set r31     = ReadRealFloat( pMatrix + 0x18 )
            set pitch   = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw     = Atan2( r21 / Cos( pitch ), r11 / Cos( pitch ) )

            call SetSpriteBaseSpaceRotationRad( pSpriteBase, yaw, pitch, angle )
        endif
    endfunction

    function SetSpriteBaseOrientationRad takes integer pSpriteBase, real yaw, real pitch, real roll returns nothing
		local integer s_type = GetSpriteBaseType( pSpriteBase )

        if s_type == 1 or s_type == 2 then
            call SetSpriteBaseSpaceRotationRad( pSpriteBase, yaw, pitch, roll )
        endif
    endfunction
    //===================================================================
    
    // Effect Rotation API Degrees
    function SetSpriteBaseSpaceRotation takes integer pSpriteBase, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseSpaceRotationRad( pSpriteBase, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    
    function GetSpriteBaseYaw takes integer pSpriteBase returns real // Z | Yaw | returns Degrees!
        return Rad2Deg( GetSpriteBaseYawRad( pSpriteBase ) )
    endfunction

    function GetSpriteBaseFacing takes integer pSpriteBase returns real
        return Rad2Deg( GetSpriteBaseFacingRad( pSpriteBase ) )
    endfunction
    
    function GetSpriteBasePitch takes integer pSpriteBase returns real
        return Rad2Deg( GetSpriteBasePitchRad( pSpriteBase ) )
    endfunction

    function GetSpriteBaseRoll takes integer pSpriteBase returns real
        return Rad2Deg( GetSpriteBaseRollRad( pSpriteBase ) )
    endfunction

    function SetSpriteBaseYaw takes integer pSpriteBase, real angle returns nothing
        call SetSpriteBaseYawRad( pSpriteBase, Deg2Rad( angle ) )
    endfunction

    function SetSpriteBaseFacing takes integer pSpriteBase, real angle returns nothing
        call SetSpriteBaseYawRad( pSpriteBase, Deg2Rad( angle ) )
    endfunction

    function SetSpriteBasePitch takes integer pSpriteBase, real angle returns nothing
        call SetSpriteBasePitchRad( pSpriteBase, Deg2Rad( angle ) )
    endfunction

    function SetSpriteBaseRoll takes integer pSpriteBase, real angle returns nothing
        call SetSpriteBaseRollRad( pSpriteBase, Deg2Rad( angle ) )
    endfunction

    function SetSpriteBaseOrientation takes integer pSpriteBase, real yaw, real pitch, real roll returns nothing
        call SetSpriteBaseOrientationRad( pSpriteBase, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    //===================================================================

    function SetSpriteBaseScaleXYZ takes integer pSpriteBase, real x, real y, real z returns nothing
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            call WriteRealFloat( pMatrix +  0x0, x )
            call WriteRealFloat( pMatrix + 0x10, y )
            call WriteRealFloat( pMatrix + 0x20, z )
        endif
    endfunction

    function ResetSpriteBaseMatrix takes integer pSpriteBase returns nothing
		local integer s_type 	= GetSpriteBaseType( pSpriteBase )
        local integer pMatrix   = 0

        if s_type == 1 or s_type == 2 then
            if s_type == 1 then
                set pMatrix = pSpriteBase + 0x64
            else
                set pMatrix = pSpriteBase + 0x108
            endif

            call WriteRealFloat( pMatrix +  0x0, 1. )
            call WriteRealFloat( pMatrix +  0x4, 0. )
            call WriteRealFloat( pMatrix +  0x8, 0. )
            call WriteRealFloat( pMatrix +  0xC, 0. )
            call WriteRealFloat( pMatrix + 0x10, 1. )
            call WriteRealFloat( pMatrix + 0x14, 0. )
            call WriteRealFloat( pMatrix + 0x18, 0. )
            call WriteRealFloat( pMatrix + 0x1C, 0. )
            call WriteRealFloat( pMatrix + 0x20, 1. )
        endif
    endfunction

    function Init_MemHackCSpriteBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ), pGameDLL + 0x4D8700 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ), pGameDLL + 0x4D7C00 )
        elseif PatchVersion == "1.27a" then // v20 = *v6 & 0x1000000;
                call SaveInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ), pGameDLL + 0x186820 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ), pGameDLL + 0x1A4540 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CSpriteBase" ), StringHash( "SetAnimation" ), pGameDLL + 0x1D6DD0 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass

//////////////////////控件//////////////////////////
//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCWidgetBaseAPI requires InMHCore
    // Widget API Engine
    function GetWidgetTypeId takes widget w returns integer
        local integer pWidget = 0
        
        if w != null then
            set pWidget = ConvertHandle( w )
            
            if pWidget != 0 then
                return ReadRealMemory( pWidget + 0x30 )
            endif
        endif

        return 0
    endfunction

    function GetWidgetBaseDataById takes integer pDataNode, integer wid returns integer
        return GetAgileDataNodeById( pDataNode, wid )
    endfunction
    
    function GetWidgetBaseUIDataById takes integer id returns integer
        return GetWidgetUIDefById( id )
    endfunction

    function GetWidgetBaseData takes integer pDataNode, widget w returns integer
        return GetAgileDataNodeById( pDataNode, GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseDataByIdCachingEx takes integer pDataNode, integer index, integer id, integer mode returns integer
        local integer pData = 0

        if id > 0 then
            if HaveSavedInteger( htObjectDataPointers, index, id ) then 
                return LoadInteger( htObjectDataPointers, index, id )
            endif

            if mode == 0 then
                set pData = GetWidgetBaseDataById( pDataNode, id )
            elseif mode == 1 then
                set pData = GetWidgetBaseUIDataById( id )
            endif

            if pData > 0 then
                call SaveInteger( htObjectDataPointers, index, id, pData )
            endif

            return pData
        endif

        return 0
    endfunction
    
    function GetWidgetBaseDataByIdCaching takes integer pDataNode, integer id returns integer
        return GetWidgetBaseDataByIdCachingEx( pDataNode, 2, id, 0 ) // DEF_ADR_UNIT_DATA = 2 | BaseData = 0
    endfunction

    function GetWidgetBaseDataCaching takes integer pDataNode, widget w returns integer
        return GetWidgetBaseDataByIdCaching( pDataNode, GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseUIData takes widget w returns integer
        return GetWidgetBaseUIDataById( GetWidgetTypeId( w ) )
    endfunction

    function GetWidgetBaseUIDataByIdCaching takes integer id returns integer
        return GetWidgetBaseDataByIdCachingEx( 0, 3, id, 1 ) // DEF_ADR_UNIT_UI = 3 | UI = 1
    endfunction

    function GetWidgetBaseUIDataCaching takes widget w returns integer
        return GetWidgetBaseUIDataByIdCaching( GetWidgetTypeId( w ) )
    endfunction
    //===========================================
    
    // Widget Base UI Data Engine
    function GetWidgetBaseUIIntegerParamById takes integer id, integer pointerlevel, integer offset returns integer
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = ReadRealMemory( pData + offset )

                if pData > 0 then
                    if pointerlevel == 0 then
                        return pData
                elseif pointerlevel == 1 then
                        return ReadRealMemory( pData )
                    endif
                endif
            endif
        endif
        
        return 0
    endfunction

    function SetWidgetBaseUIIntegerParamById takes integer id, integer pointerlevel, integer offset, integer val returns nothing
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = pData + offset

                if offset == 0x274 then
                    call WriteRealMemory( pData, pData - 0x4 )
                else
                    if pointerlevel == 0 then
                        call WriteRealMemory( pData, val )
                elseif pointerlevel == 1 then
                        if ReadRealMemory( pData ) == 0 then
                            call WriteRealMemory( pData, GetStringAddress( I2S( val ) ) )
                        endif
                        call WriteRealMemory( ReadRealMemory( pData ), val )
                    endif
                endif
            endif
        endif
    endfunction

    function GetWidgetBaseUIStringParamById takes integer id, integer pointerlevel, integer offset returns string
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = ReadRealMemory( pData + offset )

                if pData > 0 then
                    if pointerlevel == 1 then
                        set pData = ReadRealMemory( pData )
                    endif

                    if pData > 0 then
                        return ToJString( pData )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetWidgetBaseUIStringParamById takes integer id, integer pointerlevel, integer offset, string val returns nothing
        local integer pData = 0

        if id > 0 then
            set pData = GetWidgetBaseUIDataByIdCaching( id )

            if pData > 0 then
                set pData = pData + offset

                if pointerlevel == 0 then
                    call WriteRealMemory( pData, GetStringAddress( val ) )
            elseif pointerlevel == 1 then
                    if ReadRealMemory( pData ) == 0 then
                        call WriteRealMemory( pData, GetStringAddress( val ) )
                    endif
                    call WriteRealMemory( ReadRealMemory( pData ), GetStringAddress( val ) )
                endif
            endif
        endif
    endfunction
    
    function Init_MemHackCWidgetBaseAPI takes nothing returns nothing
        if PatchVersion != "" then

        endif
    endfunction
endlibrary
//! endnocjass


///////////////////////////////////////////////////////物体数据库///////////////////////
//TESH.scrollpos=221
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCObjectAPI requires InMHCore , MemoryHackCASpriteBaseAPI
    function GetARGBColour takes integer alpha, integer red, integer green, integer blue returns integer
        return CreateInteger1( alpha, red, green, blue )
    endfunction

    function IsObjectHidden takes integer pObject returns boolean
        if pObject > 0 then
            return IsFlagBitSet( ReadRealMemory( pObject + 0x20 ), 1 )
        endif

        return false
    endfunction

    function ShowObject takes integer pObject, boolean flag returns nothing
        if pObject > 0 then
            call WriteRealMemory( pObject + 0x20, B2I( not flag ) )
        endif
    endfunction

    function GetObjectTypeId takes integer pObj returns integer
        // Do NOT use this with effects or trackables, since they do not have TypeId
        if pObj > 0 then
            return ReadRealMemory( pObj + 0x30 )
        endif

        return 0
    endfunction    

    function GetObjectSprite takes integer pObject returns integer
        // Units and Effects return CSpriteUber | items and destructables returns CSpriteMini
        if pObject != 0 then
            return ReadRealMemory( pObject + 0x28 )
        endif

        return 0
    endfunction

    function GetObjectSpriteFloat takes integer pObject, integer offset returns real
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            return ReadRealFloat( pSprite + offset )
        endif

        return 0.
    endfunction

    function SetObjectSpriteFloat takes integer pObject, integer offset, real value returns real
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            call WriteRealFloat( pSprite + offset, value )
        endif

        return 0.
    endfunction

    function UpdateObjectColour takes integer pObject returns nothing // pObject = ConvertHandle( h )
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )
        local integer flag    = 0

        if pSprite != 0 then
            call WriteRealMemory( pSprite + 0x140, 0 )
            call WriteRealMemory( pSprite + 0x13C, 0 )
            set flag = ReadRealMemory( pSprite + 0x138 )

            if not IsFlagBitSet( flag, 0x800 ) then
                call WriteRealMemory( pSprite + 0x138, flag + 0x800 )
            endif
        endif
    endfunction

    function SetObjectAlpha takes integer pObject, integer alpha returns nothing
        // Does not work on items/units/destructables/doodads, meaning only works on Effects (they are pure CSpriteUber)
        local integer addr    = LoadInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ) )
        local integer pSprite = GetObjectSprite( pObject )

        if addr != 0 and pSprite != 0 then
            if alpha >= 0x00 and alpha <= 0xFF then
                call fast_call_3( addr, pSprite, alpha, 0 )
            endif
        endif
    endfunction

    function GetObjectColour takes integer pObject returns integer
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            return ReadRealMemory( pSprite + 0x148 )
        endif

        return 0
    endfunction

    function SetObjectColour takes integer pObject, integer colour returns nothing
        // Does not work on CSpriteMini, refer to GetObjectSprite for explanation.
        local integer pSprite = GetObjectSprite( pObject )

        if pSprite != 0 then
            call WriteRealMemory( pSprite + 0x148, colour )
            call UpdateObjectColour( pObject )
        endif
    endfunction

    function SetObjectColourEx takes integer pObject, integer red, integer green, integer blue, integer alpha returns nothing
        if pObject != 0 then
            call SetObjectColour( pObject, CreateInteger1( alpha, red, green, blue ) )
        endif
    endfunction
    
    function SetObjectVertexColour takes integer pObject, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( pObject, red, green, blue, alpha )
        call SetObjectAlpha( pObject, alpha )
    endfunction

    function GetObjectColourA takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 1 )
        endif
        
        return -1
    endfunction

    function SetObjectColourA takes integer pObject, integer alpha returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( alpha, GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetObjectColourR takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 2 )
        endif

        return -1
    endfunction

    function SetObjectColourR takes integer pObject, integer red returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), red, GetByteFromInteger( colour, 3 ), GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction
    
    function GetObjectColourG takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 3 )
        endif

        return -1
    endfunction

    function SetObjectColourG takes integer pObject, integer green returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), green, GetByteFromInteger( colour, 4 ) ) )
        endif
    endfunction

    function GetObjectColourB takes integer pObject returns integer
        if pObject != 0 then
            return GetByteFromInteger( GetObjectColour( pObject ), 4 )
        endif

        return -1
    endfunction

    function SetObjectColourB takes integer pObject, integer blue returns nothing
        local integer colour = 0

        if pObject != 0 then
            set colour = GetObjectColour( pObject )
            call SetObjectColour( pObject, CreateInteger1( GetByteFromInteger( colour, 1 ), GetByteFromInteger( colour, 2 ), GetByteFromInteger( colour, 3 ), blue ) )
        endif
    endfunction
    
    function SetObjectAnimationByIndex takes integer pObject, integer index returns nothing
        call SetSpriteBaseAnimationByIndex( GetObjectSprite( pObject ), index )
    endfunction

    function SetObjectAnimationByIndexWithRarity takes integer pObject, integer index, integer rarity returns nothing
        call SetSpriteBaseAnimationByIndexWithRarity( GetObjectSprite( pObject ), index, rarity )
    endfunction
    
    function SetObjectModel takes integer pObject, string model, boolean flag returns nothing
        // Works on every handle, even items.
        local integer pData = 0

        if pObject > 0 then
            set pData = ReadRealMemory( pObject ) + 0x88

            if pData > 0 then
                set pData = ReadRealMemory( pData )

                if pData > 0 then
                    call this_call_3( pData, pObject, GetStringAddress( model ), B2I( flag ) )
                endif
            endif
        endif
    endfunction

    function GetObjectX takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC0 )
    endfunction

    function SetObjectX takes integer pObject, real x returns nothing
        local integer pSprite   = GetObjectSprite( pObject )
        local integer pSmartPos = 0

        if pSprite != 0 then
            set pSmartPos = this_call_1( ReadRealMemory( ReadRealMemory( pObject ) + 0xB0 ), pObject )
            call SetSmartPositionAxisEx( pSmartPos, x, ReadRealFloat( pSprite + 0xC4 ), 1 )
            call WriteRealFloat( pSprite + 0xC0, x )
        endif
    endfunction

    function GetObjectY takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC4 )
    endfunction

    function SetObjectY takes integer pObject, real y returns nothing
        local integer pSprite   = GetObjectSprite( pObject )
        local integer pSmartPos = 0

        if pSprite != 0 then
            set pSmartPos = this_call_1( ReadRealMemory( ReadRealMemory( pObject ) + 0xB0 ), pObject )
            call SetSmartPositionAxisEx( pSmartPos, ReadRealFloat( pSprite + 0xC0 ), y, 1 )
            call WriteRealFloat( pSprite + 0xC4, y )
        endif
    endfunction

    function GetObjectZ takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xC8 )
    endfunction

    function SetObjectZ takes integer pObject, real z returns nothing
        call SetObjectSpriteFloat( pObject, 0xC8, z )
    endfunction

    function SetObjectPosition takes integer pObject, real x, real y, real z returns nothing
        local integer pSprite   = GetObjectSprite( pObject )
        local integer pSmartPos = 0

        if pSprite != 0 then
            set pSmartPos = this_call_1( ReadRealMemory( ReadRealMemory( pObject ) + 0xB0 ), pObject )
            call SetSmartPositionAxisEx( pSmartPos, x, y, 1 )
            call WriteRealFloat( pSprite + 0xC0, x )
            call WriteRealFloat( pSprite + 0xC4, y )
            call WriteRealFloat( pSprite + 0xC8, z )
        endif
    endfunction

    function GetObjectTimeScale takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0x190 )
    endfunction

    function SetObjectTimeScale takes integer pObject, real speed returns nothing
        call SetObjectSpriteFloat( pObject, 0x190, speed )
    endfunction

    function GetObjectScale takes integer pObject returns real
        return GetObjectSpriteFloat( pObject, 0xE8 )
    endfunction

    function SetObjectScale takes integer pObject, real scale returns nothing
        call SetObjectSpriteFloat( pObject, 0xE8, scale )
    endfunction

    // Effect Rotation API Radians
    function GetObjectYawRad takes integer pObject returns real // Z | Yaw | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r11   = ReadRealFloat( pSprite + 0x108 )
            set r21   = ReadRealFloat( pSprite + 0x114 )
            set r31   = ReadRealFloat( pSprite + 0x120 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw   = -Atan2( r21, r11 )

            if yaw < 0 then
                set yaw = 6.28319 + yaw
            endif
        endif

        return yaw
    endfunction

    function GetObjectPitchRad takes integer pObject returns real // Y | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r31   = ReadRealFloat( pSprite + 0x120 )
            set r32   = ReadRealFloat( pSprite + 0x124 )
            set r33   = ReadRealFloat( pSprite + 0x128 )
            set pitch = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )

            if r31 < 0. and r33 > 0. then
                set pitch = pitch
        elseif r31 < 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 < 0. then
                set pitch = 3.14159 - pitch
        elseif r31 > 0. and r33 > 0. then
                set pitch = 6.28319 + pitch
            endif
        endif
        
        return pitch
    endfunction

    function GetObjectRollRad takes integer pObject returns real // X | returns Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r31     = ReadRealFloat( pSprite + 0x120 )
            set r32     = ReadRealFloat( pSprite + 0x124 )
            set r33     = ReadRealFloat( pSprite + 0x128 )
            set pitch   = -Asin( r31 )
            set roll    = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            if roll < 0. then
                set roll = 6.28319 + roll
            endif
        endif
        
        return roll
    endfunction

    function GetObjectFacingRad takes integer pObject returns real // Z | Yaw | returns Degrees!
        return GetObjectYawRad( pObject )
    endfunction

    function SetObjectSpaceRotationRad takes integer pObject, real yaw, real pitch, real roll returns nothing
        local integer pSprite = GetObjectSprite( pObject )
        local real Sx = Sin( roll )
        local real Sy = Sin( pitch )
        local real Sz = Sin( -yaw )
        local real Cx = Cos( roll )
        local real Cy = Cos( pitch )
        local real Cz = Cos( -yaw )

        if pSprite != 0 then
            call WriteRealFloat( pSprite + 0x108, Cy * Cz )
            call WriteRealFloat( pSprite + 0x10C, -Cy * Sz )
            call WriteRealFloat( pSprite + 0x110, Sy )
            call WriteRealFloat( pSprite + 0x114, Cz * Sx * Sy + Cx * Sz )
            call WriteRealFloat( pSprite + 0x118, Cx * Cz - Sx * Sy * Sz )
            call WriteRealFloat( pSprite + 0x11C, -Cy * Sx )
            call WriteRealFloat( pSprite + 0x120, -Cx * Cz * Sy + Sx * Sz )
            call WriteRealFloat( pSprite + 0x124, Cz * Sx + Cx * Sy * Sz )
            call WriteRealFloat( pSprite + 0x128, Cx * Cy )
        endif
    endfunction

    function SetObjectYawRad takes integer pObject, real angle returns nothing // Z Yaw | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r31          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real pitch        = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r31      = ReadRealFloat( pSprite + 0x120 )
            set r32      = ReadRealFloat( pSprite + 0x124 )
            set r33      = ReadRealFloat( pSprite + 0x128 )
            set pitch    = -Asin( r31 ) //Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set roll     = Atan2( r32 / Cos( pitch ), r33 / Cos( pitch ) )

            call SetObjectSpaceRotationRad( pObject, angle, pitch, roll )
        endif
    endfunction

    function SetObjectPitchRad takes integer pObject, real angle returns nothing // Y | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r32          = 0.
        local real r33          = 0.
        local real yaw          = 0.
        local real roll         = 0.

        if pSprite != 0 then
            set r11     = ReadRealFloat( pSprite + 0x108 )
            set r21     = ReadRealFloat( pSprite + 0x114 )
            set r32     = ReadRealFloat( pSprite + 0x124 )
            set r33     = ReadRealFloat( pSprite + 0x128 )
            set yaw     = Atan2( r21 / Cos( angle ), r11 / Cos( angle ) )
            set roll    = Atan2( r32 / Cos( angle ), r33 / Cos( angle ) )

            call SetObjectSpaceRotationRad( pObject, yaw, angle, roll )
        endif
    endfunction

    function SetObjectRollRad takes integer pObject, real angle returns nothing // X | In Degrees!
        local integer pSprite   = GetObjectSprite( pObject )
        local real r11          = 0.
        local real r21          = 0.
        local real r31          = 0.
        local real yaw          = 0.
        local real pitch        = 0.

        if pSprite != 0 then
            set r11     = ReadRealFloat( pSprite + 0x108 )
            set r21     = ReadRealFloat( pSprite + 0x114 )
            set r31     = ReadRealFloat( pSprite + 0x120 )
            set pitch   = -Asin( r31 ) // Atan2( -r31, SquareRoot( Pow( r32, 2 ) + Pow( r33, 2 ) ) )
            set yaw     = Atan2( r21 / Cos( pitch ), r11 / Cos( pitch ) )

            call SetObjectSpaceRotationRad( pObject, yaw, pitch, angle )
        endif
    endfunction

    function SetObjectOrientationRad takes integer pObject, real yaw, real pitch, real roll returns nothing
        if pObject > 0 then
            call SetObjectSpaceRotationRad( pObject, yaw, pitch, roll )
            //call SetObjectRollRad( pObject, roll )
            //call SetObjectPitchRad( pObject, pitch )
            //call SetObjectYawRad( pObject, yaw )
        endif
    endfunction
    //===================================================================
    
    // Effect Rotation API Degrees
    function SetObjectSpaceRotation takes integer pObject, real yaw, real pitch, real roll returns nothing
        call SetObjectSpaceRotationRad( pObject, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    
    function GetObjectYaw takes integer pObject returns real // Z | Yaw | returns Degrees!
        return Rad2Deg( GetObjectYawRad( pObject ) )
    endfunction

    function GetObjectFacing takes integer pObject returns real
        return Rad2Deg( GetObjectFacingRad( pObject ) )
    endfunction
    
    function GetObjectPitch takes integer pObject returns real
        return Rad2Deg( GetObjectPitchRad( pObject ) )
    endfunction

    function GetObjectRoll takes integer pObject returns real
        return Rad2Deg( GetObjectRollRad( pObject ) )
    endfunction

    function SetObjectYaw takes integer pObject, real angle returns nothing
        call SetObjectYawRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectFacing takes integer pObject, real angle returns nothing
        call SetObjectYawRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectPitch takes integer pObject, real angle returns nothing
        call SetObjectPitchRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectRoll takes integer pObject, real angle returns nothing
        call SetObjectRollRad( pObject, Deg2Rad( angle ) )
    endfunction

    function SetObjectOrientation takes integer pObject, real yaw, real pitch, real roll returns nothing
        call SetObjectOrientationRad( pObject, Deg2Rad( yaw ), Deg2Rad( pitch ), Deg2Rad( roll ) )
    endfunction
    //===================================================================

    function SetObjectScaleEx takes integer pObject, real x, real y, real z returns nothing
        call SetSpriteBaseMaterialScale( GetObjectSprite( pObject ), x, y, z )
    endfunction

    function ResetObjectMatrix takes integer pObject returns nothing
        call ResetSpriteBaseMatrix( GetObjectSprite( pObject ) )
    endfunction

    function Init_APIMemoryObjectData takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x4D3D50 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x4D3250 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x186FA0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x1A4CC0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CObject" ), StringHash( "SetAlpha" ), pGameDLL + 0x1D7550 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass


/////////////////////////////////////////技能////////////////////

//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityBaseAPI requires InMHCore
    // Base Ability Data/UI Data by Id API
    function GetAbilityBaseDataById takes integer aid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ) )

        if addr != 0 and aid != 0 then
           return this_call_1( addr, aid )
        endif

        return 0
    endfunction

    function GetAbilityBaseDataByIdCaching takes integer aid returns integer
        // DEF_ADR_ABILITY_DATA = 0
        local integer pAbil = 0

        if HaveSavedInteger( htObjectDataPointers, 0, aid ) then 
            return LoadInteger( htObjectDataPointers, 0, aid )
        endif

        set pAbil = GetAbilityBaseDataById( aid )
        if pAbil != 0 then
            call SaveInteger( htObjectDataPointers, 0, aid, pAbil )
        endif

        return pAbil
    endfunction

    function GetAbilityBaseUIById takes integer aid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ) )

        if addr != 0 and aid != 0 then
            return this_call_1( addr, aid )
        endif

        return 0
    endfunction

    function GetAbilityBaseUIByIdCaching takes integer aid returns integer
        // DEF_ADR_ABILITY_UI = 1
        local integer pAbil = 0

        if HaveSavedInteger( htObjectDataPointers, 1, aid ) then
            return LoadInteger( htObjectDataPointers, 1, aid )
        endif

        set pAbil = GetAbilityBaseUIById( aid )
        if pAbil != 0 then
            call SaveInteger( htObjectDataPointers, 1, aid, pAbil )
        endif

        return pAbil
    endfunction

    function GetAbilityBaseMaxLevelById takes integer aid returns integer
        local integer pAbil

        if aid != 0 then
            set pAbil = GetAbilityBaseDataByIdCaching( aid )

            if pAbil != 0 then
                return ReadRealMemory( pAbil + 0x50 )
            endif
        endif

        return 0
    endfunction
    //===========================================

    // Base Ability Parameters API
    function SetAbilityBaseHotkeyParam takes integer aid, integer off, integer newVal returns nothing
        local integer pAbil = GetAbilityBaseUIByIdCaching( aid )

        if pAbil > 0 then
            call WriteRealMemory( ReadRealMemory( pAbil + off ), newVal )
        endif
    endfunction

    function GetAbilityBaseHotkeyParam takes integer aid, integer off returns integer
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ReadRealMemory( pData )
            endif
        endif

        return 0
    endfunction

    function SetAbilityBaseUIIntegerParam takes integer aid, integer off, integer newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, newVal )
        endif
    endfunction

    function GetAbilityBaseUIIntegerParam takes integer aid, integer off returns integer
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return ReadRealMemory( pData + off )
        endif

        return 0
    endfunction

    function SetAbilityBaseUIRealParam takes integer aid, integer off, real newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, SetRealIntoMemory( newVal ) )
        endif
    endfunction

    function GetAbilityBaseUIRealParam takes integer aid, integer off returns real
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return ReadRealFloat( pData + off )
        endif

        return 0.
    endfunction

    function SetAbilityBaseUIBoolParam takes integer aid, integer off, boolean flag returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, B2I( flag ) )
        endif
    endfunction

    function GetAbilityBaseUIBoolParam takes integer aid, integer off returns boolean
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            return ReadRealMemory( pData + off ) > 0
        endif

        return false
    endfunction

    function GetAbilityBaseUIPStringParam takes integer aid, integer off returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ToJString( ReadRealMemory( pData ) )
            endif
        endif

        return null
    endfunction

    function SetAbilityBaseUIPStringParam takes integer aid, integer off, string newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                call WriteRealMemory( pData, GetStringAddress( newVal ) )
            endif
        endif
    endfunction
    
    function GetAbilityBaseUIStringParam takes integer aid, integer off returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )
        
        if pData > 0 then
            set pData = ReadRealMemory( pData + off )

            if pData > 0 then
                return ToJString( pData )
            endif
        endif

        return null
    endfunction

    function SetAbilityBaseUIStringParam takes integer aid, integer off, string newVal returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData > 0 then
            call WriteRealMemory( pData + off, GetStringAddress( newVal ) )
        endif
    endfunction

    function GetAbilityBaseUIStringParam2 takes integer aid, integer off, integer level returns string
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData != 0 then
            set pData = ReadRealMemory( pData + off )
            set level = level - 1

            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                if pData != 0 then
                    set pData = ReadRealMemory( pData + level * 0x4 )

                    if pData != 0 then
                        return ToJString( pData )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetAbilityBaseUIStringParam2 takes integer aid, integer off, string newVal, integer level returns nothing
        local integer pData = GetAbilityBaseUIByIdCaching( aid )

        if pData != 0 then
            set pData = ReadRealMemory( pData + off )
            set level = level - 1

            if level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
                if pData != 0 then
                    call WriteRealMemory( pData + level * 0x4, GetStringAddress( newVal ) )
                endif
            endif
        endif
    endfunction
    //===========================================
    
    // Ability Base Data API by Id
    
    //  CAbilityDef
	//	uint32_t	 unk_0;			// 0x0 | void**
	//	uint32_t	 unk_4;			// 0x4
	//	float		 nDuration;		// 0x8 | heroDuration
	//	float		 hDuration;		// 0xC | normalDuration
	//	int32_t		 manaCost;		// 0x10
	//	float		 cooldown;		// 0x14
	//	float		 aoe;			// 0x18
	//	float		 range;			// 0x1C
	//	float		 dataA;			// 0x20
	//	float		 dataB;			// 0x24
	//	float		 dataC;			// 0x28 | backswing
	//	float		 dataD;			// 0x2C | width
	//	float		 dataE;			// 0x30
	//	float		 dataF;			// 0x34
	//	uint32_t	 unk_38;		// 0x38
	//	uint32_t	 unk_3C;		// 0x3C
	//	uint32_t	 unk_40;		// 0x40
	//	uint32_t	 summonedUnit;	// 0x44
	//	VariousText	 buffIds;		// 0x48 - 0x50
	//	uint32_t	 unk_50;		// 0x50
	//	VariousText	 effectIds;		// 0x58 - 0x60
	//	uint32_t	 effectId;		// 0x64 | if effect id is sungular
    //  sizeof = 0x68
    
    function GetAbilityBaseDefData takes integer aid, integer level returns integer
        local integer pAbil = GetAbilityBaseDataByIdCaching( aid )

        if level > 0 then
            set level = level - 1
        endif

        if pAbil != 0 and level >= 0 and level < GetAbilityBaseMaxLevelById( aid ) then
            set pAbil = ReadRealMemory( pAbil + 0x54 )

            if pAbil != 0 then
                return pAbil + level * 0x68
            endif
        endif

        return 0
    endfunction

    function GetAbilityBaseNormalDurationById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x8 )
        endif

        return .0
    endfunction

    function SetAbilityBaseNormalDurationById takes integer aid, integer level, real duration returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x8, duration )
        endif
    endfunction

    function GetAbilityBaseHeroDurationById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0xC )
        endif

        return .0
    endfunction

    function SetAbilityBaseHeroDurationById takes integer aid, integer level, real duration returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0xC, duration )
        endif
    endfunction

    function GetAbilityBaseManaCostById takes integer aid, integer level returns integer
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealMemory( pAbil + 0x10 )
        endif

        return 0
    endfunction

    function SetAbilityBaseManaCostById takes integer aid, integer level, integer cost returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealMemory( pAbil + 0x10, cost )
        endif
    endfunction

    function GetAbilityBaseCooldownById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x14 )
        endif

        return .0
    endfunction

    function SetAbilityBaseCooldownById takes integer aid, integer level, real cool returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x14, cool )
        endif
    endfunction

    function GetAbilityBaseAoEById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x18 )
        endif

        return .0
    endfunction

    function SetAbilityBaseAoEById takes integer aid, integer level, real aoe returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x18, aoe )
        endif
    endfunction

    function GetAbilityBaseRangeById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x1C )
        endif

        return .0
    endfunction

    function SetAbilityBaseRangeById takes integer aid, integer level, real range returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x1C, range )
        endif
    endfunction

    function GetAbilityBaseDataAById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x20 )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataAById takes integer aid, integer level, real dataA returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x20, dataA )
        endif
    endfunction

    function GetAbilityBaseDataBById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x24 )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataBById takes integer aid, integer level, real dataB returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x24, dataB )
        endif
    endfunction

    function GetAbilityBaseDataCById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x28 )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataCById takes integer aid, integer level, real dataC returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x28, dataC )
        endif
    endfunction

    function GetAbilityBaseDataDById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x2C )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataDById takes integer aid, integer level, real dataD returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x2C, dataD )
        endif
    endfunction

    function GetAbilityBaseDataEById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x30 )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataEById takes integer aid, integer level, real dataE returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x30, dataE )
        endif
    endfunction

    function GetAbilityBaseDataFById takes integer aid, integer level returns real
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealFloat( pAbil + 0x34 )
        endif

        return .0
    endfunction

    function SetAbilityBaseDataFById takes integer aid, integer level, real dataF returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealFloat( pAbil + 0x34, dataF )
        endif
    endfunction

    function GetAbilityBaseSummonedUnitById takes integer aid, integer level returns integer
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealMemory( pAbil + 0x44 )
        endif

        return 0
    endfunction

    function SetAbilityBaseSummonedUnitById takes integer aid, integer level, integer uid returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealMemory( pAbil + 0x44, uid )
        endif
    endfunction

    function GetAbilityBaseEffectIdById takes integer aid, integer level returns integer
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            return ReadRealMemory( pAbil + 0x64 )
        endif

        return 0
    endfunction

    function SetAbilityBaseEffectIdById takes integer aid, integer level, integer eid returns nothing
        local integer pAbil = GetAbilityBaseDefData( aid, level )

        if pAbil != 0 then
            call WriteRealMemory( pAbil + 0x64, eid )
        endif
    endfunction
    //===========================================

    // Ability Base UI Data API by Id
    function GetAbilityBaseEffectSoundById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x30 )
    endfunction
    
    function SetAbilityBaseEffectSoundById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x30, s )
    endfunction

    function GetAbilityBaseEffectSoundLoopedById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x34 )
    endfunction
    
    function SetAbilityBaseEffectSoundLoopedById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x34, s )
    endfunction

    function GetAbilityBaseMissingIconById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x38 )
    endfunction
    
    function SetAbilityBaseMissingIconById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x38, s )
    endfunction

    function GetAbilityBaseCurrentIconById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x3C )
    endfunction
    
    function SetAbilityBaseCurrentIconById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x3C, s )
    endfunction

    function GetAbilityBaseCursorTextureById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x44 )
    endfunction
    
    function SetAbilityBaseCursorTextureById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x44, s )
    endfunction

    function GetAbilityBaseGlobalMessageById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x48 )
    endfunction

    function SetAbilityBaseGlobalMessageById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x48, s )
    endfunction
    
    function GetAbilityBaseGlobalSoundById takes integer aid returns string
        return GetAbilityBaseUIStringParam( aid, 0x4C )
    endfunction
    
    function SetAbilityBaseGlobalSoundById takes integer aid, string s returns nothing
        call SetAbilityBaseUIStringParam( aid, 0x4C, s )
    endfunction
    
    function GetAbilityBaseButtonXById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x50 )
    endfunction
    
    function SetAbilityBaseButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x50, newX )
    endfunction
    
    function GetAbilityBaseButtonYById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x54 )
    endfunction
    
    function SetAbilityBaseButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x54, newY )
    endfunction
    
    function GetAbilityBaseUnButtonXById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x58 )
    endfunction
    
    function SetAbilityBaseUnButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x58, newX )
    endfunction
    
    function GetAbilityBaseUnButtonYById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x5C )
    endfunction
    
    function SetAbilityBaseUnButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x5C, newY )
    endfunction
    
    function GetAbilityBaseResearchButtonXById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x60 )
    endfunction
    
    function SetAbilityBaseResearchButtonXById takes integer aid, integer newX returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x60, newX )
    endfunction
    
    function GetAbilityBaseResearchButtonYById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x64 )
    endfunction
    
    function SetAbilityBaseResearchButtonYById takes integer aid, integer newY returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x64, newY )
    endfunction
    
    function GetAbilityBaseMissileSpeedById takes integer aid returns real
        return GetAbilityBaseUIRealParam( aid, 0x68 )
    endfunction
    
    function SetAbilityBaseMissileSpeedById takes integer aid, real speed returns nothing
        call SetAbilityBaseUIRealParam( aid, 0x68, speed )
    endfunction
    
    function GetAbilityBaseMissileArcById takes integer aid returns real
        return GetAbilityBaseUIRealParam( aid, 0x6C )
    endfunction
    
    function SetAbilityBaseMissileArcById takes integer aid, real arc returns nothing
        call SetAbilityBaseUIRealParam( aid, 0x6C, arc )
    endfunction
    
    function IsAbilityMissileHomingById takes integer aid returns boolean
        return GetAbilityBaseUIBoolParam( aid, 0x70 )
    endfunction
    
    function SetAbilityBaseMissileHomingById takes integer aid, boolean homing returns nothing
        call SetAbilityBaseUIBoolParam( aid, 0x70, homing )
    endfunction
    
    function GetAbilityBaseSpellDetailsById takes integer aid returns integer
        return GetAbilityBaseUIIntegerParam( aid, 0x74 )
    endfunction
    
    function SetAbilityBaseSpellDetailsById takes integer aid, integer det returns nothing
        call SetAbilityBaseUIIntegerParam( aid, 0x74, det )
    endfunction
    
    function GetAbilityBaseHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x84 )
    endfunction
    
    function SetAbilityBaseHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x84, newVal )
    endfunction
    
    function GetAbilityBaseUnHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x90 )
    endfunction
    
    function SetAbilityBaseUnHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x90, newVal )
    endfunction
    
    function GetAbilityBaseResearchHotkeyIdById takes integer aid returns integer
        return GetAbilityBaseHotkeyParam( aid, 0x9C )
    endfunction
    
    function SetAbilityBaseResearchHotkeyIdById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyParam( aid, 0x9C, newVal )
    endfunction

    function GetAbilityBaseNameById takes integer aid returns string
        return GetAbilityBaseUIPStringParam( aid, 0xA8 )
    endfunction
    
    function SetAbilityBaseNameById takes integer aid, string s returns nothing
        call SetAbilityBaseUIPStringParam( aid, 0xA8, s )
    endfunction

    function GetAbilityBaseIconById takes integer aid returns string
        return GetAbilityBaseUIPStringParam( aid, 0xB4 )
    endfunction
    
    function SetAbilityBaseIconById takes integer aid, string s returns nothing
        call SetAbilityBaseUIPStringParam( aid, 0xB4, s )
    endfunction

    function GetAbilityBaseMissileArtById takes integer aid returns string
        return GetAbilityBaseUIPStringParam( aid, 0xF0 )
    endfunction
    
    function SetAbilityBaseMissileArtById takes integer aid, string s returns nothing
        call SetAbilityBaseUIPStringParam( aid, 0xF0, s )
    endfunction

    function GetAbilityBaseResearchTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x12C, lvl )
    endfunction
    
    function SetAbilityBaseResearchTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x12C, s, lvl )
    endfunction

    function GetAbilityBaseTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x138, lvl )
    endfunction
    
    function SetAbilityBaseTipById takes integer aid, integer lvl, string s returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x138, s, lvl )
    endfunction
    
    function GetAbilityBaseUnTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x144, lvl )
    endfunction
    
    function SetAbilityBaseUnTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x144, s, lvl )
    endfunction
    
    function GetAbilityBaseResearchUberTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x150, lvl )
    endfunction
    
    function SetAbilityBaseResearchUberTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x150, s, lvl )
    endfunction
    
    function GetAbilityBaseUbertipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x15C, lvl )
    endfunction
    
    function SetAbilityBaseUbertipById takes integer aid, integer lvl, string s returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x15C, s, lvl )
    endfunction

    function GetAbilityBaseResearchUnUberTipById takes integer aid, integer lvl returns string
        return GetAbilityBaseUIStringParam2( aid, 0x168, lvl )
    endfunction

    function SetAbilityBaseResearchUnUberTipById takes integer aid, string s, integer lvl returns nothing
        call SetAbilityBaseUIStringParam2( aid, 0x168, s, lvl )
    endfunction

    function SetAbilityBaseHotkeyCommonById takes integer aid, integer newVal returns nothing
        call SetAbilityBaseHotkeyIdById( aid, newVal )
        call SetAbilityBaseUnHotkeyIdById( aid, newVal )
        call SetAbilityBaseResearchHotkeyIdById( aid, newVal )
    endfunction
    //===========================================
    
    // Base Ability Data/UI Data API
    function GetAbilityTypeId takes ability a returns integer
        return GetAddressAbilityTypeId( ConvertHandle( a ) )
    endfunction

    function GetAbilityBaseId takes ability abil returns integer
        return GetAddressAbilityBaseId( ConvertHandle( abil ) )
    endfunction
    
    function GetAbilityBaseData takes ability abil returns integer
        return GetAbilityBaseDataById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseDataCaching takes ability abil returns integer
        return GetAbilityBaseDataByIdCaching( GetAbilityBaseDataById( GetAbilityTypeId( abil ) ) )
    endfunction

    function GetAbilityBaseUI takes ability abil returns integer
        return GetAbilityBaseUIById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseUICaching takes ability abil returns integer
        return GetAbilityBaseUIByIdCaching( GetAbilityTypeId( abil ) )
    endfunction
    //===========================================
    
    // Base Ability Data Data API
    function GetAbilityBaseMaxLevel takes ability abil returns integer
        return GetAbilityBaseMaxLevelById( GetAbilityTypeId( abil ) )
    endfunction

    function GetAbilityBaseHeroDuration takes ability abil, integer level returns real
        return GetAbilityBaseHeroDurationById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseHeroDuration takes ability abil, integer level, real duration returns nothing
        call SetAbilityBaseHeroDurationById( GetAbilityTypeId( abil ), level, duration )
    endfunction

    function GetAbilityBaseNormalDuration takes ability abil, integer level returns real
        return GetAbilityBaseNormalDurationById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseNormalDuration takes ability abil, integer level, real duration returns nothing
        call SetAbilityBaseNormalDurationById( GetAbilityTypeId( abil ), level, duration )
    endfunction

    function GetAbilityBaseManaCost takes ability abil, integer level returns integer
        return GetAbilityBaseManaCostById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseManaCost takes ability abil, integer level, integer cost returns nothing
        call SetAbilityBaseManaCostById( GetAbilityTypeId( abil ), level, cost )
    endfunction

    function GetAbilityBaseCooldown takes ability abil, integer level returns real
        return GetAbilityBaseCooldownById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseCooldown takes ability abil, integer level, real cool returns nothing
        call SetAbilityBaseCooldownById( GetAbilityTypeId( abil ), level, cool )
    endfunction

    function GetAbilityBaseAoE takes ability abil, integer level returns real
        return GetAbilityBaseAoEById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseAoE takes ability abil, integer level, real aoe returns nothing
        call SetAbilityBaseAoEById( GetAbilityTypeId( abil ), level, aoe )
    endfunction

    function GetAbilityBaseRange takes ability abil, integer level returns real
        return GetAbilityBaseRangeById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseRange takes ability abil, integer level, real range returns nothing
        call SetAbilityBaseRangeById( GetAbilityTypeId( abil ), level, range )
    endfunction

    function GetAbilityBaseDataA takes ability abil, integer level returns real
        return GetAbilityBaseDataAById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataA takes ability abil, integer level, real dataA returns nothing
        call SetAbilityBaseDataAById( GetAbilityTypeId( abil ), level, dataA )
    endfunction

    function GetAbilityBaseDataB takes ability abil, integer level returns real
        return GetAbilityBaseDataBById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataB takes ability abil, integer level, real dataB returns nothing
        call SetAbilityBaseDataBById( GetAbilityTypeId( abil ), level, dataB )
    endfunction

    function GetAbilityBaseDataC takes ability abil, integer level returns real
        return GetAbilityBaseDataCById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataC takes ability abil, integer level, real dataC returns nothing
        call SetAbilityBaseDataCById( GetAbilityTypeId( abil ), level, dataC )
    endfunction

    function GetAbilityBaseDataD takes ability abil, integer level returns real
        return GetAbilityBaseDataDById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataD takes ability abil, integer level, real dataD returns nothing
        call SetAbilityBaseDataDById( GetAbilityTypeId( abil ), level, dataD )
    endfunction

    function GetAbilityBaseDataE takes ability abil, integer level returns real
        return GetAbilityBaseDataEById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataE takes ability abil, integer level, real dataE returns nothing
        call SetAbilityBaseDataEById( GetAbilityTypeId( abil ), level, dataE )
    endfunction

    function GetAbilityBaseDataF takes ability abil, integer level returns real
        return GetAbilityBaseDataFById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseDataF takes ability abil, integer level, real dataF returns nothing
        call SetAbilityBaseDataFById( GetAbilityTypeId( abil ), level, dataF )
    endfunction

    function GetAbilityBaseSummonedUnit takes ability abil, integer level returns integer
        return GetAbilityBaseSummonedUnitById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseSummonedUnit takes ability abil, integer level, integer uid returns nothing
        call SetAbilityBaseSummonedUnitById( GetAbilityTypeId( abil ), level, uid )
    endfunction

    function GetAbilityBaseEffectId takes ability abil, integer level returns integer
        return GetAbilityBaseEffectIdById( GetAbilityTypeId( abil ), level )
    endfunction

    function SetAbilityBaseEffectId takes ability abil, integer level, integer eid returns nothing
        call SetAbilityBaseEffectIdById( GetAbilityTypeId( abil ), level, eid )
    endfunction
    //===========================================

    // Base Ability UI Data API
    function GetAbilityBaseEffectSound takes ability abil returns string
        return GetAbilityBaseEffectSoundById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseEffectSound takes ability abil, string s returns nothing
        call SetAbilityBaseEffectSoundById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseEffectSoundLooped takes ability abil returns string
        return GetAbilityBaseEffectSoundLoopedById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseEffectSoundLooped takes ability abil, string s returns nothing
        call SetAbilityBaseEffectSoundLoopedById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseMissingIcon takes ability abil returns string
        return GetAbilityBaseMissingIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissingIcon takes ability abil, string s returns nothing
        call SetAbilityBaseMissingIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseCurrentIcon takes ability abil returns string
        return GetAbilityBaseCurrentIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseCurrentIcon takes ability abil, string s returns nothing
        call SetAbilityBaseCurrentIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseCursorTexture takes ability abil returns string
        return GetAbilityBaseCursorTextureById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseCursorTexture takes ability abil, string s returns nothing
        call SetAbilityBaseCursorTextureById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseGlobalMessage takes ability abil returns string
        return GetAbilityBaseGlobalMessageById( GetAbilityTypeId( abil ) )
    endfunction

    function SetAbilityBaseGlobalMessage takes ability abil, string s returns nothing
        call SetAbilityBaseGlobalMessageById( GetAbilityTypeId( abil ), s )
    endfunction
    
    function GetAbilityBaseGlobalSound takes ability abil returns string
        return GetAbilityBaseGlobalSoundById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseGlobalSound takes ability abil, string s returns nothing
        call SetAbilityBaseGlobalSoundById( GetAbilityTypeId( abil ), s )
    endfunction
    
    function GetAbilityBaseButtonX takes ability abil returns integer
        return GetAbilityBaseButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseButtonY takes ability abil returns integer
        return GetAbilityBaseButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseUnButtonX takes ability abil returns integer
        return GetAbilityBaseUnButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseUnButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseUnButtonY takes ability abil returns integer
        return GetAbilityBaseUnButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseUnButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseResearchButtonX takes ability abil returns integer
        return GetAbilityBaseResearchButtonXById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchButtonX takes ability abil, integer newX returns nothing
        call SetAbilityBaseResearchButtonXById( GetAbilityTypeId( abil ), newX )
    endfunction
    
    function GetAbilityBaseResearchButtonY takes ability abil returns integer
        return GetAbilityBaseResearchButtonYById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchButtonY takes ability abil, integer newY returns nothing
        call SetAbilityBaseResearchButtonYById( GetAbilityTypeId( abil ), newY )
    endfunction
    
    function GetAbilityBaseMissileSpeed takes ability abil returns real
        return GetAbilityBaseMissileSpeedById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileSpeed takes ability abil, real speed returns nothing
        call SetAbilityBaseMissileSpeedById( GetAbilityTypeId( abil ), speed )
    endfunction
    
    function GetAbilityBaseMissileArc takes ability abil returns real
        return GetAbilityBaseMissileArcById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileArc takes ability abil, real arc returns nothing
        call SetAbilityBaseMissileArcById( GetAbilityTypeId( abil ), arc )
    endfunction
    
    function IsAbilityMissileHoming takes ability abil returns boolean
        return IsAbilityMissileHomingById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileHoming takes ability abil, boolean homing returns nothing
        call SetAbilityBaseMissileHomingById( GetAbilityTypeId( abil ), homing )
    endfunction
    
    function GetAbilityBaseSpellDetails takes ability abil returns integer
        return GetAbilityBaseSpellDetailsById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseSpellDetails takes ability abil, integer det returns nothing
        call SetAbilityBaseSpellDetailsById( GetAbilityTypeId( abil ), det )
    endfunction
    
    function GetAbilityBaseHotkeyId takes ability abil returns integer
        return GetAbilityBaseHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction
    
    function GetAbilityBaseUnHotkeyId takes ability abil returns integer
        return GetAbilityBaseUnHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseUnHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseUnHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction
    
    function GetAbilityBaseResearchHotkeyId takes ability abil returns integer
        return GetAbilityBaseResearchHotkeyIdById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseResearchHotkeyId takes ability abil, integer newVal returns nothing
        call SetAbilityBaseResearchHotkeyIdById( GetAbilityTypeId( abil ), newVal )
    endfunction

    function GetAbilityBaseName takes ability abil returns string
        return GetAbilityBaseNameById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseName takes ability abil, string s returns nothing
        call SetAbilityBaseNameById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseIcon takes ability abil returns string
        return GetAbilityBaseIconById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseIcon takes ability abil, string s returns nothing
        call SetAbilityBaseIconById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseMissileArt takes ability abil returns string
        return GetAbilityBaseMissileArtById( GetAbilityTypeId( abil ) )
    endfunction
    
    function SetAbilityBaseMissileArt takes ability abil, string s returns nothing
        call SetAbilityBaseMissileArtById( GetAbilityTypeId( abil ), s )
    endfunction

    function GetAbilityBaseResearchTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseResearchTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction

    function GetAbilityBaseTip takes ability abil, integer lvl returns string
        return GetAbilityBaseTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseTip takes ability abil, integer lvl, string s returns nothing
        call SetAbilityBaseTipById( GetAbilityTypeId( abil ), lvl, s )
    endfunction
    
    function GetAbilityBaseUnTip takes ability abil, integer lvl returns string
        return GetAbilityBaseUnTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseUnTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseUnTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction
    
    function GetAbilityBaseResearchUberTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchUberTipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseResearchUberTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchUberTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction
    
    function GetAbilityBaseUbertip takes ability abil, integer lvl returns string
        return GetAbilityBaseUbertipById( GetAbilityTypeId( abil ), lvl )
    endfunction
    
    function SetAbilityBaseUbertip takes ability abil, integer lvl, string s returns nothing
        call SetAbilityBaseUbertipById( GetAbilityTypeId( abil ), lvl, s )
    endfunction

    function GetAbilityBaseResearchUnUberTip takes ability abil, integer lvl returns string
        return GetAbilityBaseResearchUnUberTipById( GetAbilityTypeId( abil ), lvl )
    endfunction

    function SetAbilityBaseResearchUnUberTip takes ability abil, string s, integer lvl returns nothing
        call SetAbilityBaseResearchUnUberTipById( GetAbilityTypeId( abil ), s, lvl )
    endfunction

    function SetAbilityBaseHotkeyCommon takes ability abil, integer newVal returns nothing
        call SetAbilityBaseHotkeyCommonById( GetAbilityTypeId( abil ), newVal )
    endfunction
    //===========================================
    
    function Init_MemHackAbilityBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ), pGameDLL + 0x2669E0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ), pGameDLL + 0x32D420 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ), pGameDLL + 0x265ED0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ), pGameDLL + 0x32C8E0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ), pGameDLL + 0x68EDF0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ), pGameDLL + 0x322C30 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ), pGameDLL + 0x6AC530 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ), pGameDLL + 0x340380 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetDataNode" ), pGameDLL + 0x6E06E0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityBase" ), StringHash( "GetUINode" ), pGameDLL + 0x374340 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass
//////////////基础技能数据API


//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityAddressAPI requires InMHCore
    // CAbility API
    function GetAbilityBaseDataByAddress takes integer pAbil returns integer
        if pAbil > 0 then
            return ReadRealMemory( pAbil + 0x54 )
        endif

        return 0
    endfunction

    function GetAddressAbilityTypeId takes integer pAbil returns integer
        if pAbil != 0 then
            return ReadRealMemory( pAbil + 0x34 )
        endif

        return 0
    endfunction
    
    function GetAddressAbilityBaseTypeId takes integer pAbil returns integer
        local integer base = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 then
                return ReadRealMemory( base + 0x34 )
            endif
        endif

        return 0
    endfunction
    
    function GetAddressAbilityBaseId takes integer pAbil returns integer
        local integer base = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 and ReadRealMemory( pAbil + 0x6C ) > 0 then
                return ReadRealMemory( base + 0x30 )
            endif
        endif

        return 0
    endfunction

    function GetAddressAbilityOrderId takes integer pAbil returns integer
        local integer pOffset2 = 0
        local integer base     = 0

        if pAbil > 0 then
            set base = GetAbilityBaseDataByAddress( pAbil )

            if base > 0 then
                set base = ReadRealMemory( base + 0x30 )

                if base > 0 then
                    if base == 'ANcl' then
                        return ReadRealMemory( pAbil + 0x124 )
                    else
                        return c_call_1( ReadRealMemory( ReadRealMemory( pAbil ) + 0x308 ), 0 )
                    endif
                endif
            endif
        endif

        return 0
    endfunction

    function IsAddressAbilityOnCooldown takes integer pAbil returns boolean
        if pAbil > 0 then
            return IsFlagBitSet( ReadRealMemory( pAbil + 0x20 ), 512 )
        endif

        return false
    endfunction
    
    function IsAddressAbilitySafe takes integer pAbil returns boolean
        local integer base  = GetAddressAbilityBaseId( pAbil )
        local integer order = 0

        if base > 0 then
            if base == 'ANcl' then
                set order = ReadRealMemory( pAbil + 0x124 )
            else
                set order = GetAddressAbilityOrderId( pAbil )
            endif

            if base == 'AOre' or base == 'Aexh' then
                return true
            endif

            return order > 0 and base != 'ANeg'
        endif

        return false
    endfunction

    function IsAddressAbilityUsable takes integer pAbil returns boolean // Always false for ANcl
        if pAbil > 0 then
            return this_call_1( ReadRealMemory( ReadRealMemory( pAbil ) + 0x1D8 ), pAbil ) == 1 or ( ReadRealMemory( pAbil + 0x6C ) != 0 and GetAddressAbilityBaseId( pAbil ) == 'ANcl' ) 
        endif

        return false
    endfunction

    function GetAddressAbilityCastTime takes integer pAbil returns real
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0x84 )

            if pAbil > 0 then
                return GetRealFromMemory( ReadRealMemory( pAbil ) )
            endif
        endif

        return 0.
    endfunction

    function SetAddressAbilityCastTime takes integer pAbil, real r returns nothing
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0x84 )

            if pAbil > 0 then
                call WriteRealMemory( pAbil, SetRealIntoMemory( r ) )
            endif
        endif
    endfunction
    
    function GetAddressAbilityCastpoint takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0x8C ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityCastpoint takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x8C, SetRealIntoMemory( dur ) )
        endif
    endfunction

    function GetAddressAbilityBackswing takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0x94 ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityBackswing takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x94, SetRealIntoMemory( dur ) )
        endif
    endfunction

    function GetAddressAbilityDefaultCooldown takes integer pAbil returns real
        if pAbil > 0 then
            return GetRealFromMemory( ReadRealMemory( pAbil + 0xB4 ) )
        endif

        return 0.
    endfunction

    function SetAddressAbilityDefaultCooldown takes integer pAbil, real dur returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0xB4, SetRealIntoMemory( dur ) )
        endif
    endfunction
    
    function GetAddressAbilityManaCost takes integer pAbil, integer level returns integer
        if pAbil > 0 then
            set pAbil = GetAbilityBaseDataByAddress( pAbil )

            if pAbil > 0 then
                return ReadRealMemory( pAbil + level * 0x68 )
            endif
        endif

        return 0
    endfunction
    
    function SetAddressAbilityManaCost takes integer pAbil, integer level, integer mc returns nothing
        if pAbil > 0 then
            set pAbil = GetAbilityBaseDataByAddress( pAbil )

            if pAbil > 0 then
                call WriteRealMemory( pAbil + level * 0x68, mc )
            endif
        endif
    endfunction

    function GetAddressAbilityCooldownStamp takes integer pAbil returns real
        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )
            
            if pAbil > 0 then
                return GetRealFromMemory( ReadRealMemory( pAbil + 0x4 ) )
            endif
        endif

        return 0.
    endfunction
    
    function GetAddressAbilityCurrentCooldown takes integer pAbil returns real
        local real cd = 0.

        if pAbil > 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )

            if pAbil > 0 then
                set cd    = GetRealFromMemory( ReadRealMemory( pAbil + 0x4 ) )
                set pAbil = ReadRealMemory( pAbil + 0xC )

                if pAbil > 0 then
                    set pAbil = ReadRealMemory( pAbil + 0x40 )
                    
                    if pAbil > 0 then
                        return cd - GetRealFromMemory( pAbil )
                    endif
                endif
            endif
        endif

        return .0
    endfunction
    
    function SetAddressAbilityCooldown takes integer pAbil, real seconds, string mode returns nothing
        local real cd = 0.

        if pAbil != 0 then
            set pAbil = ReadRealMemory( pAbil + 0xDC )
 
            if pAbil != 0 then
                set cd = ReadRealFloat( pAbil + 0x4 )

                if mode == "+" then
                    set seconds = cd + seconds
            elseif mode == "-" then
                    set seconds = cd - seconds
                endif

                call WriteRealMemory( pAbil + 0x4, SetRealIntoMemory( seconds ) )
            endif
        endif
    endfunction
    
    function StartAddressAbilityCooldown takes integer pAbil, real cd returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ) )
        local integer arg  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if addr != 0 and pAbil != 0 and arg != 0 and IsAddressAbilitySafe( pAbil ) then
            call WriteRealFloat( arg + 0x0, cd )
            call this_call_2( addr, pAbil, arg + 0x0 )
            return IsAddressAbilityOnCooldown( pAbil )
        endif

        return false
    endfunction

    function SetAddressAbilityDisabled takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x3C, count )
        endif
    endfunction

    function GetAddressAbilityDisabled takes integer pAbil returns integer
        return ReadRealMemory( pAbil + 0x3C )
    endfunction

    function SetAddressAbilityHidden takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x40, count )
        endif
    endfunction

    function AddAddressAbilityHidden takes integer pAbil, integer d returns nothing
        call WriteRealMemory( pAbil + 0x40, ReadRealMemory( pAbil + 0x40 ) + d )
    endfunction

    function GetAddressAbilityDisabledEx takes integer pAbil returns integer
        if pAbil > 0 then
            return ReadRealMemory( pAbil + 0x44 ) 
        endif
        
        return 0
    endfunction

    function SetAddressAbilityDisabledEx takes integer pAbil, integer count returns nothing
        if pAbil > 0 then
            call WriteRealMemory( pAbil + 0x44, count )
        endif
    endfunction

    function ShowAddressAbility takes integer pAbil, boolean flag returns nothing
        if pAbil > 0 then
            if ReadRealMemory( pAbil ) > 0 then
                call WriteRealMemory( pAbil + 0x40, B2I( not flag ) )
            endif
        endif
    endfunction

    function SilenceAddressAbility takes integer pAbil returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ) )

        if addr != 0 and pAbil != 0 then
            call this_call_3( addr, pAbil, 0, 1 )
        endif
    endfunction

    function UnsilenceAddressAbility takes integer pAbil returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ) )

        if addr != 0 and pAbil != 0 then
            call this_call_3( addr, pAbil, 0, 1 )
        endif
    endfunction
    //===========================================

    // Buff API
    function GetAddressBuffLevel takes integer pBuff returns integer
        if pBuff > 0 then
            return ReadRealMemory( pBuff + 0xB0 ) + 1
        endif

        return -1 // Ensure we failed
    endfunction
    //===========================================

    function Init_MemHackAbilityAddressAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x0518B0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x0538A0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x053900 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x050B70 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x052B60 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x052BC0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x418D20 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x3E9FA0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x3EE3C0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x436460 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x4076E0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x40BB00 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "StartCooldown" ), pGameDLL + 0x46A570 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Silence" ), pGameDLL + 0x43B7C0 )
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Unsilence" ), pGameDLL + 0x43FBE0 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass
////////////技能地址API


//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityNormalAPI requires InMHCore , MemoryHackAbilityAddressAPI
    // jAbility API
    function GetAbilityOrderId takes ability a returns integer
        return GetAddressAbilityOrderId( ConvertHandle( a ) )
    endfunction

    function IsAbilityOnCooldown takes ability a returns boolean
        return IsAddressAbilityOnCooldown( ConvertHandle( a ) )
    endfunction

    function IsAbilitySafe takes ability a returns boolean
        return IsAddressAbilitySafe( ConvertHandle( a ) )
    endfunction

    function IsAbilityUsable takes ability a returns boolean
        return IsAddressAbilityUsable( ConvertHandle( a ) )
    endfunction

    function GetAbilityCastpoint takes ability a returns real
        return GetAddressAbilityCastpoint( ConvertHandle( a ) )
    endfunction

    function SetAbilityCastpoint takes ability a, real dur returns nothing
        call SetAddressAbilityCastpoint( ConvertHandle( a ), dur )
    endfunction

    function GetAbilityBackswing takes ability a returns real
        return GetAddressAbilityBackswing( ConvertHandle( a ) )
    endfunction

    function SetAbilityBackswing takes ability a, real dur returns nothing
        call SetAddressAbilityBackswing( ConvertHandle( a ), dur )
    endfunction

    function GetAbilityManaCost takes ability a, integer level returns integer
        return GetAddressAbilityManaCost( ConvertHandle( a ), level )
    endfunction

    function SetAbilityManaCost takes ability a, integer level, integer mc returns nothing
        call SetAddressAbilityManaCost( ConvertHandle( a ), level, mc )
    endfunction

    function GetAbilityCooldownStamp takes ability a returns real
        //This actually returns the timestamp, not the cooldown. To get the real cooldown you need to subtract this from the current game time.
        return GetAddressAbilityCooldownStamp( ConvertHandle( a ) )
    endfunction

    function GetAbilityCurrentCooldown takes ability a returns real
        //This value holds the base cooldown of the ability at the last time it was casted. It’s used to calculate the % of elapsed cooldown.
        //This is completely irrelevant for the gameplay, it’s used only to determine which frame of the cooldown model will be displayed.
        return GetAddressAbilityCurrentCooldown( ConvertHandle( a ) )
    endfunction

    function SetAbilityCooldown takes ability a, real seconds, string mode returns nothing
        call SetAddressAbilityCooldown( ConvertHandle( a ), seconds, mode )
    endfunction

    function AddAbilityCooldown takes ability a, real seconds returns nothing
        call SetAbilityCooldown( a, seconds, "+" )
    endfunction

    function ReduceAbilityCooldown takes ability a, real seconds returns nothing
        call SetAbilityCooldown( a, seconds, "-" )
    endfunction

    function ResetAbilityCooldown takes ability a returns nothing
        call SetAbilityCooldown( a, -1., "" )
    endfunction

    function StartAbilityCooldown takes ability a, real cd returns nothing
        call StartAddressAbilityCooldown( ConvertHandle( a ), cd )
    endfunction

    function GetAbilityCastTime takes ability a returns real
        return GetAddressAbilityCastTime( ConvertHandle( a ) )
    endfunction

    function SetAbilityCastTime takes ability a, real r returns nothing
        call SetAddressAbilityCastTime( ConvertHandle( a ), r )
    endfunction

    function SetAbilityDisabled takes ability a, integer count returns nothing
        // not safe unless used with PauseUnit. Button will be blacked, but current casts of that ability won’t be interrupted.
        call SetAddressAbilityDisabled( ConvertHandle( a ), count )
    endfunction

    function GetAbilityDisabled takes ability a returns integer
        return GetAddressAbilityDisabled( ConvertHandle( a ) )
    endfunction

    function SetAbilityHidden takes ability a, integer count returns nothing
        // This one is 100% safe. This hides the ability button, and order can’t be issued.
        call SetAddressAbilityHidden( ConvertHandle( a ), count ) // -1 = unhide | 1 = hide
    endfunction

    function AddAbilityHidden takes ability a, integer count returns nothing
        call AddAddressAbilityHidden( ConvertHandle( a ), count )
    endfunction

    function GetAbilityDisabledEx takes ability a returns integer
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        return GetAddressAbilityDisabledEx( ConvertHandle( a ) )
    endfunction

    function SetAbilityDisabledEx takes ability a, integer count returns nothing
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        call SetAddressAbilityDisabledEx( ConvertHandle( a ), count ) // -1 = unhide | 1 = hide
    endfunction

    function SilenceAbility takes ability a returns nothing
        call SilenceAddressAbility( ConvertHandle( a ) )
    endfunction

    function UnsilenceAbility takes ability a returns nothing
        call UnsilenceAddressAbility( ConvertHandle( a ) )
    endfunction

    function ShowAbility takes ability a, boolean flag returns nothing
        call ShowAddressAbility( ConvertHandle( a ), flag )
    endfunction
    //===========================================

    // Buff API
    function GetBuffLevel takes buff b returns integer
        return GetAddressBuffLevel( ConvertHandle( b ) )
    endfunction
    //===========================================

    function Init_MemHackAbilityNormalAPI takes nothing returns nothing
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
//! endnocjass
//////////////////不知道干啥的


//TESH.scrollpos=66
//TESH.alwaysfold=0
//! nocjass
library MemoryHackAbilityUnitAPI requires InMHCore , MemoryHackAbilityAddressAPI
    // CUnit Ability API
    function GetUnitAbilityReal takes integer pUnit, integer aid, integer unk1, integer unk2, integer unk3, integer unk4 returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ) )

        if addr != 0 and pUnit > 0 and aid > 0 then
            return this_call_6( addr, pUnit, aid, unk1, unk2, unk3, unk4 )
        endif

        return 0
    endfunction

    function CUnitAddAbility takes integer pUnit, integer aid returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ) )

        if addr != 0 and pUnit != 0 and aid != 0 then
            return fast_call_5( addr, pUnit, aid, 0, 0, 0 ) > 0
        endif

        return false
    endfunction

    function CUnitRemoveAbility takes integer pUnit, integer pAbil returns boolean
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ) )

        if addr != 0 and pUnit != 0 and pAbil != 0 then
            call this_call_2( addr, pUnit, pAbil )
            return true
        endif

        return false
    endfunction

    function CUnitRemoveAbilityById takes integer pUnit, integer aid returns boolean
        local integer pAbil = 0

        if pUnit != 0 and aid != 0 then
            set pAbil = GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 )

            if pAbil != 0 then
                return CUnitRemoveAbility( pUnit, pAbil )
            endif
        endif

        return false
    endfunction
    //===========================================
    
    // jUnit Ability API
    function GetUnitAbilityData takes unit u, integer aid, integer flag returns integer
        local integer pUnit

        if u != null and aid > 0 then
            set pUnit = ConvertHandle( u )

            if pUnit > 0 then
                return GetUnitAbilityReal( pUnit, aid, 0, flag, 1, 1 )
            endif
        endif

        return 0
    endfunction

    function GetUnitAbility takes unit u, integer aid returns integer
        if GetUnitAbilityLevel( u, aid ) > 0 then
            return GetUnitAbilityData( u, aid, 1 )
        endif

        return 0
    endfunction

    function GetUnitAbilityByIndex takes unit u, integer index returns ability
        local integer pData = ConvertHandle( u )
        local integer pAbil = 0
        local integer i = 0

        if pData != 0 then
            set pAbil = GetCAgentFromHashGroup( pData + 0x1DC )

            if pAbil != 0 then
                loop
                    exitwhen pAbil == 0 or i == index
                    set pAbil = GetCAgentFromHashGroup( pAbil + 0x24 )
                    set i = i + 1
                endloop

                if pAbil != 0 then
                    return ObjectToAbility( pAbil )
                endif
            endif
        endif

        return null
    endfunction

    function GetUnitJAbility takes unit u, integer aid returns ability
        return ObjectToAbility( GetUnitAbility( u, aid ) )
    endfunction

    function AddUnitAbility takes unit u, integer aid returns boolean
        return CUnitAddAbility( ConvertHandle( u ), aid )
    endfunction

    function RemoveUnitAbility takes unit u, integer aid, boolean removeduplicates returns nothing
        call CUnitRemoveAbility( ConvertHandle( u ), aid )
    endfunction

    function GetUnitAbilityBase takes unit u, integer aid returns integer
        return GetUnitAbilityData( u, aid, 0 )
    endfunction

    function GetUnitAbilityOrderId takes unit u, integer aid returns integer
        return GetAddressAbilityOrderId( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilityOnCooldown takes unit u, integer aid returns boolean
        return IsAddressAbilityOnCooldown( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilitySafe takes unit u, integer aid returns boolean
        return IsAddressAbilitySafe( GetUnitAbility( u, aid ) )
    endfunction

    function IsUnitAbilityUsable takes unit u, integer aid returns boolean
        return IsAddressAbilityUsable( GetUnitAbility( u, aid ) )
    endfunction

    function GetUnitAbilityCastpoint takes unit u, integer aid returns real
        return GetAddressAbilityCastpoint( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCastpoint takes unit u, integer aid, real dur returns nothing
        call SetAddressAbilityCastpoint( GetUnitAbility( u, aid ), dur )
    endfunction

    function GetUnitAbilityBackswing takes unit u, integer aid returns real
        return GetAddressAbilityBackswing( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityBackswing takes unit u, integer aid, real dur returns nothing
        call SetAddressAbilityBackswing( GetUnitAbility( u, aid ), dur )
    endfunction

    function GetUnitAbilityManaCost takes unit u, integer aid, integer level returns integer
        return GetAddressAbilityManaCost( GetUnitAbility( u, aid ), level )
    endfunction

    function SetUnitAbilityManaCost takes unit u, integer aid, integer level, integer mc returns nothing
        call SetAddressAbilityManaCost( GetUnitAbility( u, aid ), level, mc )
    endfunction

    function GetUnitAbilityCooldownStamp takes unit u, integer aid returns real
        //This actually returns the timestamp, not the cooldown. To get the real cooldown you need to subtract this from the current game time.
        return GetAddressAbilityCooldownStamp( GetUnitAbility( u, aid ) )
    endfunction

    function GetUnitAbilityCurrentCooldown takes unit u, integer aid returns real
        //This value holds the base cooldown of the ability at the last time it was casted. It’s used to calculate the % of elapsed cooldown.
        //This is completely irrelevant for the gameplay, it’s used only to determine which frame of the cooldown model will be displayed.
        return GetAddressAbilityCurrentCooldown( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCooldown takes unit u, integer aid, real seconds, string mode returns nothing
        call SetAddressAbilityCooldown( GetUnitAbility( u, aid ), seconds, mode )
    endfunction

    function AddUnitAbilityCooldown takes unit u, integer aid, real seconds returns nothing
        call SetUnitAbilityCooldown( u, aid, seconds, "+" )
    endfunction

    function ReduceUnitAbilityCooldown takes unit u, integer aid, real seconds returns nothing
        call SetUnitAbilityCooldown( u, aid, seconds, "-" )
    endfunction

    function ResetUnitAbilityCooldown takes unit u, integer aid returns nothing
        call SetUnitAbilityCooldown( u, aid, -1., "" )
    endfunction

    function StartUnitAbilityCooldown takes unit u, integer aid, real cd returns nothing
        call StartAddressAbilityCooldown( GetUnitAbility( u, aid ), cd )
    endfunction

    function GetUnitAbilityCastTime takes unit u, integer aid returns real
        return GetAddressAbilityCastTime( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityCastTime takes unit u, integer aid, real r returns nothing
        call SetAddressAbilityCastTime( GetUnitAbility( u, aid ), r )
    endfunction

    function SetUnitAbilityDisabled takes unit u, integer aid, integer count returns nothing
        // not safe unless used with PauseUnit. Button will be blacked, but current casts of that ability won’t be interrupted.
        call SetAddressAbilityDisabled( GetUnitAbility( u, aid ), count )
    endfunction

    function GetUnitAbilityDisabled takes unit u, integer aid returns integer
        return GetAddressAbilityDisabled( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityHidden takes unit u, integer aid, integer count returns nothing
        // This one is 100% safe. This hides the ability button, and order can’t be issued.
        call SetAddressAbilityHidden( GetUnitAbility( u, aid ), count ) // -1 = unhide | 1 = hide
    endfunction

    function AddUnitAbilityHidden takes unit u, integer aid, integer count returns nothing
        call AddAddressAbilityHidden( GetUnitAbility( u, aid ), count )
    endfunction

    function GetUnitAbilityDisabledEx takes unit u, integer aid returns integer
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        return GetAddressAbilityDisabledEx( GetUnitAbility( u, aid ) )
    endfunction

    function SetUnitAbilityDisabledEx takes unit u, integer aid, integer count returns nothing
        // This one is used by Orb of Slow. Button is blacked, but cooldown is stil displayed.
        call SetAddressAbilityDisabledEx( GetUnitAbility( u, aid ), count ) // -1 = unhide | 1 = hide
    endfunction

    function SilenceUnitAbility takes unit u, integer aid returns nothing
        call SilenceAddressAbility( GetUnitAbility( u, aid ) )
    endfunction

    function UnsilenceUnitAbility takes unit u, integer aid returns nothing
        call UnsilenceAddressAbility( GetUnitAbility( u, aid ) )
    endfunction

    function ShowUnitAbility takes unit u, integer aid, boolean flag returns nothing
        call ShowAddressAbility( GetUnitAbility( u, aid ), flag )
    endfunction
    //===========================================

    // Buff API
    function GetUnitBuffLevel takes unit u, integer bid returns integer
        return GetAddressBuffLevel( GetUnitAbility( u, bid ) )
    endfunction
    //===========================================
    
    function Init_MemHackAbilityUnitAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x079400 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x24D900 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x07A8F0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x0787D0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x24CDF0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x079CC0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x46F440 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x454EB0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x471160 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x48CB80 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x4725F0 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x48E8A0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "GetAbility" ), pGameDLL + 0x4C0C90 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "AddAbility" ), pGameDLL + 0x4A6700 )
                call SaveInteger( MemHackTable, StringHash( "CAbilityUnit" ), StringHash( "RemoveAbility" ), pGameDLL + 0x4C29B0 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass
//////////////////单位技能


//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCastAbility requires InMHCore , MemoryHackAbilityAddressAPI , MemoryHackAbilityUnitAPI
    function CastAbilityBasic takes integer pAbil returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ) )

        if addr != 0 and pAbil != 0 then
            return this_call_1( addr, pAbil )
        endif

        return 0
    endfunction
    
    function CastAbilityPosition takes integer aid, unit source, real targX, real targY returns nothing
        // Fits for non-target spells, i.e. Was Stomp and such...
        local integer pData = ConvertHandle( source )

        if pData > 0 then
            set pData = GetUnitAbility( source, aid )

            if pData > 0 then
                call WriteRealMemory( pData + 0xF8, SetRealIntoMemory( targX ) )
                call WriteRealMemory( pData + 0x100, SetRealIntoMemory( targY ) )
                call WriteRealMemory( pData + 0x20, 0x9800 )
                set pData = CastAbilityBasic( pData )
            endif
        endif
    endfunction

    function CastAbilityTarget takes integer aid, unit source, widget target returns nothing
        // Due to memory issues requires std/this calls to use different memory allocation
        // else spells which deals damage immediately on cast will interference with damage-related functions
        // hence why we use separate memory addresses for each unique stdcall and such.
        local integer pData  = 0
        local integer unitHashA = 0
        local integer unitHashB = 0
        local integer flags  = 0

        if GetUnitAbilityLevel( source, aid ) > 0 and target != null then
            set pData = ConvertHandle( target )

            if pData > 0 then
                set unitHashA = ReadRealMemory( pData + 0x0C )
                set unitHashB = ReadRealMemory( pData + 0x10 )

                if unitHashA > 0 and unitHashB > 0 then
                    set pData = ConvertHandle( source )

                    if pData > 0 then
                        set pData = GetUnitAbility( source, aid )

                        if pData > 0 then
                            // Widget is saved via HashGroup, hence we grab our units HashA and HashB and save them to TargetHashGroup
                            call WriteRealMemory( pData + 0xE4, unitHashA )
                            call WriteRealMemory( pData + 0xE8, unitHashB )
                            set flags = ReadRealMemory( pData + 0x20 )

                            if not IsFlagBitSet( flags, 0x10000 ) then
                                // 0x19804 stands for "target", 0x1F020 stands for "target item", 0x9800 stands for point target
                                call WriteRealMemory( pData + 0x20, flags + 0x10000 )
                                set flags = flags + 0x10000
                                if not IsFlagBitSet( flags, 0x1 ) then
                                    call WriteRealMemory( pData + 0x20, flags + 0x1 )
                                endif
                            endif

                            set pData = CastAbilityBasic( pData ) // If value > 0 then cast has been successful.
                        endif
                    endif
                endif
            endif
        endif
    endfunction

    function CastAbilityTargetGround takes integer aid, unit source, integer lvl, real targX, real targY, boolean remove returns nothing
        call UnitAddAbility( source, aid )

        if lvl > 1 then
            call SetUnitAbilityLevel( source, aid, lvl )
        endif

        call CastAbilityPosition( aid, source, targX, targY )
        if remove then
            // Note: channeled abilities stop as soon as ability is removed!
            // This Applies to Chain Lightning and such.
            call UnitRemoveAbility( source, aid )
        endif
    endfunction

    function CastAbilityTargetWidget takes integer aid, unit source, widget target, integer lvl, boolean remove returns nothing
        call UnitAddAbility( source, aid )

        if lvl > 1 then
            call SetUnitAbilityLevel( source, aid, lvl )
        endif

        call CastAbilityTarget( aid, source, target )
        if remove then
            // Note: channeled abilities stop as soon as ability is removed!
            // This Applies to Chain Lightning and such.
            call UnitRemoveAbility( source, aid )
        endif
    endfunction

    function CastAbilityTargetSelf takes integer aid, unit source, integer lvl returns nothing
        call CastAbilityTargetWidget( aid, source, source, lvl, true )
    endfunction
    
    function Init_MemHackCastAbility takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ), pGameDLL + 0x05CFD0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ), pGameDLL + 0x05C3A0 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ), pGameDLL + 0x3ECB70 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ), pGameDLL + 0x40A2B0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CAbility" ), StringHash( "Cast" ), pGameDLL + 0x43E390 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass
/////////////////临时创建技能




////////////////////////////特效函数/////////////////
//TESH.scrollpos=102
//TESH.alwaysfold=0
//! nocjass
library MemoryHackEffectAPI  requires InMHCore , MemoryHackCObjectAPI
    function IsEffectHidden takes effect e returns boolean
        return IsObjectHidden( ConvertHandle( e ) )
    endfunction

    function ShowEffect takes effect e, boolean flag returns nothing
        call ShowObject( ConvertHandle( e ), flag )
    endfunction

    function SetEffectAlpha takes effect e, integer alpha returns nothing
        call SetObjectAlpha( ConvertHandle( e ), alpha )
    endfunction

    function GetEffectColour takes effect e returns integer
        return GetObjectColour( ConvertHandle( e ) )
    endfunction

    function SetEffectColour takes effect e, integer colour returns nothing
        call SetObjectColour( ConvertHandle( e ), colour )
    endfunction

    function SetEffectColourEx takes effect e, integer red, integer green, integer blue, integer alpha returns nothing
        call SetObjectColourEx( ConvertHandle( e ), red, green, blue, alpha )
    endfunction

    function SetEffectVertexColour takes effect e, integer red, integer green, integer blue, integer alpha returns nothing
        local integer pObject = ConvertHandle( e )

        if pObject > 0 then
            call SetObjectColourEx( pObject, red, green, blue, alpha )
            call SetObjectAlpha( pObject, alpha )
        endif
    endfunction

    function GetEffectColourA takes effect e returns integer
        return GetObjectColourA( ConvertHandle( e ) )
    endfunction

    function SetEffectColourA takes effect e, integer alpha returns nothing
        call SetObjectColourA( ConvertHandle( e ), alpha )
    endfunction

    function GetEffectColourR takes effect e returns integer
        return GetObjectColourR( ConvertHandle( e ) )
    endfunction

    function SetEffectColourR takes effect e, integer red returns nothing
        call SetObjectColourR( ConvertHandle( e ), red )
    endfunction

    function GetEffectColourG takes effect e returns integer
        return GetObjectColourG( ConvertHandle( e ) )
    endfunction

    function SetEffectColourG takes effect e, integer green returns nothing
        call SetObjectColourG( ConvertHandle( e ), green )
    endfunction

    function GetEffectColourB takes effect e returns integer
        return GetObjectColourB( ConvertHandle( e ) )
    endfunction

    function SetEffectColourB takes effect e, integer blue returns nothing
        call SetObjectColourB( ConvertHandle( e ), blue )
    endfunction

    function SetEffectModel takes effect e, string model, boolean flag returns nothing
        call SetObjectModel( ConvertHandle( e ), model, flag )
    endfunction

    function GetEffectX takes effect e returns real
        return GetObjectX( ConvertHandle( e ) )
    endfunction

    function SetEffectX takes effect e, real x returns nothing
        call SetObjectX( ConvertHandle( e ), x )
    endfunction

    function GetEffectY takes effect e returns real
        return GetObjectY( ConvertHandle( e ) )
    endfunction

    function SetEffectY takes effect e, real y returns nothing
        call SetObjectY( ConvertHandle( e ), y )
    endfunction

    function GetEffectZ takes effect e returns real
        return GetObjectZ( ConvertHandle( e ) )
    endfunction

    function SetEffectZ takes effect e, real z returns nothing
        call SetObjectZ( ConvertHandle( e ), z )
    endfunction

    function SetEffectPosition takes effect e, real x, real y, real z returns nothing
        call SetObjectPosition( ConvertHandle( e ), x, y, z )
    endfunction

    function GetEffectTimeScale takes effect e returns real
        return GetObjectTimeScale( ConvertHandle( e ) )
    endfunction

    function SetEffectTimeScale takes effect e, real speed returns nothing
        call SetObjectTimeScale( ConvertHandle( e ), speed )
    endfunction

    function GetEffectScale takes effect e returns real
        return GetObjectScale( ConvertHandle( e ) )
    endfunction

    function SetEffectScale takes effect e, real scale returns nothing
        call SetObjectScale( ConvertHandle( e ), scale )
    endfunction

    function SetEffectScaleEx takes effect e, real x, real y, real z returns nothing
        call SetObjectScaleEx( ConvertHandle( e ), x, y, z )
    endfunction

    function GetEffectRoll takes effect e returns real // X | returns Degrees!
        return GetObjectRoll( ConvertHandle( e ) )
    endfunction

    function SetEffectRoll takes effect e, real angle returns nothing
        call SetObjectRoll( ConvertHandle( e ), angle )
    endfunction

    function GetEffectPitch takes effect e returns real // Y | returns Degrees!
        return GetObjectPitch( ConvertHandle( e ) )
    endfunction

    function SetEffectPitch takes effect e, real angle returns nothing // Y | In Degrees!
        call SetObjectPitch( ConvertHandle( e ), angle )
    endfunction

    function GetEffectYaw takes effect e returns real // Z | Yaw | returns Degrees!
        return GetObjectYaw( ConvertHandle( e ) )
    endfunction
    
    function GetEffectFacing takes effect e returns real // Z | Yaw | returns Degrees!
        return GetObjectFacing( ConvertHandle( e ) )
    endfunction

    function SetEffectYaw takes effect e, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectYaw( ConvertHandle( e ), angle )
    endfunction

    function SetEffectFacing takes effect e, real angle returns nothing // Z | Yaw | In Degrees!
        call SetObjectFacing( ConvertHandle( e ), angle )
    endfunction

    function SetEffectSpaceRotation takes effect e, real yaw, real pitch, real roll returns nothing
        call SetObjectSpaceRotation( ConvertHandle( e ), yaw, pitch, roll )
    endfunction

    function SetEffectOrientation takes effect e, real yaw, real pitch, real roll returns nothing
        call SetObjectOrientation( ConvertHandle( e ), yaw, pitch, roll )
    endfunction

    function ResetEffectMatrix takes effect e returns nothing
        call ResetObjectMatrix( ConvertHandle( e ) )
    endfunction

    function SetEffectAnimationByIndex takes effect e, integer index returns nothing
        call SetObjectAnimationByIndex( ConvertHandle( e ), index )
    endfunction

    function SetEffectAnimationByIndexWithRarity takes effect e, integer index, integer rarity returns nothing
        call SetObjectAnimationByIndexWithRarity( ConvertHandle( e ), index, rarity )
    endfunction
    
    function Init_MemHackEffectAPI takes nothing returns nothing
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
//! endnocjass


////////////////////////物品函数////////////////////
//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackItemBaseAPI requires InMHCore , MemoryHackCObjectAPI , MemoryHackCWidgetBaseAPI
    // Item API Engine
    function GetItemBaseDataById takes integer iid returns integer
        return GetAgileDataNodeById( LoadInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ) ), iid )
    endfunction

    function GetItemBaseData takes item it returns integer
        return GetItemBaseDataById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseDataByIdCaching takes integer iid returns integer
        return GetWidgetBaseDataByIdCachingEx( LoadInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ) ), 2, iid, 0 ) // Base Item Data
    endfunction

    function GetItemBaseDataCaching takes item it returns integer
        return GetItemBaseDataByIdCaching( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseUIDataById takes integer iid returns integer
        return GetWidgetBaseUIDataById( iid )
    endfunction

    function GetItemBaseUIData takes item it returns integer
        return GetItemBaseUIDataById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseUIDataByIdCaching takes integer iid returns integer
        return GetWidgetBaseDataByIdCachingEx( 0, 3, iid, 1 ) // Base Item UI Data | pUnitUIDataNode - no longer necessary
    endfunction

    function GetItemBaseUIDataCaching takes item it returns integer
        return GetItemBaseUIDataByIdCaching( GetItemTypeId( it ) )
    endfunction
    //===========================================

    // Item Base UI Data API by Id
    function GetItemBaseUIStringParamById takes integer iid, integer pointerlevel, integer offset returns string
        return GetWidgetBaseUIStringParamById( iid, pointerlevel, offset )
    endfunction
    
    function SetItemBaseUIStringParamById takes integer iid, integer pointerlevel, integer offset, string text returns nothing
        call SetWidgetBaseUIStringParamById( iid, pointerlevel, offset, text )
    endfunction

    function GetItemBaseNameById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x2C )
    endfunction

    function SetItemBaseNameById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x2C, text )
    endfunction

    function GetItemBaseIconPathById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x24C )
    endfunction

    function SetItemBaseIconPathById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x24C, text )
    endfunction
    
    function GetItemBaseTipById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x260 )
    endfunction

    function SetItemBaseTipById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x260, text )
    endfunction

    function GetItemBaseUbertipById takes integer iid returns string
        return GetItemBaseUIStringParamById( iid, 1, 0x26C )
    endfunction

    function SetItemBaseUbertipById takes integer iid, string text returns nothing
        call SetItemBaseUIStringParamById( iid, 1, 0x26C, text )
    endfunction

    function GetItemBaseHotkeyById takes integer iid returns integer
        if iid > 0 then
            if GetWidgetBaseUIIntegerParamById( iid, 0, 0x270 ) > 0 or GetWidgetBaseUIIntegerParamById( iid, 0, 0x274 ) > 0 then
                return GetWidgetBaseUIIntegerParamById( iid, 1, 0x278 )
            endif
        endif
    
        return 0
    endfunction

    function SetItemBaseHotkeyById takes integer iid, integer key returns nothing
        if iid > 0 then
            call SetWidgetBaseUIIntegerParamById( iid, 0, 0x270,   1 )
            call SetWidgetBaseUIIntegerParamById( iid, 0, 0x274, key )
            call SetWidgetBaseUIIntegerParamById( iid, 1, 0x278, key )
        endif
    endfunction
    //===========================================
    
    // Item Base UI Data API
    function GetItemBaseUIStringParam takes item it, integer pointerlevel, integer offset returns string
        return GetItemBaseUIStringParamById( GetItemTypeId( it ), pointerlevel, offset )
    endfunction
    
    function SetItemBaseUIStringParam takes item it, integer pointerlevel, integer offset, string text returns nothing
        call SetItemBaseUIStringParamById( GetItemTypeId( it ), pointerlevel, offset, text )
    endfunction

    function GetItemBaseName takes item it returns string
        return GetItemBaseNameById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseName takes item it, string text returns nothing
        call SetItemBaseNameById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseIconPath takes item it returns string
        return GetItemBaseIconPathById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseIconPath takes item it, string text returns nothing
        call SetItemBaseIconPathById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseTip takes item it returns string
        return GetItemBaseTipById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseTip takes item it, string text returns nothing
        call SetItemBaseTipById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseUbertip takes item it returns string
        return GetItemBaseUbertipById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseUbertip takes item it, string text returns nothing
        call SetItemBaseUbertipById( GetItemTypeId( it ), text )
    endfunction

    function GetItemBaseHotkey takes item it returns integer
        return GetItemBaseHotkeyById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseHotkey takes item it, integer key returns nothing
        call SetItemBaseHotkeyById( GetItemTypeId( it ), key )
    endfunction
    //===========================================
    
    // Item Base Data API by Id
    function GetItemBaseTypeIdById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x14 )
        endif

        return 0
    endfunction

    function GetItemBaseGoldCostById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return 0
    endfunction

    function SetItemBaseGoldCostById takes integer iid, integer cost returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x20, cost )
        endif
    endfunction

    function GetItemBaseLumberCostById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x24 )
        endif

        return 0
    endfunction

    function SetItemBaseLumberCostById takes integer iid, integer cost returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x24, cost )
        endif
    endfunction

    function GetItemBaseLevelById takes integer iid returns integer
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x38 )
        endif

        return 0
    endfunction

    function SetItemBaseLevelById takes integer iid, integer level returns nothing
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            call WriteRealMemory( pData + 0x38, level )
        endif
    endfunction

    function IsItemBaseSellableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x50 ) > 1
        endif

        return false
    endfunction

    function IsItemBasePawnableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x54 ) > 1
        endif

        return false
    endfunction

    function IsItemBaseDroppableById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x60 ) > 1
        endif

        return false
    endfunction

    function IsItemBaseDroppedOnDeathById takes integer iid returns boolean
        local integer pData = GetItemBaseDataById( iid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x64 ) > 1
        endif

        return false
    endfunction
    //===========================================

    // Item Base UI Data API
    function GetItemBaseTypeId takes item it returns integer
        return GetItemBaseTypeIdById( GetItemTypeId( it ) )
    endfunction

    function GetItemBaseGoldCost takes item it returns integer
        return GetItemBaseGoldCostById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseGoldCost takes item it, integer cost returns nothing
        call SetItemBaseGoldCostById( GetItemTypeId( it ), cost )
    endfunction

    function GetItemBaseLumberCost takes item it returns integer
        return GetItemBaseLumberCostById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseLumberCost takes item it, integer cost returns nothing
        call SetItemBaseLumberCostById( GetItemTypeId( it ), cost )
    endfunction

    function GetItemBaseLevel takes item it returns integer
        return GetItemBaseLevelById( GetItemTypeId( it ) )
    endfunction

    function SetItemBaseLevel takes item it, integer lvl returns nothing
        call SetItemBaseLevelById( GetItemTypeId( it ), lvl )
    endfunction

    function IsItemBaseSellable takes item it returns boolean
        return IsItemBaseSellableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBasePawnable takes item it returns boolean
        return IsItemBasePawnableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBaseDroppable takes item it returns boolean
        return IsItemBaseDroppableById( GetItemTypeId( it ) )
    endfunction

    function IsItemBaseDroppedOnDeath takes item it returns boolean
        return IsItemBaseDroppedOnDeathById( GetItemTypeId( it ) )
    endfunction
    //===========================================

    function Init_MemHackItemBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ), pGameDLL + 0xACBA24 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ), pGameDLL + 0xAB4BCC )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ), pGameDLL + 0xBEC238 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ), pGameDLL + 0xD707A0 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CItemBase" ), StringHash( "DataNode" ), pGameDLL + 0xD385D8 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass


//TESH.scrollpos=60
//TESH.alwaysfold=0
//! nocjass
library MemoryHackItemNormalAPI requires InMHCore , MemoryHackCObjectAPI
    function CItemGetAbilityByIndex takes integer pItem, integer index returns ability
        local integer pData = pItem
        local integer pAbil = 0
        local integer i = 0

        if pData != 0 then
            set pAbil = GetCAgentFromHashGroup( pData + 0x9C + 0x8 * index )

            if pAbil != 0 then
                return ObjectToAbility( pAbil )
            endif
        endif

        return null
    endfunction

    function CItemStartCooldown takes integer pUnit, integer pItem, real cd returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ) )
        local integer mem  = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )
        local integer pInv = 0

        if addr != 0 and mem != 0 and pUnit != 0 and pItem != 0 then
            set pInv = ReadRealMemory( pUnit + 0x1F8 )

            if pInv != 0 then
                call WriteRealFloat( mem, cd )
                call this_call_4( addr, pInv, pItem, mem, mem )
            endif
        endif
    endfunction

    function CItemSetTypeId takes integer pItem, integer id returns nothing
        local integer oldId   = 0

        if pItem > 0 then
            set oldId = ReadRealMemory( pItem + 0x30 )

            if oldId > 0 then
                call WriteRealMemory( pItem + 0x30, id )
            endif
        endif
    endfunction
    
    function CItemSetModel takes integer pItem, string model, boolean flag returns nothing
        call SetObjectModel( pItem, model, flag )
    endfunction
    
    function CItemGetLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x58 ) )
        endif
        
        return 0.
    endfunction

    function CItemSetLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x58, SetRealIntoMemory( life ) )
        endif
    endfunction

    function CItemGetMaxLife takes integer pItem returns real
        if pItem > 0 then
            return GetRealFromMemory( ReadRealMemory( pItem + 0x60 ) )
        endif
        
        return 0.
    endfunction

    function CItemSetMaxLife takes integer pItem, real life returns nothing
        if pItem > 0 then
            call WriteRealMemory( pItem + 0x60, SetRealIntoMemory( life ) )
        endif
    endfunction
    //
    
    // jitem API
    function GetItemAbilityByIndex takes item it, integer index returns ability
        return CItemGetAbilityByIndex( ConvertHandle( it ), index )
    endfunction
    
    function StartItemCooldown takes unit u, item it, real cd returns nothing
        call CItemStartCooldown( ConvertHandle( u ), ConvertHandle( it ), cd )
    endfunction

    function SetItemIdType takes item it, integer id returns nothing
        call CItemSetTypeId( ConvertHandle( it ), id )
    endfunction
    
    function SetItemModel takes item it, string model, boolean flag returns nothing
        call CItemSetModel( ConvertHandle( it ), model, flag )
    endfunction
    
    function GetItemLife takes item it returns real
        return CItemGetLife( ConvertHandle( it ) )
    endfunction

    function SetItemLife takes item it, real life returns nothing
        call CItemSetLife( ConvertHandle( it ), life )
    endfunction

    function GetItemMaxLife takes item it returns real
        return CItemGetMaxLife( ConvertHandle( it ) )
    endfunction

    function SetItemMaxLife takes item it, real life returns nothing
        call CItemSetMaxLife( ConvertHandle( it ), life )
    endfunction

    function Init_MemHackItemNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ), pGameDLL + 0x0E4B50 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ), pGameDLL + 0x0E3F30 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ), pGameDLL + 0x54C2E0 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ), pGameDLL + 0x569A40 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CItem" ), StringHash( "StatCooldown" ), pGameDLL + 0x59DB70 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass






//////////////////////单位函数//////////////////////
//TESH.scrollpos=396
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUnitBaseAPI requires InMHCore , MemoryHackCObjectAPI
    // Unit API Engine
    function GetUnitBaseDataById takes integer uid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ) )

        if addr != 0 and uid != 0 then
            return GetAgileDataNodeById( addr, uid )
        endif

        return 0
    endfunction

    function GetUnitBaseData takes unit u returns integer
        return GetUnitBaseDataById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseDataByIdCaching takes integer uid returns integer
        // DEF_ADR_UNIT_DATA = 2
        local integer pUnit = 0

        if uid > 0 then
            if HaveSavedInteger( htObjectDataPointers, 2, uid ) then 
                return LoadInteger( htObjectDataPointers, 2, uid )
            endif

            set pUnit = GetUnitBaseDataById( uid )

            if pUnit > 0 then
                call SaveInteger( htObjectDataPointers, 2, uid, pUnit )
            endif

            return pUnit
        endif

        return 0
    endfunction

    function GetUnitBaseDataCaching takes unit u returns integer
        return GetUnitBaseDataByIdCaching( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseUIDataById takes integer uid returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ) )

        if addr != 0 and uid != 0 then
           return this_call_1( addr, uid )
        endif

        return 0
    endfunction

    function GetUnitBaseUIData takes unit u returns integer
        return GetUnitBaseUIDataById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseUIDataByIdCaching takes integer uid returns integer
        // DEF_ADR_UNIT_UI = 3
        local integer pUnit = 0

        if uid > 0 then
            if HaveSavedInteger( htObjectDataPointers, 3, uid ) then 
                return LoadInteger( htObjectDataPointers, 3, uid )
            endif

            set pUnit = GetUnitBaseUIDataById( uid )
            if pUnit > 0 then
                call SaveInteger( htObjectDataPointers, 3, uid, pUnit )
            endif

            return pUnit
        endif

        return 0
    endfunction

    function GetUnitBaseUIDataCaching takes unit u returns integer
        return GetUnitBaseUIDataByIdCaching( GetUnitTypeId( u ) )
    endfunction
    //===========================================

    // Unit Base UI Data Engine
    function GetUnitBaseUIIntegerParam takes integer uid, integer pointerlevel, integer offset returns integer
        return GetWidgetBaseUIIntegerParamById( uid, pointerlevel, offset )
    endfunction

    function SetUnitBaseUIIntegerParam takes integer uid, integer pointerlevel, integer offset, integer val returns nothing
        call SetWidgetBaseUIIntegerParamById( uid, pointerlevel, offset, val )
    endfunction

    function GetUnitBaseUIStringParam takes integer uid, integer pointerlevel, integer offset returns string
        return GetWidgetBaseUIStringParamById( uid, pointerlevel, offset )
    endfunction

    function SetUnitBaseUIStringParam takes integer uid, integer pointerlevel, integer offset, string val returns nothing
        call SetWidgetBaseUIStringParamById( uid, pointerlevel, offset, val )
    endfunction
    //===========================================
    
    // Unit Base UI Data API by Id
    function GetUnitBasePortraitById takes integer uid returns string
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x38 )

                if pData > 0 then
                    return ToJString( pData )
                endif
            endif
        endif

        return null
    endfunction

    function SetUnitBasePortraitById takes integer uid, string model returns nothing
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                call WriteNullTerminatedString( model, pData + 0x38 )
            endif
        endif
    endfunction

    function GetUnitBaseMissileArtById takes integer uid, integer index returns string
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
        
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x44 )

                    if pData > 0 then
                        return ToJString( ReadRealMemory( pData + index * 4 ) )
                    endif
                endif
            endif
        endif

        return null
    endfunction

    function SetUnitBaseMissileArtById takes integer uid, string model, integer index returns nothing
        local integer pData = 0
    
        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )

                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x44 )
        
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, GetStringAddress( model ) )
                    endif
                endif
            endif
        endif
    endfunction

    function GetUnitBaseMissileSpeedById takes integer uid, integer index returns real
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x64 )
    
                    if pData > 0 then
                        return ReadRealFloat( pData + index * 4 )
                    endif
                endif
            endif
        endif

        return -1.
    endfunction

    function SetUnitBaseMissileSpeedById takes integer uid, integer index, real speed returns nothing
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x64 )
    
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, SetRealIntoMemory( speed ) )
                    endif
                endif
            endif
        endif
    endfunction

    function GetUnitBaseMissileArcById takes integer uid, integer index returns real
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x70 )
    
                    if pData > 0 then
                        return ReadRealFloat( pData + index * 4 )
                    endif
                endif
            endif
        endif

        return -1.
    endfunction

    function SetUnitBaseMissileArcById takes integer uid, integer index, real arc returns nothing
        local integer pData = 0

        if uid > 0 then
            if index == 0 or index == 1 then
                set pData = GetUnitBaseUIDataByIdCaching( uid )
    
                if pData > 0 then
                    set pData = ReadRealMemory( pData + 0x70 )
    
                    if pData > 0 then
                        call WriteRealMemory( pData + index * 4, SetRealIntoMemory( arc ) )
                    endif
                endif
            endif
        endif
    endfunction
    
    function GetUnitBaseColorById takes integer uid returns integer
        local integer pData = 0
    
        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )
    
            if pData > 0 then
                return ReadRealMemory( pData + 0xAC )
            endif
        endif
    
        return 0
    endfunction

    function GetUnitBaseModelById takes integer uid returns string
        local integer pData = 0

        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x34 )
    
                if pData > 0 then
                    return ToJString( pData )
                endif
            endif
        endif

        return null
    endfunction

    function SetUnitBaseModelById takes integer uid, string model returns nothing
        local integer pData = 0
    
        if uid > 0 then
            set pData = GetUnitBaseUIDataByIdCaching( uid )
    
            if pData > 0 then
                call WriteNullTerminatedString( model, pData + 0x34 )
            endif
        endif
    endfunction
    
    function GetUnitBaseIconPathById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x24C )
    endfunction

    function SetUnitBaseIconPathById takes integer uid, string iconpath returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x24C, iconpath )
    endfunction
    
    function GetUnitBaseTipById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x260 )
    endfunction

    function SetUnitBaseTipById takes integer uid, string text returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x260, text )
    endfunction

    function GetUnitBaseUbertipById takes integer uid returns string
        return GetUnitBaseUIStringParam( uid, 1, 0x26C )
    endfunction

    function SetUnitBaseUbertipById takes integer uid, string text returns nothing
        call SetUnitBaseUIStringParam( uid, 1, 0x26C, text )
    endfunction

    function GetUnitBaseHotkeyById takes integer uid returns integer
        if uid > 0 then
            if GetUnitBaseUIIntegerParam( uid, 0, 0x270 ) > 0 or GetUnitBaseUIIntegerParam( uid, 0, 0x274 ) > 0 then
                return GetUnitBaseUIIntegerParam( uid, 1, 0x278 )
            endif
        endif
    
        return 0
    endfunction

    function SetUnitBaseHotkeyById takes integer uid, integer key returns nothing
        if uid > 0 then
            call SetUnitBaseUIIntegerParam( uid, 0, 0x270,   1 )
            call SetUnitBaseUIIntegerParam( uid, 0, 0x274, key )
            call SetUnitBaseUIIntegerParam( uid, 1, 0x278, key )
        endif
    endfunction
    //===========================================

    // Unit Base UI Data API by Unit
    function GetUnitBaseModel takes unit u returns string
        return GetUnitBaseModelById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseModel takes unit u, string model returns nothing
        call SetUnitBaseModelById( GetUnitTypeId( u ), model )
    endfunction

    function GetUnitBasePortrait takes unit u returns string
        return GetUnitBasePortraitById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBasePortrait takes unit u, string model returns nothing
        call SetUnitBasePortraitById( GetUnitTypeId( u ), model )
    endfunction

    function GetUnitBaseMissileArt takes unit u, integer index returns string
        return GetUnitBaseMissileArtById( GetUnitTypeId( u ), index )
    endfunction

    function SetUnitBaseMissileArt takes unit u, string model, integer index returns nothing
        call SetUnitBaseMissileArtById( GetUnitTypeId( u ), model, index )
    endfunction

    function GetUnitBaseMissileSpeed takes unit u, integer index returns real
        return GetUnitBaseMissileSpeedById( GetUnitTypeId( u ), index )
    endfunction

    function SetUnitBaseMissileSpeed takes unit u, integer index, real speed returns nothing
        call SetUnitBaseMissileSpeedById( GetUnitTypeId( u ), index, speed )
    endfunction

    function GetUnitBaseColor takes unit u returns integer
        return GetUnitBaseColorById( GetUnitTypeId( u ) )
    endfunction

    function GetUnitBaseIconPath takes unit u returns string
        return GetUnitBaseIconPathById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitBaseIconPath takes unit u, string iconpath returns nothing
        call SetUnitBaseIconPathById( GetUnitTypeId( u ), iconpath )
    endfunction
    
    function GetUnitBaseTip takes unit u returns string
        return GetUnitBaseTipById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseTip takes unit u, string text returns nothing
        call SetUnitBaseTipById( GetUnitTypeId( u ), text )
    endfunction

    function GetUnitBaseUbertip takes unit u returns string
        return GetUnitBaseUbertipById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseUbertip takes unit u, string text returns nothing
        call SetUnitBaseUbertipById( GetUnitTypeId( u ), text )
    endfunction

    function GetUnitBaseHotkey takes unit u returns integer
        return GetUnitBaseHotkeyById( GetUnitTypeId( u ) )
    endfunction

    function SetUnitBaseHotkey takes unit u, integer key returns nothing
        call SetUnitBaseHotkeyById( GetUnitTypeId( u ), key )
    endfunction
    //===========================================

    // Unit Base Data API by Id
    function GetUnitGoldCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return -1
    endfunction
    
    function SetUnitGoldCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x20, value )
        endif
    endfunction

    function GetUnitLumberCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x24 )
        endif

        return -1
    endfunction
    
    function SetUnitLumberCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x24, value )
        endif
    endfunction
    
    function GetUnitFoodCostById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x5C )
        endif

        return -1
    endfunction
    
    function SetUnitFoodCostById takes integer uid, integer value returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 and value >= 0 then
            call WriteRealMemory( pData + 0x5C, value )
        endif
    endfunction
    
    function GetHeroBasePrimaryAttributeById takes integer uid returns integer
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return ReadRealMemory( pData + 0x17C )
        endif

        return -1
    endfunction

    function SetHeroBasePrimaryAttributeById takes integer uid, integer index returns nothing
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            if index >= 0 and index <= 2 then
                call WriteRealMemory( pData + 0x17C, index )
            endif
        endif
    endfunction

    function GetUnitCollisionSizeById takes integer uid returns real
        local integer pData = GetUnitBaseDataById( uid )

        if pData > 0 then
            return GetRealFromMemory( ReadRealMemory( pData + 0x19C ) )
        endif

        return -1.234 // to ensure we failed
    endfunction
    //===========================================

    // Unit Base Data API by unit
    function GetUnitGoldCostEx takes unit u returns integer
        return GetUnitGoldCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitGoldCostEx takes unit u, integer value returns nothing
        call SetUnitGoldCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetUnitLumberCost takes unit u returns integer
        return GetUnitLumberCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitLumberCost takes unit u, integer value returns nothing
        call SetUnitLumberCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetUnitFoodCost takes unit u returns integer
        return GetUnitFoodCostById( GetUnitTypeId( u ) )
    endfunction
    
    function SetUnitFoodCost takes unit u, integer value returns nothing
        call SetUnitFoodCostById( GetUnitTypeId( u ), value )
    endfunction
    
    function GetHeroBasePrimaryAttribute takes unit u returns integer
        return GetHeroBasePrimaryAttributeById( GetUnitTypeId( u ) )
    endfunction

    function SetHeroBasePrimaryAttribute takes unit u, integer index returns nothing
        call SetHeroBasePrimaryAttributeById( GetUnitTypeId( u ), index )
    endfunction
    
    function GetUnitCollisionSize takes unit u returns real
        return GetUnitCollisionSizeById( GetUnitTypeId( u ) )
    endfunction
    //===========================================

    function Init_MemHackUnitBaseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xACB2B4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xACC72C )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x32D3C0 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xAB445C )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xAB58D4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x32C880 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xBEC470 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xBE6114 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x327020 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xD709D8 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xBE6114 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x344760 )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "DataNode" ),      pGameDLL + 0xD38810 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "UINode" ),        pGameDLL + 0xD324B4 )
                call SaveInteger( MemHackTable, StringHash( "CUnitBase" ), StringHash( "GetUnitUIData" ), pGameDLL + 0x378720 )
            endif
        endif
    endfunction
    //===========================================
endlibrary
//! endnocjass


//TESH.scrollpos=461
//TESH.alwaysfold=0
//! nocjass
library MemoryHackUnitNormalAPI requires InMHCore , MemoryHackCObjectAPI
    function CUnitApplyUpgrades takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUnapplyUpgrades takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUpdateInfoBar takes integer pUnit returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_1( addr, pUnit )
        endif
    endfunction

    function CUnitUpdateHeroBar takes integer pUnit, integer unk1 returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, unk1 )
        endif
    endfunction
    
    function CUnitRefreshPortraitOnSelect takes integer pUnit, integer unk1 returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ) )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, unk1 )
        endif
    endfunction
    
    function CUnitRefreshInfoBarOnSelect takes integer pUnit returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ) )

        if addr != 0 and pUnit != 0 then
            return this_call_1( addr, pUnit )
        endif

        return 0
    endfunction

    function CUnitAddAbilityEx takes integer pUnit, integer aid, boolean checkduplicate returns nothing
        local boolean flag = false

        if pUnit != 0 and aid != 0 then
            if not ( checkduplicate and GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 ) != 0 ) then
                call CUnitUnapplyUpgrades( pUnit )
                set flag = CUnitAddAbility( pUnit, aid )
                call CUnitApplyUpgrades( pUnit )
                
                if flag then
                    call CUnitUpdateInfoBar( pUnit )
                endif
            endif
        endif
    endfunction

    function CUnitRemoveAbilityEx takes integer pUnit, integer aid, boolean removeduplicates returns nothing
        local integer pAbil = 0
        local boolean flag = false

        if pUnit != 0 and aid != 0 then
            loop
                set pAbil = GetUnitAbilityReal( pUnit, aid, 0, 1, 1, 1 )

                if pAbil != 0 then
                    set flag = CUnitRemoveAbility( pUnit, pAbil )

                    if not removeduplicates then
                        set pAbil = 0
                    endif
                endif

                exitwhen pAbil == 0
            endloop

            if flag then
                call CUnitUpdateInfoBar( pUnit )
            endif
        endif
    endfunction

    function CUnitMorphToTypeIdEx takes integer pUnit, integer id, integer unk1, integer unk2, integer unk3, integer unk4, integer unk5, integer unk6, integer unk7, integer unk8, integer unk9 returns boolean
        // This function imitates spells like Metamorphosis etc, but without additional leaks.
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ) )

        if addr != 0 and pUnit != 0 then
            if ReadRealMemory( pUnit + 0x30 ) != id then
                return this_call_11( addr, pUnit, id, unk1, unk2, unk3, unk4, unk5, unk6, unk7, unk8, unk9 ) != 0
            endif
        endif

        return false
    endfunction
    
    function CUnitMorphToTypeId takes integer pUnit, integer id returns boolean
        return CUnitMorphToTypeIdEx( pUnit, id, 1282, 0, 0, 2, 2, 1, 0, 0, 0 )
    endfunction
    //===========================================
    
    // jUnit API
    function GetUnitTypeIdReal takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x30 )
        endif

        return 0
    endfunction

    function SetUnitTypeId takes unit u, integer i returns nothing
        // Note: This is simply change for portrait and some cosmetic stuff!
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0x30, i )
        endif
    endfunction

    function MorphUnitToTypeId takes unit u, integer id returns boolean
        return CUnitMorphToTypeId( ConvertHandle( u ), id )
    endfunction
    
    function UpdateHeroBar takes unit u returns nothing
        call CUnitUpdateHeroBar( ConvertHandle( u ), 0 )
    endfunction
    
    function RefreshUnitPortraitOnSelect takes unit u returns nothing
        call CUnitRefreshPortraitOnSelect( ConvertHandle( u ), 1 )
    endfunction

    function RefreshUnitInfoBarOnSelect takes unit u returns nothing
        call CUnitRefreshInfoBarOnSelect( ConvertHandle( u ) )
    endfunction
    
    function MorphUnitToTypeIdEx takes unit u, integer id returns integer
        // This function imitates spells like Metamorphosis etc, but without additional leaks.
        local integer pUnit = ConvertHandle( u )

        if pUnit > 0 then
            if ReadRealMemory( pUnit + 0x30 ) != id then
                call CUnitMorphToTypeId( pUnit, id )
                call CUnitUpdateHeroBar( pUnit, 0 )
                call CUnitRefreshPortraitOnSelect( pUnit, 1 )
                return CUnitRefreshInfoBarOnSelect( pUnit )
            endif
        endif

        return 0
    endfunction

    function GetHeroNeededXPForLevel takes unit u, integer level returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            if IsUnitType( u, UNIT_TYPE_HERO ) then
                return this_call_2( addr, pUnit, level )
            endif
        endif

        return 0
    endfunction

    function ApplyUnitUpgrades takes unit u returns nothing
        call CUnitApplyUpgrades( ConvertHandle( u ) )
    endfunction
    
    function UnapplyUnitUpgrades takes unit u returns nothing
        call CUnitUnapplyUpgrades( ConvertHandle( u ) )
    endfunction
    
    function UpdateUnitInfoBar takes unit u returns nothing
        call CUnitUpdateInfoBar( ConvertHandle( u ) )
    endfunction
    
    function AddUnitAbilityEx takes unit u, integer aid, boolean checkduplicate returns nothing
        call CUnitAddAbilityEx( ConvertHandle( u ), aid, checkduplicate )
    endfunction
    
    function RemoveUnitAbilityEx takes unit u, integer aid, boolean removeduplicates returns nothing
        call CUnitRemoveAbilityEx( ConvertHandle( u ), aid, removeduplicates )
    endfunction

    function GetHeroNeededXP takes unit u returns integer
        return GetHeroNeededXPForLevel( u, GetUnitLevel( u ) )
    endfunction

    function GetUnitVertexColour takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0x2D4 )
        endif

        return 0
    endfunction

    function GetUnitVertexColourA takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 1 )
    endfunction

    function GetUnitVertexColourR takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 2 )
    endfunction

    function GetUnitVertexColourG takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 3 )
    endfunction

    function GetUnitVertexColourB takes unit u returns integer
        return GetByteFromInteger( GetUnitVertexColour( u ), 4 )
    endfunction

    function SetUnitModel takes unit u, string model, boolean flag returns nothing
        call SetObjectModel( ConvertHandle( u ), model, flag )
    endfunction

    function SetUnitTexture takes unit u, string texturepath, integer textureId returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ) )
        local integer pUnit = ConvertHandle( u )
        local integer pTexture = 0

        if addr != 0 and pUnit != 0 then
            if texturepath != "" then
                set pTexture = LoadCBackDropFrameTexture( texturepath, false )

                if pTexture > 0 and textureId > 0 then
                    return fast_call_3( addr, ReadRealMemory( pUnit + 0x28 ), pTexture, textureId )
                endif
            endif
        endif

        return 0
    endfunction
    
    function GetUnitImpactZ takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0x228 )
        endif

        return 0.
    endfunction

    function SetUnitImpactZ takes unit u, real impactZ returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealFloat( pData + 0x228, impactZ )
        endif
    endfunction

    function RedrawUnit takes unit u returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ) )
        local integer pData = ConvertHandle( u )

        if addr != 0 and pData != 0 then
            call this_call_1( addr, pData )
        endif
    endfunction

    function IsAttackDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                return ReadRealMemory( pData + 0x40 ) > 0
            endif
        endif

        return false
    endfunction

    function UnitDisableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 0 )
            endif
        endif
    endfunction
    
    function UnitEnableAttack takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E8 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x40, 1 )
            endif
        endif
    endfunction

    function GetUnitCritterFlag takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            // 0 - normal | 1 - critter
            return ReadRealMemory( pData + 0x60 )
        endif

        return -1
    endfunction

    function SetUnitCritterFlag takes unit u, integer id returns nothing
        // Acts similar to 'Amec', meaning if unit has flag equal to 1
        // then he is considered a creep and will be ignored by autoattacks.
        // However, an attack may still be forced with 'A' key or rightclick
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if id >= 0 and id <= 1 then
                call WriteRealMemory( pData + 0x60, id )
            endif
        endif
    endfunction
    
    function GetUnitTimedLife takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    return ReadRealFloat( pData + 0x4 )
                endif
            endif
        endif

        return 0.
    endfunction

    function SetUnitTimedLife takes unit u, real dur returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetUnitAbility( u, 'BTLF' )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x90 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x4, dur )
                endif
            endif
        endif
    endfunction

    function SetUnitPhased takes unit u returns nothing
        // Must be used with a slight delay AFTER cast, the minimum is one frame after successful cast!
        local integer data  = GetUnitBaseDataById( GetUnitTypeId( u ) ) + 0x1AC
        local integer p1    = ReadRealMemory( data )
        local integer p2    = ReadRealMemory( data + 0x4 )

        call WriteRealMemory( data, 0x8 )
        call WriteRealMemory( data + 0x4, 0x10 )
        call SetUnitPathing( u, true )
        call WriteRealMemory( data, p1 )
        call WriteRealMemory( data + 0x4, p2 )
    endfunction

    function UnitApplySilence takes unit u, boolean flag returns nothing
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            call this_call_2( addr, pUnit, B2I( flag ) )
        endif
    endfunction

    function UnitDisableAbilities takes unit u, boolean flag returns nothing
        // Visually equal to pause: all skills are hidden and silenced
        local integer addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ) )
        local integer pUnit = ConvertHandle( u )

        if addr != 0 and pUnit != 0 then
            call this_call_5( addr, pUnit, 1, B2I( flag ), 0, 0 )
        endif
    endfunction
    
    function UnitSetStunFlag takes unit u, boolean add returns nothing
        local integer addr  = 0
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            if add then
                set addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ) )

                if addr != 0 then
                    call this_call_2( addr, ConvertHandle( u ), ConvertHandle( u ) )
                endif
            else
                set addr = LoadInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ) )

                if addr != 0 then
                    call this_call_1( addr, ConvertHandle( u ) )
                endif
            endif
        endif
    endfunction

    function IsUnitStunned takes unit u returns boolean
        local integer pHandle = ConvertHandle( u )
        
        if pHandle > 0 then
            return ReadRealMemory( pHandle + 0x198 ) > 0
        endif

        return false
    endfunction

    function UnitApplyStun takes unit u returns nothing //unsafe, do not use unless you tested it through
        local integer pHandle = ConvertHandle( u )

        if pHandle > 0 then
            call WriteRealMemory( pHandle + 0x198, 0 )
        endif
    endfunction

    function IsUnitMovementDisabled takes unit u returns boolean
        local integer pdata = GetHandleId( u )

        if pdata > 0 then
            set pdata = ConvertHandle( u )

            if pdata > 0 then
                set pdata = ReadRealMemory( pdata + 0x1EC )

                if pdata > 0 then
                    return ReadRealMemory( pdata + 0x7C ) > 0
                endif
            endif
        endif

        return false
    endfunction

    function SetUnitControl takes unit u, integer flagval, integer moveval, integer atackval, integer invval returns nothing
        local boolean isFlag = false
        local integer pUnit = ConvertHandle( u )
        local integer flags = 0
        local integer Amov  = 0
        local integer Aatk  = 0
        local integer AInv  = 0

        if pUnit > 0 then
            set flags  = ReadRealMemory( pUnit + 0x248 )
            set Aatk   = ReadRealMemory( pUnit + 0x1E8 )
            set Amov   = ReadRealMemory( pUnit + 0x1EC )
            set AInv   = ReadRealMemory( pUnit + 0x1F8 )
            set isFlag = not IsFlagBitSet( flags, absI( flagval ) ) // 512
            
            if flagval < 0 then
                set isFlag = not isFlag
            endif

            if isFlag then
                call WriteRealMemory( pUnit + 0x248, flags + flagval )
            endif
            
            if Amov > 0 then
                call WriteRealMemory( Amov + 0x40, ReadRealMemory( Amov + 0x40 ) + moveval )
            endif

            if Aatk > 0 then
                call WriteRealMemory( Aatk + 0x40, ReadRealMemory( Aatk + 0x40 ) + atackval )
            endif

            if AInv > 0 then
                call WriteRealMemory( AInv + 0x3C, ReadRealMemory( AInv + 0x3C ) + invval )
            endif
        endif
    endfunction

    function UnitDisableControl takes unit u returns nothing
        //Hides all command buttons and sets the Ward flag. Unit will keep its current order, and player can’t give new orders
        //Notice the the unit can’t be ordered with triggers as well. To issue an order you need to temporarily reenable control
        call SetUnitControl( u, 512, 1, 1, 1 )
    endfunction

    function UnitEnableControl takes unit u returns nothing
        //Removes the Ward flag and reenables Amov and Aatk
        call SetUnitControl( u, -512, -1, -1, -1 )
    endfunction

    function UnitRemoveMovementDisables takes unit u returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( ReadRealMemory( pData + 0x1EC ) + 0x7C, 0 )
            endif
        endif
    endfunction

    function SetUnitMovement takes integer pData, boolean flag returns nothing
        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC )

            if pData > 0 then
                call WriteRealMemory( pData + 0x7C, B2I( not flag ) ) //  ReadRealMemory( pdata ) + d
            endif
        endif
    endfunction

    function UnitEnableMovement takes unit u returns nothing
        if u == null then
            return
        endif

        call SetUnitMovement( ConvertHandle( u ), false )
    endfunction

    function UnitDisableMovement takes unit u returns nothing
        if u == null then
            return
        endif

        call SetUnitMovement( ConvertHandle( u ), true )
    endfunction

    function UnitDisableMovementEx takes unit u, boolean disable returns nothing
        local integer i = 2
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if not disable then
                set i = 1
            endif

            call PauseUnit( u, true )
            set pData = ReadRealMemory( pData + 0x1EC )
            
            if pData > 0 then
                call SetAddressAbilityDisabled( pData, i ) //pointer to 'Amov' is located at offset 123 of unit object, Aatk is at offset 122, and AInv is offset 124
            endif

            call PauseUnit( u, false )
        endif
    endfunction

    function IsUnitInventoryDisabled takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                return I2B( ReadRealMemory( pData + 0x3C ) )
            endif
        endif
    
        return false
    endfunction
    
    function UnitEnableInventory takes unit u, boolean flag returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F8 )

            if pData > 0 then
                set pData = pData + 0x3C
                call WriteRealMemory( pData, B2I( not flag ) )
            endif
        endif
    endfunction

    function GetAddressLocustFlags takes integer pHash1, integer pHash2 returns integer
        local integer pObj = GetCObjectFromHash( pHash1, pHash2 )

        if pObj > 0 then
            return ReadRealMemory( pObj + 0x94 )
        endif

        return 0
    endfunction

    function SetLocustFlags takes unit u, integer i returns nothing //These flags can make unit immune to truesight
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = pData + 0x16C
            set pData = GetAddressLocustFlags( ReadRealMemory( pData ), ReadRealMemory( pData + 4 ) )

            if pData > 0 then
                call WriteRealMemory( pData + 0x34, i )
            endif
        endif
    endfunction

    function UnitEnableTruesightImmunity takes unit u returns nothing
        call SetLocustFlags( u, 0x08000000 ) //I don’t really know what other side effects may be caused by this, at least GroupEnum is not affected
    endfunction

    function UnitDisableTruesightImmunity takes unit u returns nothing
        call SetLocustFlags( u, 0 )
    endfunction

    function GetUnitFlags takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x20 )
        endif

        return 0
    endfunction

    function SetUnitFlags takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x20, i )
        endif
    endfunction

    function AddUnitFlags takes unit u, integer i returns nothing
        call SetUnitFlags( u, GetUnitFlags( u ) + i )
    endfunction
    
    function GetUnitFlags_2 takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x5C )
        endif

        return 0
    endfunction

    function SetUnitFlags_2 takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x5C, i )
        endif
    endfunction

    function AddUnitFlags_2 takes unit u, integer i returns nothing
        call SetUnitFlags_2( u, GetUnitFlags_2( u ) + i )
    endfunction

    function GetUnitVisibilityClass takes unit u returns integer
        local integer a = ConvertHandle( u )
        local integer res = 0

        if a > 0 then
            set res = ReadRealMemory( a + 0x130 )

            if res > 0 then
                set res = GetCAgentFromHash( res, ReadRealMemory( a + 0x134 ) )
            endif
        endif

        return res
    endfunction

    function SetUnitVisibleByPlayer takes unit u, player p, integer c returns nothing
        local integer a = GetUnitVisibilityClass( u )

        if a > 0 then
            call WriteRealMemory( a + 0x2C + 4 * GetPlayerId( p ), c )
            if c > 0 and not IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
                call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) + Player2Flag( p ) )
            elseif c==0 and IsFlagBitSet( ReadRealMemory( a + 0x24 ), Player2Flag( p ) ) then
                call WriteRealMemory( a + 0x24, ReadRealMemory( a + 0x24 ) - Player2Flag( p ) )
            endif
        endif
    endfunction

    function IsUnitInvulnerable takes unit u returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return IsFlagBitSet( ReadRealMemory( pData + 0x20 ), 8 )
        endif

        return false
    endfunction

    function GetUnitInvulnerableCounter takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE8 )
        endif

        return 0
    endfunction

    function SetUnitInvulnerableCounter takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE8, i )
        endif
    endfunction

    function ModifyInvulnerableCounter takes unit u, integer diff returns nothing
        if u != null then
            call SetUnitInvulnerableCounter( u, GetUnitInvulnerableCounter( u ) + diff )
        endif
    endfunction

    function IsUnitInvulnerable2 takes unit u returns boolean
        return GetUnitInvulnerableCounter( u ) > 0
    endfunction

    function SetUnitFacingEx takes unit u, real facing, boolean isinstant returns nothing
        local integer pObject   = ConvertHandle( u )
        local integer vtable    = 0
        local integer pSmartPos = 0
        local integer pPosPos   = 0
        local integer arg       = LoadInteger( MemHackTable, StringHash( "PointerArray" ), 0 )

        if pObject != 0 and arg != 0 then
            set vtable = ReadRealMemory( pObject )

            if vtable != 0 then
                set pSmartPos = this_call_1( ReadRealMemory( vtable + 0xB8 ), pObject )

                if pSmartPos != 0 then
                    set pPosPos = GetCObjectFromHashGroup( pSmartPos + 0x08 )
                    
                    if pPosPos != 0 then
                        set vtable = ReadRealMemory( pPosPos )
                        
                        if vtable != 0 then
                            set facing = Deg2Rad( facing )
                            call WriteRealFloat( arg + 0x0, facing )
                            call this_call_2( ReadRealMemory( vtable + 0x4C ), pPosPos, arg + 0x0 )

                            if isinstant then
                                call this_call_1( ReadRealMemory( vtable + 0x58 ), pPosPos )
                            endif
                        endif
                    endif
                endif
            endif
        endif
    endfunction

    function SetUnitFacingInstantOld takes unit u, real angle returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0x28 )

                if pData > 0 then
                    call SetUnitFacing( u, angle )
                    call WriteRealFloat( pData + 0xA4, Deg2Rad( angle ) )
                endif
            endif
        endif
    endfunction

    function GetUnitMoveType takes unit u returns integer
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x16C )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    return ReadRealMemory( pData + 0x9C )
                endif
            endif
        endif

        return 0
    endfunction

    function SetUnitMoveType takes unit u, integer m_type returns nothing
        // foot = 33554434 | fly = 67108868 | amph = -2147483520
        // This method only properly works if unit has FLY movement as default, els.
        // Meaning only a unit with default move type of flying can lose flying pathing and gain it back.
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x16C )

            if pData > 0 then
                set pData = ReadRealMemory( pData + 0xA8 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0x9C, m_type )
                endif
            endif
        endif
    endfunction

    function GetHeroPrimaryAttribute takes unit u returns integer //1 = str, 2 = int, 3 = agi
        local integer a = ConvertHandle( u )

        if a > 0 then
            set a = ReadRealMemory( a + 0x1F0 )

            if a > 0 then
                return ReadRealMemory( a + 0xCC )
            endif
        endif

        return 0
    endfunction

    function SetHeroPrimaryAttribute takes unit u, integer i returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            if IsUnitIdType( GetUnitTypeId( u ), UNIT_TYPE_HERO ) then
                set pData = ReadRealMemory( pData + 0x1F0 )

                if pData > 0 then
                    call WriteRealMemory( pData + 0xCC, i )
                endif
            endif
        endif
    endfunction

    function GetUnitAttackAbility takes unit u returns integer
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            return ReadRealMemory( pData + 0x1E8 )
        endif
        
        return 0
    endfunction

    function SetUnitAttackAbility takes unit u, integer pAddr returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            call WriteRealMemory( pData + 0x1E8, pAddr )
        endif
    endfunction
    
    function GetUnitAttackOffsetValue takes unit u, integer pOff returns integer
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            return ReadRealMemory( pData + pOff )
        endif

        return 0
    endfunction

    function GetUnitNextAttackTimestamp takes unit u returns real
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x4 )
            endif
        endif

        return -1.
    endfunction

    function UnitResetAttackCooldown takes unit u returns boolean
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1E4, 0 )
                return true
            endif
        endif

        return false
    endfunction

    function UnitNullifyCurrentAttack takes unit u returns string
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1F4 )

            if pData > 0 then
                call WriteRealMemory( pData + 0x1F4, 0 )
                return "nulled"
            else
                return "already empty"
            endif
        else
            return "cannot attack"
        endif

        return "no attack has been found"
    endfunction

    function AddUnitExtraAttack takes unit u returns boolean
        local integer pData = GetUnitAttackAbility( u )
        local real attackdelay

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1E4 )

            if pData > 0 then
                set attackdelay = CleanReal( IndexToReal( ReadRealMemory( pData + 0x8 )  ) )

                if attackdelay > 0 then
                    call WriteRealMemory( pData + 0x4, CleanInt( RealToIndex( GetUnitNextAttackTimestamp( u ) - attackdelay ) ) )
                    return true
                endif
            endif
        endif

        return false
    endfunction

    function GetUnitAttackTypeByIndex takes unit u, integer index returns integer
        if index == 0 or index == 1 then
            return GetUnitAttackOffsetValue( u, 0xF4 + 4 * index )
        endif

        return -1
    endfunction

    function GetUnitAttackType1 takes unit u returns integer
        return GetUnitAttackTypeByIndex( u, 0 )
    endfunction

    function GetUnitAttackType2 takes unit u returns integer
        return GetUnitAttackTypeByIndex( u, 1 )
    endfunction

    function SetUnitAttackOffsetValue takes unit u, integer offset, integer val returns nothing
        local integer pData = GetUnitAttackAbility( u )

        if pData > 0 then
            call WriteRealMemory( pData + offset, val )
        endif
    endfunction
    
    function SetUnitAttackTypeByIndex takes unit u, integer i, integer attacknum returns nothing
        //6 = hero, 5 = chaos, 4 = magic, 3 = siege, 2 = piercing, 1 = normal, 0 = spell?
        //values over 6 takes incorrect multipliers from nearby memory, do not use them
        call SetUnitAttackOffsetValue( u, 0xF4 + 4 * attacknum, i )
    endfunction

    function SetUnitAttackType1 takes unit u, integer i returns nothing
        call SetUnitAttackTypeByIndex( u, i, 0 )
    endfunction

    function SetUnitAttackType2 takes unit u, integer i returns nothing
        call SetUnitAttackTypeByIndex( u, i, 1 )
    endfunction

    function GetUnitWeaponSound takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xE8 )
    endfunction

    function SetUnitWeaponSound takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xE8, i )
    endfunction
    
    function GetUnitWeaponType takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xDC )
    endfunction
    
    function SetUnitWeaponType takes unit u, integer i returns nothing
        // unit's weapon type is melee, ranged, splash, artillery, etc -> 0 = melee, 1 = instant, 2 = ranger, 5 = splash, 6 = mbounce | up to 8
        call SetUnitAttackOffsetValue( u, 0xDC, i )
    endfunction

    function GetUnitBaseDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xA0 )
    endfunction

    function SetUnitBaseDamage takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xA0, i )
    endfunction

    function AddUnitBaseDamage takes unit u, integer bonus returns nothing
        call SetUnitBaseDamage( u, GetUnitBaseDamage( u ) + bonus )
    endfunction

    function GetUnitBonusDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xAC )
    endfunction

    function SetUnitBonusDamage takes unit u, integer i returns nothing
        //setting green bonus automatically adjusts base damage to fit
        call SetUnitAttackOffsetValue( u, 0xAC, i )
    endfunction

    function AddUnitBonusDamage takes unit u, integer i returns nothing
        call SetUnitBonusDamage( u, GetUnitBonusDamage( u ) + i )
    endfunction

    function GetUnitTotalDamage takes unit u returns integer
        return GetUnitBaseDamage( u ) + GetUnitBonusDamage( u )
    endfunction

    function GetUnitBaseAttributeDamage takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0xA4 )
    endfunction

    function SetUnitBaseAttributeDamage takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0xA4, i )
    endfunction

    function GetUnitDamageDicesSideCount takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x94 )
    endfunction

    function SetUnitDamageDicesSideCount takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0x94, i )
    endfunction

    function GetUnitDamageDicesCount takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x88 )
    endfunction
    
    function SetUnitDamageDicesCount takes unit u, integer i returns nothing
        call SetUnitAttackOffsetValue( u, 0x88, i )
    endfunction

    function GetUnitAttackRangeByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x258 + 0x24 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackRangeByIndex takes unit u, integer index, real range returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x258 + 0x24 * index, SetRealIntoMemory( range ) )
        endif
    endfunction
    
    function GetUnitAttackRange1 takes unit u returns real
        return GetUnitAttackRangeByIndex( u, 0 )
    endfunction 

    function SetUnitAttackRange1 takes unit u, real range returns nothing
        call SetUnitAttackRangeByIndex( u, 0, range )
    endfunction

    function GetUnitAttackRange2 takes unit u returns real
        return GetUnitAttackRangeByIndex( u, 1 )
    endfunction

    function SetUnitAttackRange2 takes unit u, real range returns nothing
       call SetUnitAttackRangeByIndex( u, 1, range )
    endfunction

    function GetUnitBATByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x158 + 0x8 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitBATByIndex takes unit u, integer index, real baseas returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x158 + 0x8 * index, SetRealIntoMemory( baseas ) )
        endif
    endfunction

    function GetUnitBAT1 takes unit u returns real
        return GetUnitBATByIndex( u, 0 )
    endfunction

    function SetUnitBAT1 takes unit u, real baseas returns nothing
        call SetUnitBATByIndex( u, 0, baseas )
    endfunction

    function GetUnitBAT2 takes unit u returns real
        return GetUnitBATByIndex( u, 1 )
    endfunction
    
    function SetUnitBAT2 takes unit u, real baseas returns nothing
        call SetUnitBATByIndex( u, 1, baseas )
    endfunction

    function GetUnitAttackPointByIndex takes unit u, integer index returns real
        if index == 0 or index == 1 then
            return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x16C + 0x10 * index ) )
        endif

        return 0.
    endfunction

    function SetUnitAttackPointByIndex takes unit u, integer index, real atckpoint returns nothing
        if index == 0 or index == 1 then
            call SetUnitAttackOffsetValue( u, 0x16C + 0x10 * index, SetRealIntoMemory( atckpoint ) )
        endif
    endfunction
    
    function GetUnitAttackPoint1 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 0 )
    endfunction
    
    function SetUnitAttackPoint1 takes unit u, real atckpoint returns nothing
        call SetUnitAttackPointByIndex( u, 0, atckpoint )
    endfunction

    function GetUnitAttackPoint2 takes unit u returns real
        return GetUnitAttackPointByIndex( u, 1 )
    endfunction

    function SetUnitAttackPoint2 takes unit u, real atckpoint returns nothing
        call SetUnitAttackPointByIndex( u, 1, atckpoint )
    endfunction

    function GetUnitAttackEnabledIndex takes unit u returns integer
        return GetUnitAttackOffsetValue( u, 0x104 )
    endfunction

    function GetUnitAttackBackswing takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x190 ) )
    endfunction 

    function SetUnitAttackBackswing takes unit u, real backswing returns nothing
        call SetUnitAttackOffsetValue( u, 0x190, SetRealIntoMemory( backswing ) )
    endfunction

    function GetUnitAttackSpeed takes unit u returns real
        return GetRealFromMemory( GetUnitAttackOffsetValue( u, 0x1B0 ) )
    endfunction
    
    function SetUnitAttackSpeed takes unit u, real atckspeed returns nothing
        call SetUnitAttackOffsetValue( u, 0x1B0, SetRealIntoMemory( atckspeed ) )
    endfunction

    function AddUnitAttackSpeed takes unit u, real atckspeed returns nothing
        call SetUnitAttackSpeed( u, GetUnitAttackSpeed( u ) + atckspeed )
    endfunction

    function GetUnitAttackDamage takes unit u returns real
        local integer dmg = GetUnitDamageDicesCount( u )
        local integer spread = GetRandomInt( dmg, dmg * GetUnitDamageDicesSideCount( u ) )

        return I2R( GetUnitBaseDamage( u ) + GetUnitBonusDamage( u ) + spread )
    endfunction
    
    function GetUnitArmourType takes unit u returns integer
        //armor types: 0 - Light; 1 - Medium; 2 - Heavy; 3 - Fortified; 4 - Normal; 5 - Hero; 6 - Divine; 7 - unarmored; | rest seems to have Light properties
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealMemory( pData + 0xE4 )
        endif

        return 0
    endfunction

    function SetUnitArmourType takes unit u, integer id returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealMemory( pData + 0xE4, id )
        endif
    endfunction

    function GetUnitArmour takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0xE0 )
        endif
        
        return 0.
    endfunction

    function SetUnitArmour takes unit u, real armour returns nothing
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            call WriteRealFloat( pData + 0xE0, armour )
        endif
    endfunction

    function AddUnitArmour takes unit u, real value returns nothing
        call SetUnitArmour( u, GetUnitArmour( u ) + value )
    endfunction

    function GetUnitTimeScale takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            return ReadRealFloat( pData + 0x300 )
        endif

        return 0.
    endfunction

    function GetUnitBaseMoveSpeed takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return ReadRealFloat( pData + 0x70 )
            endif
        endif

        return 0.
    endfunction

    function GetUnitBonusMoveSpeed takes unit u returns real
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                return ReadRealFloat( pData + 0x78 )
            endif
        endif

        return -1000. // To ensure we failed to get Bonus MoveSpeed.
    endfunction

    function SetUnitBonusMoveSpeed takes unit u, real bonusms returns boolean
        local integer pData = ConvertHandle( u )

        if pData > 0 then
            set pData = ReadRealMemory( pData + 0x1EC ) //Amov
            
            if pData > 0 then
                call WriteRealFloat( pData + 0x78, bonusms )
                call SetUnitMoveSpeed( u, ReadRealFloat( pData + 0x70 ) ) //required to update ms instantly
                return true
            endif
        endif

        return false
    endfunction

    function AddUnitBonusMovespeed takes unit u, real bonusms returns nothing
        call SetUnitBonusMoveSpeed( u, GetUnitBonusMoveSpeed( u ) + bonusms )
    endfunction

    function GetUnitCurrentSight takes unit u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x104 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x78 )
            endif
        endif

        return 0.
    endfunction

    function SetUnitCurrentSight takes unit u, real newsight returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0x104 )

            if pData > 0 then
                call UnitAddAbility( u, 'AIsi' )
                call UnitRemoveAbility( u, 'AIsi' )
                call WriteRealFloat( pData + 0x78, newsight )
            endif
        endif
    endfunction
    
    function SetUnitMaxLife takes unit u, real newhp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                call WriteRealFloat( pData + 0x84, newhp )
            endif
        endif
    endfunction

    function AddUnitMaxLife takes unit u, real value returns nothing
        call SetUnitMaxLife( u, GetUnitState( u, UNIT_STATE_MAX_LIFE ) + value )
    endfunction

    function SetUnitMaxMana takes unit u, real newmp returns nothing
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xC0 )

            if pData > 0 then
                call WriteRealFloat( pData + 0x84, newmp )
            endif
        endif
    endfunction

    function AddUnitMaxMana takes unit u, real value returns nothing
        call SetUnitMaxMana( u, GetUnitState( u, UNIT_STATE_MAX_MANA ) + value )
    endfunction

    function GetWidgetLifeRegen takes widget u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xA0 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x7C )
            endif
        endif

        return 0.
    endfunction

    function GetUnitLifeRegen takes unit u returns real
        return GetWidgetLifeRegen( u )
    endfunction

    function SetUnitLifeRegen takes unit u, real regen returns nothing
        local integer pData = ConvertHandle( u )
        local real curhp    = GetWidgetLife( u )

        if pData > 0 then
            if curhp > 0 then
                set pData = GetCObjectFromHashGroup( pData + 0xA0 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x7C, regen )
                    call SetWidgetLife( u, curhp )
                endif
            endif
        endif
    endfunction

    function AddUnitLifeRegen takes unit u, real regen returns nothing
        call SetUnitLifeRegen( u, GetUnitLifeRegen( u ) + regen )
    endfunction

    function GetUnitManaRegen takes unit u returns real
        local integer pData = ConvertHandle( u )
        
        if pData > 0 then
            set pData = GetCObjectFromHashGroup( pData + 0xC0 )

            if pData > 0 then
                return ReadRealFloat( pData + 0x7C )
            endif
        endif

        return 0.
    endfunction

    function SetUnitManaRegen takes unit u, real regen returns nothing
        local integer pData = ConvertHandle( u )
        local real curmp = GetUnitState( u, UNIT_STATE_MANA )

        if pData > 0 then
            if curmp > 0 then
                set pData = GetCObjectFromHashGroup( pData + 0xC0 )

                if pData > 0 then
                    call WriteRealFloat( pData + 0x7C, regen )
                    call SetUnitState( u, UNIT_STATE_MANA, curmp )
                endif
            endif
        endif
    endfunction

    function AddUnitManaRegen takes unit u, real regen returns nothing
        call SetUnitManaRegen( u, GetUnitManaRegen( u ) + regen )
    endfunction
    //===========================================

    function Init_MemHackUnitNormalAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0x943A94 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x285350 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x0773A0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x077420 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x270420 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x283650 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x4D3DE0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x208270 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x333370 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x2A2A40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x270970 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x2B3FC0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x2B3FF0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x270930 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x270940 )
            elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0x931934 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x284830 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x076770 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x0767F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x2A6440 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x282B30 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x4D32E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x26EB50 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x332830 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x2A1F20 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x26FE50 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x2B34A0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x2B34D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x26FE10 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x26FE20 )
            elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xA4A704 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x67FB00 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x471C40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x46F180 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x66B600 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x65AE60 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x186F40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x668050 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x3598C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x653220 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x67FA80 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6AA8E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6AD4E0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x676610 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x676600 )
            elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xB77EB0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x69D240 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x48F380 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x48C8C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x688D30 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x678590 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x1A4C60 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x685780 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x377060 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x670950 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x69D1C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6C8020 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6CAC20 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x693D40 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x693D30 )
            elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "vtable" ), pGameDLL + 0xB68914 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Redraw" ), pGameDLL + 0x6D13F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Silence" ), pGameDLL + 0x4C3490 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Pause" ), pGameDLL + 0x4C09D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Stun" ), pGameDLL + 0x6BCEC0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "Unstun" ), pGameDLL + 0x6AC6C0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "SetReplaceableTexture" ), pGameDLL + 0x1D74F0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "GetHeroNeededXP" ), pGameDLL + 0x6B9910 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateInfoBar" ), pGameDLL + 0x3AB170 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "MorphToTypeId" ), pGameDLL + 0x6A4A80 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UpdateHeroBar" ), pGameDLL + 0x6D1370 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "ApplyUpgrades" ), pGameDLL + 0x6FC1D0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "UnapplyUpgrades" ), pGameDLL + 0x6FEDD0 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshPortraitOnSelect" ), pGameDLL + 0x6C7F00 )
                call SaveInteger( MemHackTable, StringHash( "CUnit" ), StringHash( "RefreshInforBarOnSelect" ), pGameDLL + 0x6C7EF0 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass


///////////////////////鼠标事件捕获///////////////////
//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackMouseAPI requires InMHCore
    function GetCMouseEvent takes nothing returns integer
        return LoadInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ) )
    endfunction

    function GetCursorX takes nothing returns integer
        local integer pMouse = GetCursorPosStruct( )
        
        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x0 )
        endif

        return 0
    endfunction

    function GetCursorY takes nothing returns integer
        local integer pMouse = GetCursorPosStruct( )
        
        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x4 )
        endif

        return 0
    endfunction
    
    function GetCursorRelativeAxis takes nothing returns integer
        local integer window = LoadInteger( MemHackTable, StringHash( "GameWindowAPI" ), StringHash( "Window" ) )
        local integer pMouse = 0

        if window != 0 then
            set pMouse = GetCursorPosStruct( )

            if pMouse != 0 then
                if ScreenToClient( window, pMouse ) > 0 then
                    return pMouse
                endif
            endif
        endif

        return 0
    endfunction

    function GetCursorXRelative takes nothing returns integer
        local integer pMouse = GetCursorRelativeAxis( )

        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x0 )
        endif

        return 0
    endfunction

    function GetCursorYRelative takes nothing returns integer
        local integer pMouse = GetCursorRelativeAxis( )

        if pMouse != 0 then
            return ReadRealMemory( pMouse + 0x4 )
        endif

        return 0
    endfunction

    function GetMouseWorldEnv takes nothing returns integer
        local integer addr = LoadInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ) )

        if addr != 0 then
            set addr = ReadRealMemory( addr )

            if addr != 0 then
                set addr = ReadRealMemory( addr + 0x3BC )

                if addr != 0 then
                    return addr + 0x310
                endif
            endif
        endif

        return 0
    endfunction

    function GetMouseWorldAxis takes integer offset returns real
        local integer addr = GetMouseWorldEnv( )

        if addr != 0 then
            return ReadRealFloat( GetMouseWorldEnv( ) + offset )
        endif

        return 0.
    endfunction

    function GetMouseWorldX takes nothing returns real
        return GetMouseWorldAxis( 0x0 )
    endfunction

    function GetMouseWorldY takes nothing returns real
        return GetMouseWorldAxis( 0x4 )
    endfunction

    function GetMouseWorldZ takes nothing returns real
        return GetMouseWorldAxis( 0x8 )
    endfunction
    
    function Init_MemHackMouseAPI takes nothing returns nothing
        if PatchVersion != "" then
            if PatchVersion == "1.24e" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xACBDD8 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xAB0454 )
        elseif PatchVersion == "1.26a" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xAB4F80 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xA9A434 )
        elseif PatchVersion == "1.27a" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xBE6350 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xB66308 )
        elseif PatchVersion == "1.27b" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xD6A8B8 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xCE3A8C )
        elseif PatchVersion == "1.28f" then
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "CGameUIObject" ), pGameDLL + 0xD326F0 )
                call SaveInteger( MemHackTable, StringHash( "CMouse" ), StringHash( "Event" ),         pGameDLL + 0xCB1AD4 )
            endif
        endif
    endfunction
endlibrary
//! endnocjass



library MhLibrary initializer MhLibrary_Init requires MemoryHackMouseAPI , MemoryHackUnitNormalAPI , MemoryHackUnitBaseAPI , MemoryHackItemNormalAPI , MemoryHackItemBaseAPI , MemoryHackEffectAPI , MemoryHackCastAbility , MemoryHackAbilityUnitAPI , MemoryHackAbilityNormalAPI , MemoryHackAbilityAddressAPI , MemoryHackAbilityAddressAPI , MemoryHackAbilityBaseAPI , MemoryHackCObjectAPI , MemoryHackCWidgetBaseAPI , MemoryHackCASpriteBaseAPI , MemoryHackCFrameBackDropAPI
    private function MhLibrary_Init takes nothing returns nothing
        call RunMhCore()  
        call Init_MemHackCBackDropFrameAPI()
        call Init_MemHackCSpriteBaseAPI()
        call Init_MemHackCWidgetBaseAPI()
        call Init_APIMemoryObjectData()
        call Init_MemHackAbilityAddressAPI( )           // API allowing you to modify ability data freely, peek into the library for the functions.
        call Init_MemHackAbilityBaseAPI( )              // Refers to Init_MemHackAbilityAddressAPI and UIBaseData, contains a simple user-friendly API.
        call Init_MemHackAbilityNormalAPI( )            // Refers to Init_MemHackAbilityAddressAPI, contains a simple user-friendly API.
        call Init_MemHackAbilityUnitAPI( )              // Refers to Init_MemHackAbilityAddressAPI, contains a simple user-friendly API.
        call Init_MemHackCastAbility()
        call Init_MemHackEffectAPI()
        call Init_MemHackItemBaseAPI( )                 // API allowing you to modify item's base data.
        call Init_MemHackItemNormalAPI( )               // Contains a small portion of things that can be done to items.
        call Init_MemHackUnitBaseAPI( )                 // API allowing you to modify unit's base data.
        call Init_MemHackUnitNormalAPI( )               // API allowing you to modify unit data freely, peek into the library for the functions.
        call Init_MemHackMouseAPI()
        call BJDebugMsg("内存捕手，启动！")
    endfunction
endlibrary
