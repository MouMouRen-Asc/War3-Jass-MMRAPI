//TESH.scrollpos=0
//TESH.alwaysfold=0
//! nocjass
library MemoryHackCASpriteBaseAPI
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

//===========================================================================
function InitTrig_MemHackCSpriteBaseAPI takes nothing returns nothing
    //set gg_trg_MemHackCSpriteBaseAPI = CreateTrigger(  )
endfunction
//! endnocjass
