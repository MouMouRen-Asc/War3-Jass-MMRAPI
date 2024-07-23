<?local slk = require 'slk' ?>

#include "YDWEBase.j"

#ifndef YDWETriggerEventIncluded
#define YDWETriggerEventIncluded

library YDWETriggerEvent 

globals
#ifndef YDWE_DamageEventTrigger
#define YDWE_DamageEventTrigger
    trigger yd_DamageEventTrigger = null
#endif
    private constant integer DAMAGE_EVENT_SWAP_TIMEOUT = 600  // 每隔这个时间(秒), yd_DamageEventTrigger 会被移入销毁队列
    private constant boolean DAMAGE_EVENT_SWAP_ENABLE = true  // 若为 false 则不启用销毁机制
    private trigger yd_DamageEventTriggerToDestory = null

    private trigger array DamageEventQueue
    private integer DamageEventNumber = 0
	
    item bj_lastMovedItemInItemSlot = null
	
    private trigger MoveItemEventTrigger = null
    private trigger array MoveItemEventQueue
    private integer MoveItemEventNumber = 0
endglobals
	
function YDWEAnyUnitDamagedTriggerAction takes nothing returns nothing
    local integer i = 0
    
    loop
        exitwhen i >= DamageEventNumber
        if DamageEventQueue[i] != null and IsTriggerEnabled(DamageEventQueue[i]) and TriggerEvaluate(DamageEventQueue[i]) then
            call TriggerExecute(DamageEventQueue[i])
        endif
        set i = i + 1  
    endloop    
endfunction

function YDWEAnyUnitDamagedFilter takes nothing returns boolean     
    if GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0 then 
        call TriggerRegisterUnitEvent(yd_DamageEventTrigger, GetFilterUnit(), EVENT_UNIT_DAMAGED)
    endif
    return false
endfunction

function YDWEAnyUnitDamagedEnumUnit takes nothing returns nothing
    local group g = CreateGroup()
    local integer i = 0
    loop
        call GroupEnumUnitsOfPlayer(g, Player(i), Condition(function YDWEAnyUnitDamagedFilter))
        set i = i + 1
        exitwhen i >= bj_MAX_PLAYER_SLOTS
    endloop
    call DestroyGroup(g)
    set g = null
endfunction

function YDWEAnyUnitDamagedRegistTriggerUnitEnter takes nothing returns nothing
    local trigger t = CreateTrigger()
    local region  r = CreateRegion()
    local rect world = GetWorldBounds()
    call RegionAddRect(r, world)
    call TriggerRegisterEnterRegion(t, r, Condition(function YDWEAnyUnitDamagedFilter))
    call RemoveRect(world)
    set t = null
    set r = null
    set world = null
endfunction

// 将 yd_DamageEventTrigger 移入销毁队列, 从而排泄触发器事件
function YDWESyStemAnyUnitDamagedSwap takes nothing returns nothing
    local boolean isEnabled = IsTriggerEnabled(yd_DamageEventTrigger)
    local group g =CreateGroup()

    call DisableTrigger(yd_DamageEventTrigger)
    if yd_DamageEventTriggerToDestory != null then
        call DestroyTrigger(yd_DamageEventTriggerToDestory)
    endif

    set yd_DamageEventTriggerToDestory = yd_DamageEventTrigger
    set yd_DamageEventTrigger = CreateTrigger()
    if not isEnabled then
        call DisableTrigger(yd_DamageEventTrigger)
    endif

    call TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction) 
    call YDWEAnyUnitDamagedEnumUnit()
endfunction

function YDWESyStemAnyUnitDamagedRegistTrigger takes trigger trg returns nothing
    if trg == null then
        return
    endif
        
    if DamageEventNumber == 0 then
        set yd_DamageEventTrigger = CreateTrigger()
        call TriggerAddAction(yd_DamageEventTrigger, function YDWEAnyUnitDamagedTriggerAction) 
        call YDWEAnyUnitDamagedEnumUnit()
        call YDWEAnyUnitDamagedRegistTriggerUnitEnter()
        if DAMAGE_EVENT_SWAP_ENABLE then
            // 每隔 DAMAGE_EVENT_SWAP_TIMEOUT 秒, 将正在使用的 yd_DamageEventTrigger 移入销毁队列
            call TimerStart(CreateTimer(), DAMAGE_EVENT_SWAP_TIMEOUT, true, function YDWESyStemAnyUnitDamagedSwap)
        endif
    endif   
    
    set DamageEventQueue[DamageEventNumber] = trg
    set DamageEventNumber = DamageEventNumber + 1
endfunction

function YDWESyStemItemUnmovableTriggerAction takes nothing returns nothing
    local integer i = 0
    
    if GetIssuedOrderId() >= 852002 and GetIssuedOrderId() <= 852007 then 
		set bj_lastMovedItemInItemSlot = GetOrderTargetItem() 
    	loop
        	exitwhen i >= MoveItemEventNumber
        	if MoveItemEventQueue[i] != null and IsTriggerEnabled(MoveItemEventQueue[i]) and TriggerEvaluate(MoveItemEventQueue[i]) then
        	    call TriggerExecute(MoveItemEventQueue[i])
        	endif
        	set i = i + 1  
    	endloop  
	endif	
endfunction

function YDWESyStemItemUnmovableRegistTrigger takes trigger trg returns nothing
    if trg == null then
        return
    endif
        
    if MoveItemEventNumber == 0 then
        set MoveItemEventTrigger = CreateTrigger()
        call TriggerAddAction(MoveItemEventTrigger, function YDWESyStemItemUnmovableTriggerAction) 
        call TriggerRegisterAnyUnitEventBJ(MoveItemEventTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    endif   
    
    set MoveItemEventQueue[MoveItemEventNumber] = trg
    set MoveItemEventNumber = MoveItemEventNumber + 1
endfunction

function GetLastMovedItemInItemSlot takes nothing returns item
    return  bj_lastMovedItemInItemSlot
endfunction

endlibrary 

#endif /// YDWETriggerEventIncluded

#ifndef YDWEEventDamageDataIncluded 
#define YDWEEventDamageDataIncluded

library YDWEEventDamageData
	globals        
    	private constant integer EVENT_DAMAGE_DATA_VAILD       = 0
    	private constant integer EVENT_DAMAGE_DATA_IS_PHYSICAL = 1
    	private constant integer EVENT_DAMAGE_DATA_IS_ATTACK   = 2
    	private constant integer EVENT_DAMAGE_DATA_IS_RANGED   = 3
    	private constant integer EVENT_DAMAGE_DATA_DAMAGE_TYPE = 4
    	private constant integer EVENT_DAMAGE_DATA_WEAPON_TYPE = 5
    	private constant integer EVENT_DAMAGE_DATA_ATTACK_TYPE = 6
	endglobals

	native EXGetEventDamageData takes integer edd_type returns integer
	native EXSetEventDamage takes real amount returns boolean
	
	function YDWEIsEventPhysicalDamage takes nothing returns boolean
		return 0 != EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
	endfunction

	function YDWEIsEventAttackDamage takes nothing returns boolean
		return 0 != EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
	endfunction
	
	function YDWEIsEventRangedDamage takes nothing  returns boolean
		return 0 != EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
	endfunction
	
	function YDWEIsEventDamageType takes damagetype damageType returns boolean
		return damageType == ConvertDamageType(EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
	endfunction

	function YDWEIsEventWeaponType takes weapontype weaponType returns boolean
		return weaponType == ConvertWeaponType(EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
	endfunction
	
	function YDWEIsEventAttackType takes attacktype attackType returns boolean
		return attackType == ConvertAttackType(EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
	endfunction

	
	function YDWESetEventDamage takes real amount returns boolean
		return EXSetEventDamage(amount)
	endfunction
	
	
endlibrary

#endif  /// YDWEEventDamageDataIncluded

#ifndef YDWEYDWEJapiScriptIncluded 
#define YDWEYDWEJapiScriptIncluded

library YDWEYDWEJapiScript
	globals
    	constant integer YDWE_OBJECT_TYPE_ABILITY      = 0
    	constant integer YDWE_OBJECT_TYPE_BUFF         = 1
    	constant integer YDWE_OBJECT_TYPE_UNIT         = 2
    	constant integer YDWE_OBJECT_TYPE_ITEM         = 3
    	constant integer YDWE_OBJECT_TYPE_UPGRADE      = 4
    	constant integer YDWE_OBJECT_TYPE_DOODAD       = 5
    	constant integer YDWE_OBJECT_TYPE_DESTRUCTABLE = 6
	endglobals

	native EXExecuteScript     takes string script returns string

endlibrary

#endif  /// YDWEYDWEJapiScriptIncluded


#ifndef BZAPIINCLUDE
#define BZAPIINCLUDE

library BzAPI
    //hardware
    native DzGetMouseTerrainX takes nothing returns real
    native DzGetMouseTerrainY takes nothing returns real
    native DzGetMouseTerrainZ takes nothing returns real
    native DzIsMouseOverUI takes nothing returns boolean
    native DzGetMouseX takes nothing returns integer
    native DzGetMouseY takes nothing returns integer
    native DzGetMouseXRelative takes nothing returns integer
    native DzGetMouseYRelative takes nothing returns integer
    native DzSetMousePos takes integer x, integer y returns nothing
    native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
    native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzGetTriggerKey takes nothing returns integer
    native DzGetWheelDelta takes nothing returns integer
    native DzIsKeyDown takes integer iKey returns boolean
    native DzGetTriggerKeyPlayer takes nothing returns player
    native DzGetWindowWidth takes nothing returns integer
    native DzGetWindowHeight takes nothing returns integer
    native DzGetWindowX takes nothing returns integer
    native DzGetWindowY takes nothing returns integer
    native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
    native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
    native DzIsWindowActive takes nothing returns boolean
    //plus
    native DzDestructablePosition takes destructable d, real x, real y returns nothing
    native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
    native DzExecuteFunc takes string funcName returns nothing
    native DzGetUnitUnderMouse takes nothing returns unit
    native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
    native DzSetMemory takes integer address, real value returns nothing
    native DzSetUnitID takes unit whichUnit, integer id returns nothing
    native DzSetUnitModel takes unit whichUnit, string path returns nothing
    native DzSetWar3MapMap takes string map returns nothing
    native DzGetLocale takes nothing returns string
    native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
    //sync
    native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
    native DzSyncData takes string prefix, string data returns nothing
    native DzGetTriggerSyncPrefix takes nothing returns string
    native DzGetTriggerSyncData takes nothing returns string
    native DzGetTriggerSyncPlayer takes nothing returns player
    native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
    //native DzGetPushContext takes nothing returns string
    native DzSyncDataImmediately takes string prefix, string data returns nothing   
    //gui
    native DzFrameHideInterface takes nothing returns nothing
    native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
    native DzFrameGetPortrait takes nothing returns integer
    native DzFrameGetMinimap takes nothing returns integer
    native DzFrameGetCommandBarButton takes integer row, integer column returns integer
    native DzFrameGetHeroBarButton takes integer buttonId returns integer
    native DzFrameGetHeroHPBar takes integer buttonId returns integer
    native DzFrameGetHeroManaBar takes integer buttonId returns integer
    native DzFrameGetItemBarButton takes integer buttonId returns integer
    native DzFrameGetMinimapButton takes integer buttonId returns integer
    native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
    native DzFrameGetTooltip takes nothing returns integer
    native DzFrameGetChatMessage takes nothing returns integer
    native DzFrameGetUnitMessage takes nothing returns integer
    native DzFrameGetTopMessage takes nothing returns integer
    native DzGetColor takes integer r, integer g, integer b, integer a returns integer
    native DzFrameSetUpdateCallback takes string func returns nothing
    native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
    native DzFrameShow takes integer frame, boolean enable returns nothing
    native DzCreateFrame takes string frame, integer parent, integer id returns integer
    native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
    native DzDestroyFrame takes integer frame returns nothing
    native DzLoadToc takes string fileName returns nothing
    native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
    native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
    native DzFrameClearAllPoints takes integer frame returns nothing
    native DzFrameSetEnable takes integer name, boolean enable returns nothing
    native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
    native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
    native DzGetTriggerUIEventPlayer takes nothing returns player
    native DzGetTriggerUIEventFrame takes nothing returns integer
    native DzFrameFindByName takes string name, integer id returns integer
    native DzSimpleFrameFindByName takes string name, integer id returns integer
    native DzSimpleFontStringFindByName takes string name, integer id returns integer
    native DzSimpleTextureFindByName takes string name, integer id returns integer
    native DzGetGameUI takes nothing returns integer
    native DzClickFrame takes integer frame returns nothing
    native DzSetCustomFovFix takes real value returns nothing
    native DzEnableWideScreen takes boolean enable returns nothing
    native DzFrameSetText takes integer frame, string text returns nothing
    native DzFrameGetText takes integer frame returns string
    native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
    native DzFrameGetTextSizeLimit takes integer frame returns integer
    native DzFrameSetTextColor takes integer frame, integer color returns nothing
    native DzGetMouseFocus takes nothing returns integer
    native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
    native DzFrameSetFocus takes integer frame, boolean enable returns boolean
    native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
    native DzFrameGetEnable takes integer frame returns boolean
    native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
    native DzFrameGetAlpha takes integer frame returns integer
    native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
    native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
    native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
    native DzFrameSetScale takes integer frame, real scale returns nothing
    native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
    native DzFrameCageMouse takes integer frame, boolean enable returns nothing
    native DzFrameGetValue takes integer frame returns real
    native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
    native DzFrameSetStepValue takes integer frame, real step returns nothing
    native DzFrameSetValue takes integer frame, real value returns nothing
    native DzFrameSetSize takes integer frame, real w, real h returns nothing
    native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
    native DzFrameSetVertexColor takes integer frame, integer color returns nothing
    native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
    native DzFrameSetPriority takes integer frame, integer priority returns nothing
    native DzFrameSetParent takes integer frame, integer parent returns nothing
    native DzFrameGetHeight takes integer frame returns real
    native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
    native DzFrameGetParent takes integer frame returns integer
    native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
    native DzFrameGetName takes integer frame returns string
    native DzGetClientWidth takes nothing returns integer
    native DzGetClientHeight takes nothing returns integer
    native DzFrameIsVisible takes integer frame returns boolean
        //显示/隐藏SimpleFrame
    //native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
    // 追加文字（支持TextArea）
    native DzFrameAddText takes integer frame, string text returns nothing
    // 沉默单位-禁用技能
    native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
    // 禁用攻击
    native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
    // 禁用道具
    native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
    // 刷新小地图
    native DzUpdateMinimap takes nothing returns nothing
    // 修改单位alpha
    native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
    // 设置单位是否可以选中
    native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
    // 修改单位是否可以被设置为目标
    native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
    // 保存内存数据
    native DzSaveMemoryCache takes string cache returns nothing
    // 读取内存数据
    native DzGetMemoryCache takes nothing returns string
    // 设置加速倍率
    native DzSetSpeed takes real ratio returns nothing
    // 转换世界坐标为屏幕坐标-异步
    native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
    // 转换世界坐标为屏幕坐标-获取转换后的X坐标
    native DzGetConvertWorldPositionX takes nothing returns real
    // 转换世界坐标为屏幕坐标-获取转换后的Y坐标
    native DzGetConvertWorldPositionY takes nothing returns real
    // 创建command button
    native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
    function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
    endfunction

    function DzTriggerRegisterKeyEventTrg takes trigger trg, integer status, integer btn returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
    endfunction

    function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseMoveEvent(trg, true, null)
    endfunction

    function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterMouseWheelEvent(trg, true, null)
    endfunction

    function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
        if trg == null then
            return
        endif
        call DzTriggerRegisterWindowResizeEvent(trg, true, null)
    endfunction

    function DzF2I takes integer i returns integer
        return i
    endfunction

    function DzI2F takes integer i returns integer
        return i
    endfunction

    function DzK2I takes integer i returns integer
        return i
    endfunction

    function DzI2K takes integer i returns integer
        return i
    endfunction

    function DzTriggerRegisterMallItemSyncData takes trigger trig returns nothing
        call DzTriggerRegisterSyncData(trig, "DZMIA", true)
    endfunction

    function DzGetTriggerMallItemPlayer takes nothing returns player
        return DzGetTriggerSyncPlayer()
    endfunction

    function DzGetTriggerMallItem takes nothing returns string
        return DzGetTriggerSyncData()
    endfunction

    

endlibrary
#endif

#ifndef YDWEAbilityStateIncluded
#define YDWEAbilityStateIncluded

library YDWEAbilityState
	globals
		private constant integer ABILITY_STATE_COOLDOWN         = 1

		private constant integer ABILITY_DATA_TARGS             = 100 // integer
		private constant integer ABILITY_DATA_CAST              = 101 // real
		private constant integer ABILITY_DATA_DUR               = 102 // real
		private constant integer ABILITY_DATA_HERODUR           = 103 // real
		private constant integer ABILITY_DATA_COST              = 104 // integer
		private constant integer ABILITY_DATA_COOL              = 105 // real
		private constant integer ABILITY_DATA_AREA              = 106 // real
		private constant integer ABILITY_DATA_RNG               = 107 // real
		private constant integer ABILITY_DATA_DATA_A            = 108 // real
		private constant integer ABILITY_DATA_DATA_B            = 109 // real
		private constant integer ABILITY_DATA_DATA_C            = 110 // real
		private constant integer ABILITY_DATA_DATA_D            = 111 // real
		private constant integer ABILITY_DATA_DATA_E            = 112 // real
		private constant integer ABILITY_DATA_DATA_F            = 113 // real
		private constant integer ABILITY_DATA_DATA_G            = 114 // real
		private constant integer ABILITY_DATA_DATA_H            = 115 // real
		private constant integer ABILITY_DATA_DATA_I            = 116 // real
		private constant integer ABILITY_DATA_UNITID            = 117 // integer

		private constant integer ABILITY_DATA_HOTKET            = 200 // integer
		private constant integer ABILITY_DATA_UNHOTKET          = 201 // integer
		private constant integer ABILITY_DATA_RESEARCH_HOTKEY   = 202 // integer
		private constant integer ABILITY_DATA_NAME              = 203 // string
		private constant integer ABILITY_DATA_ART               = 204 // string
		private constant integer ABILITY_DATA_TARGET_ART        = 205 // string
		private constant integer ABILITY_DATA_CASTER_ART        = 206 // string
		private constant integer ABILITY_DATA_EFFECT_ART        = 207 // string
		private constant integer ABILITY_DATA_AREAEFFECT_ART    = 208 // string
		private constant integer ABILITY_DATA_MISSILE_ART       = 209 // string
		private constant integer ABILITY_DATA_SPECIAL_ART       = 210 // string
		private constant integer ABILITY_DATA_LIGHTNING_EFFECT  = 211 // string
		private constant integer ABILITY_DATA_BUFF_TIP          = 212 // string
		private constant integer ABILITY_DATA_BUFF_UBERTIP      = 213 // string
		private constant integer ABILITY_DATA_RESEARCH_TIP      = 214 // string
		private constant integer ABILITY_DATA_TIP               = 215 // string
		private constant integer ABILITY_DATA_UNTIP             = 216 // string
		private constant integer ABILITY_DATA_RESEARCH_UBERTIP  = 217 // string
		private constant integer ABILITY_DATA_UBERTIP           = 218 // string
		private constant integer ABILITY_DATA_UNUBERTIP         = 219 // string
		private constant integer ABILITY_DATA_UNART             = 220 // string
	endglobals

	native EXGetUnitAbility        takes unit u, integer abilcode returns ability
	native EXGetUnitAbilityByIndex takes unit u, integer index returns ability
	native EXGetAbilityId          takes ability abil returns integer
	native EXGetAbilityState       takes ability abil, integer state_type returns real
	native EXSetAbilityState       takes ability abil, integer state_type, real value returns boolean
	native EXGetAbilityDataReal    takes ability abil, integer level, integer data_type returns real
	native EXSetAbilityDataReal    takes ability abil, integer level, integer data_type, real value returns boolean
	native EXGetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
	native EXSetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
	native EXGetAbilityDataString  takes ability abil, integer level, integer data_type returns string
	native EXSetAbilityDataString  takes ability abil, integer level, integer data_type, string value returns boolean

	function YDWEGetUnitAbilityState takes unit u, integer abilcode, integer state_type returns real
		return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type)
	endfunction

	function YDWEGetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type returns integer
		return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction

	function YDWEGetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type returns real
		return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction

	function YDWEGetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type returns string
		return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction

	function YDWESetUnitAbilityState takes unit u, integer abilcode, integer state_type, real value returns boolean
		return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value)
	endfunction

	function YDWESetUnitAbilityDataInteger takes unit u, integer abilcode, integer level, integer data_type, integer value returns boolean
		return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction

	function YDWESetUnitAbilityDataReal takes unit u, integer abilcode, integer level, integer data_type, real value returns boolean
		return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction

	function YDWESetUnitAbilityDataString takes unit u, integer abilcode, integer level, integer data_type, string value returns boolean
		return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction

	native EXSetAbilityAEmeDataA takes ability abil, integer unitid returns boolean

	function YDWEUnitTransform takes unit u, integer abilcode, integer targetid returns nothing
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, ABILITY_DATA_UNITID, GetUnitTypeId(u))
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), GetUnitTypeId(u))
		call UnitRemoveAbility(u, abilcode)
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid)
		call UnitRemoveAbility(u, abilcode)
	endfunction

	native EXGetItemDataString takes integer itemcode, integer data_type returns string
	native EXSetItemDataString takes integer itemcode, integer data_type, string value returns boolean

	function YDWEGetItemDataString takes integer itemcode, integer data_type returns string
		return EXGetItemDataString(itemcode, data_type)
	endfunction

	function YDWESetItemDataString takes integer itemcode, integer data_type, string value returns boolean
		return EXSetItemDataString(itemcode, data_type, value)
	endfunction

endlibrary

#endif  /// YDWEAbilityStateIncluded 



#ifndef MMRAPIIncluded
#define MMRAPIIncluded


library MmrApi initializer MmrApi_Init requires YDWEYDWEJapiScript
    globals
    private unit array TargetUnit
    private integer array StrAppend
    private integer array AgiAppend
    private integer array IntAppend
    private real array AttackAppend
    private real array MaxHealthAppend
    private real array MaxManaAppend

    private integer array StrPercent
    private integer array AgiPercent
    private integer array IntPercent
    private integer array AttackPercent
    private integer array MaxHealthPercent
    private integer array MaxManaPercent

    private integer array PlayerUnitSkill_1
    private integer array PlayerUnitSkill_2
    private integer array PlayerUnitSkill_3
    private integer array PlayerUnitSkill_4
    
    private integer array PlayerUnitSkillLevel_1
    private integer array PlayerUnitSkillLevel_2
    private integer array PlayerUnitSkillLevel_3
    private integer array PlayerUnitSkillLevel_4

    private boolean array CanTrans

    private hashtable TransSkillDataTable
    private hashtable TransSkill
    private integer TransSkillDataTableID = 1

    gamecache PlayerGameCaChe
    endglobals

    function MMRAPI_GetPlayerUnitSkill takes integer pid , integer wich returns integer skillid
        if wich == 1 then
            return  PlayerUnitSkill_1[pid]  
        elseif wich == 2 then
            return  PlayerUnitSkill_2[pid]  
        elseif wich == 3 then
            return  PlayerUnitSkill_3[pid]  
        elseif wich == 4 then
            return  PlayerUnitSkill_4[pid]  
        endif
        return 0 
    endfunction

    function MMRAPI_SetPlayerUnitSkill takes integer pid , integer wich , integer skillid returns nothing
        if wich == 1 then
            set  PlayerUnitSkill_1[pid]  = skillid
        elseif wich == 2 then
            set  PlayerUnitSkill_2[pid]  = skillid
        elseif wich == 3 then
            set  PlayerUnitSkill_3[pid]  = skillid
        elseif wich == 4 then
            set  PlayerUnitSkill_4[pid]  = skillid
        endif
    endfunction

    private function MMRAPI_GetPlayerUnitSkillLevel takes integer pid , integer wich returns integer skillid
        if wich == 1 then
            return  PlayerUnitSkillLevel_1[pid]  
        elseif wich == 2 then
            return  PlayerUnitSkillLevel_2[pid]  
        elseif wich == 3 then
            return  PlayerUnitSkillLevel_3[pid]  
        elseif wich == 4 then
            return  PlayerUnitSkillLevel_4[pid]  
        endif
        return 0 
    endfunction

    private function MMRAPI_SetPlayerUnitSkillLevel takes integer pid , integer wich , integer skilllevel returns nothing
        if wich == 1 then
            set  PlayerUnitSkillLevel_1[pid]  = skilllevel
        elseif wich == 2 then
            set  PlayerUnitSkillLevel_2[pid]  = skilllevel
        elseif wich == 3 then
            set  PlayerUnitSkillLevel_3[pid]  = skilllevel
        elseif wich == 4 then
            set  PlayerUnitSkillLevel_4[pid]  = skilllevel
        endif
    endfunction

    function MMRAPI_GetNullSkillSolt takes integer pid returns integer soltid
        if PlayerUnitSkill_1[pid] == null or PlayerUnitSkill_1[pid] == 0 then
            return 1
        endif
        if PlayerUnitSkill_2[pid] == null or PlayerUnitSkill_2[pid] == 0 then
            return 2
        endif
        if PlayerUnitSkill_3[pid] == null or PlayerUnitSkill_3[pid] == 0 then
            return 3
        endif
        if PlayerUnitSkill_4[pid] == null or PlayerUnitSkill_4[pid] == 0 then
            return 4
        endif
        return 0
    endfunction

    function MMRAPI_GetSkillIdSolt takes integer pid  , integer skillid returns integer soltid
        if (PlayerUnitSkill_1[pid] != null or PlayerUnitSkill_1[pid] != 0) and  PlayerUnitSkill_1[pid] == skillid then
            return 1
        endif
        if (PlayerUnitSkill_2[pid] != null or PlayerUnitSkill_2[pid] != 0) and  PlayerUnitSkill_2[pid] == skillid then
            return 2
        endif
        if (PlayerUnitSkill_3[pid] != null or PlayerUnitSkill_3[pid] != 0) and  PlayerUnitSkill_3[pid] == skillid then
            return 3
        endif
        if (PlayerUnitSkill_4[pid] != null or PlayerUnitSkill_4[pid] != 0) and  PlayerUnitSkill_4[pid] == skillid then
            return 4
        endif
        return 0
    endfunction

    function MMRAPI_TargetPlayer takes player tplayer returns unit thisunit
        return TargetUnit[GetPlayerId(tplayer)]
    endfunction

    function MMRAPI_TargetPlayerBagIsNull takes integer pid returns boolean isnull
        return (((UnitItemInSlot(TargetUnit[pid], 0) == null) or (UnitItemInSlot(TargetUnit[pid], 1) == null)) or ((UnitItemInSlot(TargetUnit[pid], 2) == null) and (UnitItemInSlot(TargetUnit[pid], 3) == null))) or ((UnitItemInSlot(TargetUnit[pid], 4) == null) or (UnitItemInSlot(TargetUnit[pid], 5) == null))
    endfunction

    function MMRAPI_BaseAttributemodification takes unit target, unitstate attributeType, real value, boolean isAddition returns nothing
        local real originalValue = 0
        local real newValue = 0

        // 获取原始属性值
        set originalValue = GetUnitState(target, attributeType)
        // 根据是增加还是减少来计算新的属性值
        if isAddition then
            set newValue = originalValue + value
        else
            set newValue = originalValue - value
        endif

        // 设置单位的新属性值
        call SetUnitState(target, attributeType, newValue)

    endfunction

    function MMRAPI_CheckHeroMainAttribute takes unit wichunit returns integer MainAttribute
        if YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(wichunit) , "Primary") == "STR" then
            return 1
        endif
        if YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(wichunit) , "Primary") == "AIG" then
            return 2
        endif
        if YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId(wichunit) , "Primary") == "INT" then
            return 3
        endif
        return 0
    endfunction 

    function MMRAPI_DynamicAttributeCalcute takes unit wichUnit , integer percentage ,integer wichAttribute  , real thisAttrApvalue , boolean includeBonuses returns nothing
        local integer str 
        local integer agi
        local integer int
        local real attack
        local real maxhealth
        local real maxmana
        local real percent
        local integer apValue = 0
        set str =  GetHeroStr(wichUnit,includeBonuses) - R2I(thisAttrApvalue)
        set agi =  GetHeroAgi(wichUnit,includeBonuses) - R2I(thisAttrApvalue)
        set int =  GetHeroInt(wichUnit,includeBonuses) - R2I(thisAttrApvalue)
        set attack = GetUnitState(wichUnit, ConvertUnitState(0x12)) - thisAttrApvalue
        set maxhealth = GetUnitState(wichUnit, UNIT_STATE_MAX_LIFE) - thisAttrApvalue
        set maxmana = GetUnitState(wichUnit, UNIT_STATE_MAX_MANA) - thisAttrApvalue
        set percent = I2R(percentage)/100
        if wichAttribute == 1 then
            set  apValue = R2I(percent * str)
            call SetHeroStr(wichUnit ,(str + apValue) , includeBonuses ) 
            set StrAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        elseif wichAttribute == 2 then
            set  apValue = R2I(percent * agi)
            call SetHeroAgi(wichUnit ,(agi + apValue) , includeBonuses ) 
            set AgiAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        elseif  wichAttribute == 3 then
            set  apValue = R2I(percent * int)
            call SetHeroInt(wichUnit ,(int + apValue) , includeBonuses ) 
            set IntAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        elseif  wichAttribute == 4 then
            set  apValue = R2I(percent * attack)
            call SetUnitState(wichUnit , ConvertUnitState(0x12) , attack + apValue)
            set AttackAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        elseif  wichAttribute == 5 then
            set  apValue = R2I(percent * maxhealth)
            call SetUnitState(wichUnit , UNIT_STATE_MAX_LIFE , maxhealth + apValue)
            set MaxHealthAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        elseif  wichAttribute == 6 then
            set  apValue = R2I(percent * maxmana)
            call SetUnitState(wichUnit , UNIT_STATE_MAX_MANA , maxmana + apValue)
            set MaxManaAppend[GetPlayerId(GetOwningPlayer(wichUnit))] = apValue
        endif

    endfunction

    function MMRAPI_DynamicAttributeTimeTick takes nothing returns nothing
        local integer loopTimes = 0
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                
        endif
        set loopTimes = 1
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                               
        endif
        set loopTimes = 2
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)             
        endif
        set loopTimes = 3
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                        
        endif
        set loopTimes = 4
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                      
        endif
        set loopTimes = 5
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                       
        endif
        set loopTimes = 6
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                      
        endif
        set loopTimes = 7
        if TargetUnit[loopTimes] != null and (GetPlayerSlotState(Player(loopTimes)) == PLAYER_SLOT_STATE_PLAYING) then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                          
        endif
    endfunction

    function MMRAPI_DynamicAttributeTimeInit takes nothing returns nothing
    local timer appendtimer = CreateTimer()
    call TimerStart(appendtimer , 1 , true , function MMRAPI_DynamicAttributeTimeTick)
    endfunction
    //1是力量2是敏捷3是智力4是攻击5是生命6是魔法
    function MMRAPI_ChangeAttributePercent takes player wichplayer , integer typevalue ,integer value , boolean isadd returns nothing
        local integer truevalue 
        local integer playerid = GetPlayerId(wichplayer)
        if isadd then
            set truevalue = value
        else
            set truevalue = value * -1
        endif


        if typevalue == 1 then
            set StrPercent[playerid] = StrPercent[playerid] + truevalue
        elseif typevalue == 2 then
            set AgiPercent[playerid] = AgiPercent[playerid] + truevalue
        elseif typevalue == 3 then
            set IntPercent[playerid] = IntPercent[playerid] + truevalue
        elseif typevalue == 4 then
            set AttackPercent[playerid] = AttackPercent[playerid] + truevalue
        elseif typevalue == 5 then
            set MaxHealthPercent[playerid] = MaxHealthPercent[playerid] + truevalue
        elseif typevalue == 6 then
            set MaxManaPercent[playerid] = MaxManaPercent[playerid] + truevalue
        endif
    endfunction

        //1是力量2是敏捷3是智力4是攻击5是生命6是魔法
    function MMRAPI_GetAttributePercent takes player wichplayer , integer typevalue returns integer
        local integer playerid = GetPlayerId(wichplayer)
        if typevalue == 1 then
            return StrPercent[playerid]
        elseif typevalue == 2 then
            return AgiPercent[playerid]
        elseif typevalue == 3 then
            return IntPercent[playerid]
        elseif typevalue == 4 then
            return AttackPercent[playerid]
        elseif typevalue == 5 then
            return MaxHealthPercent[playerid]
        elseif typevalue == 6 then
            return MaxManaPercent[playerid]
        endif
            return 0
    endfunction

    function MMRAPI_HeroPercentSet takes player wichplayer , integer ValueType , integer value returns nothing
        local integer playerid = GetPlayerId(wichplayer)
        if ValueType == 1 then
        set StrPercent[playerid] = value
        elseif ValueType == 2 then
        set AgiPercent[playerid] = value
        elseif ValueType ==3 then
        set IntPercent[playerid] = value
        elseif ValueType ==4 then
        set AttackPercent[playerid] = value
        elseif ValueType ==5 then
        set MaxHealthPercent[playerid] = value
        elseif ValueType ==6 then
        set MaxManaPercent[playerid] = value
        endif

    endfunction

    function MMRAPI_HeroSet takes player wichplayer , unit wichhero returns nothing
        set TargetUnit[GetPlayerId(wichplayer)] = wichhero
    endfunction

    function MmrApi_Init takes nothing returns nothing
        local integer loopTimes = 0
        loop
            exitwhen loopTimes<12
            set StrAppend[loopTimes] = 0
            set AgiAppend[loopTimes] = 0
            set IntAppend[loopTimes] = 0

            set StrPercent[loopTimes] = 0
            set AgiPercent[loopTimes] = 0
            set IntPercent[loopTimes] = 0
            set CanTrans[loopTimes] = true
            set loopTimes = loopTimes + 1 
        endloop
        set TransSkillDataTable = InitHashtable()
        set TransSkill = InitHashtable()
        //set PlayerGameCaChe = InitGameCache()
    endfunction

    function MMRAPI_HeroTransformation takes unit wichUnit , unitpool unitp returns nothing
        local unit needtransformation_unit
        local item array bagitem
        local real unit_x
        local real unit_y
        local real unitface
        local integer unitstr
        local integer unitagi
        local integer unitint
        local real unitattack
        local real unitattackrange
        local real unitattackspeed
        local real unitattackjiange
        local real unitmaxhealth
        local real unitmaxmana
        local real unitdefence
        local player unitcontralplayer
        local integer playerid
        local integer array skillid
        local integer array skilllevel

            if (IsUnitType(wichUnit, UNIT_TYPE_HERO) == true) then

            set needtransformation_unit = wichUnit
            set unit_x = GetUnitX(needtransformation_unit)
            set unit_y = GetUnitY(needtransformation_unit)
            set unitcontralplayer =  GetOwningPlayer(needtransformation_unit)
            set playerid = GetPlayerId(unitcontralplayer)
            set unitface = GetUnitFacing(needtransformation_unit)

            set bagitem[0] = UnitItemInSlot(needtransformation_unit , 0)
            set bagitem[1] = UnitItemInSlot(needtransformation_unit , 1)
            set bagitem[2] = UnitItemInSlot(needtransformation_unit , 2)
            set bagitem[3] = UnitItemInSlot(needtransformation_unit , 3)
            set bagitem[4] = UnitItemInSlot(needtransformation_unit , 4)
            set bagitem[5] = UnitItemInSlot(needtransformation_unit , 5)
            if bagitem[0] != null then
                call UnitRemoveItem(wichUnit , bagitem[0])    
            endif      
            if bagitem[1] != null then
                call UnitRemoveItem(wichUnit , bagitem[1])    
            endif 
            if bagitem[2] != null then
                call UnitRemoveItem(wichUnit , bagitem[2])    
            endif 
            if bagitem[3] != null then
                call UnitRemoveItem(wichUnit , bagitem[3])    
            endif 
            if bagitem[4] != null then
                call UnitRemoveItem(wichUnit , bagitem[4])    
            endif 
            if bagitem[5] != null then
                call UnitRemoveItem(wichUnit , bagitem[5])    
            endif 
            set skillid[0] = MMRAPI_GetPlayerUnitSkill(playerid , 1)
            set skillid[1] = MMRAPI_GetPlayerUnitSkill(playerid , 2)
            set skillid[2] = MMRAPI_GetPlayerUnitSkill(playerid , 3)
            set skillid[3] = MMRAPI_GetPlayerUnitSkill(playerid , 4)

            call MMRAPI_SetPlayerUnitSkillLevel(playerid , 1 , GetUnitAbilityLevel(wichUnit , skillid[0]))
            call MMRAPI_SetPlayerUnitSkillLevel(playerid , 2 , GetUnitAbilityLevel(wichUnit , skillid[1]))
            call MMRAPI_SetPlayerUnitSkillLevel(playerid , 3 , GetUnitAbilityLevel(wichUnit , skillid[2]))
            call MMRAPI_SetPlayerUnitSkillLevel(playerid , 4 , GetUnitAbilityLevel(wichUnit , skillid[3]))

            set skilllevel[0] = MMRAPI_GetPlayerUnitSkillLevel(playerid , 1)
            set skilllevel[1] = MMRAPI_GetPlayerUnitSkillLevel(playerid , 2)
            set skilllevel[2] = MMRAPI_GetPlayerUnitSkillLevel(playerid , 3)
            set skilllevel[3] = MMRAPI_GetPlayerUnitSkillLevel(playerid , 4)


            set unitstr = GetHeroStr(needtransformation_unit ,false )
            set unitagi = GetHeroAgi(needtransformation_unit ,false )
            set unitint = GetHeroInt(needtransformation_unit ,false )
            set unitmaxhealth = GetUnitState(needtransformation_unit, UNIT_STATE_MAX_LIFE)
            set unitmaxmana = GetUnitState(needtransformation_unit, UNIT_STATE_MAX_MANA)
            set unitdefence = GetUnitState(needtransformation_unit, ConvertUnitState(0x20))
            set unitattack = GetUnitState(needtransformation_unit, ConvertUnitState(0x12))
            set unitattackrange = GetUnitState(needtransformation_unit, ConvertUnitState(0x16))
            set unitattackjiange = GetUnitState(needtransformation_unit, ConvertUnitState(0x25))
            set unitattackspeed = GetUnitState(needtransformation_unit, ConvertUnitState(0x51))


            call RemoveUnit(needtransformation_unit)
            set needtransformation_unit = PlaceRandomUnit(unitp , unitcontralplayer , unit_x , unit_y , unitface)
            set TargetUnit[playerid]  =  needtransformation_unit

            call SetHeroStr(needtransformation_unit, unitstr , true)
            call SetHeroAgi(needtransformation_unit, unitagi , true)
            call SetHeroInt(needtransformation_unit, unitint , true)

            call SetUnitState(needtransformation_unit , UNIT_STATE_MAX_LIFE , unitmaxhealth)
            call SetUnitState(needtransformation_unit , UNIT_STATE_MAX_MANA , unitmaxmana)
            call SetUnitState(needtransformation_unit , ConvertUnitState(0x20) , unitdefence)
            call SetUnitState(needtransformation_unit , ConvertUnitState(0x12) , unitattack)
            call SetUnitState(needtransformation_unit ,  ConvertUnitState(0x16) , unitattackrange)
            call SetUnitState(needtransformation_unit , ConvertUnitState(0x25) , unitattackjiange)
            call SetUnitState(needtransformation_unit , ConvertUnitState(0x51) , unitattackspeed)
            call SelectUnitForPlayerSingle( needtransformation_unit , GetLocalPlayer() ) 
            

            if bagitem[0] != null then
                call UnitAddItem(needtransformation_unit , bagitem[0])    
            endif      
            if bagitem[1] != null then
                call UnitAddItem(needtransformation_unit , bagitem[1])    
            endif 
            if bagitem[2] != null then
                call UnitAddItem(needtransformation_unit , bagitem[2])    
            endif 
            if bagitem[3] != null then
                call UnitAddItem(needtransformation_unit , bagitem[3])    
            endif 
            if bagitem[4] != null then
                call UnitAddItem(needtransformation_unit , bagitem[4])    
            endif 
            if bagitem[5] != null then
                call UnitAddItem(needtransformation_unit , bagitem[5])    
            endif 


            if skillid[0] != 0 and skillid[0] != null then
                    call UnitAddAbility (needtransformation_unit , skillid[0])
                    call SetUnitAbilityLevel(needtransformation_unit , skillid[0] , skilllevel[0])
            endif 
            if skillid[1] != 0 and skillid[1] != null then
                    call UnitAddAbility (needtransformation_unit , skillid[1])
                    call SetUnitAbilityLevel(needtransformation_unit , skillid[1] , skilllevel[1])
            endif
            if skillid[2] != 0 and skillid[2] != null then
                    call UnitAddAbility (needtransformation_unit , skillid[2])
                    call SetUnitAbilityLevel(needtransformation_unit , skillid[2] , skilllevel[2])
            endif
            if skillid[3] != 0 and skillid[3] != null then
                    call UnitAddAbility (needtransformation_unit , skillid[3])
                    call SetUnitAbilityLevel(needtransformation_unit , skillid[3] , skilllevel[3])
            endif  
        endif
    endfunction

    function MMRAPI_DeleteSkillAsSoltAndHero takes player wichplayer ,integer wichskill returns nothing
        local integer playerid = GetPlayerId(wichplayer)
        if wichskill == 1 then
            call UnitRemoveAbility(TargetUnit[playerid] , PlayerUnitSkill_1[playerid])   
            set PlayerUnitSkill_1[playerid] = 0          
        endif
        if wichskill == 2 then
            call UnitRemoveAbility(TargetUnit[playerid] , PlayerUnitSkill_2[playerid])  
            set PlayerUnitSkill_2[playerid] = 0            
        endif
        if wichskill == 3 then
            call UnitRemoveAbility(TargetUnit[playerid] , PlayerUnitSkill_3[playerid])
            set PlayerUnitSkill_3[playerid] = 0              
        endif
        if wichskill == 4 then
            call UnitRemoveAbility(TargetUnit[playerid] , PlayerUnitSkill_4[playerid])
            set PlayerUnitSkill_4[playerid] = 0              
        endif
    endfunction

    function MMRAPI_SetInTransSkillHash takes integer FatherAbilt , integer SonAbilt1 , integer SonAbilt2 ,integer SonAbilt3 ,integer SonAbilt4 , integer TargetAbilt returns nothing
        call SaveInteger(TransSkillDataTable , TransSkillDataTableID , 0 , TargetAbilt)
        call SaveInteger(TransSkillDataTable , TransSkillDataTableID , 1 , SonAbilt1)
        call SaveInteger(TransSkillDataTable , TransSkillDataTableID , 2 , SonAbilt2)
        call SaveInteger(TransSkillDataTable , TransSkillDataTableID , 3 , SonAbilt3)
        call SaveInteger(TransSkillDataTable , TransSkillDataTableID , 4 , SonAbilt4)
        call SaveInteger(TransSkill , FatherAbilt , 0 , LoadInteger(TransSkill, FatherAbilt ,0) + 1 )
        call SaveInteger(TransSkill , FatherAbilt , LoadInteger(TransSkill, FatherAbilt ,0) , TransSkillDataTableID )
        set TransSkillDataTableID = TransSkillDataTableID + 1
    endfunction

    function MMRAPI_CheckTargetSkill takes integer fatherskill ,integer number returns integer tskill
        if LoadInteger(TransSkill , fatherskill  , 0 ) > 0 then
            return LoadInteger(TransSkillDataTable , LoadInteger(TransSkill , fatherskill  , number ) , 0 )
        endif
        return 0
    endfunction

    private function MMRAPI_CheckSkillCanTrans takes integer pid  , integer solt returns boolean can
        local integer myskill = MMRAPI_GetPlayerUnitSkill(pid , solt ) 
        local integer looptime = LoadInteger(TransSkill , myskill , 0 )
        local integer dataid
        local integer array dataskill
        local boolean array transskill 
        if CanTrans[pid] then
            if looptime >= 1 then
                loop
                    exitwhen looptime <= 0
                    set dataid =  LoadInteger(TransSkill , myskill , looptime )
                    set dataskill[0] = LoadInteger(TransSkillDataTable , dataid , 0 )
                    set dataskill[1] = LoadInteger(TransSkillDataTable , dataid , 1 )
                    set dataskill[2] = LoadInteger(TransSkillDataTable , dataid , 2 )
                    set dataskill[3] = LoadInteger(TransSkillDataTable , dataid , 3 )
                    set dataskill[4] = LoadInteger(TransSkillDataTable , dataid , 4 )
                    set transskill[1] = false
                    set transskill[2] = false
                    set transskill[3] = false
                    set transskill[4] = false
                    if (( dataskill[0] == null or dataskill[0] == 0 ) or (MMRAPI_GetSkillIdSolt(pid , dataskill[0]) != 0 )) == false then
                
                        if dataskill[1] != null and dataskill[1] != 0 then
                            set transskill[1] = GetUnitAbilityLevel(MMRAPI_TargetPlayer( Player( pid ) ) , dataskill[1]) > 0
                            if transskill[1] == true then
                                call UnitRemoveAbility( TargetUnit[pid], dataskill[1])
                                call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , dataskill[1]) , 0 )  
                            endif
                        endif
               
                        if dataskill[2] != null and dataskill[2] != 0 then
                            set transskill[2] = GetUnitAbilityLevel(MMRAPI_TargetPlayer( Player( pid ) ) , dataskill[2]) > 0
                            if transskill[2] == true then
                                call UnitRemoveAbility( TargetUnit[pid], dataskill[2])
                                call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , dataskill[2]) , 0 )                      
                            endif
                        endif
                        if dataskill[3] != null and dataskill[3] != 0 then
                            set transskill[3] = GetUnitAbilityLevel(MMRAPI_TargetPlayer( Player( pid ) ) , dataskill[3]) > 0
                            if transskill[3] == true then
                                call UnitRemoveAbility( TargetUnit[pid], dataskill[1])
                                call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , dataskill[3]) , 0 )                   
                            endif
                        endif
                        if dataskill[4] != null and dataskill[4] != 0 then
                            set transskill[4] = GetUnitAbilityLevel(MMRAPI_TargetPlayer( Player( pid ) ) , dataskill[4]) > 0
                            if transskill[4] == true then
                                call UnitRemoveAbility( TargetUnit[pid], dataskill[1])
                                call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , dataskill[4]) , 0 )  
                            endif
                        endif
                        if (transskill[1] or transskill[2]) or (transskill[3] or transskill[4]) then
                            call UnitRemoveAbility( TargetUnit[pid], myskill)
                            call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , myskill) , 0 )
                            call UnitAddAbility(TargetUnit[pid] , dataskill[0])
                            call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetNullSkillSolt(pid) , dataskill[0])
                    
                            call MMRAPI_CheckSkillCanTrans(pid , 1 )
                            call MMRAPI_CheckSkillCanTrans(pid , 2 )
                            call MMRAPI_CheckSkillCanTrans(pid , 3 )
                            call MMRAPI_CheckSkillCanTrans(pid , 4 )
                            return true
                        endif
                    endif
                    set looptime = looptime - 1 
                endloop
            endif     
        endif 
        return false
    endfunction

    function MMRAPI_CheckSkillCanTransReturnSkid takes integer pid  , integer solt  , integer checkskill returns boolean get
        local integer myskill = MMRAPI_GetPlayerUnitSkill(pid , solt ) 
        local integer looptime = LoadInteger(TransSkill , myskill , 0 )
        local integer looptime2 = 1
        local integer dataid
        local integer array dataskill
        local boolean Can = false
        if looptime >= 1 then
            loop
                exitwhen looptime <= 0
                set dataid =  LoadInteger(TransSkill , myskill , looptime )
                set dataskill[0] = LoadInteger(TransSkillDataTable , dataid , 0 )
                set dataskill[1] = LoadInteger(TransSkillDataTable , dataid , 1 )
                set dataskill[2] = LoadInteger(TransSkillDataTable , dataid , 2 )
                set dataskill[3] = LoadInteger(TransSkillDataTable , dataid , 3 )
                set dataskill[4] = LoadInteger(TransSkillDataTable , dataid , 4 )
                if (( dataskill[0] == null or dataskill[0] == 0 ) or (MMRAPI_GetSkillIdSolt(pid , dataskill[0]) != 0 )) == false then
                    if dataskill[1] != null and dataskill[1] != 0 and checkskill == dataskill[1] then
                        set Can = true
                    endif
                    if dataskill[2] != null and dataskill[2] != 0 and checkskill == dataskill[2] then
                        set Can = true
                    endif
                    if dataskill[3] != null and dataskill[3] != 0 and checkskill == dataskill[3] then
                        set Can = true
                    endif
                    if dataskill[4] != null and dataskill[4] != 0 and checkskill == dataskill[4] then
                        set Can = true
                    endif
                endif
               set looptime = looptime - 1 
            endloop
        endif 
        set looptime = LoadInteger(TransSkill , checkskill , 0 )
        if looptime >= 1 then
            loop
                exitwhen looptime <= 0
                set dataid =  LoadInteger(TransSkill , checkskill , looptime )
                set dataskill[0] = LoadInteger(TransSkillDataTable , dataid , 0 )
                set dataskill[1] = LoadInteger(TransSkillDataTable , dataid , 1 )
                set dataskill[2] = LoadInteger(TransSkillDataTable , dataid , 2 )
                set dataskill[3] = LoadInteger(TransSkillDataTable , dataid , 3 )
                set dataskill[4] = LoadInteger(TransSkillDataTable , dataid , 4 )
                if (( dataskill[0] == null or dataskill[0] == 0 ) or (MMRAPI_GetSkillIdSolt(pid , dataskill[0]) != 0 )) == false then
                    if dataskill[1] != null and dataskill[1] != 0 and myskill == dataskill[1] then
                        set Can = true
                    endif
                    if dataskill[2] != null and dataskill[2] != 0 and myskill == dataskill[2] then
                        set Can = true
                    endif
                    if dataskill[3] != null and dataskill[3] != 0 and myskill == dataskill[3] then
                        set Can = true
                    endif
                    if dataskill[4] != null and dataskill[4] != 0 and myskill == dataskill[4] then
                        set Can = true
                    endif
                endif
               set looptime = looptime - 1 
            endloop
        endif 

        return Can
    endfunction

    function MMRAPI_TransSkillFromHash takes integer pid , integer skillid , integer solt returns nothing
        local integer skilldata
        local integer fatherskill
        local integer targetskill
        local integer array checkskill

        set skilldata = 1
        set targetskill = LoadInteger(TransSkillDataTable , skillid , MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
        if (skillid != 0 or skillid != null) then
            if targetskill != null or targetskill != 0  then
                if MMRAPI_GetPlayerUnitSkill(pid , skilldata ) != 0 and MMRAPI_GetSkillIdSolt(pid , skillid) != 0 and GetUnitAbilityLevel(TargetUnit[pid] , targetskill) <= 0 then
                    call UnitRemoveAbility( TargetUnit[pid], MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
                    call MMRAPI_SetPlayerUnitSkill(pid , skilldata , 0 )
                    call UnitRemoveAbility( TargetUnit[pid], skillid)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , skillid) , 0 )
                    call UnitAddAbility(TargetUnit[pid] , targetskill)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetNullSkillSolt(pid) , targetskill)
                endif
            endif
        endif
        set skilldata = 2
        set targetskill = LoadInteger(TransSkillDataTable , skillid , MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
        if (skillid != 0 or skillid != null) then
            if targetskill != null or targetskill != 0  then
                if MMRAPI_GetPlayerUnitSkill(pid , skilldata ) != 0 and MMRAPI_GetSkillIdSolt(pid , skillid) != 0 and GetUnitAbilityLevel(TargetUnit[pid] , targetskill) <= 0 then
                    call UnitRemoveAbility( TargetUnit[pid], MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
                    call MMRAPI_SetPlayerUnitSkill(pid , skilldata , 0 )
                    call UnitRemoveAbility( TargetUnit[pid], skillid)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , skillid) , 0 )
                    call UnitAddAbility(TargetUnit[pid] , targetskill)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetNullSkillSolt(pid) , targetskill)
                endif
            endif
        endif
        set skilldata = 3
        set targetskill = LoadInteger(TransSkillDataTable , skillid , MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
        if (skillid != 0 or skillid != null) then
            if targetskill != null or targetskill != 0  then
                if MMRAPI_GetPlayerUnitSkill(pid , skilldata ) != 0 and MMRAPI_GetSkillIdSolt(pid , skillid) != 0 and GetUnitAbilityLevel(TargetUnit[pid] , targetskill) <= 0 then
                    call UnitRemoveAbility( TargetUnit[pid], MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
                    call MMRAPI_SetPlayerUnitSkill(pid , skilldata , 0 )
                    call UnitRemoveAbility( TargetUnit[pid], skillid)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , skillid) , 0 )
                    call UnitAddAbility(TargetUnit[pid] , targetskill)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetNullSkillSolt(pid) , targetskill)
                endif
            endif
        endif
        set skilldata = 4
        set targetskill = LoadInteger(TransSkillDataTable , skillid , MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
        if (skillid != 0 or skillid != null) then
            if targetskill != null or targetskill != 0  then
                if MMRAPI_GetPlayerUnitSkill(pid , skilldata ) != 0 and MMRAPI_GetSkillIdSolt(pid , skillid) != 0 and GetUnitAbilityLevel(TargetUnit[pid] , targetskill) <= 0 then
                    call UnitRemoveAbility( TargetUnit[pid], MMRAPI_GetPlayerUnitSkill(pid , skilldata ))
                    call MMRAPI_SetPlayerUnitSkill(pid , skilldata , 0 )
                    call UnitRemoveAbility( TargetUnit[pid], skillid)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetSkillIdSolt(pid , skillid) , 0 )
                    call UnitAddAbility(TargetUnit[pid] , targetskill)
                    call MMRAPI_SetPlayerUnitSkill(pid , MMRAPI_GetNullSkillSolt(pid) , targetskill)
                endif
            endif
        endif        
    endfunction

    function MMRAPI_ChangeCanTransState takes integer pid returns boolean can
        if CanTrans[pid] then
            set CanTrans[pid] = false
            return false
        else
            set CanTrans[pid] = true
            return true
        endif
        return false
    endfunction

    function MMRAPI_AddSkillAsSoltAndHero takes player wichplayer ,integer skillid returns nothing
        local integer pid = GetPlayerId(wichplayer)
        local integer skillsoltid = MMRAPI_GetNullSkillSolt(pid)
        if skillsoltid != 0 then
            if GetUnitAbilityLevel(TargetUnit[pid] , skillid) > 0 then
                call SetUnitAbilityLevel(TargetUnit[pid] , skillid , GetUnitAbilityLevel(TargetUnit[pid] , skillid) + 1)
            else
                call UnitAddAbility(TargetUnit[pid] , skillid)  
                call MMRAPI_SetPlayerUnitSkill(pid ,skillsoltid , skillid)
            endif
        else
            if GetUnitAbilityLevel(TargetUnit[pid] , skillid) > 0 then
                call SetUnitAbilityLevel(TargetUnit[pid] , skillid , GetUnitAbilityLevel(TargetUnit[pid] , skillid) + 1)
            endif
        endif

        // call MMRAPI_TransSkillFromHash(pid , MMRAPI_GetPlayerUnitSkill(pid , 1 ) , skillsoltid )
        // call MMRAPI_TransSkillFromHash(pid , MMRAPI_GetPlayerUnitSkill(pid , 2 ) , skillsoltid )
        // call MMRAPI_TransSkillFromHash(pid , MMRAPI_GetPlayerUnitSkill(pid , 3 ) , skillsoltid )
        // call MMRAPI_TransSkillFromHash(pid , MMRAPI_GetPlayerUnitSkill(pid , 4 ) , skillsoltid )

        // call MMRAPI_CheckSkillCanTrans(pid , 1 )
        // call MMRAPI_CheckSkillCanTrans(pid , 2 )
        // call MMRAPI_CheckSkillCanTrans(pid , 3 )
        // call MMRAPI_CheckSkillCanTrans(pid , 4 )
    endfunction


endlibrary

#endif  ///MMRAPIIncluded



#ifndef BagPackApiIncluded 
#define BagPackApiIncluded 

 
library BagPackApi requires BzAPI , YDWEYDWEJapiScript , MmrApi

    native function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
    
    struct RandomItem
        integer BaseItem = 0
        integer array TypeValue[6]
        integer array Value[6]
        integer TimeId

        method SetRandomItemBaseItemType takes integer thisitembasetype returns nothing
            set this.BaseItem = thisitembasetype
        endmethod

        method GetRandomItemBaseItemType takes nothing returns integer thisitembasetype
            return this.BaseItem
        endmethod

        method SetRandomItemType takes integer number , integer tyvalue returns nothing
            set this.TypeValue[number] = tyvalue
        endmethod

        method GetRandomItemType takes integer number returns integer thisitemtype
            return this.TypeValue[number]
        endmethod

        method SetRandomItemValue takes integer number , integer value returns nothing
            set this.Value[number] = value
        endmethod

        method GetRandomItemValue takes integer number returns integer thisitemvalue
            return this.Value[number]
        endmethod

        method SetRandomItemTimeId takes integer Tid returns nothing
            set this.TimeId = Tid
        endmethod

        method GetRandomItemTimeid takes nothing returns integer Tid
            return this.TimeId
        endmethod
    endstruct

    globals
    private RandomItem array MyBagItem

    private integer array BackPackUi
    private hashtable array BackPackHash
    private integer array BackPackItemValue
    private integer array PlayerChoosePage
    private integer array MouseInBagUi

    private boolean array PlayerBagCanUse_2
    private boolean array PlayerBagCanUse_3
    private boolean array PlayerBagCanUse_4
 

    private string BagPack_Base_BackGround_1_Texter = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
    private string BagPack_ItemShowBackGround_1_Texter = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
    private string BaseBagPackInmageSolt = "UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"
    private string BagPack_ChooseBagBottomOn = "ReplaceableTextures\\CommandButtons\\BTNMoonKey.blp"
    private string BagPack_ChooseBagBottomOFF = "ReplaceableTextures\\CommandButtons\\BTNGlyph.blp"

    boolean IsCanUseBagOn = true

    endglobals




    private function BagPackApi_GetItemBackPackItemSoltId takes integer wichframe returns integer sid
        local integer LoopA = 301
        loop
            exitwhen LoopA >320

            if wichframe ==  BackPackUi[LoopA]then
                return LoopA - 300
            endif

        set LoopA = LoopA + 1
        endloop
        return 0
    endfunction

    private function BagPackApi_ChangeBagPackLineTexter takes integer page  , integer solt  ,integer pid returns nothing
        local integer line = 4
        local integer wich = (solt - (solt /line) * line)
        local RandomItem loaditem
        local string needchangetexter
        local integer needChangeType = 0
        set line = (solt/4)
        if (wich == 0) then
        set wich = 4
        set line = (solt/4) - 1
        endif

        if LoadInteger(BackPackHash[pid] , page , solt) != null and PlayerChoosePage[pid] == page and LoadInteger(BackPackHash[pid] , page , solt) != -1 then
            set loaditem = LoadInteger(BackPackHash[pid] , page , solt)
            set needChangeType = loaditem.GetRandomItemBaseItemType()
            set needchangetexter = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, needChangeType, "Art")
            call DzFrameSetTexture(BackPackUi[wich + (4 * line) +100], needchangetexter, 0 )
            //call BJDebugMsg("solt")
        elseif LoadInteger(BackPackHash[pid] , page , solt) == -1 or LoadInteger(BackPackHash[pid] , page , solt) == null then
            call DzFrameSetTexture(BackPackUi[wich + (4 * line) +100], BaseBagPackInmageSolt, 0 )
        endif

    endfunction

    private function BagPackApi_WhenMouseInUnitBackPackItem takes nothing returns nothing
        local integer Infarm = DzGetTriggerUIEventFrame()
        local integer pid = GetPlayerId(GetLocalPlayer())
        local integer soltid = BagPackApi_GetItemBackPackItemSoltId(Infarm)
        local RandomItem newRandom
        local integer needChangeType
        local string needshowstr
        set MouseInBagUi[pid] = soltid
        set newRandom = LoadInteger(BackPackHash[pid], PlayerChoosePage[pid] , soltid)
        if newRandom.GetRandomItemBaseItemType() != 0 then
            set needChangeType = newRandom.GetRandomItemBaseItemType()
            set needshowstr = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, needChangeType, "Tip") + "|n"
            set needshowstr = needshowstr + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, needChangeType, "Ubertip") + "|n"
            //set needshowstr = needshowstr + I2S(newRandom.GetRandomItemTimeid()) +"掉落时间戳"
            //call BJDebugMsg("In" + I2S(soltid))
            call DzFrameSetText(BackPackUi[6] , needshowstr)
            call DzFrameSetTexture( BackPackUi[7], YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, needChangeType, "Art"), 0 )
            call DzFrameShow(BackPackUi[5] , true)
            call DzFrameShow(BackPackUi[6] , true)
            call DzFrameShow(BackPackUi[7] , true)
        endif
    endfunction

    private function BagPackApi_WhenMouseKickUnitBackPackItem takes nothing returns nothing
        call DzSyncData("BagPackApi_KickItem" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + I2S(DzGetTriggerUIEventFrame()))
    endfunction

    private function BagPackApi_WhenRigthMouseKickUnitBackPackItem takes nothing returns nothing
        local RandomItem removeitem = LoadInteger(BackPackHash[GetPlayerId(GetLocalPlayer())], PlayerChoosePage[GetPlayerId(GetLocalPlayer())] , MouseInBagUi[GetPlayerId(GetLocalPlayer())])

        if MouseInBagUi[GetPlayerId(GetLocalPlayer())] > 0 and DzGetTriggerKeyPlayer() == GetLocalPlayer() and removeitem.GetRandomItemBaseItemType() != 0 then
            call DzSyncData("BagPackApi_DeleteItem" , I2S(GetPlayerId(GetLocalPlayer())) + I2S(MouseInBagUi[GetPlayerId(GetLocalPlayer())]))    
            call removeitem.destroy()
            call SaveInteger(BackPackHash[GetPlayerId(GetLocalPlayer())] ,PlayerChoosePage[GetPlayerId(GetLocalPlayer())] ,MouseInBagUi[GetPlayerId(GetLocalPlayer())], -1 )
            call BagPackApi_ChangeBagPackLineTexter(PlayerChoosePage[GetPlayerId(GetLocalPlayer())] , MouseInBagUi[GetPlayerId(GetLocalPlayer())] , GetPlayerId(GetLocalPlayer()))
        endif
    endfunction

    private function BagPackApi_WhenMouseOutUnitBackPackItem takes nothing returns nothing
            call DzFrameShow(BackPackUi[5] , false)
            call DzFrameShow(BackPackUi[6] , false)
            call DzFrameShow(BackPackUi[7] , false)
            set MouseInBagUi[GetPlayerId(GetLocalPlayer())] = -1
    endfunction


    private function BagPackApi_CreateBagPackLine takes integer LineNumber returns nothing
        local integer looptimeB = 1
        local integer slot


        loop
            exitwhen looptimeB > 4
            set BackPackUi[looptimeB + (4 * LineNumber) +100] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[0], "template", 0)
            call DzFrameSetSize(BackPackUi[looptimeB + (4 * LineNumber) +100], 0.0327, 0.0342 )
            call DzFrameSetPoint(BackPackUi[looptimeB + (4 * LineNumber) +100], 6, BackPackUi[0], 6,-0.030 + (0.0358* looptimeB ), 0.1831 - (0.0400 * LineNumber)) 
            call DzFrameSetTexture(BackPackUi[looptimeB + (4 * LineNumber) +100], BaseBagPackInmageSolt, 0 )
            set BackPackUi[looptimeB+(4 * LineNumber) +200] = DzCreateFrameByTagName("TEXT", "name", BackPackUi[looptimeB + (4 * LineNumber) +100], "template", 0)
            call DzFrameSetSize( BackPackUi[looptimeB+(4 * LineNumber) +200], 0.01, 0.01 )
            call DzFrameSetPoint( BackPackUi[looptimeB+(4 * LineNumber) +200], 8, BackPackUi[looptimeB + (4 * LineNumber) +100], 8, 0.00, 0.00 )
            call DzFrameSetFont( BackPackUi[looptimeB+(4 * LineNumber) +200], "war3mapImported\\fonts.ttf", 0.01, 0 )
            call DzFrameSetText( BackPackUi[looptimeB+(4 * LineNumber) +200], "1" )
            call DzFrameShow( BackPackUi[looptimeB+(4 * LineNumber) +200] , false )
            set BackPackUi[looptimeB + (4 * LineNumber) + 300] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", BackPackUi[looptimeB + (4 * LineNumber) +100], "template", 0)
            call DzFrameSetSize(BackPackUi[looptimeB + (4 * LineNumber) + 300], 0.0327, 0.0342 )
            call DzFrameSetPoint(BackPackUi[looptimeB + (4 * LineNumber) + 300], 6, BackPackUi[looptimeB + (4 * LineNumber) +100], 6,0,0)
            if GetLocalPlayer() == GetLocalPlayer() then
                call DzFrameSetScriptByCode(BackPackUi[looptimeB + (4 * LineNumber) + 300] , 2 , function BagPackApi_WhenMouseInUnitBackPackItem , false)
                call DzFrameSetScriptByCode(BackPackUi[looptimeB + (4 * LineNumber) + 300] , 3 , function BagPackApi_WhenMouseOutUnitBackPackItem , false)
                call DzFrameSetScriptByCode(BackPackUi[looptimeB + (4 * LineNumber) + 300] , 1 , function BagPackApi_WhenMouseKickUnitBackPackItem , false)
                call DzFrameSetScriptByCode(BackPackUi[looptimeB + (4 * LineNumber) + 300] , 13 , function BagPackApi_WhenRigthMouseKickUnitBackPackItem , false)
            endif
            set looptimeB = looptimeB + 1
        endloop
    endfunction


    private function BagPackApi_ItemToBagPack takes player wichplayer , integer page , integer solt  , integer initemtype , integer timevalue returns nothing
        local RandomItem needsaveitem = RandomItem.create()
        call needsaveitem.SetRandomItemBaseItemType(initemtype)
        call needsaveitem.SetRandomItemTimeId(timevalue)
        call SaveInteger(BackPackHash[GetPlayerId(wichplayer)] , page , solt , needsaveitem)
        if wichplayer == GetLocalPlayer() then
    	    call BagPackApi_ChangeBagPackLineTexter(page , solt , GetPlayerId(wichplayer))
        endif
    endfunction

    private function BagPackApi_RemoveItemFormBagPack takes player wichplayer , integer page , integer solt returns nothing
        local RandomItem removeitem = LoadInteger(BackPackHash[GetPlayerId(wichplayer)] ,page ,solt)
        call removeitem.destroy()
        call SaveInteger(BackPackHash[GetPlayerId(wichplayer)] ,PlayerChoosePage[GetPlayerId(wichplayer)] ,solt, -1 )
        if wichplayer == GetLocalPlayer() then
    	    call BagPackApi_ChangeBagPackLineTexter(page , solt , GetPlayerId(wichplayer))
        endif
    endfunction

    private function BagPackApi_GetNullBag takes player wichplayer , integer page returns integer nullsolt
        local integer looptimeA = 1
        loop
            exitwhen looptimeA > 20
            if LoadInteger(BackPackHash[GetPlayerId(wichplayer)] , page , looptimeA) == null or LoadInteger(BackPackHash[GetPlayerId(wichplayer)] , page , looptimeA) == -1 then
                return looptimeA
            endif
            set looptimeA = looptimeA + 1
        endloop
        return 0
    endfunction

    function BagPackApi_SetItemToBag takes player wichplayer , item wichitem returns nothing
        local integer nullsolt = 0
        local integer itemtypeid = GetItemTypeId(wichitem)
        local integer pager = 1

        set nullsolt = BagPackApi_GetNullBag(wichplayer , 1 )

        if PlayerBagCanUse_2[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 2 )
            set pager = 2
        endif
        if PlayerBagCanUse_3[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 3 )
            set pager = 3
        endif
        if PlayerBagCanUse_4[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 4 )
            set pager = 4
        endif
        if nullsolt != 0 then
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , itemtypeid , 1)
            call RemoveItem(wichitem)
        else
            call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "装备背包已经满了")
        endif
    endfunction

    function BagPackApi_SetItemTypeToBag takes player wichplayer , integer wichitemtype returns nothing
        local integer nullsolt = 0
        local integer pager = 1

        set nullsolt = BagPackApi_GetNullBag(wichplayer , 1 )

        if PlayerBagCanUse_2[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 2 )
            set pager = 2
        endif
        if PlayerBagCanUse_3[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 3 )
            set pager = 3
        endif
        if PlayerBagCanUse_4[GetPlayerId(wichplayer)] and nullsolt == 0 then
            set nullsolt = BagPackApi_GetNullBag(wichplayer , 4 )
            set pager = 4
        endif
        if nullsolt != 0 then
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , wichitemtype , 1)
        else
            call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "装备背包已经满了")
        endif
    endfunction

    private function BagPackApi_WhneUnitKickChangeBottom takes nothing returns nothing
        local integer kickfarm = DzGetTriggerUIEventFrame()
        local integer pid = GetPlayerId(DzGetTriggerUIEventPlayer())
        local integer looptimeA = 1
        if kickfarm == BackPackUi [11] then
        call DzFrameShow(BackPackUi[21] , true)  
        call DzFrameShow(BackPackUi[22] , false) 
        call DzFrameShow(BackPackUi[23] , false) 
        call DzFrameShow(BackPackUi[24] , false) 
        set PlayerChoosePage[pid] = 1
        
        elseif kickfarm == BackPackUi [12] then
        call DzFrameShow(BackPackUi[21] , false)  
        call DzFrameShow(BackPackUi[22] , true) 
        call DzFrameShow(BackPackUi[23] , false) 
        call DzFrameShow(BackPackUi[24] , false) 
        set PlayerChoosePage[pid] = 2
        elseif kickfarm == BackPackUi [13] then
        call DzFrameShow(BackPackUi[21] , false)  
        call DzFrameShow(BackPackUi[22] , false) 
        call DzFrameShow(BackPackUi[23] , true) 
        call DzFrameShow(BackPackUi[24] , false) 
        set PlayerChoosePage[pid] = 3
        elseif kickfarm == BackPackUi [14] then
        call DzFrameShow(BackPackUi[21] , false)  
        call DzFrameShow(BackPackUi[22] , false) 
        call DzFrameShow(BackPackUi[23] , false) 
        call DzFrameShow(BackPackUi[24] , true) 
        set PlayerChoosePage[pid] = 4
        endif
        if DzGetTriggerUIEventPlayer() == GetLocalPlayer() then
            loop
                exitwhen looptimeA > 20
                call BagPackApi_ChangeBagPackLineTexter(PlayerChoosePage[pid], looptimeA , pid)
                set looptimeA = looptimeA + 1
            endloop
        endif
    endfunction

    private function CreateItemToUnit takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer itemtypeinteger = S2I( SubStringBJ(basedata , 2 , 20) )
        call UnitAddItem( MMRAPI_TargetPlayer(DzGetTriggerSyncPlayer()), CreateItem(itemtypeinteger , 0 , 0 ) )
    endfunction

    private function BagPackApi_GetDataForItemUiAndClean  takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer frame = S2I( SubStringBJ(basedata , 2 , 20) )
        local integer looptimeA = 301
        local integer solt = 0
        local integer page = PlayerChoosePage[pid]
        local RandomItem needcitem
        local integer itemtypeid
        local item createitem

        if IsCanUseBagOn == true then
            if ItemUseBag_GetNullSolt.evaluate(pid) != 0 and DzGetTriggerSyncPlayer() == GetLocalPlayer() then
                loop
                    exitwhen frame == BackPackUi[looptimeA] or looptimeA> 321
                    set looptimeA = looptimeA + 1
                endloop
                if looptimeA == 321 then
                    set solt = 0        
                else
                    set solt = looptimeA - 300
                    set needcitem = LoadInteger(BackPackHash[pid], page , solt )
                    if needcitem.GetRandomItemBaseItemType() != 0 and  needcitem.GetRandomItemBaseItemType() != null then
                        set itemtypeid = needcitem.GetRandomItemBaseItemType()
                        call BagPackApi_RemoveItemFormBagPack(DzGetTriggerSyncPlayer() , page , solt)
                        call DzSyncData("ItemUseBag_AddAB" , I2S(GetPlayerId(DzGetTriggerSyncPlayer())) + I2S(itemtypeid))    
                    endif

                    //set createitem = CreateItem(itemtypeid , 0 , 0 )
                    //call UnitAddItem( MMRAPI_TargetPlayer(DzGetTriggerSyncPlayer()), CreateItem(itemtypeid , 0 , 0 ) )
                endif
            elseif ItemUseBag_GetNullSolt.evaluate(pid) == 0 and DzGetTriggerSyncPlayer() == GetLocalPlayer() then
                call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "存档装备已经装备了6件了")
            endif
        else
            if MMRAPI_TargetPlayerBagIsNull(pid) and DzGetTriggerSyncPlayer() == GetLocalPlayer() then
                loop
                    exitwhen frame == BackPackUi[looptimeA] or looptimeA> 321
                    set looptimeA = looptimeA + 1
                endloop
                if looptimeA == 321 then
                    set solt = 0        
                else
                    set solt = looptimeA - 300
                    
                    set needcitem = LoadInteger(BackPackHash[pid], page , solt )
                    if needcitem.GetRandomItemBaseItemType() != 0 and  needcitem.GetRandomItemBaseItemType() != null then
                        set itemtypeid = needcitem.GetRandomItemBaseItemType()
                        call BagPackApi_RemoveItemFormBagPack(DzGetTriggerSyncPlayer() , page , solt)
                        call DzSyncData("BagPackApi_CreateItem" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + I2S(itemtypeid))
                    endif

                    //set createitem = CreateItem(itemtypeid , 0 , 0 )
                    //call UnitAddItem( MMRAPI_TargetPlayer(DzGetTriggerSyncPlayer()), CreateItem(itemtypeid , 0 , 0 ) )
                endif
            elseif MMRAPI_TargetPlayerBagIsNull(pid) == false and DzGetTriggerSyncPlayer() == GetLocalPlayer() then
                call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "英雄身上装备满了")
            endif
            
        endif

    endfunction

    function BagPackApi_UiCreate takes nothing returns nothing
        local trigger newtrigger
        local integer looptimeA
        local trigger right_mouse_kick

        set right_mouse_kick = CreateTrigger()
        call DzTriggerRegisterMouseEventTrg( right_mouse_kick, 1, 2 )
        call TriggerAddAction(right_mouse_kick, function BagPackApi_WhenRigthMouseKickUnitBackPackItem)
        set MouseInBagUi[0] = -1
        set MouseInBagUi[1] = -1
        set MouseInBagUi[2] = -1
        set MouseInBagUi[3] = -1

        set BackPackHash[0] = InitHashtable()
        set BackPackHash[1] = InitHashtable()
        set BackPackHash[2] = InitHashtable()
        set BackPackHash[3] = InitHashtable()
        set BackPackHash[4] = InitHashtable()
        set BackPackHash[5] = InitHashtable()
        set BackPackHash[6] = InitHashtable()
        set BackPackHash[7] = InitHashtable()

        set PlayerChoosePage[0] = 1
        set PlayerChoosePage[1] = 1
        set PlayerChoosePage[2] = 1
        set PlayerChoosePage[3] = 1
        set PlayerChoosePage[4] = 1
        set PlayerChoosePage[5] = 1
        set PlayerChoosePage[6] = 1
        set PlayerChoosePage[7] = 1

        set PlayerBagCanUse_2[0] = false
        set PlayerBagCanUse_2[1] = false
        set PlayerBagCanUse_2[2] = false
        set PlayerBagCanUse_2[3] = false
        set PlayerBagCanUse_2[4] = false
        set PlayerBagCanUse_2[5] = false
        set PlayerBagCanUse_2[6] = false
        set PlayerBagCanUse_2[7] = false

        set PlayerBagCanUse_3[0] = false
        set PlayerBagCanUse_3[1] = false
        set PlayerBagCanUse_3[2] = false
        set PlayerBagCanUse_3[3] = false
        set PlayerBagCanUse_3[4] = false
        set PlayerBagCanUse_3[5] = false
        set PlayerBagCanUse_3[6] = false
        set PlayerBagCanUse_3[7] = false

        set PlayerBagCanUse_4[0] = false
        set PlayerBagCanUse_4[1] = false
        set PlayerBagCanUse_4[2] = false
        set PlayerBagCanUse_4[3] = false
        set PlayerBagCanUse_4[4] = false
        set PlayerBagCanUse_4[5] = false
        set PlayerBagCanUse_4[6] = false
        set PlayerBagCanUse_4[7] = false


        /*基础底图创建*/
        set BackPackUi[0] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
        call DzFrameSetAbsolutePoint( BackPackUi[0], 6, 0.51, 0.2 )
        call DzFrameSetSize( BackPackUi[0], 0.15, 0.3 )
        call DzFrameSetTexture( BackPackUi[0], BagPack_Base_BackGround_1_Texter, 0 )
        call DzFrameShow( BackPackUi[0], false )
        /*选择背包按钮创建*/
        set BackPackUi[1] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[0], "template", 0)
        call DzFrameSetPoint( BackPackUi[1], 2 , BackPackUi[0] , 0 , -0.003, -0.005 )
        call DzFrameSetSize( BackPackUi[1], 0.04, 0.04 )
        call DzFrameSetTexture( BackPackUi[1], BagPack_ChooseBagBottomOFF, 0 )
        set BackPackUi[11] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", BackPackUi[1], "template", 0)
        call DzFrameSetPoint( BackPackUi[11], 6 , BackPackUi[1] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[11], 0.04, 0.04 )
        set BackPackUi[21] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[11], "template", 0)
        call DzFrameSetPoint( BackPackUi[21], 6 , BackPackUi[11] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[21], 0.04, 0.04 )
        call DzFrameShow(BackPackUi[21] , true)
        call DzFrameSetTexture( BackPackUi[21], BagPack_ChooseBagBottomOn, 0 )

        if GetLocalPlayer() == GetLocalPlayer() then
    	    call DzFrameSetScriptByCode(BackPackUi[11] , 1 , function BagPackApi_WhneUnitKickChangeBottom , false)
        endif

        set BackPackUi[2] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[0], "template", 0)
        call DzFrameSetPoint( BackPackUi[2], 0 , BackPackUi[1] , 6 , 0, -0.003 )
        call DzFrameSetSize( BackPackUi[2], 0.04, 0.04 )
        call DzFrameSetTexture( BackPackUi[2], BagPack_ChooseBagBottomOFF, 0 )
        set BackPackUi[12] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", BackPackUi[2], "template", 0)
        call DzFrameSetPoint( BackPackUi[12], 6 , BackPackUi[2] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[12], 0.04, 0.04 )
        set BackPackUi[22] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[12], "template", 0)
        call DzFrameSetPoint( BackPackUi[22], 6 , BackPackUi[12] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[22], 0.04, 0.04 )
        call DzFrameShow(BackPackUi[22] , false)
        call DzFrameSetTexture( BackPackUi[22], BagPack_ChooseBagBottomOn, 0 )

        if GetLocalPlayer() == GetLocalPlayer() then
    	    call DzFrameSetScriptByCode(BackPackUi[12] , 1 , function BagPackApi_WhneUnitKickChangeBottom , false)
        endif

        set BackPackUi[3] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[0], "template", 0)
        call DzFrameSetPoint( BackPackUi[3], 0 , BackPackUi[2] , 6 , 0, -0.003 )
        call DzFrameSetSize( BackPackUi[3], 0.04, 0.04 )
        call DzFrameSetTexture( BackPackUi[3], BagPack_ChooseBagBottomOFF, 0 )
        set BackPackUi[13] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", BackPackUi[3], "template", 0)
        call DzFrameSetPoint( BackPackUi[13], 6 , BackPackUi[3] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[13], 0.04, 0.04 )
        set BackPackUi[23] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[13], "template", 0)
        call DzFrameSetPoint( BackPackUi[23], 6 , BackPackUi[13] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[23], 0.04, 0.04 )
        call DzFrameShow(BackPackUi[23] , false)
        call DzFrameSetTexture( BackPackUi[23], BagPack_ChooseBagBottomOn, 0 )

        if GetLocalPlayer() == GetLocalPlayer() then
    	    call DzFrameSetScriptByCode(BackPackUi[13] , 1 , function BagPackApi_WhneUnitKickChangeBottom , false)
        endif

        set BackPackUi[4] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[0], "template", 0)
        call DzFrameSetPoint( BackPackUi[4], 0 , BackPackUi[3] , 6 , 0, -0.003 )
        call DzFrameSetSize( BackPackUi[4], 0.04, 0.04 )
        call DzFrameSetTexture( BackPackUi[4], BagPack_ChooseBagBottomOFF, 0 )
        set BackPackUi[14] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", BackPackUi[4], "template", 0)
        call DzFrameSetPoint( BackPackUi[14], 6 , BackPackUi[4] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[14], 0.04, 0.04 )
        set BackPackUi[24] = DzCreateFrameByTagName("BACKDROP", "name", BackPackUi[14], "template", 0)
        call DzFrameSetPoint( BackPackUi[24], 6 , BackPackUi[14] , 6 , 0, 0 )
        call DzFrameSetSize( BackPackUi[24], 0.04, 0.04 )
        call DzFrameShow(BackPackUi[24] , false)
        call DzFrameSetTexture( BackPackUi[24], BagPack_ChooseBagBottomOn, 0 )

        if GetLocalPlayer() == GetLocalPlayer() then
    	    call DzFrameSetScriptByCode(BackPackUi[14] , 1 , function BagPackApi_WhneUnitKickChangeBottom , false)
        endif

        /*鼠标进入按钮说明创建*/
        set BackPackUi[5] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
        call DzFrameSetPoint( BackPackUi[5], 6, BackPackUi[0], 6, 0.1509, 0.09 )
        call DzFrameSetSize( BackPackUi[5], 0.11, 0.21 )
        call DzFrameSetTexture( BackPackUi[5], BagPack_ItemShowBackGround_1_Texter, 0 )
        call DzFrameShow( BackPackUi[5], true )
        set BackPackUi[6] = DzCreateFrameByTagName("TEXT", "name", BackPackUi[5], "template", 0)
        call DzFrameSetPoint( BackPackUi[6], 6, BackPackUi[5], 6, 0.0074, -0.024 )
        call DzFrameSetSize( BackPackUi[6], 0.09, 0.18 )
        call DzFrameSetFont( BackPackUi[6], "war3mapImported\\fonts.ttf", 0.01, 0 )
        call DzFrameSetText(BackPackUi[6] , "吃吃初次惆怅长岑长擦擦擦擦擦擦擦擦擦")
        set BackPackUi[7] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
        call DzFrameSetPoint( BackPackUi[7], 6, BackPackUi[5], 6, 0.01, 0.16 )
        call DzFrameSetSize( BackPackUi[7], 0.04, 0.04 )
        call DzFrameSetTexture( BackPackUi[7], "ReplaceableTextures\\CommandButtons\\BTNAlleriaFlute.blp", 0 )
        call DzFrameShow(BackPackUi[5] , false)
        call DzFrameShow(BackPackUi[6] , false)
        call DzFrameShow(BackPackUi[7] , false)
        set looptimeA = 0
        loop
            exitwhen looptimeA > 4
               call BagPackApi_CreateBagPackLine(looptimeA)
            set looptimeA = looptimeA + 1
        endloop

        set newtrigger = CreateTrigger()
        call DzTriggerRegisterSyncData(newtrigger , "BagPackApi_KickItem" , false)
        call TriggerAddAction(newtrigger , function BagPackApi_GetDataForItemUiAndClean)
        set newtrigger = CreateTrigger()
        call DzTriggerRegisterSyncData(newtrigger , "BagPackApi_CreateItem" , false)
        call TriggerAddAction(newtrigger , function CreateItemToUnit)

    endfunction

    function BagPackApi_UiShowOrClose takes player tplayer returns nothing
        if IsCanUseBagOn == true then
            call ItemUseBag_ShowUseBag.execute(tplayer)
        endif
        if tplayer == GetLocalPlayer() and DzFrameIsVisible(BackPackUi[0]) == false then
            call DzFrameShow( BackPackUi[0], true )
            call DzFrameSetTexture( BackPackUi[0], BagPack_Base_BackGround_1_Texter, 0 )
            if PlayerBagCanUse_2[GetPlayerId(tplayer)] == false then
                call DzFrameShow(BackPackUi[2] , false )
            endif
            if PlayerBagCanUse_3[GetPlayerId(tplayer)] == false then
                call DzFrameShow(BackPackUi[3] , false )
            endif
            if PlayerBagCanUse_4[GetPlayerId(tplayer)] == false then
                call DzFrameShow(BackPackUi[4] , false )
            endif
        elseif tplayer == GetLocalPlayer() and DzFrameIsVisible(BackPackUi[0]) == true then
            call DzFrameShow( BackPackUi[0] , false )
        endif
    endfunction

    function BagPackApi_SetBackGround takes string Base , string ItemShow , string bottonon , string bottonclose returns nothing
        set BagPack_Base_BackGround_1_Texter = Base
        set BagPack_ItemShowBackGround_1_Texter = ItemShow
        set BagPack_ChooseBagBottomOn = bottonon
        set BagPack_ChooseBagBottomOFF = bottonclose
    endfunction

    function BagPackApi_SetPlayerBagPackCanUse takes player wich , boolean bag2 , boolean bag3 , boolean bag4 returns nothing
        set PlayerBagCanUse_2[GetPlayerId(wich)] = bag2
        set PlayerBagCanUse_3[GetPlayerId(wich)] = bag3
        set PlayerBagCanUse_4[GetPlayerId(wich)] = bag4
    endfunction
endlibrary

#endif


#ifndef DamageShowIncluded
#define DamageShowIncluded

library DamageShow requires optional BzAPI , YDWEYDWEJapiScript , MmrApi

    globals
        private integer array UiDamQuick
        private real array Damage
        private integer array Soft
        private string array playart
    endglobals

    function DAMAGESHOW_PlayerArtSet takes player pl returns nothing
        set playart[GetPlayerId(pl)] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_UNIT,GetUnitTypeId(MMRAPI_TargetPlayer(pl)) , "Art")
    endfunction

    function DAMAGESHOW_DamageAdd takes player playerwho  , real value returns nothing
        set Damage[GetPlayerId(playerwho)] = Damage[GetPlayerId(playerwho)] + value
    endfunction

    function DAMAGESHOW_DamageNull takes player playerwho  returns nothing
        set Damage[GetPlayerId(playerwho)] = 0
    endfunction

    private function DAMAGESHOW_HideActions takes nothing returns nothing
        local player p = DzGetTriggerUIEventPlayer()
        if DzFrameIsVisible(UiDamQuick[0]) then
            if (p == GetLocalPlayer()) then
                call DzFrameShow( UiDamQuick[0], false )
                call DzFrameSetTexture( UiDamQuick[1], "DamageShow\\Tasktip.tga", 0 )
            endif
        else
            if (p == GetLocalPlayer()) then
                call DzFrameShow( UiDamQuick[0], true )
                call DzFrameSetTexture( UiDamQuick[1], "DamageShow\\Taskhide.tga", 0 )
            endif
        endif
    endfunction

    private function DAMAGESHOW_Create takes nothing returns nothing
        local integer loopa
        local integer n
        // Dam
        set n = 0
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "rw" + I2S(n) ), DzGetGameUI(), "template", 0)
        call DzFrameSetSize( UiDamQuick[n], 0.13, 0.18 )
        call DzFrameSetPoint( UiDamQuick[n], 2, DzGetGameUI(), 5, 0.00, 0.1 )
        call DzFrameSetTexture( UiDamQuick[n], "DamageShow\\taskbg.tga", 0 )
        call DzFrameShow( UiDamQuick[n], false )
        set n = 1
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "rw" + I2S(n) ), DzGetGameUI(), "template", 0)
        call DzFrameSetSize( UiDamQuick[n], 0.0431, 0.0237 )
        call DzFrameSetPoint( UiDamQuick[n], 8, UiDamQuick[0], 2, 0.00, 0.00 )
        call DzFrameSetTexture( UiDamQuick[n], "DamageShow\\Taskhide.tga", 0 )
        call DzFrameShow( UiDamQuick[n], false )
        set n = 2
        set UiDamQuick[n] = DzCreateFrameByTagName("TEXT", ( "rw" + I2S(n) ), DzGetGameUI(), "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 0, UiDamQuick[1], 0, 0.00, 0.00 )
        call DzFrameSetPoint( UiDamQuick[n], 8, UiDamQuick[1], 8, 0.00, 0.00 )
        call DzFrameSetScriptByCode(UiDamQuick[n], 1, function DAMAGESHOW_HideActions, true)
        call DzFrameSetEnable( UiDamQuick[n], false )
        set n = 101
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 2, UiDamQuick[0], 2, -0.004, -0.012 )
        call DzFrameSetSize( UiDamQuick[n], 0.025, 0.025 )
        call DzFrameSetTexture( UiDamQuick[n], "ReplaceableTextures\\CommandButtons\\BTNArthas.blp", 0 )
        set n = 102
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 2, UiDamQuick[0], 2, -0.004, -0.042 )
        call DzFrameSetSize( UiDamQuick[n], 0.025, 0.025 )
        call DzFrameSetTexture( UiDamQuick[n], "ReplaceableTextures\\CommandButtons\\BTNArthas.blp", 0 )
        set n = 103
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 2, UiDamQuick[0], 2, -0.004, -0.072 )
        call DzFrameSetSize( UiDamQuick[n], 0.025, 0.025 )
        call DzFrameSetTexture( UiDamQuick[n], "ReplaceableTextures\\CommandButtons\\BTNArthas.blp", 0 )
        set n = 104
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 2, UiDamQuick[0], 2, -0.004, -0.102 )
        call DzFrameSetSize( UiDamQuick[n], 0.025, 0.025 )
        call DzFrameSetTexture( UiDamQuick[n], "ReplaceableTextures\\CommandButtons\\BTNArthas.blp", 0 )
        set n = 105
        set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
        call DzFrameSetPoint( UiDamQuick[n], 2, UiDamQuick[0], 2, -0.004, -0.132 )
        call DzFrameSetSize( UiDamQuick[n], 0.025, 0.025 )
        call DzFrameSetTexture( UiDamQuick[n], "ReplaceableTextures\\CommandButtons\\BTNArthas.blp", 0 )
        
        set loopa = 201
        loop
            exitwhen loopa > 205
            set n = loopa
            set UiDamQuick[n] = DzCreateFrameByTagName("BACKDROP", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
            call DzFrameSetPoint( UiDamQuick[n], 8, UiDamQuick[( n - 100 )], 6, 0, 0.00 )
            call DzFrameSetSize( UiDamQuick[n], ( 110.00 / 1280.00 ), ( 20.00 / 1280.00 ) )
            call DzFrameSetTexture( UiDamQuick[n], "DamageShow\\p" + I2S(( n - 200 )) + ".tga", 0 )
            set loopa = loopa + 1
        endloop

        set loopa = 301
        loop
            exitwhen loopa > 305
            set n = loopa
            set UiDamQuick[n] = DzCreateFrameByTagName("TEXT", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
            call DzFrameSetPoint( UiDamQuick[n], 8, UiDamQuick[( n - 100 )], 2, -0.005, 0.00 )
            call DzFrameSetFont( UiDamQuick[n], "FontsZiTi_ui.ttf", 0.01, 0 )
            call DzFrameSetPriority( UiDamQuick[n], 1 )
            set loopa = loopa + 1
        endloop

        set loopa = 401
        loop
            exitwhen loopa > 405
            set n = loopa
            set UiDamQuick[n] = DzCreateFrameByTagName("TEXT", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
            call DzFrameSetPoint( UiDamQuick[n], 5, UiDamQuick[( n - 200 )], 5, -0.174875, 0.00 )
            call DzFrameSetFont( UiDamQuick[n], "FontsZiTi_ui.ttf", 0.01, 0 )
            call DzFrameSetPriority( UiDamQuick[n], 1 )
        set loopa = loopa + 1
        endloop

        set loopa = 501
        loop
            exitwhen loopa > 505
            set n = loopa
            set UiDamQuick[n] = DzCreateFrameByTagName("TEXT", ( "blood" + I2S(n) ), UiDamQuick[0], "template", 0)
            call DzFrameSetPoint( UiDamQuick[n], 4, UiDamQuick[( n - 300 )], 5, -0.0559375, 0.00 )
            call DzFrameSetFont( UiDamQuick[n], "FontsZiTi_ui.ttf", 0.01, 0 )
            call DzFrameSetPriority( UiDamQuick[n], 1 )
            set loopa = loopa + 1
        endloop
        
        call DestroyTrigger( GetTriggeringTrigger() )
    endfunction

    private function CheckBubble takes integer leftindex , integer rightindex  returns integer wintime
        local integer looptime = 0
        local integer temptime = 0
        local integer tyid = leftindex
        loop
            exitwhen looptime > rightindex
            if Damage[leftindex] < Damage[looptime] and leftindex != looptime then
                set temptime = temptime + 1
            endif
            set looptime = looptime + 1
        endloop
            return temptime
    endfunction

    private function BubbleSort takes integer leftindex , integer rightindex  returns nothing//冒泡
        local integer looptimes = 0
        if (leftindex >= rightindex) then//
		    return
        endif
        loop
            exitwhen looptimes >= 5
            set Soft[CheckBubble.evaluate(looptimes , rightindex)] = looptimes
            set looptimes = looptimes + 1
        endloop
    endfunction


    private function DAMAGESHOW_TimerFunction takes nothing returns nothing
        local integer loopa
        local integer loops
        local real damageforall = Damage[0] + Damage[1] + Damage[2] + Damage[3] + Damage[4]
        local integer playerid
        local string stringggg
        local timer timerc
        local integer cleantime = 100
        call BubbleSort.execute(0 , 5)
        set loopa = 1

        loop
            exitwhen loopa > 5
            if ((GetPlayerSlotState(Player(loopa - 1)) == PLAYER_SLOT_STATE_PLAYING) and (GetPlayerController(Player(loopa - 1)) == MAP_CONTROL_USER)) then
                if ((Player(loopa - 1) == GetLocalPlayer())) then
                    set loops = 1
                    loop
                        exitwhen loops > 5
                        set playerid = Soft[loops - 1]
                        if ((Damage[playerid] > 10.00)) then
                            call DzFrameShow( UiDamQuick[( loops + 100 )], true )
                            call DzFrameShow( UiDamQuick[( loops + 200 )], true )
                            call DzFrameShow( UiDamQuick[( loops + 300 )], true )
                            call DzFrameShow( UiDamQuick[( loops + 400 )], false )
                            call DzFrameShow( UiDamQuick[( loops + 500 )], true )
                            call DzFrameSetTexture( UiDamQuick[( loops + 100 )], playart[playerid] , 0 )
                            call DzFrameSetTexture( UiDamQuick[( loops + 200 )], "DamageShow\\p" + I2S(playerid + 1 ) + ".tga", 0 )
                            call DzFrameSetSize( UiDamQuick[( loops + 200 )],  ((110.00 * (Damage[playerid] / damageforall))/1280.00), ( 20.00 / 1280.00 ) )
                            call DzFrameSetText( UiDamQuick[( loops + 300 )], GetPlayerName(Player(playerid)))
                            call DzFrameSetText( UiDamQuick[( loops + 400 )],  R2SW( (Damage[playerid] / damageforall)  * 100.00 , 1, 2) + "%" ) 
                            if (Damage[playerid] / 10000000000.00) > 1 then
                                set stringggg = R2SW(( Damage[playerid] / 10000000000.00 ), 1, 2) + "百亿"
                            elseif (Damage[playerid] / 100000000.00) > 1 then
                                set stringggg = R2SW(( Damage[playerid] / 100000000.00 ), 1, 2) + "亿"
                            elseif (Damage[playerid] / 1000000.00) > 1 then
                                set stringggg = R2SW(( Damage[playerid] / 1000000.00 ), 1, 2) + "百万"
                            elseif (Damage[playerid] / 10000.00) > 1 then
                                set stringggg = R2SW(( Damage[playerid] / 10000.00 ), 1, 2) + "万"
                            else
                                set stringggg = R2SW(Damage[playerid], 1, 2)
                            endif
                            call DzFrameSetText( UiDamQuick[( loops + 500 )], "|cffffffff" + stringggg)
                            set Damage[playerid] = 0.1
                        else
                            call DzFrameShow( UiDamQuick[( loops + 100 )], false )
                            call DzFrameShow( UiDamQuick[( loops + 200 )], false )
                            call DzFrameShow( UiDamQuick[( loops + 300 )], false )
                            call DzFrameShow( UiDamQuick[( loops + 400 )], false )
                            call DzFrameShow( UiDamQuick[( loops + 500 )], false )
                        endif
                        set loops = loops + 1
                    endloop
                endif
            endif
            set loopa = loopa + 1
        endloop
    endfunction


    private function DAMAGESHOW_TimeCreateAndStart takes nothing returns nothing
        local timer timerc
        set timerc = CreateTimer()
        call TimerStart(timerc, 1 , true , function DAMAGESHOW_TimerFunction)
        set timerc = null
    endfunction

    private function DAMAGESHOW_TimeOn takes nothing returns nothing
        local integer loopa
            set loopa = 0
        loop
            exitwhen loopa > 4
            if ((GetPlayerSlotState(Player(loopa)) == PLAYER_SLOT_STATE_PLAYING) and (GetPlayerController(Player(loopa)) == MAP_CONTROL_USER)) then
                if ((Player(loopa) == GetLocalPlayer())) then
                call DzFrameShow( UiDamQuick[0], true )
                call DzFrameShow( UiDamQuick[1], true )
                call DzFrameSetEnable( UiDamQuick[2], true )
                endif
            endif
        set loopa = loopa + 1
        endloop
        call DAMAGESHOW_TimeCreateAndStart()
    endfunction

    function DAMAGESHOW_Init takes nothing returns nothing
        local integer lp = 0

        loop
            exitwhen lp > 4
            set Damage[lp] = 0.1
            set Soft[lp] = lp
            set lp = lp + 1
        endloop

        call DAMAGESHOW_Create()
        call DAMAGESHOW_TimeOn()
    endfunction

endlibrary

#endif

#ifndef FuncItemSystemIncluded
#define FuncItemSystemIncluded

library FuncItemSystem requires optional YDWEBase,YDWETriggerEvent,YDWEEventDamageData,YDWEAbilityState,MmrApi , DamageShow
	
	globals
		/*
属性ID		装备上的属性名称
0		基础攻击
1		攻击附加
2		基础护甲
3		护甲附加
4		攻击速度
5		攻击间隔
6		攻击范围
7		移动速度
8		技能冷却
9		基础力量
10		基础敏捷
11		基础智力
12		力量附加
13		敏捷附加
14		智力附加
15		力量百分比
16		敏捷百分比
17		智力百分比
18		最大生命值
19		最大生命百分比
20		最大魔法值
21		最大魔法百分比
22		物理暴击概率
23		物理暴击伤害
24		魔法暴击概率
25		魔法暴击伤害
26		技能伤害加成
27		技能附加伤害
28		攻击附加伤害
29		每秒攻击力
30		每秒力量
31		每秒敏捷
32		每秒智力
33		每秒最大生命
34		每秒最大魔法
35		每秒金币
36		每秒木材
37		每秒生命回复
38		每秒魔法回复
39		杀敌攻击力
40		杀敌力量
41		杀敌敏捷
42		杀敌智力
43		杀敌最大生命值
44		杀敌最大魔法值
45		杀敌经验值
46		杀敌经验值加成
47		杀敌金币
48		杀敌金币加成
49		杀敌木材
50		杀敌木材加成
51		物理伤害
52		魔法伤害
53		最终伤害
54		物理吸血
55		法术吸血
56		普通怪增伤
57		精英怪增伤
58		Boss增伤
59		物理减伤
60		魔法减伤

		*/
        private constant integer ITEM_SYSTEM_ATTACK = 0	
		private constant integer ITEM_SYSTEM_ATTACK_APPEND = 1
        private constant integer ITEM_SYSTEM_ARMOR = 2
        private constant integer ITEM_SYSTEM_ARMOR_APPEND = 3
        private constant integer ITEM_SYSTEM_ATTACK_SPEED = 4
		private constant integer ITEM_SYSTEM_ATTACK_DELAY = 5	
		private constant integer ITEM_SYSTEM_ATTACK_FAR = 6
        private constant integer ITEM_SYSTEM_MOVE_SPEED = 7
        private constant integer ITEM_SYSTEM_SKILL_COLD_DOWN = 8
        private constant integer ITEM_SYSTEM_STR = 9
        private constant integer ITEM_SYSTEM_AGI = 10
        private constant integer ITEM_SYSTEM_INT = 11
        private constant integer ITEM_SYSTEM_STR_APPEND = 12
		private constant integer ITEM_SYSTEM_AGI_APPEND = 13
		private constant integer ITEM_SYSTEM_INT_APPEND = 14
        private constant integer ITEM_SYSTEM_STR_PERCENT = 15
		private constant integer ITEM_SYSTEM_AGI_PERCENT = 16
		private constant integer ITEM_SYSTEM_INT_PERCENT = 17
		private constant integer ITEM_SYSTEM_MAX_HEALTH = 18
        private constant integer ITEM_SYSTEM_MAX_HEALTH_PERCENT = 19
		private constant integer ITEM_SYSTEM_MAX_MANA = 20
        private constant integer ITEM_SYSTEM_MAX_MANA_PERCENT = 21
		private constant integer ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE = 22
		private constant integer ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT = 23
		private constant integer ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE = 24
		private constant integer ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT = 25
		private constant integer ITEM_SYSTEM_SKILL_DAMAGE_PERCENT = 26
        private constant integer ITEM_SYSTEM_SKILL_DAMAGE_APPEDN = 27
        private constant integer ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN = 28
        private constant integer ITEM_SYSTEM_TIME_ATTACK = 29
        private constant integer ITEM_SYSTEM_TIME_STR = 30
        private constant integer ITEM_SYSTEM_TIME_INT = 31
        private constant integer ITEM_SYSTEM_TIME_AGI = 32
        private constant integer ITEM_SYSTEM_TIME_MAX_HEALTH = 33
        private constant integer ITEM_SYSTEM_TIME_MAX_MANA = 34
        private constant integer ITEM_SYSTEM_TIME_GOLD = 35
        private constant integer ITEM_SYSTEM_TIME_WOOD = 36
        private constant integer ITEM_SYSTEM_TIME_HEALTH = 37
        private constant integer ITEM_SYSTEM_TIME_MANA = 38
        private constant integer ITEM_SYSTEM_KILL_ATTACK = 39
        private constant integer ITEM_SYSTEM_KILL_STR = 40
        private constant integer ITEM_SYSTEM_KILL_AGI = 41
        private constant integer ITEM_SYSTEM_KILL_INT = 42
        private constant integer ITEM_SYSTEM_KILL_MAX_HEALTH = 43
        private constant integer ITEM_SYSTEM_KILL_MAX_MANA = 44
        private constant integer ITEM_SYSTEM_KILL_EXP = 45
        private constant integer ITEM_SYSTEM_KILL_EXP_PERCENT = 46
        private constant integer ITEM_SYSTEM_KILL_GOLD = 47
        private constant integer ITEM_SYSTEM_KILL_GOLD_PERCENT = 48
        private constant integer ITEM_SYSTEM_KILL_WOOD = 49
        private constant integer ITEM_SYSTEM_KILL_WOOD_PERCENT = 50
        private constant integer ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT = 51
        private constant integer ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT = 52
        private constant integer ITEM_SYSTEM_LAST_DAMAGE_PERCENT = 53
        private constant integer ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING = 54
        private constant integer ITEM_SYSTEM_MAGIC_BLOOD_SUCKING = 55
        private constant integer ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT = 56
        private constant integer ITEM_SYSTEM_ELITE_DAMAGE_PERCENT = 57
        private constant integer ITEM_SYSTEM_BOSS_DAMAGE_PERCENT = 58
        private constant integer ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT = 59
        private constant integer ITEM_SYSTEM_MAGIC_PROTECT_PERCENT = 60

        private constant integer ITEM_SYSTEM_TIME_ATTACK_10 = 61
        private constant integer ITEM_SYSTEM_TIME_STR_10 = 62
        private constant integer ITEM_SYSTEM_TIME_AGI_10 = 63
        private constant integer ITEM_SYSTEM_TIME_INT_10 = 64
        private constant integer ITEM_SYSTEM_TIME_MAX_HEALTH_10 = 65
        private constant integer ITEM_SYSTEM_TIME_MAX_MANA_10 = 66
        private constant integer ITEM_SYSTEM_TIME_GOLD_10 = 67
        private constant integer ITEM_SYSTEM_TIME_WOOD_10 = 68
        private constant integer ITEM_SYSTEM_TIME_HEALTH_10 = 69
        private constant integer ITEM_SYSTEM_TIME_MANA_10 = 70
        private constant integer ITEM_SYSTEM_KILL_ATTACK_10 = 71
        private constant integer ITEM_SYSTEM_KILL_STR_10 = 72
        private constant integer ITEM_SYSTEM_KILL_AGI_10 = 73
        private constant integer ITEM_SYSTEM_KILL_INT_10 = 74
        private constant integer ITEM_SYSTEM_KILL_MAX_HEALTH_10 = 75
        private constant integer ITEM_SYSTEM_KILL_MAX_MANA_10 = 76
        private constant integer ITEM_SYSTEM_KILL_EXP_10 = 77
        private constant integer ITEM_SYSTEM_KILL_EXP_PERCENT_10 = 78
        private constant integer ITEM_SYSTEM_KILL_GOLD_10 = 79
        private constant integer ITEM_SYSTEM_KILL_GOLD_PERCENT_10 = 80
        private constant integer ITEM_SYSTEM_KILL_WOOD_10 = 81
        private constant integer ITEM_SYSTEM_KILL_WOOD_PERCENT_10 = 82


		private hashtable Item = InitHashtable()
		private trigger array trg
		//0是三维技能，1是攻击技能，2是防御技能
		private integer array GreenValueSkill
        private integer array MonsterCheckSkill
        private integer TimerRunTime = 1
        private integer array KillTimes

        private integer array Time_Add_Attack//1
        private integer array Time_Add_Str//2
        private integer array Time_Add_Agi//3
        private integer array Time_Add_Int//4
        private integer array Time_Add_MaxHealth//5
        private integer array Time_Add_MaxMana//6
        private integer array Time_Add_Gold//7
        private integer array Time_Add_Wood//8
        private integer array Time_Add_Health//9
        private integer array Time_Add_Mana//10


        private integer array Kill_Add_Attack//11
        private integer array Kill_Add_Str//12
        private integer array Kill_Add_Agi//13
        private integer array Kill_Add_Int//14
        private integer array Kill_Add_MaxHealth//15
        private integer array Kill_Add_MaxMana//16
        private integer array Kill_Add_Exp//17
        private integer array Kill_Add_Exp_Percent//18
        private integer array Kill_Add_Gold//19
        private integer array Kill_Add_Gold_Percent//20
        private integer array Kill_Add_Wood//21
        private integer array Kill_Add_Wood_Percent//22

        private integer array Player_Physical_Critical_Value//23
        private integer array Player_Physical_Critical_Percent//24
        private integer array Player_Magic_Critical_Value//25
        private integer array Player_Magic_Critical_Percent//26
        private integer array Player_Skill_Damage_Percent//27
        private integer array Player_Skill_Damage_Append//28
        private integer array Player_Attack_Damage_Append//29


        private integer array Player_Physical_Damage_Percent//30
        private integer array Player_Magic_Damage_Percent//31
        private integer array Player_Last_Damage_Percent//32
        private integer array Player_Normal_Damage_Percent//33
        private integer array Player_Elite_Damage_Percent//34
        private integer array Player_Boss_Damage_Percent//35

        private integer array Player_Physical_Sucking//36
        private integer array Player_Magic_Sucking//37
        private integer array Player_Physical_LessDamage//38
        private integer array Player_Magic_LessDamage//39

        private integer array Player_Normal_Physical_MultipliedValue
        private integer array Player_Elite_Physical_MultipliedValue
        private integer array Player_Boss_Physical_MultipliedValue
        private integer array Player_Normal_Magic_MultipliedValue
        private integer array Player_Elite_Magic_MultipliedValue
        private integer array Player_Boss_Magic_MultipliedValue

        private integer array Player_Skill_Cold_Donw//40

        private integer array Time_Add_Attack_10//1
        private integer array Time_Add_Str_10//2
        private integer array Time_Add_Agi_10//3
        private integer array Time_Add_Int_10//4
        private integer array Time_Add_MaxHealth_10//5
        private integer array Time_Add_MaxMana_10//6
        private integer array Time_Add_Gold_10//7
        private integer array Time_Add_Wood_10//8

        private integer array Kill_Add_Attack_10//11
        private integer array Kill_Add_Str_10//12
        private integer array Kill_Add_Agi_10//13
        private integer array Kill_Add_Int_10//14
        private integer array Kill_Add_MaxHealth_10//15
        private integer array Kill_Add_MaxMana_10//16
        private integer array Kill_Add_Exp_10//17
        private integer array Kill_Add_Exp_Percent_10//18
        private integer array Kill_Add_Gold_10//19
        private integer array Kill_Add_Gold_Percent_10//20
        private integer array Kill_Add_Wood_10//21
        private integer array Kill_Add_Wood_Percent_10//22


	endglobals

	private function PFWZ takes string str,unit u,real size,integer red,integer blue,integer green,real movex,real movey,real cleartime returns nothing
		local texttag pf
		set pf = CreateTextTag()
		call SetTextTagText( pf, str, size )
    	call SetTextTagColor( pf, red, blue, green, 255 )
    	call SetTextTagPosUnit( pf, u, 90.00 )
    	call SetTextTagVelocity( pf, movex, movey )
    	call SetTextTagLifespan( pf, cleartime )
        call SetTextTagFadepoint( pf , cleartime/2 )
    	call SetTextTagPermanent( pf, false )

        if GetLocalPlayer() == GetOwningPlayer(u) then
        // Use only local code (no net traffic) within this block to avoid desyncs.
        call SetTextTagVisibility(pf, true)
        endif
    	set pf =null
	endfunction

	private function InItem takes nothing returns nothing
	<?
	for id, obj in pairs(slk.item) do
	local ubertip = obj.ubertip
	local Tip = ubertip or ''
	local attack = string.match(Tip,"基础攻击.[+-]?%d+")--整数
    local attack_ad = string.match(Tip,"攻击附加.[+-]?%d+")--整数
	local armor = string.match(Tip,"基础护甲.[+-]?%d+")--整数
    local armor_ad = string.match(Tip,"护甲附加.[+-]?%d+")--整数
	local attackspeed = string.match(Tip,"攻击速度.[+-]?%d+")--整数
	local attackdelay = string.match(Tip,"攻击间隔.[+-]?%d+")--整数
	local attackfar = string.match(Tip,"攻击范围.[+-]?%d+")--整数
    local movespeed = string.match(Tip,"移动速度.[+-]?%d+")--整数
    local skillcolddown = string.match(Tip,"技能冷却.[+-]?%d+")--整数
	local str = string.match(Tip,"基础力量.[+-]?%d+")--整数
	local agi = string.match(Tip,"基础敏捷.[+-]?%d+")--整数
	local int = string.match(Tip,"基础智力.[+-]?%d+")--整数
	local str_ad = string.match(Tip,"力量附加.[+-]?%d+")--整数
	local agi_ad = string.match(Tip,"敏捷附加.[+-]?%d+")--整数
	local int_ad = string.match(Tip,"智力附加.[+-]?%d+")--整数
	local str_p = string.match(Tip,"力量百分比.[+-]?%d+")--整数
	local agi_p = string.match(Tip,"敏捷百分比.[+-]?%d+")--整数
	local int_p = string.match(Tip,"智力百分比.[+-]?%d+")--整数
	local maxhealth = string.match(Tip,"最大生命值.[+-]?%d+")--整数
    local maxhealth_p = string.match(Tip,"最大生命百分比.[+-]?%d+")--整数
	local maxmana = string.match(Tip,"最大魔法值.[+-]?%d+")--整数
    local maxmana_p = string.match(Tip,"最大魔法百分比.[+-]?%d+")--整数
    local physical_cp = string.match(Tip,"物理暴击概率.[+-]?%d+")--整数
    local physical_cv = string.match(Tip,"物理暴击伤害.[+-]?%d+")--整数
    local magic_cp = string.match(Tip,"魔法暴击概率.[+-]?%d+")--整数
    local magic_cv = string.match(Tip,"魔法暴击伤害.[+-]?%d+")--整数
    local skilldamage_p = string.match(Tip,"技能伤害加成.[+-]?%d+")--整数
    local skilldamage_add = string.match(Tip,"技能附加伤害.[+-]?%d+")--整数
    local attackdamage_add = string.match(Tip,"攻击附加伤害.[+-]?%d+")--整数
    local time_attack =  string.match(Tip,"每秒攻击力.[+-]?%d+")--整数
    local time_str =  string.match(Tip,"每秒力量.[+-]?%d+")--整数
    local time_agi =  string.match(Tip,"每秒敏捷.[+-]?%d+")--整数
    local time_int =  string.match(Tip,"每秒智力.[+-]?%d+")--整数
    local time_maxhealth =  string.match(Tip,"每秒最大生命.[+-]?%d+")--整数
    local time_maxmana =  string.match(Tip,"每秒最大魔法.[+-]?%d+")--整数
    local time_gold =  string.match(Tip,"每秒金币.[+-]?%d+")--整数
    local time_wood =  string.match(Tip,"每秒木材.[+-]?%d+")--整数
    local time_health =  string.match(Tip,"每秒生命回复.[+-]?%d+")--整数
    local time_mana =  string.match(Tip,"每秒魔法回复.[+-]?%d+")--整数
    local kill_attack =  string.match(Tip,"杀敌攻击.[+-]?%d+")--整数
    local kill_str =  string.match(Tip,"杀敌力量.[+-]?%d+")--整数
    local kill_agi =  string.match(Tip,"杀敌敏捷.[+-]?%d+")--整数
    local kill_int =  string.match(Tip,"杀敌智力.[+-]?%d+")--整数
    local kill_maxhealth =  string.match(Tip,"杀敌最大生命.[+-]?%d+")--整数
    local kill_mana =  string.match(Tip,"杀敌最大魔法.[+-]?%d+")--整数
    local kill_exp =  string.match(Tip,"杀敌经验.[+-]?%d+")--整数
    local kill_exp_p =  string.match(Tip,"杀敌经验加成.[+-]?%d+")--整数
    local kill_gold =  string.match(Tip,"杀敌金币.[+-]?%d+")--整数
    local kill_gold_p =  string.match(Tip,"杀敌金币加成.[+-]?%d+")--整数
    local kill_wood =  string.match(Tip,"杀敌木材.[+-]?%d+")--整数
    local kill_wood_p =  string.match(Tip,"杀敌木材加成.[+-]?%d+")--整数
    local physical_p =  string.match(Tip,"物理伤害.[+-]?%d+")--整数
    local magic_p =  string.match(Tip,"魔法伤害.[+-]?%d+")--整数
    local lastdamage = string.match(Tip,"最终伤害.[+-]?%d+")--整数
    local vampire_physical = string.match(Tip,"物理吸血.[+-]?%d+")--整数
    local vampire_magic = string.match(Tip,"魔法吸血.[+-]?%d+")--整数
    local damageadd_normal = string.match(Tip,"普通怪增伤.[+-]?%d+")--整数
    local damageadd_elite = string.match(Tip,"精英怪增伤.[+-]?%d+")--整数
    local damageadd_boss = string.match(Tip,"Boss增伤.[+-]?%d+")--整数
    local lessdamage_physical = string.match(Tip,"物理减伤.[+-]?%d+")--整数
    local lessdamage_magic = string.match(Tip,"魔法减伤.[+-]?%d+")--整数
    --v1.1
    local time_attack_10 =  string.match(Tip,"每十秒攻击力.[+-]?%d+")--整数
    local time_str_10 =  string.match(Tip,"每十秒力量.[+-]?%d+")--整数
    local time_agi_10 =  string.match(Tip,"每十秒敏捷.[+-]?%d+")--整数
    local time_int_10 =  string.match(Tip,"每十秒智力.[+-]?%d+")--整数
    local time_maxhealth_10 =  string.match(Tip,"每十秒最大生命.[+-]?%d+")--整数
    local time_maxmana_10 =  string.match(Tip,"每十秒最大魔法.[+-]?%d+")--整数
    local time_gold_10 =  string.match(Tip,"每十秒金币.[+-]?%d+")--整数
    local time_wood_10 =  string.match(Tip,"每十秒木材.[+-]?%d+")--整数
    local kill_attack_10 =  string.match(Tip,"杀十个敌人攻击.[+-]?%d+")--整数
    local kill_str_10 =  string.match(Tip,"杀十个敌人力量.[+-]?%d+")--整数
    local kill_agi_10 =  string.match(Tip,"杀十个敌人敏捷.[+-]?%d+")--整数
    local kill_int_10 =  string.match(Tip,"杀十个敌人智力.[+-]?%d+")--整数
    local kill_maxhealth_10 =  string.match(Tip,"杀十个敌人最大生命.[+-]?%d+")--整数
    local kill_mana_10 =  string.match(Tip,"杀十个敌人最大魔法.[+-]?%d+")--整数
    local kill_exp_10 =  string.match(Tip,"杀十个敌人经验.[+-]?%d+")--整数
    local kill_exp_p_10 =  string.match(Tip,"杀十个敌人经验加成.[+-]?%d+")--整数
    local kill_gold_10 =  string.match(Tip,"杀十个敌人金币.[+-]?%d+")--整数
    local kill_gold_p_10 =  string.match(Tip,"杀十个敌人金币加成.[+-]?%d+")--整数
    local kill_wood_10 =  string.match(Tip,"杀十个敌人木材.[+-]?%d+")--整数
    local kill_wood_p_10 =  string.match(Tip,"杀十个敌人木材加成.[+-]?%d+")--整数
	?>

	<?if attack ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ATTACK,<?=tonumber(string.match(attack,"[+-]?%d+"))?>)
	<?end?>
    <?if attack_ad ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ATTACK_APPEND,<?=tonumber(string.match(attack_ad,"[+-]?%d+"))?>)
	<?end?>
    <?if armor ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ARMOR,<?=tonumber(string.match(armor,"[+-]?%d+"))?>)
	<?end?>
    <?if armor_ad ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ARMOR_APPEND,<?=tonumber(string.match(armor_ad,"[+-]?%d+"))?>)
	<?end?>
    <?if attackspeed ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ATTACK_SPEED,<?=tonumber(string.match(attackspeed,"[+-]?%d+"))?>)
	<?end?>
    <?if attackdelay ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ATTACK_DELAY,<?=tonumber(string.match(attackdelay,"[+-]?%d+"))?>)
	<?end?>
    <?if attackfar ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ATTACK_FAR,<?=tonumber(string.match(attackfar,"[+-]?%d+"))?>)
	<?end?>
    <?if movespeed ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MOVE_SPEED,<?=tonumber(string.match(movespeed,"[+-]?%d+"))?>)
	<?end?>
    <?if skillcolddown ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_SKILL_COLD_DOWN,<?=tonumber(string.match(skillcolddown,"[+-]?%d+"))?>)
	<?end?>
    <?if str ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_STR,<?=tonumber(string.match(str,"[+-]?%d+"))?>)
	<?end?>
    <?if agi ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_AGI,<?=tonumber(string.match(agi,"[+-]?%d+"))?>)
	<?end?>
    <?if int ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_INT,<?=tonumber(string.match(int,"[+-]?%d+"))?>)
	<?end?>
    <?if str_ad ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_STR_APPEND,<?=tonumber(string.match(str_ad,"[+-]?%d+"))?>)
	<?end?>
    <?if agi_ad ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_AGI_APPEND,<?=tonumber(string.match(agi_ad,"[+-]?%d+"))?>)
	<?end?>
    <?if int_ad ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_INT_APPEND,<?=tonumber(string.match(int_ad,"[+-]?%d+"))?>)
	<?end?>
    <?if str_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_STR_PERCENT,<?=tonumber(string.match(str_p,"[+-]?%d+"))?>)
	<?end?>
    <?if agi_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_AGI_PERCENT,<?=tonumber(string.match(agi_p,"[+-]?%d+"))?>)
	<?end?>
    <?if int_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_INT_PERCENT,<?=tonumber(string.match(int_p,"[+-]?%d+"))?>)
	<?end?>
    <?if maxhealth ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAX_HEALTH,<?=tonumber(string.match(maxhealth,"[+-]?%d+"))?>)
	<?end?>
    <?if maxmana ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAX_MANA,<?=tonumber(string.match(maxmana,"[+-]?%d+"))?>)
	<?end?>
    <?if maxhealth_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAX_HEALTH_PERCENT,<?=tonumber(string.match(maxhealth_p,"[+-]?%d+"))?>)
	<?end?>
    <?if maxmana_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAX_MANA_PERCENT,<?=tonumber(string.match(maxmana_p,"[+-]?%d+"))?>)
	<?end?>
    <?if physical_cp ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT,<?=tonumber(string.match(physical_cp,"[+-]?%d+"))?>)
	<?end?>
    <?if physical_cv ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE,<?=tonumber(string.match(physical_cv,"[+-]?%d+"))?>)
	<?end?>
    <?if magic_cp ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT,<?=tonumber(string.match(magic_cp,"[+-]?%d+"))?>)
	<?end?>
    <?if magic_cv ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE,<?=tonumber(string.match(magic_cv,"[+-]?%d+"))?>)
	<?end?>
    <?if skilldamage_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_SKILL_DAMAGE_PERCENT,<?=tonumber(string.match(skilldamage_p,"[+-]?%d+"))?>)
	<?end?>
    <?if skilldamage_add ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_SKILL_DAMAGE_APPEDN,<?=tonumber(string.match(skilldamage_add,"[+-]?%d+"))?>)
	<?end?>
    <?if time_attack ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_ATTACK,<?=tonumber(string.match(time_attack,"[+-]?%d+"))?>)
	<?end?>
    <?if time_str ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_STR,<?=tonumber(string.match(time_str,"[+-]?%d+"))?>)
	<?end?>
    <?if time_agi ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_AGI,<?=tonumber(string.match(time_agi,"[+-]?%d+"))?>)
	<?end?>
    <?if time_int ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_INT,<?=tonumber(string.match(time_int,"[+-]?%d+"))?>)
	<?end?>
    <?if time_maxhealth ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_MAX_HEALTH,<?=tonumber(string.match(time_maxhealth,"[+-]?%d+"))?>)
	<?end?>
    <?if time_maxmana ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_MAX_MANA,<?=tonumber(string.match(time_maxmana,"[+-]?%d+"))?>)
	<?end?>
    <?if time_gold ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_GOLD,<?=tonumber(string.match(time_gold,"[+-]?%d+"))?>)
	<?end?>
    <?if time_wood ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_WOOD,<?=tonumber(string.match(time_wood,"[+-]?%d+"))?>)
	<?end?>
    <?if time_health ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_HEALTH,<?=tonumber(string.match(time_health,"[+-]?%d+"))?>)
	<?end?>
    <?if time_mana ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_MANA,<?=tonumber(string.match(time_mana,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_attack ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_ATTACK,<?=tonumber(string.match(kill_attack,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_str ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_STR,<?=tonumber(string.match(kill_str,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_agi ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_AGI,<?=tonumber(string.match(kill_agi,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_int ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_INT,<?=tonumber(string.match(kill_int,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_maxhealth ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_MAX_HEALTH,<?=tonumber(string.match(kill_maxhealth,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_maxmana ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_MAX_MANA,<?=tonumber(string.match(kill_maxmana,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_exp ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_EXP,<?=tonumber(string.match(kill_exp,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_exp_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_EXP_PERCENT,<?=tonumber(string.match(kill_exp_p,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_gold ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_GOLD,<?=tonumber(string.match(kill_gold,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_gold_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_GOLD_PERCENT,<?=tonumber(string.match(kill_gold_p,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_wood ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_WOOD,<?=tonumber(string.match(kill_wood,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_wood_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_WOOD_PERCENT,<?=tonumber(string.match(kill_wood_p,"[+-]?%d+"))?>)
	<?end?>
    <?if physical_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT,<?=tonumber(string.match(physical_p,"[+-]?%d+"))?>)
	<?end?>
    <?if magic_p ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT,<?=tonumber(string.match(magic_p,"[+-]?%d+"))?>)
	<?end?>
    <?if lastdamage ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_LAST_DAMAGE_PERCENT,<?=tonumber(string.match(lastdamage,"[+-]?%d+"))?>)
	<?end?>
    <?if vampire_physical ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING,<?=tonumber(string.match(vampire_physical,"[+-]?%d+"))?>)
	<?end?>
    <?if vampire_magic ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAGIC_BLOOD_SUCKING,<?=tonumber(string.match(vampire_magic,"[+-]?%d+"))?>)
	<?end?>
    <?if damageadd_normal ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT,<?=tonumber(string.match(damageadd_normal,"[+-]?%d+"))?>)
	<?end?>
    <?if damageadd_elite ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_ELITE_DAMAGE_PERCENT,<?=tonumber(string.match(damageadd_elite,"[+-]?%d+"))?>)
	<?end?>
    <?if damageadd_boss ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_BOSS_DAMAGE_PERCENT,<?=tonumber(string.match(damageadd_boss,"[+-]?%d+"))?>)
	<?end?>
    <?if lessdamage_physical ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT,<?=tonumber(string.match(lessdamage_physical,"[+-]?%d+"))?>)
	<?end?>
    <?if lessdamage_magic ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_MAGIC_PROTECT_PERCENT,<?=tonumber(string.match(lessdamage_magic,"[+-]?%d+"))?>)
	<?end?>


    <?if time_attack_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_ATTACK_10,<?=tonumber(string.match(time_attack_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_str_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_STR_10,<?=tonumber(string.match(time_str_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_agi_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_AGI_10,<?=tonumber(string.match(time_agi_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_int_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_INT_10,<?=tonumber(string.match(time_int_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_maxhealth_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_MAX_HEALTH_10,<?=tonumber(string.match(time_maxhealth_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_maxmana_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_MAX_MANA_10,<?=tonumber(string.match(time_maxmana_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_gold_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_GOLD_10,<?=tonumber(string.match(time_gold_10,"[+-]?%d+"))?>)
	<?end?>
    <?if time_wood_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_TIME_WOOD_10,<?=tonumber(string.match(time_wood_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_attack_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_ATTACK_10,<?=tonumber(string.match(kill_attack_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_str_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_STR_10,<?=tonumber(string.match(kill_str_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_agi_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_AGI_10,<?=tonumber(string.match(kill_agi_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_int_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_INT_10,<?=tonumber(string.match(kill_int_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_maxhealth_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_MAX_HEALTH_10,<?=tonumber(string.match(kill_maxhealth_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_mana_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_MAX_MANA_10,<?=tonumber(string.match(kill_mana_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_exp_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_EXP_10,<?=tonumber(string.match(kill_exp_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_exp_p_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_EXP_PERCENT_10,<?=tonumber(string.match(kill_exp_p_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_gold_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_GOLD_10,<?=tonumber(string.match(kill_gold_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_gold_p_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_GOLD_PERCENT_10,<?=tonumber(string.match(kill_gold_p_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_wood_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_WOOD_10,<?=tonumber(string.match(kill_wood_10,"[+-]?%d+"))?>)
	<?end?>
    <?if kill_wood_p_10 ~= nil then?>
	call SaveInteger(Item,'<?=id?>',ITEM_SYSTEM_KILL_WOOD_PERCENT_10,<?=tonumber(string.match(kill_wood_p_10,"[+-]?%d+"))?>)
	<?end?>
	<?end?>

	<?for id, obj in pairs(slk.ability) do
	local tip = obj.name
	local Tip = tip or ''
	local SWXGJN = string.match(Tip,"玩家绿字三维修改技能")
	local GJXGJN = string.match(Tip,"玩家绿字攻击修改技能")
	local FYXGJN = string.match(Tip,"玩家绿字防御修改技能")

    local NormalMonster = string.match(Tip,"普通怪")
    local EliteMonster = string.match(Tip,"精英怪")
    local BossMonster = string.match(Tip,"Boss")
	?>
	<?if SWXGJN ~= nil then?>
	set GreenValueSkill[0] = '<?=id?>'
	<?end?>
	<?if GJXGJN ~= nil then?>
	set GreenValueSkill[1] = '<?=id?>'
	<?end?>
	<?if FYXGJN ~= nil then?>
	set GreenValueSkill[2] = '<?=id?>'
	<?end?>

	<?if NormalMonster ~= nil then?>
	set MonsterCheckSkill[0] = '<?=id?>'
	<?end?>
    <?if EliteMonster ~= nil then?>
	set MonsterCheckSkill[1] = '<?=id?>'
	<?end?>
    <?if BossMonster ~= nil then?>
	set MonsterCheckSkill[2] = '<?=id?>'
	<?end?>

	<?end?>


	endfunction

	private function trg0Ac takes nothing returns nothing
	///获得物品触发器，攻击力 护甲 生命值 获得之后直接添加，其他的给操作物品单位绑定值
		local real GJL = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK))
		local real GJLAD = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_APPEND))
		local real HJ = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ARMOR))
		local real SMZ = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ =R2I( LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_MANA))
        local real HJAD = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit = GetManipulatingUnit()
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2

		//拾取物品单位是英雄才增加
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		/// 攻击力
		if GJL != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x12),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x12)) + GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x25),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x25)) + (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x51),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x51)) + (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16)) + I2R(GJJL)))
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x52),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16))))
		endif
		/// 护甲
		if HJ != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x20),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x20)) + HJ))
		endif
		/// 生命值
		if SMZ != 0. then
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_LIFE,GetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_LIFE) + SMZ)
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_LIFE,GetUnitState(GetManipulatingUnit(),UNIT_STATE_LIFE) + SMZ)
		endif
		/// 魔法值
		if MFZ != 0. then
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_MANA,GetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_MANA) + MFZ)
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_MANA,GetUnitState(GetManipulatingUnit(),UNIT_STATE_MANA) + MFZ)
		endif
        //移动速度
        if YDSD != 0. then
            call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetTriggerUnit()) + YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) + STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) + AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) + INT ,false)
        endif


		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	


		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif

        //拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_HEALTH_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_MANA_PERCENT) , true)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MANA)

    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Time_Add_Attack_10[PlayerId] = Time_Add_Attack_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_ATTACK_10)
    set Time_Add_Str_10[PlayerId] = Time_Add_Str_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_STR_10)
    set Time_Add_Agi_10[PlayerId] = Time_Add_Agi_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_AGI_10)
    set Time_Add_Int_10[PlayerId] = Time_Add_Int_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_INT_10)
    set Time_Add_MaxHealth_10[PlayerId] = Time_Add_MaxHealth_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_HEALTH_10)
    set Time_Add_MaxMana_10[PlayerId] = Time_Add_MaxMana_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_MANA_10)
    set Time_Add_Gold_10[PlayerId] = Time_Add_Gold_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_GOLD_10)
    set Time_Add_Wood_10[PlayerId] = Time_Add_Wood_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_WOOD_10)

    set Kill_Add_Attack_10[PlayerId] = Kill_Add_Attack_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_ATTACK_10)
    set Kill_Add_Str_10[PlayerId] = Kill_Add_Str_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_STR_10)
    set Kill_Add_Agi_10[PlayerId] = Kill_Add_Agi_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_AGI_10)
    set Kill_Add_Int_10[PlayerId] = Kill_Add_Int_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_INT_10)
    set Kill_Add_MaxHealth_10[PlayerId] = Kill_Add_MaxHealth_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_HEALTH_10)
    set Kill_Add_MaxMana_10[PlayerId] = Kill_Add_MaxMana_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_MANA_10)
    set Kill_Add_Exp_10[PlayerId] = Kill_Add_Exp_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_10)
    set Kill_Add_Exp_Percent_10[PlayerId] = Kill_Add_Exp_Percent_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_PERCENT_10)
    set Kill_Add_Gold_10[PlayerId] = Kill_Add_Gold_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_10)
    set Kill_Add_Gold_Percent_10[PlayerId] = Kill_Add_Gold_Percent_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_PERCENT_10)
    set Kill_Add_Wood_10[PlayerId] = Kill_Add_Wood_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_10)
    set Kill_Add_Wood_Percent_10[PlayerId] = Kill_Add_Wood_Percent_10[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_PERCENT_10)

    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] + LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    endif

	endfunction

	private function trg1Ac takes nothing returns nothing
	///丢弃物品触发器，攻击力 护甲 生命值 获得之后直接减少，其他的给操作物品单位绑定值
		local real GJL = I2R(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK))
		local real HJ = I2R(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ARMOR))
		local real SMZ = I2R(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ = I2R(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_MANA))
        local real GJLAD = I2R(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_APPEND))
        local real HJAD = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit = GetManipulatingUnit()
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2

		//拾取物品单位是英雄才减少
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		if GJL != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x12),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x12)) - GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x25),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x25)) - (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x51),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x51)) - (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16)) - I2R(GJJL)))
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x52),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x16))))
		endif
		if HJ != 0. then
			call SetUnitState(GetManipulatingUnit(),ConvertUnitState(0x20),(GetUnitState(GetManipulatingUnit(),ConvertUnitState(0x20)) - HJ))
		endif
		if SMZ != 0. then
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_LIFE,GetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_LIFE) - SMZ)
		endif
		if MFZ != 0. then
			call SetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_MANA,GetUnitState(GetManipulatingUnit(),UNIT_STATE_MAX_MANA) - MFZ)
		endif
        //移动速度
        if YDSD != 0. then
        call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetTriggerUnit()) - YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) - STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) - AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) - INT ,false)
        endif

		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	

		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif
    	//拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_STR_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_AGI_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_INT_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_HEALTH_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAX_MANA_PERCENT) , false)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MANA)


    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Time_Add_Attack_10[PlayerId] = Time_Add_Attack_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_ATTACK_10)
    set Time_Add_Str_10[PlayerId] = Time_Add_Str_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_STR_10)
    set Time_Add_Agi_10[PlayerId] = Time_Add_Agi_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_AGI_10)
    set Time_Add_Int_10[PlayerId] = Time_Add_Int_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_INT_10)
    set Time_Add_MaxHealth_10[PlayerId] = Time_Add_MaxHealth_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_HEALTH_10)
    set Time_Add_MaxMana_10[PlayerId] = Time_Add_MaxMana_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_MAX_MANA_10)
    set Time_Add_Gold_10[PlayerId] = Time_Add_Gold_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_GOLD_10)
    set Time_Add_Wood_10[PlayerId] = Time_Add_Wood_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_TIME_WOOD_10)

    set Kill_Add_Attack_10[PlayerId] = Kill_Add_Attack_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_ATTACK_10)
    set Kill_Add_Str_10[PlayerId] = Kill_Add_Str_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_STR_10)
    set Kill_Add_Agi_10[PlayerId] = Kill_Add_Agi_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_AGI_10)
    set Kill_Add_Int_10[PlayerId] = Kill_Add_Int_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_INT_10)
    set Kill_Add_MaxHealth_10[PlayerId] = Kill_Add_MaxHealth_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_HEALTH_10)
    set Kill_Add_MaxMana_10[PlayerId] = Kill_Add_MaxMana_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_MAX_MANA_10)
    set Kill_Add_Exp_10[PlayerId] = Kill_Add_Exp_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_10)
    set Kill_Add_Exp_Percent_10[PlayerId] = Kill_Add_Exp_Percent_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_EXP_PERCENT_10)
    set Kill_Add_Gold_10[PlayerId] = Kill_Add_Gold_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_10)
    set Kill_Add_Gold_Percent_10[PlayerId] = Kill_Add_Gold_Percent_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_GOLD_PERCENT_10)
    set Kill_Add_Wood_10[PlayerId] = Kill_Add_Wood_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_10)
    set Kill_Add_Wood_Percent_10[PlayerId] = Kill_Add_Wood_Percent_10[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_KILL_WOOD_PERCENT_10)


    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] - LoadInteger(Item,GetItemTypeId(GetManipulatedItem()),ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
	
    endif


	endfunction

	private function trg23Co takes nothing returns boolean
		///触发器条件，主要是用于判断单位是否是英雄，单位之间是否是敌对的
    	return  IsUnitType(GetKillingUnit(), UNIT_TYPE_HERO) and (GetPlayerController(GetOwningPlayer(GetKillingUnit())) == MAP_CONTROL_USER)
    endfunction

	private function trg2Ac takes nothing returns nothing
		///击杀之后添加属性
        local player pl = GetOwningPlayer(GetKillingUnit())
        local unit tunit = MMRAPI_TargetPlayer(pl)
        if tunit != null then
            if Kill_Add_Attack[GetPlayerId(pl)] > 0 then
                call SetUnitState(tunit,ConvertUnitState(0x12),(GetUnitState(tunit,ConvertUnitState(0x12)) + Kill_Add_Attack[GetPlayerId(pl)]))
            endif
            if Kill_Add_Str[GetPlayerId(pl)] > 0 then
                call SetHeroStr(tunit , GetHeroStr( tunit , false ) + Kill_Add_Str[GetPlayerId(pl)] , false)
            endif
            if Kill_Add_Agi[GetPlayerId(pl)] > 0 then
                call SetHeroAgi(tunit , GetHeroAgi( tunit , false ) + Kill_Add_Agi[GetPlayerId(pl)] , false)
            endif
            if Kill_Add_Int[GetPlayerId(pl)] > 0 then
                call SetHeroInt(tunit , GetHeroInt( tunit , false ) + Kill_Add_Int[GetPlayerId(pl)] , false)
            endif
            if Kill_Add_MaxHealth[GetPlayerId(pl)] > 0 then
                call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Kill_Add_MaxHealth[GetPlayerId(pl)]))
            endif
            if Kill_Add_MaxMana[GetPlayerId(pl)] > 0 then
                call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Kill_Add_MaxMana[GetPlayerId(pl)]))
            endif
            if Kill_Add_Exp[GetPlayerId(pl)] > 0 then
                call AddHeroXP( tunit , Kill_Add_Exp[GetPlayerId(pl)] + ((Kill_Add_Exp[GetPlayerId(pl)] * Kill_Add_Exp_Percent[GetPlayerId(pl)])/100), true)
			endif
            if Kill_Add_Gold[GetPlayerId(pl)] > 0 then
                call SetPlayerState(pl , PLAYER_STATE_RESOURCE_GOLD , GetPlayerState(pl, PLAYER_STATE_RESOURCE_GOLD) + Kill_Add_Gold[GetPlayerId(pl)]+ ((Kill_Add_Gold[GetPlayerId(pl)] * Kill_Add_Gold_Percent[GetPlayerId(pl)])/100))
			endif
            if Kill_Add_Wood[GetPlayerId(pl)] > 0 then
                call SetPlayerState(pl , PLAYER_STATE_RESOURCE_LUMBER , GetPlayerState(pl, PLAYER_STATE_RESOURCE_LUMBER) + Kill_Add_Wood[GetPlayerId(pl)] + ((Kill_Add_Wood[GetPlayerId(pl)] * Kill_Add_Wood_Percent[GetPlayerId(pl)])/100))
			endif

            if KillTimes[GetPlayerId(pl)] >= 10 then
                set KillTimes[GetPlayerId(pl)] = 0
                if Kill_Add_Attack_10[GetPlayerId(pl)] > 0 then
                    call SetUnitState(tunit,ConvertUnitState(0x12),(GetUnitState(tunit,ConvertUnitState(0x12)) + Kill_Add_Attack_10[GetPlayerId(pl)]))
                endif
                if Kill_Add_Str_10[GetPlayerId(pl)] > 0 then
                    call SetHeroStr(tunit , GetHeroStr( tunit , false ) + Kill_Add_Str_10[GetPlayerId(pl)] , false)
                endif
                if Kill_Add_Agi_10[GetPlayerId(pl)] > 0 then
                    call SetHeroAgi(tunit , GetHeroAgi( tunit , false ) + Kill_Add_Agi_10[GetPlayerId(pl)] , false)
                endif
                if Kill_Add_Int_10[GetPlayerId(pl)] > 0 then
                    call SetHeroInt(tunit , GetHeroInt( tunit , false ) + Kill_Add_Int_10[GetPlayerId(pl)] , false)
                endif
                if Kill_Add_MaxHealth_10[GetPlayerId(pl)] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Kill_Add_MaxHealth_10[GetPlayerId(pl)]))
                endif
                if Kill_Add_MaxMana_10[GetPlayerId(pl)] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Kill_Add_MaxMana_10[GetPlayerId(pl)]))
                endif
                if Kill_Add_Exp_10[GetPlayerId(pl)] > 0 then
                    call AddHeroXP( tunit , Kill_Add_Exp_10[GetPlayerId(pl)] + ((Kill_Add_Exp_10[GetPlayerId(pl)] * Kill_Add_Exp_Percent_10[GetPlayerId(pl)])/100), true)
			    endif
                if Kill_Add_Gold_10[GetPlayerId(pl)] > 0 then
                    call SetPlayerState(pl , PLAYER_STATE_RESOURCE_GOLD , GetPlayerState(pl, PLAYER_STATE_RESOURCE_GOLD) + Kill_Add_Gold_10[GetPlayerId(pl)]+ ((Kill_Add_Gold_10[GetPlayerId(pl)] * Kill_Add_Gold_Percent_10[GetPlayerId(pl)])/100))
			    endif
                if Kill_Add_Wood_10[GetPlayerId(pl)] > 0 then
                    call SetPlayerState(pl , PLAYER_STATE_RESOURCE_LUMBER , GetPlayerState(pl, PLAYER_STATE_RESOURCE_LUMBER) + Kill_Add_Wood_10[GetPlayerId(pl)] + ((Kill_Add_Wood_10[GetPlayerId(pl)] * Kill_Add_Wood_Percent_10[GetPlayerId(pl)])/100))
			    endif
            else 
                set KillTimes[GetPlayerId(pl)] = KillTimes[GetPlayerId(pl)] + 1
            endif
        endif
	endfunction

	private function trg3Ac takes nothing returns nothing
		///攻击之后添加属性
	endfunction
	private function trg4Ac takes nothing returns nothing
		///每秒事件，每秒加属性和每秒回血
        local integer Sy = 0
        local unit tunit 
        set TimerRunTime = TimerRunTime + 1
		loop
			exitwhen Sy == 7
            set tunit = MMRAPI_TargetPlayer(Player(Sy))
            if tunit != null then
              	if Time_Add_Attack[Sy] > 0 then
                    call SetUnitState(tunit,ConvertUnitState(0x12),(GetUnitState(tunit,ConvertUnitState(0x12)) + Time_Add_Attack[Sy]))
			    endif
			    if Time_Add_Str[Sy] > 0 then
                    call SetHeroStr(tunit , GetHeroStr( tunit , false ) + Time_Add_Str[Sy] , false)
			    endif
                if Time_Add_Agi[Sy] > 0 then
                    call SetHeroAgi(tunit , GetHeroAgi( tunit , false ) + Time_Add_Agi[Sy] , false)
			    endif
                if Time_Add_Int[Sy] > 0 then
                    call SetHeroInt(tunit , GetHeroInt( tunit , false ) + Time_Add_Int[Sy] , false)
			    endif
                if Time_Add_MaxHealth[Sy] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Time_Add_MaxHealth[Sy]))
			    endif
                if Time_Add_MaxMana[Sy] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_MAX_MANA , (GetUnitState(tunit,UNIT_STATE_MAX_MANA) + Time_Add_MaxMana[Sy]))
			    endif
                if Time_Add_Gold[Sy] > 0 then
                    call SetPlayerState(Player(Sy) , PLAYER_STATE_RESOURCE_GOLD , GetPlayerState(Player(Sy), PLAYER_STATE_RESOURCE_GOLD) + Time_Add_Gold[Sy])
			    endif
                if Time_Add_Wood[Sy] > 0 then
                    call SetPlayerState(Player(Sy) , PLAYER_STATE_RESOURCE_LUMBER , GetPlayerState(Player(Sy), PLAYER_STATE_RESOURCE_LUMBER) + Time_Add_Wood[Sy])
			    endif
                if Time_Add_Health[Sy] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_LIFE , (GetUnitState(tunit,UNIT_STATE_LIFE) + Time_Add_Health[Sy]))
			    endif
                if Time_Add_Mana[Sy] > 0 then
                    call SetUnitState(tunit , UNIT_STATE_MANA , (GetUnitState(tunit,UNIT_STATE_MANA) + Time_Add_Mana[Sy]))
			    endif  
            endif
			set Sy = Sy + 1
		endloop

        if TimerRunTime >= 10 then
            set TimerRunTime = 1
            set Sy = 0
            loop
			    exitwhen Sy == 7
                set tunit = MMRAPI_TargetPlayer(Player(Sy))
                if tunit != null then
              	    if Time_Add_Attack_10[Sy] > 0 then
                        call SetUnitState(tunit,ConvertUnitState(0x12),(GetUnitState(tunit,ConvertUnitState(0x12)) + Time_Add_Attack_10[Sy]))
			        endif
			        if Time_Add_Str_10[Sy] > 0 then
                        call SetHeroStr(tunit , GetHeroStr( tunit , false ) + Time_Add_Str_10[Sy] , false)
			        endif
                    if Time_Add_Agi_10[Sy] > 0 then
                        call SetHeroAgi(tunit , GetHeroAgi( tunit , false ) + Time_Add_Agi_10[Sy] , false)
			        endif
                    if Time_Add_Int_10[Sy] > 0 then
                        call SetHeroInt(tunit , GetHeroInt( tunit , false ) + Time_Add_Int_10[Sy] , false)
			        endif
                    if Time_Add_MaxHealth_10[Sy] > 0 then
                        call SetUnitState(tunit , UNIT_STATE_MAX_LIFE , (GetUnitState(tunit,UNIT_STATE_MAX_LIFE) + Time_Add_MaxHealth_10[Sy]))
			        endif
                    if Time_Add_MaxMana_10[Sy] > 0 then
                        call SetUnitState(tunit , UNIT_STATE_MAX_MANA , (GetUnitState(tunit,UNIT_STATE_MAX_MANA) + Time_Add_MaxMana_10[Sy]))
			        endif
                    if Time_Add_Gold_10[Sy] > 0 then
                        call SetPlayerState(Player(Sy) , PLAYER_STATE_RESOURCE_GOLD , GetPlayerState(Player(Sy), PLAYER_STATE_RESOURCE_GOLD) + Time_Add_Gold_10[Sy])
			        endif
                    if Time_Add_Wood_10[Sy] > 0 then
                        call SetPlayerState(Player(Sy) , PLAYER_STATE_RESOURCE_LUMBER , GetPlayerState(Player(Sy), PLAYER_STATE_RESOURCE_LUMBER) + Time_Add_Wood_10[Sy])
			        endif
            endif
			set Sy = Sy + 1
		endloop
        endif
	endfunction

	private function trg5Co takes nothing returns boolean
		///任意单位伤害事件的条件，筛选用的
    	return GetEventDamage() >= 1.00 and IsUnitEnemy(GetTriggerUnit(), GetOwningPlayer(GetEventDamageSource())) == true 
	endfunction

    //暴击检测
    private function CheckAndCalcutePhysicalOrMagic_CriticalStrike takes real damagevalue ,integer pid , boolean isphysical returns real damage
        local real needreturn = 0
        if isphysical then
            if (Player_Physical_Critical_Percent[pid]) >= GetRandomInt(1,100) then
                set needreturn = damagevalue * (1 + (Player_Physical_Critical_Value[pid]/100))
                if  needreturn > 100000000 then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn/100000000)) + "亿",GetTriggerUnit(),0.035,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),3.0)
                elseif  needreturn > 10000000  then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn/1000000)) + "千万",GetTriggerUnit(),0.03,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),2.5)
                elseif  needreturn > 1000000  then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn/1000000)) + "百万",GetTriggerUnit(),0.025,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),2.0)
                elseif needreturn > 10000 then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn/10000)) + "万",GetTriggerUnit(),0.02,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),1.5)
                else 
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn)) ,GetTriggerUnit(),0.02,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),1.0)
                endif
                return needreturn
            else
                return damagevalue
            endif
        else
            if (Player_Magic_Critical_Percent[pid]) >= GetRandomInt(1,100) then
                set needreturn = damagevalue * (1 + (Player_Magic_Critical_Value[pid]/100))

                if  needreturn > 100000000 then
                    call PFWZ("|cff2c5dfc魔法暴击" + R2S(needreturn/100000000) + "亿",GetTriggerUnit(),0.035,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),3.0)
                elseif  needreturn > 10000000  then
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn/10000000)) + "千万",GetTriggerUnit(),0.03,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),2.5)
                elseif  needreturn > 1000000  then
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn/1000000)) + "百万",GetTriggerUnit(),0.025,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),2.0)
                elseif needreturn > 10000 then
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn/10000)) + "万",GetTriggerUnit(),0.02,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),1.5)
                else 
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn)) ,GetTriggerUnit(),0.02,255,255,255,GetRandomReal(0.00,0.05),GetRandomReal(0.00,0.05),1.0)             
                endif
                return needreturn
            else
                return damagevalue
            endif
        endif
        return 0.
    endfunction
	//伤害造成以及伤害公式
	private function trg5Ac takes nothing returns nothing

		///任意单位事件的动作，用来写暴击，暴击几率，吸血，伤害减免的
		///伤害来源等同于攻击者，触发单位等同于被攻击者。这个事件是有单位受到伤害值的时候会触发的，所以触发单位受到伤害值后触发事件
		/// GetEventDamageSource = 伤害来源，GetTriggerUnit = 触发单位
        local real getdamage = GetEventDamage()
        local real AttackValue 
        local real realdamage
        local integer magicDamageMult
        local integer physicalDamageMmult
        local integer pid
        local unit damageunit = GetEventDamageSource()
        local unit targetunit = GetTriggerUnit()
        local real suckingvalue
        local real needsetdamage

        if GetPlayerController(GetOwningPlayer(damageunit)) == MAP_CONTROL_USER then
            set pid = GetPlayerId(GetOwningPlayer(damageunit))
            if     GetUnitAbilityLevel(targetunit , MonsterCheckSkill[0]) >= 1 then
                set  magicDamageMult = Player_Normal_Magic_MultipliedValue[pid]
                set  physicalDamageMmult = Player_Normal_Physical_MultipliedValue[pid]
            elseif GetUnitAbilityLevel(targetunit , MonsterCheckSkill[1]) >= 1 then
                set  magicDamageMult = Player_Elite_Magic_MultipliedValue[pid]
                set  physicalDamageMmult = Player_Elite_Physical_MultipliedValue[pid]
            elseif GetUnitAbilityLevel(targetunit , MonsterCheckSkill[2]) >= 1 then
                set  magicDamageMult = Player_Boss_Magic_MultipliedValue[pid]
                set  physicalDamageMmult = Player_Elite_Physical_MultipliedValue[pid]
            else
                set  magicDamageMult = Player_Normal_Magic_MultipliedValue[pid]
                set  physicalDamageMmult = Player_Normal_Physical_MultipliedValue[pid]
            endif
            if (YDWEIsEventAttackDamage() == true) then
                if (YDWEIsEventPhysicalDamage() == true) and ( YDWEIsEventAttackType(ATTACK_TYPE_MAGIC) == false ) then
                    set realdamage = (Player_Attack_Damage_Append[pid] + getdamage) * physicalDamageMmult
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true)
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Physical_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = realdamage*(I2R(Player_Physical_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif 
                else
                    set realdamage = (Player_Attack_Damage_Append[pid] + getdamage) * magicDamageMult 
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false)
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Magic_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Magic_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif            
                endif
                call YDWESetEventDamage(needsetdamage) 
            else 
                if (YDWEIsEventPhysicalDamage() == true) then
                    set realdamage = (Player_Skill_Damage_Append[pid] + getdamage) * physicalDamageMmult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true) 
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Physical_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Physical_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif
                else
                    set realdamage = (Player_Skill_Damage_Append[pid] + getdamage) * magicDamageMult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false)
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Magic_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Magic_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif  
                endif
                call YDWESetEventDamage(needsetdamage) 
            endif
        else
            set pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
            set AttackValue = GetUnitState(GetEventDamageSource(),ConvertUnitState(0x12)) + GetUnitState(GetEventDamageSource(),ConvertUnitState(0x13))
            if (YDWEIsEventPhysicalDamage() == true) then
                if AttackValue > 10000 then
                    set AttackValue = AttackValue/100
                    set realdamage = (((AttackValue * 1 + 100) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (I2R(Player_Physical_LessDamage[pid])/100))                
                    set realdamage = realdamage * 100
                else
                    set realdamage = (((AttackValue * 1 + 100) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (I2R(Player_Physical_LessDamage[pid])/100))
                endif
            else
                set realdamage = (((getdamage * 1 + 100) * getdamage)/(getdamage +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (I2R(Player_Magic_LessDamage[pid])/100))
                if realdamage >2000000000 or realdamage < 0 then
                    set realdamage = 2000000000
                endif
            endif
            call YDWESetEventDamage(realdamage)
        endif

		// static if LIBRARY_YDWEEventDamageData then
		// ///暴击和暴击几率
		// /*
		// 注意：
		// 暴击的漂浮文字，注意。这个容易爆炸
		// 如果地图含有分裂或多重的，有可能会容易炸的，因为一瞬间造成过多
		// 所以，可以在模拟分裂或多重的时候，是需要选取区域造成伤害的，可以在选取的时候 的那个伤害类型选择一个指定的
		// 然后再在这个函数库里面，关于条件判断的那里加多一个判断
		// 判断：单位所受伤害的伤害类型是当初选取指定的类型 不等于 true，这样那些分裂和多重就不会触发到暴击
		// // */
		// endif
	endfunction

    private function trg6Actime takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local unit sunit = YDWEGetUnitByString( "SkillTime"+I2S(YDWEH2I(t)), "unit")
        local integer needability = YDWEGetIntegerByString( "SkillTime"+I2S(YDWEH2I(t)), "abcode")
        local real time = YDWEGetRealByString( "SkillTime"+I2S(YDWEH2I(t)), "time")
        
        call YDWESetUnitAbilityState(sunit , needability , 1 , time)  
        call YDWEFlushMissionByString("SkillTime"+I2S(YDWEH2I(t)))
        call DestroyTimer(t)
    endfunction

    private function trg6Ac takes nothing returns nothing
        local integer needability
        local real coldtime
        local real tcoodtime
        local timer skt
        if (GetSpellAbilityUnit() == MMRAPI_TargetPlayer(GetOwningPlayer(GetSpellAbilityUnit()))) and (MMRAPI_TargetPlayer(GetOwningPlayer(GetSpellAbilityUnit())) != null )then
            set needability = GetSpellAbilityId()
            set tcoodtime = Player_Skill_Cold_Donw[GetPlayerId(GetOwningPlayer(GetSpellAbilityUnit()))]
            if tcoodtime < -70 then
               set tcoodtime = 0.3
            elseif tcoodtime > 0 then
               set tcoodtime = 1
            else 
                set tcoodtime = 1 + (tcoodtime/100)
            endif
            set skt = CreateTimer()
            set coldtime = YDWEGetUnitAbilityDataReal(GetSpellAbilityUnit(), needability, GetUnitAbilityLevel(GetSpellAbilityUnit(), needability), 105) * tcoodtime
            call YDWESaveUnitByString("SkillTime"+I2S(YDWEH2I(skt)) , "unit" ,GetSpellAbilityUnit() )
		    call YDWESaveIntegerByString( "SkillTime"+I2S(YDWEH2I(skt)), "abcode", needability)   
		    call YDWESaveRealByString( "SkillTime"+I2S(YDWEH2I(skt)), "time", coldtime)              
            call TimerStart(skt, 0.03, false , function trg6Actime) 
		    set skt = null
        endif
	endfunction
	function FuncItemSystem_Init takes nothing returns nothing
		local integer Sy = 0
		call InItem()
		set trg[0] = CreateTrigger() ///获得物品
		set trg[1] = CreateTrigger() ///丢弃物品
		set trg[2] = CreateTrigger() ///玩家12和中立敌对玩家单位死亡事件
		set trg[3] = CreateTrigger() ///玩家12和中立敌对玩家单位被攻击事件
		set trg[4] = CreateTrigger() ///1秒循环事件
        set trg[5] = CreateTrigger() ///释放技能事件
		loop
			exitwhen Sy == 8
			call TriggerRegisterPlayerUnitEvent(trg[0], Player(Sy), ConvertPlayerUnitEvent(49), null)
			call TriggerRegisterPlayerUnitEvent(trg[1], Player(Sy), ConvertPlayerUnitEvent(48), null)
            call TriggerRegisterPlayerUnitEvent(trg[5], Player(Sy), ConvertPlayerUnitEvent(274), null)
			set Sy = Sy + 1
		endloop
		call TriggerAddAction(trg[0],function trg0Ac)
		call TriggerAddAction(trg[1],function trg1Ac)
        call TriggerAddAction(trg[5],function trg6Ac)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(4), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(5), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(6), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(7), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(8), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(9), ConvertPlayerUnitEvent(20), null)
        call TriggerRegisterPlayerUnitEvent(trg[2], Player(10), ConvertPlayerUnitEvent(20), null)
		call TriggerRegisterPlayerUnitEvent(trg[2], Player(11), ConvertPlayerUnitEvent(20), null)
		call TriggerRegisterPlayerUnitEvent(trg[2], Player(12), ConvertPlayerUnitEvent(20), null)
		call TriggerAddCondition(trg[2], Condition(function trg23Co))
		call TriggerAddAction(trg[2],function trg2Ac)
		call TriggerRegisterPlayerUnitEvent(trg[3], Player(11), ConvertPlayerUnitEvent(18), null)
		call TriggerRegisterPlayerUnitEvent(trg[3], Player(12), ConvertPlayerUnitEvent(18), null)
		call TriggerAddCondition(trg[3], Condition(function trg23Co))
		call TriggerAddAction(trg[3],function trg3Ac)
		call TriggerRegisterTimerEvent(trg[4], 1.00, true)
		call TriggerAddAction(trg[4],function trg4Ac)
		static if LIBRARY_YDWETriggerEvent then
		set trg[5] = CreateTrigger() ///任意单位接受伤害
		call YDWESyStemAnyUnitDamagedRegistTrigger(trg[5])
		call TriggerAddCondition(trg[5], Condition(function trg5Co))
		call TriggerAddAction(trg[5],function trg5Ac)
		endif
        set Sy = 0
        loop
            exitwhen Sy > 7
            set Player_Normal_Physical_MultipliedValue[Sy] = 1
            set Player_Elite_Physical_MultipliedValue[Sy] = 1
            set Player_Boss_Physical_MultipliedValue[Sy] = 1
            set Player_Normal_Magic_MultipliedValue[Sy] = 1
            set Player_Elite_Magic_MultipliedValue[Sy] = 1
            set Player_Boss_Magic_MultipliedValue[Sy] = 1
            set Player_Physical_Critical_Value[Sy] = 30
            set Player_Physical_Critical_Percent[Sy] = 1
            set Player_Magic_Critical_Value[Sy] = 30
            set Player_Magic_Critical_Percent[Sy] = 1
            set Sy = Sy + 1
        endloop

	endfunction

	function AddAttributeAsItem takes item getitem , player tplayer returns nothing
	///获得物品触发器，攻击力 护甲 生命值 获得之后直接添加，其他的给操作物品单位绑定值
		local real GJL = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK))
		local real GJLAD = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_APPEND))
		local real HJ = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ARMOR))
		local real SMZ = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ =R2I( LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_MANA))
        local real HJAD = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit = MMRAPI_TargetPlayer(tplayer)
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2
		//拾取物品单位是英雄才增加
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		/// 攻击力
		if GJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x12),(GetUnitState(GetItemUnit,ConvertUnitState(0x12)) + GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x25),(GetUnitState(GetItemUnit,ConvertUnitState(0x25)) + (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x51),(GetUnitState(GetItemUnit,ConvertUnitState(0x51)) + (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x16),(GetUnitState(GetItemUnit,ConvertUnitState(0x16)) + I2R(GJJL)))
			call SetUnitState(GetItemUnit,ConvertUnitState(0x52),(GetUnitState(GetItemUnit,ConvertUnitState(0x16))))
		endif
		/// 护甲
		if HJ != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x20),(GetUnitState(GetItemUnit,ConvertUnitState(0x20)) + HJ))
		endif
		/// 生命值
		if SMZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE) + SMZ)
			call SetUnitState(GetItemUnit,UNIT_STATE_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_LIFE) + SMZ)
		endif
		/// 魔法值
		if MFZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA) + MFZ)
			call SetUnitState(GetItemUnit,UNIT_STATE_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MANA) + MFZ)
		endif
        //移动速度
        if YDSD != 0. then
            call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetTriggerUnit()) + YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) + STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) + AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) + INT ,false)
        endif


		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	


		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif

        //拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_HEALTH_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_MANA_PERCENT) , true)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MANA)

    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] + LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    endif

	endfunction

    function RemoveAttributeAsItem takes item getitem , player tplayer returns nothing
    ///丢弃物品触发器，攻击力 护甲 生命值 获得之后直接减少，其他的给操作物品单位绑定值
		local real GJL = I2R(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK))
		local real HJ = I2R(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ARMOR))
		local real SMZ = I2R(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ = I2R(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_MANA))
        local real GJLAD = I2R(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_APPEND))
        local real HJAD = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit =  MMRAPI_TargetPlayer(tplayer)
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2

		//拾取物品单位是英雄才减少
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		if GJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x12),(GetUnitState(GetItemUnit,ConvertUnitState(0x12)) - GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x25),(GetUnitState(GetItemUnit,ConvertUnitState(0x25)) - (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x51),(GetUnitState(GetItemUnit,ConvertUnitState(0x51)) - (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x16),(GetUnitState(GetItemUnit,ConvertUnitState(0x16)) - I2R(GJJL)))
			call SetUnitState(GetItemUnit,ConvertUnitState(0x52),(GetUnitState(GetItemUnit,ConvertUnitState(0x16))))
		endif
		if HJ != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x20),(GetUnitState(GetItemUnit,ConvertUnitState(0x20)) - HJ))
		endif
		if SMZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE) - SMZ)
		endif
		if MFZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA) - MFZ)
		endif
        //移动速度
        if YDSD != 0. then
        call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetItemUnit) - YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) - STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) - AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) - INT ,false)
        endif

		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	

		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif
    	//拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_STR_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_AGI_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_INT_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_HEALTH_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAX_MANA_PERCENT) , false)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_TIME_MANA)


    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] - LoadInteger(Item,GetItemTypeId(getitem),ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
	
    endif

    endfunction

    function AddAttributeAsItemType takes integer itemtypei , player tplayer returns nothing
	///获得物品触发器，攻击力 护甲 生命值 获得之后直接添加，其他的给操作物品单位绑定值
		local real GJL = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK))
		local real GJLAD = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_APPEND))
		local real HJ = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ARMOR))
		local real SMZ = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ =R2I( LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_MANA))
        local real HJAD = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit = MMRAPI_TargetPlayer(tplayer)
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2
		//拾取物品单位是英雄才增加
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		/// 攻击力
		if GJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x12),(GetUnitState(GetItemUnit,ConvertUnitState(0x12)) + GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x25),(GetUnitState(GetItemUnit,ConvertUnitState(0x25)) + (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x51),(GetUnitState(GetItemUnit,ConvertUnitState(0x51)) + (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x16),(GetUnitState(GetItemUnit,ConvertUnitState(0x16)) + I2R(GJJL)))
			call SetUnitState(GetItemUnit,ConvertUnitState(0x52),(GetUnitState(GetItemUnit,ConvertUnitState(0x16))))
		endif
		/// 护甲
		if HJ != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x20),(GetUnitState(GetItemUnit,ConvertUnitState(0x20)) + HJ))
		endif
		/// 生命值
		if SMZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE) + SMZ)
			call SetUnitState(GetItemUnit,UNIT_STATE_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_LIFE) + SMZ)
		endif
		/// 魔法值
		if MFZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA) + MFZ)
			call SetUnitState(GetItemUnit,UNIT_STATE_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MANA) + MFZ)
		endif
        //移动速度
        if YDSD != 0. then
            call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetItemUnit) + YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) + STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) + AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) + INT ,false)
        endif


		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	


		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif

        //拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_HEALTH_PERCENT) , true)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_MANA_PERCENT) , true)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MANA)

    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Time_Add_Attack_10[PlayerId] = Time_Add_Attack_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_ATTACK_10)
    set Time_Add_Str_10[PlayerId] = Time_Add_Str_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_STR_10)
    set Time_Add_Agi_10[PlayerId] = Time_Add_Agi_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_AGI_10)
    set Time_Add_Int_10[PlayerId] = Time_Add_Int_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_INT_10)
    set Time_Add_MaxHealth_10[PlayerId] = Time_Add_MaxHealth_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_HEALTH_10)
    set Time_Add_MaxMana_10[PlayerId] = Time_Add_MaxMana_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_MANA_10)
    set Time_Add_Gold_10[PlayerId] = Time_Add_Gold_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_GOLD_10)
    set Time_Add_Wood_10[PlayerId] = Time_Add_Wood_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_WOOD_10)

    set Kill_Add_Attack_10[PlayerId] = Kill_Add_Attack_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_ATTACK_10)
    set Kill_Add_Str_10[PlayerId] = Kill_Add_Str_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_STR_10)
    set Kill_Add_Agi_10[PlayerId] = Kill_Add_Agi_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_AGI_10)
    set Kill_Add_Int_10[PlayerId] = Kill_Add_Int_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_INT_10)
    set Kill_Add_MaxHealth_10[PlayerId] = Kill_Add_MaxHealth_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_HEALTH_10)
    set Kill_Add_MaxMana_10[PlayerId] = Kill_Add_MaxMana_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_MANA_10)
    set Kill_Add_Exp_10[PlayerId] = Kill_Add_Exp_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_10)
    set Kill_Add_Exp_Percent_10[PlayerId] = Kill_Add_Exp_Percent_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_PERCENT_10)
    set Kill_Add_Gold_10[PlayerId] = Kill_Add_Gold_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_10)
    set Kill_Add_Gold_Percent_10[PlayerId] = Kill_Add_Gold_Percent_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_PERCENT_10)
    set Kill_Add_Wood_10[PlayerId] = Kill_Add_Wood_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_10)
    set Kill_Add_Wood_Percent_10[PlayerId] = Kill_Add_Wood_Percent_10[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_PERCENT_10)

    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] + LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    endif

	endfunction

    function RemoveAttributeAsItemType takes integer itemtypei , player tplayer returns nothing
    ///丢弃物品触发器，攻击力 护甲 生命值 获得之后直接减少，其他的给操作物品单位绑定值
		local real GJL = I2R(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK))
		local real HJ = I2R(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ARMOR))
		local real SMZ = I2R(LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_HEALTH))
		local real MFZ = I2R(LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_MANA))
        local real GJLAD = I2R(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_APPEND))
        local real HJAD = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_ARMOR_APPEND))
        local integer YDSD = R2I(LoadInteger(Item,itemtypei,ITEM_SYSTEM_MOVE_SPEED))
        local integer STR = LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR)
        local integer AGI = LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI)
        local integer INT = LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT)
		local integer STRADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR_APPEND)
		local integer AGIADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI_APPEND)
		local integer INTADD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT_APPEND)
		local integer GJJL = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_FAR)
		local integer GJJG = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_DELAY)
		local integer GJSD = LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_SPEED)
		local unit GetItemUnit =  MMRAPI_TargetPlayer(tplayer)
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2

		//拾取物品单位是英雄才减少
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then

		if GJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x12),(GetUnitState(GetItemUnit,ConvertUnitState(0x12)) - GJL))
		endif
		/// 攻击间隔
		if GJJG != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x25),(GetUnitState(GetItemUnit,ConvertUnitState(0x25)) - (I2R(GJJG)/100)))
		endif
		/// 攻击速度
		if GJSD != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x51),(GetUnitState(GetItemUnit,ConvertUnitState(0x51)) - (I2R(GJSD)/100)))
		endif
		/// 攻击距离
		if GJJL != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x16),(GetUnitState(GetItemUnit,ConvertUnitState(0x16)) - I2R(GJJL)))
			call SetUnitState(GetItemUnit,ConvertUnitState(0x52),(GetUnitState(GetItemUnit,ConvertUnitState(0x16))))
		endif
		if HJ != 0. then
			call SetUnitState(GetItemUnit,ConvertUnitState(0x20),(GetUnitState(GetItemUnit,ConvertUnitState(0x20)) - HJ))
		endif
		if SMZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE,GetUnitState(GetItemUnit,UNIT_STATE_MAX_LIFE) - SMZ)
		endif
		if MFZ != 0. then
			call SetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA,GetUnitState(GetItemUnit,UNIT_STATE_MAX_MANA) - MFZ)
		endif
        //移动速度
        if YDSD != 0. then
        call SetUnitMoveSpeed( GetItemUnit , GetUnitMoveSpeed(GetItemUnit) - YDSD )
        endif

        if STR != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) - STR ,false)
        endif
        if AGI != 0 then
            call SetHeroAgi(GetItemUnit , GetHeroAgi(GetItemUnit , false) - AGI ,false)
        endif
        if INT != 0 then
            call SetHeroInt(GetItemUnit , GetHeroInt(GetItemUnit , false) - INT ,false)
        endif

		if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) - R2I(GJLAD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	

		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) - HJAD)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) - R2I(STRADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) - R2I(AGIADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) - R2I(INTADD))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif

	endif
    	//拾取物品单位是英雄才减少(分割一下上面写的太长了这部分是各种不是直接作用于本体而是单独储存的数据)
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true then
    call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 1 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_STR_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 2 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_AGI_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 3 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_INT_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 5 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_HEALTH_PERCENT) , false)
	call MMRAPI_ChangeAttributePercent(GetOwningPlayer(GetItemUnit) , 6 , LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAX_MANA_PERCENT) , false)

    set Time_Add_Attack[PlayerId] = Time_Add_Attack[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_ATTACK)
    set Time_Add_Str[PlayerId] = Time_Add_Str[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_STR)
    set Time_Add_Agi[PlayerId] = Time_Add_Agi[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_AGI)
    set Time_Add_Int[PlayerId] = Time_Add_Int[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_INT)
    set Time_Add_MaxHealth[PlayerId] = Time_Add_MaxHealth[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_HEALTH)
    set Time_Add_MaxMana[PlayerId] = Time_Add_MaxMana[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_MANA)
    set Time_Add_Gold[PlayerId] = Time_Add_Gold[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_GOLD)
    set Time_Add_Wood[PlayerId] = Time_Add_Wood[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_WOOD)
    set Time_Add_Health[PlayerId] = Time_Add_Health[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_HEALTH)
    set Time_Add_Mana[PlayerId] = Time_Add_Mana[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MANA)


    set Kill_Add_Attack[PlayerId] = Kill_Add_Attack[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_ATTACK)
    set Kill_Add_Str[PlayerId] = Kill_Add_Str[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_STR)
    set Kill_Add_Agi[PlayerId] = Kill_Add_Agi[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_AGI)
    set Kill_Add_Int[PlayerId] = Kill_Add_Int[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_INT)
    set Kill_Add_MaxHealth[PlayerId] = Kill_Add_MaxHealth[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_HEALTH)
    set Kill_Add_MaxMana[PlayerId] = Kill_Add_MaxMana[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_MANA)
    set Kill_Add_Exp[PlayerId] = Kill_Add_Exp[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP)
    set Kill_Add_Exp_Percent[PlayerId] = Kill_Add_Exp_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_PERCENT)
    set Kill_Add_Gold[PlayerId] = Kill_Add_Gold[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD)
    set Kill_Add_Gold_Percent[PlayerId] = Kill_Add_Gold_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_PERCENT)
    set Kill_Add_Wood[PlayerId] = Kill_Add_Wood[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD)
    set Kill_Add_Wood_Percent[PlayerId] = Kill_Add_Wood_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_PERCENT)

    set Time_Add_Attack_10[PlayerId] = Time_Add_Attack_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_ATTACK_10)
    set Time_Add_Str_10[PlayerId] = Time_Add_Str_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_STR_10)
    set Time_Add_Agi_10[PlayerId] = Time_Add_Agi_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_AGI_10)
    set Time_Add_Int_10[PlayerId] = Time_Add_Int_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_INT_10)
    set Time_Add_MaxHealth_10[PlayerId] = Time_Add_MaxHealth_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_HEALTH_10)
    set Time_Add_MaxMana_10[PlayerId] = Time_Add_MaxMana_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_MAX_MANA_10)
    set Time_Add_Gold_10[PlayerId] = Time_Add_Gold_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_GOLD_10)
    set Time_Add_Wood_10[PlayerId] = Time_Add_Wood_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_TIME_WOOD_10)

    set Kill_Add_Attack_10[PlayerId] = Kill_Add_Attack_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_ATTACK_10)
    set Kill_Add_Str_10[PlayerId] = Kill_Add_Str_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_STR_10)
    set Kill_Add_Agi_10[PlayerId] = Kill_Add_Agi_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_AGI_10)
    set Kill_Add_Int_10[PlayerId] = Kill_Add_Int_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_INT_10)
    set Kill_Add_MaxHealth_10[PlayerId] = Kill_Add_MaxHealth_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_HEALTH_10)
    set Kill_Add_MaxMana_10[PlayerId] = Kill_Add_MaxMana_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_MAX_MANA_10)
    set Kill_Add_Exp_10[PlayerId] = Kill_Add_Exp_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_10)
    set Kill_Add_Exp_Percent_10[PlayerId] = Kill_Add_Exp_Percent_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_EXP_PERCENT_10)
    set Kill_Add_Gold_10[PlayerId] = Kill_Add_Gold_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_10)
    set Kill_Add_Gold_Percent_10[PlayerId] = Kill_Add_Gold_Percent_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_GOLD_PERCENT_10)
    set Kill_Add_Wood_10[PlayerId] = Kill_Add_Wood_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_10)
    set Kill_Add_Wood_Percent_10[PlayerId] = Kill_Add_Wood_Percent_10[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_KILL_WOOD_PERCENT_10)

    set Player_Physical_Critical_Value[PlayerId] = Player_Physical_Critical_Value[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_VALUE)
    set Player_Physical_Critical_Percent[PlayerId] = Player_Physical_Critical_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_CRITICAL_STRIKE_PERCENT)
    set Player_Magic_Critical_Value[PlayerId] = Player_Magic_Critical_Value[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_VALUE)
    set Player_Magic_Critical_Percent[PlayerId] = Player_Magic_Critical_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_CRITICAL_STRIKE_PERCENT)
    set Player_Skill_Damage_Percent[PlayerId] = Player_Skill_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_DAMAGE_PERCENT)
    set Player_Skill_Damage_Append[PlayerId] = Player_Skill_Damage_Append[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_DAMAGE_APPEDN)
    set Player_Attack_Damage_Append[PlayerId] = Player_Attack_Damage_Append[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_ATTACK_DAMAGE_APPEDN)

    set Player_Physical_Damage_Percent[PlayerId] = Player_Physical_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_DAMAGE_PERCENT)
    set Player_Magic_Damage_Percent[PlayerId] = Player_Magic_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_DAMAGE_PERCENT)
    set Player_Last_Damage_Percent[PlayerId] = Player_Last_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_LAST_DAMAGE_PERCENT)
    set Player_Normal_Damage_Percent[PlayerId] = Player_Normal_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_NORMAL_DAMAGE_PERCENT)
    set Player_Elite_Damage_Percent[PlayerId] = Player_Elite_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_ELITE_DAMAGE_PERCENT)
    set Player_Boss_Damage_Percent[PlayerId] = Player_Boss_Damage_Percent[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_BOSS_DAMAGE_PERCENT)

    set Player_Skill_Cold_Donw[PlayerId] = Player_Skill_Cold_Donw[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_SKILL_COLD_DOWN)

    set Player_Physical_Sucking[PlayerId] = Player_Physical_Sucking[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_BLOOD_SUCKING)
    set Player_Magic_Sucking[PlayerId] = Player_Magic_Sucking[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_BLOOD_SUCKING)
    set Player_Physical_LessDamage[PlayerId] = Player_Physical_LessDamage[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_PHYSICAL_PROTECT_PERCENT)
    set Player_Magic_LessDamage[PlayerId] = Player_Magic_LessDamage[PlayerId] - LoadInteger(Item,itemtypei,ITEM_SYSTEM_MAGIC_PROTECT_PERCENT)

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Physical_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Normal_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Elite_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (Player_Boss_Damage_Percent[PlayerId]/100)) * ( 1 + (Player_Magic_Damage_Percent[PlayerId]/100)) * (1 + (Player_Last_Damage_Percent[PlayerId]/100))
	
    endif

    endfunction

    function GetPlayerSkillCoodDown takes unit wichunit returns real realcooldown
        local real recoldown = I2R(Player_Skill_Cold_Donw[GetPlayerId(GetOwningPlayer(wichunit))])
            if recoldown < -70 then
               set recoldown = 0.3
            elseif recoldown > 0 then
               set recoldown = 1
            else 
                set recoldown = 1 + (recoldown/100)
            endif
        return recoldown
    endfunction

    function GetAttributeForPlayer takes player wichplayer , integer wihcattribute returns integer value
        local integer pid = GetPlayerId(wichplayer)
        if wihcattribute == 1 then
            return Time_Add_Attack[pid]
        elseif wihcattribute == 2 then
            return Time_Add_Str[pid]
        elseif wihcattribute == 3 then
            return Time_Add_Agi[pid]
        elseif wihcattribute == 4 then
            return Time_Add_Int[pid]
        elseif wihcattribute == 5 then
            return Time_Add_MaxHealth[pid]
        elseif wihcattribute == 6 then
            return Time_Add_MaxMana[pid]
        elseif wihcattribute == 7 then
            return Time_Add_Gold[pid]
        elseif wihcattribute == 8 then
            return Time_Add_Wood[pid]
        elseif wihcattribute == 9 then
            return Time_Add_Health[pid]
        elseif wihcattribute == 10 then
            return Time_Add_Mana[pid]
        elseif wihcattribute == 11 then
            return Kill_Add_Attack[pid]
        elseif wihcattribute == 12 then
            return Kill_Add_Str[pid]
        elseif wihcattribute == 13 then
            return Kill_Add_Agi[pid]
        elseif wihcattribute == 14 then
            return Kill_Add_Int[pid]
        elseif wihcattribute == 15 then
            return Kill_Add_MaxHealth[pid]
        elseif wihcattribute == 16 then
            return Kill_Add_MaxMana[pid]
        elseif wihcattribute == 17 then
            return Kill_Add_Exp[pid]
        elseif wihcattribute == 18 then
            return Kill_Add_Exp_Percent[pid]
        elseif wihcattribute == 19 then
            return Kill_Add_Gold[pid]
        elseif wihcattribute == 20 then
            return Kill_Add_Gold_Percent[pid]
        elseif wihcattribute == 21 then
            return Kill_Add_Wood[pid]
        elseif wihcattribute == 22 then
            return Kill_Add_Wood_Percent[pid]
        elseif wihcattribute == 23 then
            return Player_Physical_Critical_Value[pid]
        elseif wihcattribute == 24 then
            return Player_Physical_Critical_Percent[pid]
        elseif wihcattribute == 25 then
            return Player_Magic_Critical_Value[pid]
        elseif wihcattribute == 26 then
            return Player_Magic_Critical_Percent[pid]
        elseif wihcattribute == 27 then
            return Player_Skill_Damage_Percent[pid]
        elseif wihcattribute == 28 then
            return Player_Skill_Damage_Append[pid]
        elseif wihcattribute == 29 then
            return Player_Attack_Damage_Append[pid]
        elseif wihcattribute == 30 then
            return Player_Physical_Damage_Percent[pid]
        elseif wihcattribute == 31 then
            return Player_Magic_Damage_Percent[pid]
        elseif wihcattribute == 32 then
            return Player_Last_Damage_Percent[pid]
        elseif wihcattribute == 33 then
            return Player_Normal_Damage_Percent[pid]
        elseif wihcattribute == 34 then
            return Player_Elite_Damage_Percent[pid]
        elseif wihcattribute == 35 then
            return Player_Boss_Damage_Percent[pid]
        elseif wihcattribute == 36 then
            return Player_Physical_Sucking[pid]
        elseif wihcattribute == 37 then
            return Player_Magic_Sucking[pid]
        elseif wihcattribute == 38 then
            return Player_Physical_LessDamage[pid]
        elseif wihcattribute == 39 then
            return Player_Magic_LessDamage[pid]
        elseif wihcattribute == 40 then
            return Player_Skill_Cold_Donw[pid]
        elseif wihcattribute == 41 then
            return MMRAPI_GetAttributePercent(Player(pid) , 1 )
        elseif wihcattribute == 42 then
            return MMRAPI_GetAttributePercent(Player(pid) , 2 )
        elseif wihcattribute == 43 then
            return MMRAPI_GetAttributePercent(Player(pid) , 3 )
        elseif wihcattribute == 44 then
            return MMRAPI_GetAttributePercent(Player(pid) , 4 )
        elseif wihcattribute == 45 then
            return MMRAPI_GetAttributePercent(Player(pid) , 5 )
        elseif wihcattribute == 46 then
            return MMRAPI_GetAttributePercent(Player(pid) , 6 )
         elseif wihcattribute == 47 then
            return Time_Add_Attack_10[pid]
        elseif wihcattribute == 48 then
            return Time_Add_Str_10[pid]
        elseif wihcattribute == 49 then
            return Time_Add_Agi_10[pid]
        elseif wihcattribute == 50 then
            return Time_Add_Int_10[pid]
        elseif wihcattribute == 51 then
            return Time_Add_MaxHealth_10[pid]
        elseif wihcattribute == 52 then
            return Time_Add_MaxMana_10[pid]
        elseif wihcattribute == 53 then
            return Time_Add_Gold_10[pid]
        elseif wihcattribute == 54 then
            return Time_Add_Wood_10[pid]
        elseif wihcattribute == 55 then
            return Kill_Add_Attack_10[pid]
        elseif wihcattribute == 56 then
            return Kill_Add_Str_10[pid]
        elseif wihcattribute == 57 then
            return Kill_Add_Agi_10[pid]
        elseif wihcattribute == 58 then
            return Kill_Add_Int_10[pid]
        elseif wihcattribute == 59 then
            return Kill_Add_MaxHealth_10[pid]
        elseif wihcattribute == 60 then
            return Kill_Add_MaxMana_10[pid]
        elseif wihcattribute == 61 then
            return Kill_Add_Exp_10[pid]
        elseif wihcattribute == 62 then
            return Kill_Add_Exp_Percent_10[pid]
        elseif wihcattribute == 63 then
            return Kill_Add_Gold_10[pid]
        elseif wihcattribute == 64 then
            return Kill_Add_Gold_Percent_10[pid]
        elseif wihcattribute == 65 then
            return Kill_Add_Wood_10[pid]
        elseif wihcattribute == 66 then
            return Kill_Add_Wood_Percent_10[pid] 
        endif
            return 0 
    endfunction

    function SetAttributeForPlayer takes player wichplayer , integer wihcattribute , integer value returns nothing
        local integer pid = GetPlayerId(wichplayer)
        if wihcattribute == 1 then
            set Time_Add_Attack[pid] = value
        elseif wihcattribute == 2 then
            set Time_Add_Str[pid] = value
        elseif wihcattribute == 3 then
            set Time_Add_Agi[pid] = value
        elseif wihcattribute == 4 then
            set Time_Add_Int[pid] = value
        elseif wihcattribute == 5 then
            set Time_Add_MaxHealth[pid] = value
        elseif wihcattribute == 6 then
            set Time_Add_MaxMana[pid] = value
        elseif wihcattribute == 7 then
            set Time_Add_Gold[pid] = value
        elseif wihcattribute == 8 then
            set Time_Add_Wood[pid] = value
        elseif wihcattribute == 9 then
            set Time_Add_Health[pid] = value
        elseif wihcattribute == 10 then
            set Time_Add_Mana[pid] = value
        elseif wihcattribute == 11 then
            set Kill_Add_Attack[pid] = value
        elseif wihcattribute == 12 then
            set Kill_Add_Str[pid] = value
        elseif wihcattribute == 13 then
            set Kill_Add_Agi[pid] = value
        elseif wihcattribute == 14 then
            set Kill_Add_Int[pid] = value
        elseif wihcattribute == 15 then
            set Kill_Add_MaxHealth[pid] = value
        elseif wihcattribute == 16 then
            set Kill_Add_MaxMana[pid] = value
        elseif wihcattribute == 17 then
            set Kill_Add_Exp[pid] = value
        elseif wihcattribute == 18 then
            set Kill_Add_Exp_Percent[pid] = value
        elseif wihcattribute == 19 then
            set Kill_Add_Gold[pid] = value
        elseif wihcattribute == 20 then
            set Kill_Add_Gold_Percent[pid] = value
        elseif wihcattribute == 21 then
            set Kill_Add_Wood[pid] = value
        elseif wihcattribute == 22 then
            set Kill_Add_Wood_Percent[pid] = value
        elseif wihcattribute == 23 then
            set Player_Physical_Critical_Value[pid] = value
        elseif wihcattribute == 24 then
            set Player_Physical_Critical_Percent[pid] = value
        elseif wihcattribute == 25 then
            set Player_Magic_Critical_Value[pid] = value
        elseif wihcattribute == 26 then
            set Player_Magic_Critical_Percent[pid] = value
        elseif wihcattribute == 27 then
            set Player_Skill_Damage_Percent[pid] = value
        elseif wihcattribute == 28 then
            set Player_Skill_Damage_Append[pid] = value
        elseif wihcattribute == 29 then
            set Player_Attack_Damage_Append[pid] = value
        elseif wihcattribute == 30 then
            set Player_Physical_Damage_Percent[pid] = value
        elseif wihcattribute == 31 then
            set Player_Magic_Damage_Percent[pid] = value
        elseif wihcattribute == 32 then
            set Player_Last_Damage_Percent[pid] = value
        elseif wihcattribute == 33 then
            set Player_Normal_Damage_Percent[pid] = value
        elseif wihcattribute == 34 then
            set Player_Elite_Damage_Percent[pid] = value
        elseif wihcattribute == 35 then
            set Player_Boss_Damage_Percent[pid] = value
        elseif wihcattribute == 36 then
            set Player_Physical_Sucking[pid] = value
        elseif wihcattribute == 37 then
            set Player_Magic_Sucking[pid] = value
        elseif wihcattribute == 38 then
            set Player_Physical_LessDamage[pid] = value
        elseif wihcattribute == 39 then
            set Player_Magic_LessDamage[pid] = value
        elseif wihcattribute == 40 then
            set Player_Skill_Cold_Donw[pid] = value
        elseif wihcattribute == 41 then
            call MMRAPI_HeroPercentSet(Player(pid) , 1 , value )
        elseif wihcattribute == 42 then
            call MMRAPI_HeroPercentSet(Player(pid) , 2 , value )
        elseif wihcattribute == 43 then
            call MMRAPI_HeroPercentSet(Player(pid) , 3 , value )
        elseif wihcattribute == 44 then
            call MMRAPI_HeroPercentSet(Player(pid) , 4 , value )
        elseif wihcattribute == 45 then
            call MMRAPI_HeroPercentSet(Player(pid) , 5 , value )
        elseif wihcattribute == 46 then
            call MMRAPI_HeroPercentSet(Player(pid) , 6 , value )
        elseif wihcattribute == 47 then
            set Time_Add_Attack_10[pid] = value
        elseif wihcattribute == 48 then
            set Time_Add_Str_10[pid] = value
        elseif wihcattribute == 49 then
            set Time_Add_Agi_10[pid] = value
        elseif wihcattribute == 50 then
            set Time_Add_Int_10[pid] = value
        elseif wihcattribute == 51 then
            set Time_Add_MaxHealth_10[pid] = value
        elseif wihcattribute == 52 then
            set Time_Add_MaxMana_10[pid] = value
        elseif wihcattribute == 53 then
            set Time_Add_Gold_10[pid] = value
        elseif wihcattribute == 54 then
            set Time_Add_Wood_10[pid] = value
        elseif wihcattribute == 55 then
            set Kill_Add_Attack_10[pid] = value
        elseif wihcattribute == 56 then
            set Kill_Add_Str_10[pid] = value
        elseif wihcattribute == 57 then
            set Kill_Add_Agi_10[pid] = value
        elseif wihcattribute == 58 then
            set Kill_Add_Int_10[pid] = value
        elseif wihcattribute == 59 then
            set Kill_Add_MaxHealth_10[pid] = value
        elseif wihcattribute == 60 then
            set Kill_Add_MaxMana_10[pid] = value
        elseif wihcattribute == 61 then
            set Kill_Add_Exp_10[pid] = value
        elseif wihcattribute == 62 then
            set Kill_Add_Exp_Percent_10[pid] = value
        elseif wihcattribute == 63 then
            set Kill_Add_Gold_10[pid] = value
        elseif wihcattribute == 64 then
            set Kill_Add_Gold_Percent_10[pid] = value
        elseif wihcattribute == 65 then
            set Kill_Add_Wood_10[pid] = value
        elseif wihcattribute == 66 then
            set Kill_Add_Wood_Percent_10[pid] = value
        endif
    set Player_Normal_Physical_MultipliedValue[pid] = ( 1 + (Player_Normal_Damage_Percent[pid]/100)) * ( 1 + (Player_Physical_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))
    set Player_Elite_Physical_MultipliedValue[pid] = ( 1 + (Player_Elite_Damage_Percent[pid]/100)) * ( 1 + (Player_Physical_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))
    set Player_Boss_Physical_MultipliedValue[pid] = ( 1 + (Player_Boss_Damage_Percent[pid]/100)) * ( 1 + (Player_Physical_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))

    set Player_Normal_Magic_MultipliedValue[pid] = ( 1 + (Player_Normal_Damage_Percent[pid]/100)) * ( 1 + (Player_Magic_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))
    set Player_Elite_Magic_MultipliedValue[pid] = ( 1 + (Player_Elite_Damage_Percent[pid]/100)) * ( 1 + (Player_Magic_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))
    set Player_Boss_Magic_MultipliedValue[pid] = ( 1 + (Player_Boss_Damage_Percent[pid]/100)) * ( 1 + (Player_Magic_Damage_Percent[pid]/100)) * (1 + (Player_Last_Damage_Percent[pid]/100))
	
    endfunction

    function AddAttributeForPlayer takes player wichplayer , integer wihcattribute , integer value returns nothing
        call SetAttributeForPlayer(wichplayer,wihcattribute ,GetAttributeForPlayer(wichplayer , wihcattribute) + value)
    endfunction
endlibrary

#endif



#ifndef ChooseOneForThreeIncluded 
#define ChooseOneForThreeIncluded
library ChooseOneForThree  requires BzAPI , YDWEAbilityState , YDWEYDWEJapiScript , MmrApi , FuncItemSystem
    globals

        private integer array ChooseOneForThree_InUI
        private integer array ChooseOneForThree_BaseChoose_DB
        private integer array ChooseOneForThree_Choose_Texture
        private integer array ChooseOneForThree_Choose_Bottom
        private integer array ChooseOneForThree_Choose_Text
        private integer ChooseOneForThree_BaseShow
        private integer ChooseOneForThree_MouseInTx
        private boolean array IsShowChooseOneForThree
        private string  BaseChoose_DB_TextureFile = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
        private string  MouseInTx_ModeFile  = "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl"
        private string  TextureFile = "ReplaceableTextures\\CommandButtons\\BTNReveal.blp"
        private string  ChooseAndShowText = "这是一串超级超级超级超级超级超级超级长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长的测试字符"
        private string TiltleMessage = "|cff00FF00请点击图标选择"
        private string SyncDataType = "ChooseOneForThree"
        private trigger SyncDataTrigger 
        private integer array LastTimeChoose 
        private boolean TestContral = false
        private hashtable AbStr = InitHashtable()
        private integer array ChooseThreeOfOneTime

        private string array BaseChoose_DB_TextureFile_Choose1
        private string array BaseChoose_DB_TextureFile_Choose2
        private string array BaseChoose_DB_TextureFile_Choose3

        private string array MouseInTx_ModeFile_Choose1
        private string array MouseInTx_ModeFile_Choose2
        private string array MouseInTx_ModeFile_Choose3

        private string array TextureFile_Choose1
        private string array TextureFile_Choose2
        private string array TextureFile_Choose3

        private string array ChooseAndShowText_Choose1
        private string array ChooseAndShowText_Choose2
        private string array ChooseAndShowText_Choose3
        /*1是装备，2是技能*/
        private integer array Choose_1_Type
        private integer array Choose_2_Type
        private integer array Choose_3_Type 

        private integer array Choose_1_Id
        private integer array Choose_2_Id
        private integer array Choose_3_Id

        private boolean array Chosse_1_TJ
        private boolean array Chosse_2_TJ
        private boolean array Chosse_3_TJ

        private boolean array CanThisPalyerUseChoose3

        private hashtable AttributeHash
        private integer AttributeHashLen
        private string array AttributeString
        private string array AttributeString2
        integer array PlayerAttributeCorrectedValue
    endglobals

    /*鼠标进入选择点特效提示*/
    private function WhenLocalPlayerMouseInBottomTxShow takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        if Tui == ChooseOneForThree_Choose_Bottom[0] then
        call DzFrameSetPoint(ChooseOneForThree_MouseInTx, 4, ChooseOneForThree_Choose_Texture[0], 4, 0, 0.00 )
        call DzFrameSetModel( ChooseOneForThree_MouseInTx,  MouseInTx_ModeFile_Choose1[playerid], 0, 0 )
        elseif Tui == ChooseOneForThree_Choose_Bottom[1] then
        call DzFrameSetPoint(ChooseOneForThree_MouseInTx, 4, ChooseOneForThree_Choose_Texture[1], 4, 0, 0.00 )
        call DzFrameSetModel( ChooseOneForThree_MouseInTx,  MouseInTx_ModeFile_Choose2[playerid], 0, 0 )
        elseif Tui == ChooseOneForThree_Choose_Bottom[2] then
        call DzFrameSetPoint(ChooseOneForThree_MouseInTx, 4, ChooseOneForThree_Choose_Texture[2], 4, 0, 0.00 )
        call DzFrameSetModel( ChooseOneForThree_MouseInTx,  MouseInTx_ModeFile_Choose3[playerid], 0, 0 )
        endif
        call DzFrameShow(ChooseOneForThree_MouseInTx, true )
    endfunction    
    /*鼠标移出选择点特效关闭*/
    private function WhenLocalPlayerMouseOutBottomTxClose takes nothing returns nothing
        call DzFrameShow(ChooseOneForThree_MouseInTx, false )
    endfunction

    private function WhenLocalPlayerMouseKickInChooseThreeOfOne takes nothing returns nothing
        call DzSyncData( SyncDataType, "9"+I2S(GetPlayerId(DzGetTriggerUIEventPlayer())))
    endfunction

    private function LocalPlayerMousePressBottom takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        set IsShowChooseOneForThree[playerid] = false
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[0], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[1], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[2], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[3], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[4], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[5], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[6], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[7], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseShow, IsShowChooseOneForThree[playerid] )
        if Tui == ChooseOneForThree_Choose_Bottom[0] then
        call DzSyncData( SyncDataType, "0"+I2S(playerid)) 
        elseif Tui == ChooseOneForThree_Choose_Bottom[1] then
        call DzSyncData( SyncDataType, "1"+I2S(playerid))
        elseif Tui == ChooseOneForThree_Choose_Bottom[2] then
        call DzSyncData( SyncDataType, "2"+I2S(playerid))
        endif
    endfunction

    private function DisLikeChoose takes nothing returns nothing
        local integer playerid = GetPlayerId(DzGetTriggerUIEventPlayer())
        set IsShowChooseOneForThree[playerid] = false
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[0], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[1], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[2], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[3], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[4], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[5], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[6], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[7], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseShow, IsShowChooseOneForThree[playerid] )        
    endfunction

    private function LuaLoadAbility takes nothing returns nothing

        <?for id, obj in pairs(slk.ability) do
	    local tip = obj.tip
        local ubertip = obj.ubertip
	    local Tip = tip or ''
	    ?>
            <?if tip ~= nil then?>
	            call SaveStr(AbStr,'<?=id?>',1,<?='"'..tip..'"'?>)
	        <?end?>
            <?if ubertip ~= nil then?>
                call SaveStr(AbStr,'<?=id?>',2,<?='"'..ubertip..'"'?>)
	        <?end?>
	    <?end?>

    endfunction


    private function ChooseOneForThree_Main takes nothing returns nothing
        local integer ydul_a
        local integer BaseUserUi = DzGetGameUI()
        local boolean IsFirstTimeOpen = TestContral

        call LuaLoadAbility()

        if true then

            set ChooseOneForThree_InUI[0] = DzCreateFrameByTagName("BACKDROP", "ChooseInUI1", BaseUserUi, "template", 0)
            call DzFrameShow( ChooseOneForThree_InUI[0] , true )
            call DzFrameSetSize( ChooseOneForThree_InUI[0] , 0.035, 0.035 )
            call DzFrameSetTexture( ChooseOneForThree_InUI[0] , "ReplaceableTextures\\CommandButtons\\BTNBookOfTheDead.blp" , 0 )
            call DzFrameSetPoint( ChooseOneForThree_InUI[0] , 4, BaseUserUi , 4, 0.08, -0.13 )

            set ChooseOneForThree_InUI[1] = DzCreateFrameByTagName("TEXT", "ChooseInUI2", ChooseOneForThree_InUI[0], "template", 0)
            call DzFrameSetText(ChooseOneForThree_InUI[1] , "三选一")
            call DzFrameSetTextColor(ChooseOneForThree_InUI[1] , DzGetColor(0x00, 0xff, 0xfb, 0x00))
            call DzFrameSetPoint( ChooseOneForThree_InUI[1] , 4, ChooseOneForThree_InUI[0] , 4, 0, 0 )
            call DzFrameSetFont(ChooseOneForThree_InUI[1] , "war3mapImported\\fonts.ttf" ,0.01 , 1)

            set ChooseOneForThree_InUI[2] = DzCreateFrameByTagName("SPRITE", "ChooseInUI3", ChooseOneForThree_InUI[0], "template", 0)
            call DzFrameSetModel( ChooseOneForThree_InUI[2], MouseInTx_ModeFile, 0, 0 )
            call DzFrameSetSize( ChooseOneForThree_InUI[2], 0.035, 0.035 )
            call DzFrameSetPoint( ChooseOneForThree_InUI[2] , 4, ChooseOneForThree_InUI[0] , 4, 0, 0 )
            call DzFrameShow( ChooseOneForThree_InUI[2] , false )

            set ChooseOneForThree_InUI[3] = DzCreateFrameByTagName("BUTTON", "ChooseInUI4", ChooseOneForThree_InUI[2], "template", 0)
            call DzFrameSetSize( ChooseOneForThree_InUI[3], 0.035, 0.035 )
            call DzFrameSetPoint( ChooseOneForThree_InUI[3] , 4, ChooseOneForThree_InUI[2] , 4, 0, 0 )
            if GetLocalPlayer() == GetLocalPlayer() then
            	call DzFrameSetScriptByCode( ChooseOneForThree_InUI[3] , 1 , function WhenLocalPlayerMouseKickInChooseThreeOfOne, false)
            endif
        endif
        set ChooseOneForThree_BaseChoose_DB[0] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB1", BaseUserUi, "template", 0)
        set ChooseOneForThree_BaseChoose_DB[1] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB2", BaseUserUi, "template", 0)
        set ChooseOneForThree_BaseChoose_DB[2] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB3", BaseUserUi, "template", 0)
        set ChooseOneForThree_BaseChoose_DB[3] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB4", BaseUserUi, "template", 0)

        //取消按钮
        set ChooseOneForThree_BaseChoose_DB[4] =  DzCreateFrameByTagName("BUTTON", "ChooseBaseDB5", ChooseOneForThree_BaseChoose_DB[3], "template", 0)

        //推荐按钮
        set ChooseOneForThree_BaseChoose_DB[5] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB5", BaseUserUi, "template", 0)
        set ChooseOneForThree_BaseChoose_DB[6] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB6", BaseUserUi, "template", 0)
        set ChooseOneForThree_BaseChoose_DB[7] =  DzCreateFrameByTagName("BACKDROP", "ChooseBaseDB7", BaseUserUi, "template", 0)


        set ChooseOneForThree_BaseShow =  DzCreateFrameByTagName("TEXT", "ChooseShowText", BaseUserUi, "template", 0)
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[0] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[1] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[2] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[3] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[4] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[5] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[6] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseChoose_DB[7] , IsFirstTimeOpen )
        call DzFrameShow( ChooseOneForThree_BaseShow, IsFirstTimeOpen )

        call DzFrameSetAbsolutePoint( ChooseOneForThree_BaseChoose_DB[0] , 4, 0.13, 0.34 )
        call DzFrameSetAbsolutePoint( ChooseOneForThree_BaseShow, 4, 0.455, 0.50 )

        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[1] , 3, ChooseOneForThree_BaseChoose_DB[0] , 5, 0.03, 0 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[2] , 3, ChooseOneForThree_BaseChoose_DB[1], 5, 0.03, 0 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[3] , 4, ChooseOneForThree_BaseChoose_DB[1], 4, 0, -0.18 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[4] , 4, ChooseOneForThree_BaseChoose_DB[3], 4, 0, 0 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[5] , 4, ChooseOneForThree_BaseChoose_DB[0], 4, 0, -0.08 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[6] , 4, ChooseOneForThree_BaseChoose_DB[1], 4, 0, -0.08 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[7] , 4, ChooseOneForThree_BaseChoose_DB[2], 4, 0, -0.08 )

        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[0] , 0.15, 0.30 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[1] , 0.15, 0.30 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[2] , 0.15, 0.30 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[3] , 0.06, 0.03 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[4] , 0.06, 0.03 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[5] , 0.06, 0.03 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[6] , 0.06, 0.03 )
        call DzFrameSetSize( ChooseOneForThree_BaseChoose_DB[7] , 0.06, 0.03 )
        call DzFrameSetSize( ChooseOneForThree_BaseShow, 0.15, 0.02 )

        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[0] , BaseChoose_DB_TextureFile, 0 )
        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[1] , BaseChoose_DB_TextureFile, 0 )
        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[2] , BaseChoose_DB_TextureFile, 0 )
        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[3] , "war3mapImported\\Botoom_Gold_NotChoose.blp", 0 )

        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[5] , "war3mapImported\\CanTrans.blp", 0 )
        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[6] , "war3mapImported\\CanTrans.blp", 0 )
        call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[7] , "war3mapImported\\CanTrans.blp", 0 )

        
        call DzFrameSetText( ChooseOneForThree_BaseShow, TiltleMessage )

        call DzFrameSetScriptByCode( ChooseOneForThree_BaseChoose_DB[4] , 1 , function DisLikeChoose, false)

        set ydul_a = 0
        loop
            exitwhen ydul_a > 2
            set ChooseOneForThree_Choose_Texture[ydul_a] = DzCreateFrameByTagName("BACKDROP", "name", ChooseOneForThree_BaseChoose_DB[ydul_a], "template", 0)
            call DzFrameSetPoint( ChooseOneForThree_Choose_Texture[ydul_a], 1, ChooseOneForThree_BaseChoose_DB[ydul_a], 1, 0, -0.02 )
            call DzFrameSetTexture( ChooseOneForThree_Choose_Texture[ydul_a], TextureFile, 0 )
            call DzFrameSetSize( ChooseOneForThree_Choose_Texture[ydul_a], 0.04, 0.04 )
            set ChooseOneForThree_Choose_Text[ydul_a] = DzCreateFrameByTagName("TEXT", "name", ChooseOneForThree_BaseChoose_DB[ydul_a], "template", 0)
            call DzFrameSetPoint( ChooseOneForThree_Choose_Text[ydul_a], 1, ChooseOneForThree_BaseChoose_DB[ydul_a], 1, 0.002, -0.08 )
            call DzFrameSetSize( ChooseOneForThree_Choose_Text[ydul_a], 0.11, 0.20 )
            call DzFrameSetText( ChooseOneForThree_Choose_Text[ydul_a], ChooseAndShowText)
            set ChooseOneForThree_Choose_Bottom[ydul_a] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", ChooseOneForThree_BaseChoose_DB[ydul_a] , "template", 0)
            call DzFrameSetPoint( ChooseOneForThree_Choose_Bottom[ydul_a], 4, ChooseOneForThree_BaseChoose_DB[ydul_a] , 4, 0, 0 )
            call DzFrameSetSize( ChooseOneForThree_Choose_Bottom[ydul_a], 0.15, 0.30 )
            
            if GetLocalPlayer() == GetLocalPlayer() then
            	call DzFrameSetScriptByCode( ChooseOneForThree_Choose_Bottom[ydul_a] , 2 , function WhenLocalPlayerMouseInBottomTxShow, false)
                call DzFrameSetScriptByCode( ChooseOneForThree_Choose_Bottom[ydul_a] , 3 , function WhenLocalPlayerMouseOutBottomTxClose, false)
                call DzFrameSetScriptByCode( ChooseOneForThree_Choose_Bottom[ydul_a] , 4 , function LocalPlayerMousePressBottom, false)
            endif
            set ydul_a = ydul_a + 1
        endloop
        call DzFrameSetAbsolutePoint( ChooseOneForThree_BaseChoose_DB[0], 4, 0.19, 0.34 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[1], 3, ChooseOneForThree_BaseChoose_DB[0], 5, 0.06, 0 )
        call DzFrameSetPoint( ChooseOneForThree_BaseChoose_DB[2], 3, ChooseOneForThree_BaseChoose_DB[1], 5, 0.06, 0 )
        /*初始化鼠标进入特效*/
        set ChooseOneForThree_MouseInTx = DzCreateFrameByTagName("SPRITE", "name", BaseUserUi, "template", 0)
        call DzFrameSetModel( ChooseOneForThree_MouseInTx, MouseInTx_ModeFile, 0, 0 )
        call DzFrameSetSize( ChooseOneForThree_MouseInTx, 0.04, 0.04 )
        call DzFrameShow( ChooseOneForThree_MouseInTx, false )
    endfunction    

    private function AddChooseDataToPlayer takes nothing returns nothing
    local string SyncData = DzGetTriggerSyncData()
    local string ChooseType = SubStringBJ(SyncData, 1 , 1 )
    local integer PlayerId = S2I(SubStringBJ(SyncData, 2 , 3 ))
    local integer ChooseDataType
    local integer ChooseValueId
    local unit locUnit = MMRAPI_TargetPlayer(ConvertedPlayer(PlayerId + 1))
    local real UX
    local real UY
    local item CItem
    local integer looptime = 0
    set UY =  GetUnitY(locUnit)
    set UX =  GetUnitX(locUnit)
    set LastTimeChoose[PlayerId] = S2I(ChooseType) + 1
    if S2I(ChooseType) == 0 then
    set ChooseDataType = Choose_1_Type[PlayerId]
    set ChooseValueId = Choose_1_Id[PlayerId]
    elseif S2I(ChooseType) == 1 then    
    set ChooseDataType = Choose_2_Type[PlayerId]
    set ChooseValueId = Choose_2_Id[PlayerId]
    elseif S2I(ChooseType) == 2 then    
    set ChooseDataType = Choose_3_Type[PlayerId]
    set ChooseValueId = Choose_3_Id[PlayerId]
    elseif S2I(ChooseType) == 9 then  
    call ShowChooseUiToPlayer.execute(Player(PlayerId) , 3 , 0 , 3 , 0 , 3 , 0 )
    set ChooseDataType = 0
    endif
    if locUnit != null then
        if ChooseDataType == 1 then
            set CItem = CreateItem(ChooseValueId , UX , UY)
            call UnitAddItem(locUnit , CItem) 
        elseif ChooseDataType == 2 then
            call MMRAPI_AddSkillAsSoltAndHero(ConvertedPlayer(PlayerId + 1) , ChooseValueId )
        elseif ChooseDataType == 3 then
            loop
                exitwhen looptime > LoadInteger(AttributeHash , ChooseValueId , 0 )
                call AddAttributeForPlayer(Player(PlayerId) , LoadInteger(AttributeHash , ChooseValueId , looptime) , R2I(LoadReal(AttributeHash , ChooseValueId , looptime )) * PlayerAttributeCorrectedValue[PlayerId])                
                set looptime  = looptime + 1 
            endloop
        endif 
    endif


    endfunction

    function ChooseOneForThree_Init takes nothing returns nothing
        local boolean IsFirstTimeOpen = TestContral
        local integer LoopTime = 0

        loop
            exitwhen LoopTime > 7
            set PlayerAttributeCorrectedValue[LoopTime] = 1
            set ChooseThreeOfOneTime[LoopTime] = 0
            set IsShowChooseOneForThree[LoopTime] = IsFirstTimeOpen
            set LastTimeChoose[LoopTime] = 9999
            set BaseChoose_DB_TextureFile_Choose1[LoopTime] = BaseChoose_DB_TextureFile
            set BaseChoose_DB_TextureFile_Choose2[LoopTime] = BaseChoose_DB_TextureFile
            set BaseChoose_DB_TextureFile_Choose3[LoopTime] = BaseChoose_DB_TextureFile

            set MouseInTx_ModeFile_Choose1[LoopTime] = MouseInTx_ModeFile
            set MouseInTx_ModeFile_Choose2[LoopTime] = MouseInTx_ModeFile
            set MouseInTx_ModeFile_Choose3[LoopTime] = MouseInTx_ModeFile

            set TextureFile_Choose1[LoopTime] = TextureFile
            set TextureFile_Choose2[LoopTime] = TextureFile
            set TextureFile_Choose3[LoopTime] = TextureFile

            set ChooseAndShowText_Choose1[LoopTime] = ChooseAndShowText
            set ChooseAndShowText_Choose2[LoopTime] = ChooseAndShowText
            set ChooseAndShowText_Choose3[LoopTime] = ChooseAndShowText

            set Choose_1_Type[LoopTime] = 9999
            set Choose_1_Id[LoopTime] = 0

            set Choose_2_Type[LoopTime] = 9999
            set Choose_2_Id[LoopTime] = 0

            set Choose_3_Type[LoopTime] = 9999
            set Choose_3_Id[LoopTime] = 0

            set CanThisPalyerUseChoose3[LoopTime] = false
            set LoopTime = LoopTime + 1
        endloop

        set AttributeHash = InitHashtable()
        set AttributeHashLen = 0

        set AttributeString[1] = "每秒攻击力增加"
        set AttributeString[2] = "每秒力量增加"
        set AttributeString[3] = "每秒敏捷增加"
        set AttributeString[4] = "每秒智力增加"
        set AttributeString[5] = "每秒最大生命值增加"
        set AttributeString[6] = "每秒最大魔法值增加"
        set AttributeString[7] = "每秒金币增加"
        set AttributeString[8] = "每秒木材增加"
        set AttributeString[9] = "每秒生命回复增加"
        set AttributeString[10] = "每秒魔法回复增加"
        set AttributeString[11] = "杀敌攻击力增加"
        set AttributeString[12] = "杀敌力量增加"
        set AttributeString[13] = "杀敌敏捷增加"
        set AttributeString[14] = "杀敌智力增加"
        set AttributeString[15] = "杀敌最大生命增加"
        set AttributeString[16] = "杀敌最大魔法增加"
        set AttributeString[17] = "杀敌经验增加"
        set AttributeString[18] = "杀敌经验增加(百分比)"
        set AttributeString[19] = "杀敌金币增加"
        set AttributeString[20] = "杀敌金币增加(百分比)"
        set AttributeString[21] = "杀敌木材增加"
        set AttributeString[22] = "杀敌木材增加(百分比)"
        set AttributeString[23] = "物理暴击伤害增加"
        set AttributeString[24] = "物理暴击率增加"
        set AttributeString[25] = "魔法暴击伤害增加"
        set AttributeString[26] = "魔法暴击率增加"
        set AttributeString[27] = "技能伤害百分比增加"
        set AttributeString[28] = "技能伤害附加增加"
        set AttributeString[29] = "攻击伤害附加增加"
        set AttributeString[30] = "物理伤害增加"
        set AttributeString[31] = "魔法伤害增加"
        set AttributeString[32] = "最终伤害增加"
        set AttributeString[33] = "普通怪增伤增加"
        set AttributeString[34] = "精英怪增伤增加"
        set AttributeString[35] = "Boss增伤增加"
        set AttributeString[36] = "物理吸血增加"
        set AttributeString[37] = "魔法吸血增加"
        set AttributeString[38] = "物理减伤增加"
        set AttributeString[39] = "魔法减伤增加"
        set AttributeString[40] = "冷却时间减少增加"
        set AttributeString[41] = "力量百分比增加"
        set AttributeString[42] = "敏捷百分比增加"
        set AttributeString[43] = "智力百分比增加"
        set AttributeString[44] = "攻击力百分比增加"
        set AttributeString[45] = "生命最大值百分比增加"
        set AttributeString[46] = "魔法最大值百分比增加"
        set AttributeString[47] = "每十秒增加攻击力"
        set AttributeString[48] = "每十秒增加力量"
        set AttributeString[49] = "每十秒增加敏捷"
        set AttributeString[50] = "每十秒增加智力"
        set AttributeString[51] = "每十秒增加最大生命值"
        set AttributeString[52] = "每十秒增加最大魔法值"
        set AttributeString[53] = "每十秒增加金币"
        set AttributeString[54] = "每十秒增加木材"
        set AttributeString[55] = "杀十敌获得攻击力"
        set AttributeString[56] = "杀十敌获得力量"
        set AttributeString[57] = "杀十敌获得敏捷"
        set AttributeString[58] = "杀十敌获得智力"
        set AttributeString[59] = "杀十敌获得最大生命值"
        set AttributeString[60] = "杀十敌获得最大魔法值"
        set AttributeString[61] = "杀十敌获得经验值"
        set AttributeString[62] = "杀十敌获得经验值百分比加成"
        set AttributeString[63] = "杀十敌获得金币"
        set AttributeString[64] = "杀十敌获得金币百分比加成"
        set AttributeString[65] = "杀十敌获得木材"
        set AttributeString[66] = "杀十敌获得木材百分比加成"


        set AttributeString2[1] = ""
        set AttributeString2[2] = ""
        set AttributeString2[3] = ""
        set AttributeString2[4] = ""
        set AttributeString2[5] = ""
        set AttributeString2[6] = ""
        set AttributeString2[7] = ""
        set AttributeString2[8] = ""
        set AttributeString2[9] = ""
        set AttributeString2[10] = ""
        set AttributeString2[11] = ""
        set AttributeString2[12] = ""
        set AttributeString2[13] = ""
        set AttributeString2[14] = ""
        set AttributeString2[15] = ""
        set AttributeString2[16] = ""
        set AttributeString2[17] = ""
        set AttributeString2[18] = "%"
        set AttributeString2[19] = ""
        set AttributeString2[20] = "%"
        set AttributeString2[21] = ""
        set AttributeString2[22] = "%"
        set AttributeString2[23] = "%"
        set AttributeString2[24] = "%"
        set AttributeString2[25] = "%"
        set AttributeString2[26] = "%"
        set AttributeString2[27] = "%"
        set AttributeString2[28] = ""
        set AttributeString2[29] = ""
        set AttributeString2[30] = "%"
        set AttributeString2[31] = "%"
        set AttributeString2[32] = "%"
        set AttributeString2[33] = "%"
        set AttributeString2[34] = "%"
        set AttributeString2[35] = "%"
        set AttributeString2[36] = "%"
        set AttributeString2[37] = "%"
        set AttributeString2[38] = "%"
        set AttributeString2[39] = "%"
        set AttributeString2[40] = "%"
        set AttributeString2[41] = "%"
        set AttributeString2[42] = "%"
        set AttributeString2[43] = "%"
        set AttributeString2[44] = "%"
        set AttributeString2[45] = "%"
        set AttributeString2[46] = "%"
        set AttributeString2[47] = ""
        set AttributeString2[48] = ""
        set AttributeString2[49] = ""
        set AttributeString2[50] = ""
        set AttributeString2[51] = ""
        set AttributeString2[52] = ""
        set AttributeString2[53] = ""
        set AttributeString2[54] = ""
        set AttributeString2[55] = ""
        set AttributeString2[56] = ""
        set AttributeString2[57] = ""
        set AttributeString2[58] = ""
        set AttributeString2[59] = ""
        set AttributeString2[60] = ""
        set AttributeString2[61] = ""
        set AttributeString2[62] = "%"
        set AttributeString2[63] = ""
        set AttributeString2[64] = "%"
        set AttributeString2[65] = ""
        set AttributeString2[66] = "%"

        set SyncDataTrigger = CreateTrigger()
        call DzTriggerRegisterSyncData( SyncDataTrigger ,SyncDataType ,false )
        call TriggerAddAction(SyncDataTrigger , function AddChooseDataToPlayer)
        call ChooseOneForThree_Main()
    endfunction
    function ChangeBaseTextur takes player wichplayer, integer Wich, string File returns nothing
        local integer pid = GetPlayerId(wichplayer)
        if Wich == 1 then
            set BaseChoose_DB_TextureFile_Choose1[pid] = File
        elseif Wich == 2 then
            set BaseChoose_DB_TextureFile_Choose2[pid] = File
        elseif Wich == 3 then
            set BaseChoose_DB_TextureFile_Choose3[pid] = File
        endif
    endfunction
    function ChangeTxModle takes player wichplayer, integer Wich, string File returns nothing
        local integer pid = GetPlayerId(wichplayer)
        if Wich == 1 then
            set TextureFile_Choose1[pid] = File
        elseif Wich == 2 then
            set TextureFile_Choose2[pid] = File
        elseif Wich == 3 then
            set TextureFile_Choose3[pid] = File
        endif
    endfunction
    function ChangeChooseTextureFile takes player wichplayer, integer Wich, string File returns nothing
        local integer pid = GetPlayerId(wichplayer)
        if Wich == 1 then
            set TextureFile_Choose1[pid] = File
        elseif Wich == 2 then
            set TextureFile_Choose2[pid] = File
        elseif Wich == 3 then
            set TextureFile_Choose3[pid] = File
        endif
    endfunction
    function ChangeShowMessage takes player wichplayer, integer Wich, string File returns nothing
        local integer pid = GetPlayerId(wichplayer)
        if Wich == 1 then
            set ChooseAndShowText_Choose1[pid] = File
        elseif Wich == 2 then
            set ChooseAndShowText_Choose2[pid] = File
        elseif Wich == 3 then
            set ChooseAndShowText_Choose3[pid] = File
        endif
    endfunction
    function LoadPlayerLastChoose takes player Wich returns integer Choose
        return LastTimeChoose[GetPlayerId(Wich)]
    endfunction

    function ChangePlayerChoose3Bool takes player wichplayer , boolean IsOpen returns nothing
        local integer pid = GetPlayerId(wichplayer)  
        set CanThisPalyerUseChoose3[pid] = IsOpen
    endfunction

    function ChooseThreeOfOneTimeChange takes player pl , integer value returns nothing
        local integer pid = GetPlayerId(pl)
        set ChooseThreeOfOneTime[pid] = ChooseThreeOfOneTime[pid] + value
        if ChooseThreeOfOneTime[pid] > 0 and pl == GetLocalPlayer() then
            call DzFrameShow( ChooseOneForThree_InUI[2] , true )
        elseif ChooseThreeOfOneTime[pid] <= 0 and pl == GetLocalPlayer() then
            call DzFrameShow( ChooseOneForThree_InUI[2] , false )
        endif
    endfunction

    function GetChooseThreeOfOneTime takes player pl returns integer
        local integer pid = GetPlayerId(pl)
        return ChooseThreeOfOneTime[pid]
    endfunction

    private function ShowChooseOneForThreeUi takes player ShowPlayer returns nothing
        local integer ydul_a
        local integer playerid = GetPlayerId(ShowPlayer)

        if (IsShowChooseOneForThree[GetPlayerId(ShowPlayer)]) then
            call DisplayTextToPlayer( ShowPlayer, 0, 0, "|cffffcc00【系统】|r 有一个还未选择的三选一。已经储存" )
        else
            if (GetLocalPlayer() == ShowPlayer) then
                call ChooseThreeOfOneTimeChange( ShowPlayer , -1 )
                call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[0], BaseChoose_DB_TextureFile_Choose1[playerid] , 0)
                call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[1], BaseChoose_DB_TextureFile_Choose2[playerid] , 0)
                call DzFrameSetTexture( ChooseOneForThree_BaseChoose_DB[2], BaseChoose_DB_TextureFile_Choose3[playerid] , 0)
                call DzFrameSetText( ChooseOneForThree_Choose_Text[0], ChooseAndShowText_Choose1[playerid] )
                call DzFrameSetText( ChooseOneForThree_Choose_Text[1], ChooseAndShowText_Choose2[playerid] )
                call DzFrameSetText( ChooseOneForThree_Choose_Text[2], ChooseAndShowText_Choose3[playerid] )
                call DzFrameSetTexture( ChooseOneForThree_Choose_Texture[0] ,TextureFile_Choose1[playerid], 0 )
                call DzFrameSetTexture( ChooseOneForThree_Choose_Texture[1] ,TextureFile_Choose2[playerid], 0 )
                call DzFrameSetTexture( ChooseOneForThree_Choose_Texture[2] ,TextureFile_Choose3[playerid], 0 )
                set LastTimeChoose[GetPlayerId(ShowPlayer)] = 9999
                set IsShowChooseOneForThree[GetPlayerId(ShowPlayer)] = true
                set ydul_a = 0
                call DzFrameShow( ChooseOneForThree_BaseChoose_DB[ydul_a], IsShowChooseOneForThree[GetPlayerId(ShowPlayer)] )
                if CanThisPalyerUseChoose3[GetPlayerId(ShowPlayer)] then
                call DzFrameShow( ChooseOneForThree_BaseChoose_DB[7], Chosse_3_TJ[playerid])
                else
                call DzFrameShow( ChooseOneForThree_Choose_Bottom[2], CanThisPalyerUseChoose3[GetPlayerId(ShowPlayer)] ) 
                call DzFrameSetText( ChooseOneForThree_Choose_Text[2], "|cffff0000不可选择|r|n 这个选项已经被锁定无法选择" )
                call DzFrameSetTexture( ChooseOneForThree_Choose_Texture[2] ,"ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0 )
                call DzFrameShow( ChooseOneForThree_BaseChoose_DB[7], false)
                endif
                call DzFrameShow( ChooseOneForThree_BaseChoose_DB[5], Chosse_1_TJ[playerid])
                call DzFrameShow( ChooseOneForThree_BaseChoose_DB[6], Chosse_2_TJ[playerid])
                loop
                        exitwhen ydul_a > 4
                    call DzFrameShow( ChooseOneForThree_BaseChoose_DB[ydul_a], IsShowChooseOneForThree[playerid] )
                    set ydul_a = ydul_a + 1
                endloop
            else
            endif
        endif
    endfunction


    function ShowChooseUiToPlayer takes player WillShowPlayer ,integer Choose1type ,integer Choose1id ,integer Choose2type ,integer Choose2id , integer Choose3type ,integer Choose3id returns nothing
        local integer pid = GetPlayerId(WillShowPlayer)
        local boolean array skillid
        local integer looptime = 1

        set skillid[1] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose1id)
        set skillid[2] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose2id)
        set skillid[3] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose3id)


        set Choose_1_Type[pid]  =    Choose1type
        set Choose_2_Type[pid]  =    Choose2type
        set Choose_3_Type[pid]  =    Choose3type

        set Choose_1_Id[pid]    =    Choose1id
        set Choose_2_Id[pid]    =    Choose2id
        set Choose_3_Id[pid]    =    Choose3id

        if Choose1type == 1 then
        set TextureFile_Choose1[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose1id, "Art")
        set ChooseAndShowText_Choose1[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose1id, "Tip") + "|n"  + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose1id, "Ubertip")
        elseif Choose1type == 2 then
        set TextureFile_Choose1[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, Choose1id, "Art")
        set ChooseAndShowText_Choose1[pid] = LoadStr(AbStr , Choose1id , 1) + "|n"  + LoadStr(AbStr , Choose1id , 2)
            if skillid[1] then
                set Chosse_1_TJ[pid] = true    
                //call BJDebugMsg("1号技能可合成")
            else
                set Chosse_1_TJ[pid] = false                  
            endif
        elseif Choose1type == 3 then
            set Choose_1_Id[pid] = GetRandomInt(1 , AttributeHashLen)
            set TextureFile_Choose1[pid] = LoadStr(AttributeHash , Choose_1_Id[pid] , 0 )
            set ChooseAndShowText_Choose1[pid] = ""
            loop
                exitwhen looptime > LoadInteger(AttributeHash , Choose_1_Id[pid] , 0 )
                set ChooseAndShowText_Choose1[pid] = ChooseAndShowText_Choose1[pid] + "|n" + LoadStr(AttributeHash , Choose_1_Id[pid] , looptime )
                set looptime  = looptime + 1 
            endloop
        endif

        set looptime = 1
        if Choose2type == 1 then
        set TextureFile_Choose2[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose2id, "Art")
        set ChooseAndShowText_Choose2[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose2id, "Tip") + "|n"  + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose2id, "Ubertip")
        elseif Choose2type == 2 then
        set TextureFile_Choose2[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, Choose2id, "Art")
        set ChooseAndShowText_Choose2[pid] = LoadStr(AbStr , Choose2id , 1) + "|n"  + LoadStr(AbStr , Choose2id , 2)
            if skillid[2] then
                set Chosse_2_TJ[pid] = true
                //call BJDebugMsg("2号技能可合成")
            else
                set Chosse_2_TJ[pid] = false               
            endif
        elseif Choose2type == 3 then
            set Choose_2_Id[pid] = GetRandomInt(1 , AttributeHashLen)
            set TextureFile_Choose2[pid] = LoadStr(AttributeHash , Choose_2_Id[pid] , 0 )
            set ChooseAndShowText_Choose2[pid] = ""
            loop
                exitwhen looptime > LoadInteger(AttributeHash , Choose_2_Id[pid] , 0 )
                set ChooseAndShowText_Choose2[pid] = ChooseAndShowText_Choose2[pid] + "|n" + LoadStr(AttributeHash , Choose_2_Id[pid] , looptime )
                set looptime  = looptime + 1 
            endloop
        endif

        set looptime = 1
        if Choose3type == 1 then
        set TextureFile_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Art")
        set ChooseAndShowText_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Tip") + "|n"  + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Ubertip")
        elseif Choose3type == 2 then
        set TextureFile_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, Choose3id, "Art")
        set ChooseAndShowText_Choose3[pid] = LoadStr(AbStr , Choose3id , 1) + "|n"  + LoadStr(AbStr , Choose3id , 2)
            if skillid[3] then
                set Chosse_3_TJ[pid] = true
            else
                set Chosse_3_TJ[pid] = false               
            endif
        elseif Choose3type == 3 then
            set Choose_3_Id[pid] = GetRandomInt(1 , AttributeHashLen)
            set TextureFile_Choose3[pid] = LoadStr(AttributeHash , Choose_3_Id[pid] , 0 )
            set ChooseAndShowText_Choose3[pid] = ""
            loop
                exitwhen looptime > LoadInteger(AttributeHash , Choose_3_Id[pid] , 0 )
                set ChooseAndShowText_Choose3[pid] = ChooseAndShowText_Choose3[pid] + "|n" + LoadStr(AttributeHash , Choose_3_Id[pid] , looptime )
                set looptime  = looptime + 1 
            endloop
        endif





        call ShowChooseOneForThreeUi(WillShowPlayer)
    endfunction

    function NewChooseInHashTable takes string texter returns integer id
        set AttributeHashLen = AttributeHashLen + 1
        call SaveStr(AttributeHash , AttributeHashLen , 0 , texter)
        return AttributeHashLen
    endfunction

    function AddAttributeToHash takes integer id , integer AttributeId , integer value ,string message returns nothing
        if LoadStr(AttributeHash , id , 0 ) != null then
            call SaveInteger(AttributeHash , id , 0 ,LoadInteger(AttributeHash , id , 0 ) + 1 )
            call SaveInteger(AttributeHash, id , LoadInteger(AttributeHash , id , 0 ) , AttributeId )
            call SaveReal(AttributeHash , id , LoadInteger(AttributeHash , id , 0 ) , I2R(value) )
            call SaveStr(AttributeHash , id , LoadInteger(AttributeHash , id , 0 ) , AttributeString[AttributeId] + message + AttributeString2[AttributeId])
        else
            call BJDebugMsg("Uneed_NewChooseInHashTable")
        endif
    endfunction

    function ChangePlayerAttributeCorrectedValue takes player needchangeplayer , integer newvalue  returns nothing
        set PlayerAttributeCorrectedValue[GetPlayerId(needchangeplayer)] = newvalue
    endfunction


endlibrary

#endif  /// YDWEAbilityStateIncluded


#ifndef ItemUseBagIncluded 
#define ItemUseBagIncluded 

library ItemUseBag initializer ItemUseBag_Main requires optional FuncItemSystem , BagPackApi

    globals
        private integer array ItemUseBagFrame
        private string ItemUseBagFrameBaseArtTexter = "ItemUseBag\\BagPackBaseUi.blp"
        private string ItemUseBagFrameSoltNullArtTexter
        private integer array WichItemInSolt
        private real array SoltInX
        private real array SoltInY
    endglobals

    function ItemUseBag_GetSoltId takes integer frame returns integer id
        if frame == ItemUseBagFrame[10] then
            return 1
        elseif frame == ItemUseBagFrame[20] then
            return 2
        elseif frame == ItemUseBagFrame[30] then
            return 3
        elseif frame == ItemUseBagFrame[40] then
            return 4
        elseif frame == ItemUseBagFrame[50] then
            return 5
        elseif frame == ItemUseBagFrame[60] then
            return 6
        endif
            return 0
    endfunction

    function ItemUseBag_GetNullSolt takes integer pid returns integer soltid
        if GetPlayerId(GetLocalPlayer()) == pid then
            if WichItemInSolt[1] == 0 or WichItemInSolt[1] == null or WichItemInSolt[1] == -1 then
                return 1
            elseif WichItemInSolt[2] == 0 or WichItemInSolt[2] == null or WichItemInSolt[2] == -1  then
                return 2
            elseif WichItemInSolt[3] == 0 or WichItemInSolt[3] == null or WichItemInSolt[3] == -1  then
                return 3
            elseif WichItemInSolt[4] == 0 or WichItemInSolt[4] == null or WichItemInSolt[4] == -1  then
                return 4
            elseif WichItemInSolt[5] == 0 or WichItemInSolt[5] == null or WichItemInSolt[5] == -1  then
                return 5
            elseif WichItemInSolt[6] == 0 or WichItemInSolt[6] == null or WichItemInSolt[6] == -1  then
                return 6 
            endif            
        endif
        return 0
    endfunction

    function ItemUseBag_ReArt takes nothing returns nothing
        local integer loopa = 1
        loop
            exitwhen loopa > 6
            if GetLocalPlayer() == GetLocalPlayer() then
                if WichItemInSolt[loopa] != 0 and WichItemInSolt[loopa] != null and  WichItemInSolt[loopa] != -1 then
                    call DzFrameShow( ItemUseBagFrame[loopa], true )
                    call DzFrameSetTexture( ItemUseBagFrame[loopa],YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, WichItemInSolt[loopa], "Art"), 0 )
                    call DzFrameShow( ItemUseBagFrame[(loopa*10)], true )  
                else
                    call DzFrameShow( ItemUseBagFrame[loopa], false )
                    call DzFrameShow( ItemUseBagFrame[(loopa*10)], false )  
                endif    
            endif
            set loopa = loopa + 1
        endloop
    endfunction

    function ItemUseBag_AddItmeToItemUseBag takes integer itemid returns nothing
        if WichItemInSolt[1] == 0 or WichItemInSolt[1] == null or WichItemInSolt[1] == -1 then
            set WichItemInSolt[1] = itemid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[2] == 0 or WichItemInSolt[2] == null or WichItemInSolt[2] == -1  then
            set WichItemInSolt[2] = itemid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[3] == 0 or WichItemInSolt[3] == null or WichItemInSolt[3] == -1  then
            set WichItemInSolt[3] = itemid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[4] == 0 or WichItemInSolt[4] == null or WichItemInSolt[4] == -1  then
            set WichItemInSolt[4] = itemid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[5] == 0 or WichItemInSolt[5] == null or WichItemInSolt[5] == -1  then
            set WichItemInSolt[5] = itemid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[6] == 0 or WichItemInSolt[6] == null or WichItemInSolt[6] == -1  then
            set WichItemInSolt[6] = itemid
            call ItemUseBag_ReArt()
            return
        endif
    endfunction

    private function ItemUseBag_RemoveItem takes integer soltid returns nothing
        set WichItemInSolt[soltid] = 0
        call ItemUseBag_ReArt()
    endfunction

    private function ItemUseBag_WhneMouseInSolt takes nothing returns nothing
        local integer Infarm = DzGetTriggerUIEventFrame()
        local integer pid = GetPlayerId(GetLocalPlayer())
        local integer soltid = ItemUseBag_GetSoltId(Infarm)
        local integer needChangeType
        local string needshowstr
        if WichItemInSolt[soltid] != 0 and WichItemInSolt[soltid] != null and  WichItemInSolt[soltid] != -1 then
            set needshowstr = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, WichItemInSolt[soltid], "Tip") + "|n"
            set needshowstr = needshowstr + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, WichItemInSolt[soltid], "Ubertip") + "|n"
            //set needshowstr = needshowstr + I2S(newRandom.GetRandomItemTimeid()) +"掉落时间戳"
            //call BJDebugMsg("In" + I2S(soltid))
            call DzFrameSetText(ItemUseBagFrame[9] , needshowstr)
            call DzFrameSetTexture( ItemUseBagFrame[8], YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, WichItemInSolt[soltid], "Art"), 0 )
            //call DzFrameSetPoint( ItemUseBagFrame[7], 2 , ItemUseBagFrame[0] , 0 , SoltInX[soltid]-0.05, SoltInY[soltid] )
            call DzFrameShow(ItemUseBagFrame[7] , true)
            call DzFrameShow(ItemUseBagFrame[8] , true)
            call DzFrameShow(ItemUseBagFrame[9] , true)
        endif
    endfunction
    private function ItemUseBag_WhneMouseOutSolt takes nothing returns nothing
        call DzFrameShow(ItemUseBagFrame[7] , false)
        call DzFrameShow(ItemUseBagFrame[8] , false)
        call DzFrameShow(ItemUseBagFrame[9] , false)
    endfunction
    private function ItemUseBag_WhneMouseKick takes nothing returns nothing
        local integer Infarm = DzGetTriggerUIEventFrame()
        local integer pid = GetPlayerId(GetLocalPlayer())
        local integer soltid = ItemUseBag_GetSoltId(Infarm)
        local integer itemtypel = WichItemInSolt[soltid]
        call DzSyncData("ItemUseBag_Remove" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + I2S(itemtypel))
        call ItemUseBag_RemoveItem(soltid)
    endfunction

    private function ItemUseBag_RemoveAbAndRemoveItemF takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer itemtypeinteger = S2I( SubStringBJ(basedata , 2 , 20) )  
        
        call BagPackApi_SetItemTypeToBag(Player(pid) , itemtypeinteger )

        if Player(pid) == GetLocalPlayer() then
            call RemoveAttributeAsItemType(itemtypeinteger , Player(pid) )
        endif
    endfunction

    private function ItemUseBag_AddAbToUnitF takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer itemtypeinteger = S2I( SubStringBJ(basedata , 2 , 20) )
        call AddAttributeAsItemType(itemtypeinteger , Player(pid) )
        
        if Player(pid) == GetLocalPlayer() then
            call ItemUseBag_AddItmeToItemUseBag(itemtypeinteger)
        endif
    endfunction

    private function ItemUseBag_Main takes nothing returns nothing
        local integer loopa = 1
        local trigger newtrigger

        if IsCanUseBagOn == true then
            /*基础底图创建*/
            set ItemUseBagFrame[0] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
            call DzFrameSetAbsolutePoint( ItemUseBagFrame[0], 4, 0.41, 0.42 )
            call DzFrameSetSize( ItemUseBagFrame[0], 0.1, 0.15 )
            call DzFrameSetTexture( ItemUseBagFrame[0], ItemUseBagFrameBaseArtTexter, 0 )
            call DzFrameShow( ItemUseBagFrame[0], false )
            /*提示说明*/
            set ItemUseBagFrame[7] = DzCreateFrameByTagName("BACKDROP", "name", ItemUseBagFrame[0], "template", 0)
            call DzFrameSetPoint( ItemUseBagFrame[7], 2 , ItemUseBagFrame[0] , 0 , -0.003, 0.05 )
            call DzFrameSetSize( ItemUseBagFrame[7], 0.1, 0.2 )
            call DzFrameSetTexture( ItemUseBagFrame[7], "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0 )
            call DzFrameShow( ItemUseBagFrame[7], false )
            set ItemUseBagFrame[8] = DzCreateFrameByTagName("BACKDROP", "name", ItemUseBagFrame[7], "template", 0)
            call DzFrameSetPoint( ItemUseBagFrame[8], 0 , ItemUseBagFrame[7] , 0 , 0.003, -0.005 )
            call DzFrameSetSize( ItemUseBagFrame[8], 0.04, 0.04 )
            call DzFrameSetTexture( ItemUseBagFrame[8], "ReplaceableTextures\\CommandButtons\\BTNClawsOfAttack.blp", 0 )
            call DzFrameShow( ItemUseBagFrame[8], false )
            set ItemUseBagFrame[9] = DzCreateFrameByTagName("TEXT", "name", ItemUseBagFrame[7], "template", 0)
            call DzFrameSetPoint( ItemUseBagFrame[9], 0 , ItemUseBagFrame[8] , 6 , 0, -0.005 )
            call DzFrameSetSize( ItemUseBagFrame[9], 0.08, 0.08 )
            call DzFrameSetFont(ItemUseBagFrame[9] , "", 0.01, 0)
            call DzFrameShow( ItemUseBagFrame[9], false )

            /*6个格子底图*/
            set SoltInX[1] = 0.004
            set SoltInX[2] = 0.055
            set SoltInX[3] = 0.004
            set SoltInX[4] = 0.055
            set SoltInX[5] = 0.004
            set SoltInX[6] = 0.055

            set SoltInY[1] = -0.006
            set SoltInY[2] = -0.006
            set SoltInY[3] = -0.056
            set SoltInY[4] = -0.056
            set SoltInY[5] = -0.106
            set SoltInY[6] = -0.106
            loop
                exitwhen loopa > 6
                set ItemUseBagFrame[loopa] = DzCreateFrameByTagName("BACKDROP", "name", ItemUseBagFrame[0], "template", 0)
                call DzFrameSetPoint( ItemUseBagFrame[loopa], 0 , ItemUseBagFrame[0] , 0 , SoltInX[loopa], SoltInY[loopa] )
                call DzFrameSetSize( ItemUseBagFrame[loopa], 0.04, 0.04 )
                call DzFrameShow( ItemUseBagFrame[loopa], false )
                call DzFrameSetTexture( ItemUseBagFrame[loopa], "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0 )
                set ItemUseBagFrame[(loopa*10)] = DzCreateFrameByTagName("BUTTON", "name", ItemUseBagFrame[loopa], "template", 0)
                call DzFrameSetPoint( ItemUseBagFrame[loopa*10], 4 , ItemUseBagFrame[loopa] , 4 , 0, 0 )
                call DzFrameSetSize( ItemUseBagFrame[loopa*10], 0.04, 0.04 )
                call DzFrameShow( ItemUseBagFrame[(loopa*10)], false )
                if GetLocalPlayer() == GetLocalPlayer() then
                    call DzFrameSetScriptByCode(ItemUseBagFrame[(loopa*10)] , 2 , function ItemUseBag_WhneMouseInSolt , false)
                    call DzFrameSetScriptByCode(ItemUseBagFrame[(loopa*10)] , 3 , function ItemUseBag_WhneMouseOutSolt , false)
                    call DzFrameSetScriptByCode(ItemUseBagFrame[(loopa*10)] , 1 , function ItemUseBag_WhneMouseKick , false)
                endif
                set loopa = loopa + 1
            endloop
            //call TimerStart(CreateTimer() , 0.03 ,true , function ItemUseBag_ReArt)

            set newtrigger = CreateTrigger()
            call DzTriggerRegisterSyncData(newtrigger , "ItemUseBag_Remove" , false)
            call TriggerAddAction(newtrigger , function ItemUseBag_RemoveAbAndRemoveItemF)
            set newtrigger = CreateTrigger()
            call DzTriggerRegisterSyncData(newtrigger , "ItemUseBag_AddAB" , false)
            call TriggerAddAction(newtrigger , function ItemUseBag_AddAbToUnitF)  
        endif
    endfunction

    function ItemUseBag_ShowUseBag takes player showp returns nothing
        if showp == GetLocalPlayer() then
            if DzFrameIsVisible(ItemUseBagFrame[0]) == false then
                call DzFrameShow( ItemUseBagFrame[0], true ) 
            else
                call DzFrameShow( ItemUseBagFrame[0], false ) 
            endif
        endif
    endfunction

endlibrary

#endif

#ifndef WareHouseUiSystemIncluded
#define WareHouseUiSystemIncluded 

library WareHouseUiSystem  
	globals
		private integer array WareHouseFrame
		private hashtable ItemSolt
		private itempool array WareHouseItemPool
		private integer maxlevel
		private unit array targetunit
		private boolean Auto = false

		private string BaseTexter = "WareHouseUiSystem\\BaseTexter.tga"
		private string BaseShowTexter = "WareHouseUiSystem\\BaseShowTexter.tga"
		private string BottonTexter = "WareHouseUiSystem\\BottonTexterOn.tga"
		private string AutoBottonTexterOn = "WareHouseUiSystem\\AutoBottonTexterOn.tga"
		private string AutoBottonTexterOff = "WareHouseUiSystem\\AutoBottonTexterOff.tga"
	endglobals
////本地事件
	///鼠标事件
		////鼠标进入背包格子
	private function WareHouseUiSystem_MouseInFrame takes nothing returns nothing
		local integer itemtypeinwarehouse = LoadInteger(ItemSolt, DzGetTriggerUIEventFrame() , 0)
		if itemtypeinwarehouse != 0 and itemtypeinwarehouse != -1 then
			call DzFrameSetTexture(WareHouseFrame[2] , YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, itemtypeinwarehouse , "Art") ,  0 )
			call DzFrameSetText( WareHouseFrame[3], (YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, itemtypeinwarehouse , "Tip")) + "|n|n" + (YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, itemtypeinwarehouse , "Ubertip")))
			call DzFrameShow( WareHouseFrame[1], true )
			call DzFrameShow( WareHouseFrame[2], true )
			call DzFrameShow( WareHouseFrame[3], true )
		endif
	endfunction
		////鼠标离开背包格子
	private function WareHouseUiSystem_MouseOutFrame takes nothing returns nothing
		call DzFrameShow( WareHouseFrame[1], false )
		call DzFrameShow( WareHouseFrame[2], false )
		call DzFrameShow( WareHouseFrame[3], false )
	endfunction
		////鼠标点击背包格子
	private function WareHouseUiSystem_MouseKickSoltFrame takes nothing returns nothing
		local integer itemtypeinwarehouse = LoadInteger(ItemSolt, DzGetTriggerUIEventFrame() , 0)
		local integer pid = GetPlayerId(GetLocalPlayer())
		if itemtypeinwarehouse != 0 and itemtypeinwarehouse != -1 then
			call DzSyncData ( "WHUS_KICKSOLT" ,  I2S(pid) + I2S(itemtypeinwarehouse))
			call SaveInteger(ItemSolt , DzGetTriggerUIEventFrame() , 0 , 0 )
			call DzFrameSetTexture( LoadInteger(ItemSolt ,  DzGetTriggerUIEventFrame() , 1 ) ,"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0 )
		endif

	endfunction
		///装备自动合成关闭

	///本地玩家仓库增加事件
		////为指定玩家增加一个物品
	function WareHouseUiSystem_AddItmeToWareHouse takes integer itemtypevalue , player p returns boolean issc
		local integer loopa = 1

		if p == GetLocalPlayer() then
			loop
				exitwhen loopa > LoadInteger(ItemSolt , 0 , 0)
			 	if LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) == 0 or LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) == -1 then
			 		call SaveInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 , itemtypevalue)
			 		call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa)  , 1 ) , YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, itemtypevalue , "Art"), 0 )
					return true 
			 	endif
			set loopa = loopa + 1
			endloop	
            call DzSyncData ( "WHUS_KICKSOLT" ,  I2S(GetPlayerId(p)) + I2S(itemtypevalue))
            return false
		endif

		return false
	endfunction
		////为指定玩家移除一个物品
	private function WareHouseUiSystem_RemoveItmeToWareHouse takes integer itemsolt , player p returns boolean issc
		if p == GetLocalPlayer() then
			if LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt) , 0 ) != 0 and LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt) , 0 ) != -1 then
				call SaveInteger(ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt) , 0 , 0)
				call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt)  , 1 ) ,"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0 )
				return true
			endif	
		endif
		return false
	endfunction
		////仓库删除2个相同物品
	private function WareHouseUiSystem_RemoveSameItemOfTwoOnce takes integer itemsolt , player p returns integer itemtypeid
		local integer loopa = itemsolt + 1
		local integer itemsoltitem = LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt) , 0 )
		if p == GetLocalPlayer() then
			loop
				exitwhen loopa > LoadInteger(ItemSolt , 0 , 0)
			 	if itemsoltitem != 0 and itemsoltitem != -1 then
			 		if itemsoltitem == LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) then
						call WareHouseUiSystem_RemoveItmeToWareHouse( itemsolt , p )
						call WareHouseUiSystem_RemoveItmeToWareHouse( loopa , p )
						return itemsoltitem
					endif
				endif
			set loopa = loopa + 1
			endloop
		endif
		return 0	
	endfunction
		/////仓库删除2个相同物品并添加一个新物品
	private function WareHouseUiSystem_RemoveSameItemOfTwoOnceAndAddNewItem takes integer itemsolt , integer newitem ,player p returns boolean issc
		local integer itemtpid
		local integer itemtypelevel = YDWEGetObjectPropertyInteger(YDWE_OBJECT_TYPE_ITEM, LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , itemsolt) , 0 ), "Level")
		if  itemtypelevel <= maxlevel then
			set itemtpid = WareHouseUiSystem_RemoveSameItemOfTwoOnce(itemsolt , p)
			if itemtpid != 0 then
				call DzSyncData ( "WHUS_CITEMTWH" ,  I2S(GetPlayerId(p)) + I2S(itemtypelevel))
				return true
			endif 
		endif
		return false
	endfunction
		///仓库一键合成
	private function WareHouseUiSystem_RSItemTNewItem_AllWareHouse takes player p returns nothing
		local integer loopa = 1
		loop
			exitwhen loopa > LoadInteger(ItemSolt , 0 , 0)
			call WareHouseUiSystem_RemoveSameItemOfTwoOnceAndAddNewItem(loopa , 'rag1', p )
			set loopa = loopa + 1
		endloop
	endfunction
		///鼠标点击装备一件合成
	private function WareHouseUiSystem_MouseKickHcBotton takes nothing returns nothing
		call WareHouseUiSystem_RSItemTNewItem_AllWareHouse(GetLocalPlayer())
	endfunction
		///切换自动合成
	private function WareHouseUiSystem_MouseKickAutoBotton takes nothing returns nothing
		if Auto then
			set Auto = false
			call DzFrameSetTexture( WareHouseFrame[6],AutoBottonTexterOff, 0 )
            call DzFrameSetText( WareHouseFrame[8], "自动合成[关]")
		else
			set Auto = true
			call DzFrameSetTexture( WareHouseFrame[6],AutoBottonTexterOn, 0 )
            call DzFrameSetText( WareHouseFrame[8], "自动合成[开]")
		endif
	endfunction
	///切换显示
	function WareHouseUiSystem_ShowToLoaclPlayer takes player p returns nothing
		if p == GetLocalPlayer() then
			if DzFrameIsVisible(WareHouseFrame[0])  == true then
				call DzFrameShow( WareHouseFrame[0], false )
			else
				call DzFrameShow( WareHouseFrame[0], true )
			endif
		endif
	endfunction

//全局事件
	//为玩家创建物品
	function WareHouseUiSystem_CreateItemToPlayer takes nothing returns nothing
		local integer pid = S2I( SubString(DzGetTriggerSyncData(), 0, 1) )
		local integer itemtypeid = S2I( SubString(DzGetTriggerSyncData(), 1, 20) )
		local item citem
		if DzGetTriggerSyncPrefix() == "WHUS_CITEMTWH" then
		set citem  =  PlaceRandomItem(WareHouseItemPool[itemtypeid] , GetUnitX(targetunit[pid]) , GetUnitY(targetunit[pid]) )
		call WareHouseUiSystem_AddItmeToWareHouse(GetItemTypeId(citem) ,Player(pid))
		call RemoveItem(citem)
		elseif DzGetTriggerSyncPrefix() == "WHUS_KICKSOLT" then
		set citem = CreateItem(itemtypeid ,GetUnitX(targetunit[pid]) , GetUnitY(targetunit[pid]) )
		call UnitAddItem(targetunit[pid] , citem)
		endif	

	endfunction
	//所有玩家创建背包格子
	private function WareHouseUiSystem_CreateLine takes integer linenumber returns nothing
		local integer loopa = 0
			loop
				exitwhen loopa > 7
				set WareHouseFrame[(linenumber*100) + loopa] = DzCreateFrameByTagName("BACKDROP", "name", WareHouseFrame[0], "template", 0)
            	call DzFrameSetPoint( WareHouseFrame[(linenumber*100) + loopa], 0 , WareHouseFrame[0] , 0 , 0.007 + (loopa * 0.021) , -0.01 + (linenumber* -0.025) )
            	call DzFrameSetSize( WareHouseFrame[(linenumber*100) + loopa], 0.02, 0.02 )
            	call DzFrameSetTexture( WareHouseFrame[(linenumber*100) + loopa], "UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0 )
            	call DzFrameShow( WareHouseFrame[(linenumber*100) + loopa], true )	
            	set WareHouseFrame[(linenumber*100) + loopa + 10] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", WareHouseFrame[(linenumber*100) + loopa], "template", 0)
            	call DzFrameSetSize(WareHouseFrame[(linenumber*100) + loopa + 10], 0.02, 0.02 )
            	call DzFrameSetPoint(WareHouseFrame[(linenumber*100) + loopa + 10], 4, WareHouseFrame[(linenumber*100) + loopa], 4,0,0)

				call SaveInteger(ItemSolt , 0 , 0 , LoadInteger(ItemSolt , 0 , 0) + 1)
				call SaveInteger(ItemSolt , 0 , LoadInteger(ItemSolt , 0 , 0) , WareHouseFrame[(linenumber*100) + loopa + 10] )

				call SaveInteger(ItemSolt , WareHouseFrame[(linenumber*100) + loopa + 10] , 0 , 0)
				call SaveInteger(ItemSolt , WareHouseFrame[(linenumber*100) + loopa + 10] , 1 , WareHouseFrame[(linenumber*100) + loopa ])
				    if GetLocalPlayer() == GetLocalPlayer() then
                		call DzFrameSetScriptByCode(WareHouseFrame[(linenumber*100) + loopa + 10] , 2 , function WareHouseUiSystem_MouseInFrame , false)
						call DzFrameSetScriptByCode(WareHouseFrame[(linenumber*100) + loopa + 10] , 3 , function WareHouseUiSystem_MouseOutFrame , false)
						call DzFrameSetScriptByCode(WareHouseFrame[(linenumber*100) + loopa + 10] , 1 , function WareHouseUiSystem_MouseKickSoltFrame , false)
            		endif
				set loopa = loopa + 1
			endloop
	endfunction
	//所有玩家创建背包
	private function WareHouseUiSystem_Create takes nothing returns nothing
		local integer loopa = 1
		    /*基础底图创建*/
            set WareHouseFrame[0] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
            call DzFrameSetPoint( WareHouseFrame[0], 3 , DzGetGameUI() , 3 , 0.01 , 0 )
            call DzFrameSetSize( WareHouseFrame[0], 0.18, 0.28 )
            call DzFrameSetTexture( WareHouseFrame[0], BaseTexter, 0 )
            call DzFrameShow( WareHouseFrame[0], false )
			//装备说明
			set WareHouseFrame[1] = DzCreateFrameByTagName("BACKDROP", "name", WareHouseFrame[0], "template", 0)
            call DzFrameSetPoint( WareHouseFrame[1], 0 ,  WareHouseFrame[0] , 2 , 0.005 , 0 )
            call DzFrameSetSize( WareHouseFrame[1], 0.09, 0.18 )
            call DzFrameSetTexture( WareHouseFrame[1], BaseShowTexter, 0 )
            call DzFrameShow( WareHouseFrame[1], false )

			set WareHouseFrame[2] = DzCreateFrameByTagName("BACKDROP", "name", WareHouseFrame[1], "template", 0)
            call DzFrameSetPoint( WareHouseFrame[2], 0 ,  WareHouseFrame[1] , 0 , 0.005 , -0.005 )
            call DzFrameSetSize( WareHouseFrame[2], 0.03, 0.03 )
            call DzFrameSetTexture( WareHouseFrame[2], "", 0 )
            call DzFrameShow( WareHouseFrame[2], false )

			set WareHouseFrame[3] = DzCreateFrameByTagName("TEXT", "name", WareHouseFrame[2], "template", 0)
            call DzFrameSetPoint( WareHouseFrame[3], 0 ,  WareHouseFrame[2] , 6 , 0.0 , -0.005 )
            call DzFrameSetSize( WareHouseFrame[3], 0.08, 0.15 )
            call DzFrameSetText( WareHouseFrame[3], "一串很长很长很长很长很长一串很长很长很长很长很长一串很长很长很长很长很长一串很长很长很长很长很长一串很长很长很长很长很长")
            call DzFrameShow( WareHouseFrame[3], false )

			//一键合成
			set WareHouseFrame[4] = DzCreateFrameByTagName("BACKDROP", "name", WareHouseFrame[0], "template", 0)
            call DzFrameSetPoint( WareHouseFrame[4], 6 , WareHouseFrame[0] , 6 , 0.01 , 0.02 )
            call DzFrameSetSize( WareHouseFrame[4], 0.06, 0.04 )
            call DzFrameSetTexture( WareHouseFrame[4], BottonTexter, 0 )
            call DzFrameShow( WareHouseFrame[4], true )

            set WareHouseFrame[9] = DzCreateFrameByTagName("TEXT", "name", WareHouseFrame[4], "template", 0)
            call DzFrameSetSize(WareHouseFrame[9], 0.06, 0.04 )
            call DzFrameSetPoint(WareHouseFrame[9], 0, WareHouseFrame[4], 4,-0.02,0.005)
			call DzFrameShow( WareHouseFrame[9], true )
            call DzFrameSetText( WareHouseFrame[9], "一键合成")

            set WareHouseFrame[5] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", WareHouseFrame[4], "template", 0)
            call DzFrameSetSize(WareHouseFrame[5], 0.06, 0.04 )
            call DzFrameSetPoint(WareHouseFrame[5], 4, WareHouseFrame[4], 4,0,0)
			call DzFrameShow( WareHouseFrame[5], true )
			if GetLocalPlayer() == GetLocalPlayer() then
                call DzFrameSetScriptByCode(WareHouseFrame[5] , 1 , function WareHouseUiSystem_MouseKickHcBotton , false)
            endif

			//自动合成
			set WareHouseFrame[6] = DzCreateFrameByTagName("BACKDROP", "name", WareHouseFrame[0], "template", 0)
            call DzFrameSetPoint( WareHouseFrame[6], 8 , WareHouseFrame[0] , 8 , -0.01 , 0.02 )
            call DzFrameSetSize( WareHouseFrame[6], 0.06, 0.04 )
            call DzFrameShow( WareHouseFrame[6], true )

            set WareHouseFrame[8] = DzCreateFrameByTagName("TEXT", "name", WareHouseFrame[6], "template", 0)
            call DzFrameSetSize(WareHouseFrame[8], 0.06, 0.04 )
            call DzFrameSetPoint(WareHouseFrame[8], 0, WareHouseFrame[6], 4,-0.025,0.005)
			call DzFrameShow( WareHouseFrame[8], true )
            call DzFrameSetText( WareHouseFrame[8], "自动合成")
            if Auto then
                call DzFrameSetTexture( WareHouseFrame[6], AutoBottonTexterOn, 0 )
                call DzFrameSetText( WareHouseFrame[8], "自动合成[开]")
            else
                call DzFrameSetTexture( WareHouseFrame[6], AutoBottonTexterOff, 0 )
                call DzFrameSetText( WareHouseFrame[8], "自动合成[关]")
            endif
            set WareHouseFrame[7] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", WareHouseFrame[6], "template", 0)
            call DzFrameSetSize(WareHouseFrame[7], 0.06, 0.04 )
            call DzFrameSetPoint(WareHouseFrame[7], 4, WareHouseFrame[6], 4,0,0)
			call DzFrameShow( WareHouseFrame[7], true )
			if GetLocalPlayer() == GetLocalPlayer() then
                call DzFrameSetScriptByCode(WareHouseFrame[7] , 1 , function WareHouseUiSystem_MouseKickAutoBotton , false)
            endif
			//创建UI行
			loop
				exitwhen loopa > 7
				call WareHouseUiSystem_CreateLine(loopa)
				set loopa = loopa + 1
			endloop
	endfunction

	//自动合成计时器运行函数
	function WareHouseUiSystem_AutoTimerAction takes nothing returns nothing
		if Auto then
			call WareHouseUiSystem_RSItemTNewItem_AllWareHouse(GetLocalPlayer())
		endif
	endfunction

	//入口函数
	function WareHouseUiSystem_Main takes nothing returns nothing
		local trigger synctrigger

		set synctrigger = CreateTrigger()
		call DzTriggerRegisterSyncData(synctrigger , "WHUS_CITEMTWH" , false )
		call TriggerAddAction( synctrigger , function WareHouseUiSystem_CreateItemToPlayer )
		set synctrigger = null

		set synctrigger = CreateTrigger()
		call DzTriggerRegisterSyncData(synctrigger , "WHUS_KICKSOLT" , false )
		call TriggerAddAction( synctrigger , function WareHouseUiSystem_CreateItemToPlayer )
		set synctrigger = null
		
		set ItemSolt = InitHashtable()
		set maxlevel = 0
		call WareHouseUiSystem_Create()

		call TimerStart(CreateTimer(), 3 ,true, function WareHouseUiSystem_AutoTimerAction)
	endfunction

	function WareHouseUiSystem_SetItemPool takes integer itempoollevel , itempool needset returns nothing
		set WareHouseItemPool[itempoollevel] = needset
		if maxlevel < itempoollevel then
			set maxlevel = itempoollevel
		endif
	endfunction

	function WareHouseUiSystem_SetTargetUnit takes player p , unit u returns nothing
		set targetunit[GetPlayerId(p)] = u 
	endfunction
endlibrary


#endif