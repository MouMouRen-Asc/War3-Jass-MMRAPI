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
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                
        endif
        set loopTimes = 1
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                               
        endif
        set loopTimes = 2
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)             
        endif
        set loopTimes = 3
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                        
        endif
        set loopTimes = 4
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                      
        endif
        set loopTimes = 5
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                       
        endif
        set loopTimes = 6
        if TargetUnit[loopTimes] != null then
           call MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , StrPercent[loopTimes] , 1 , I2R(StrAppend[loopTimes]) , false)    
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AgiPercent[loopTimes] , 2 , I2R(AgiAppend[loopTimes]) , false) 
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , IntPercent[loopTimes] , 3 , I2R(IntAppend[loopTimes]) , false)   
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , AttackPercent[loopTimes] , 4 , AttackAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxHealthPercent[loopTimes] , 5 , MaxHealthAppend[loopTimes] , false)
           call  MMRAPI_DynamicAttributeCalcute(TargetUnit[loopTimes] , MaxManaPercent[loopTimes] , 6 , MaxManaAppend[loopTimes] , false)                      
        endif
        set loopTimes = 7
        if TargetUnit[loopTimes] != null then
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

 
library BagPackApi  requires BzAPI , YDWEYDWEJapiScript , MmrApi

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
                set itemtypeid = needcitem.GetRandomItemBaseItemType()
                call BagPackApi_RemoveItemFormBagPack(DzGetTriggerSyncPlayer() , page , solt)
                call DzSyncData("BagPackApi_CreateItem" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + I2S(itemtypeid))
                //set createitem = CreateItem(itemtypeid , 0 , 0 )
                //call UnitAddItem( MMRAPI_TargetPlayer(DzGetTriggerSyncPlayer()), CreateItem(itemtypeid , 0 , 0 ) )
            endif
        elseif MMRAPI_TargetPlayerBagIsNull(pid) == false and DzGetTriggerSyncPlayer() == GetLocalPlayer() then
            call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "英雄身上装备满了")
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

#ifndef ChooseOneForThreeIncluded 
#define ChooseOneForThreeIncluded
library ChooseOneForThree  requires BzAPI , YDWEAbilityState , YDWEYDWEJapiScript , MmrApi
    globals
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
    endif
    if locUnit != null then
        if ChooseDataType == 1 then
            set CItem = CreateItem(ChooseValueId , UX , UY)
            call UnitAddItem(locUnit , CItem) 
        elseif ChooseDataType == 2 then
            call MMRAPI_AddSkillAsSoltAndHero(ConvertedPlayer(PlayerId + 1) , ChooseValueId )
        endif 
    endif


    endfunction

    function ChooseOneForThree_Init takes nothing returns nothing
        local boolean IsFirstTimeOpen = TestContral
        local integer LoopTime = 0

        loop
            exitwhen LoopTime > 7
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

    private function ShowChooseOneForThreeUi takes player ShowPlayer returns nothing
        local integer ydul_a
        local integer playerid = GetPlayerId(ShowPlayer)

        if (IsShowChooseOneForThree[GetPlayerId(ShowPlayer)]) then
            call DisplayTextToPlayer( ShowPlayer, 0, 0, "|cffffcc00【系统】|r 有一个还未选择的三选一。" )
        else
            if (GetLocalPlayer() == ShowPlayer) then
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

        set skillid[1] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose1id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose1id)
        set skillid[2] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose2id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose2id)
        set skillid[3] = MMRAPI_CheckSkillCanTransReturnSkid(pid, 1 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 2 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 3 , Choose3id) or MMRAPI_CheckSkillCanTransReturnSkid(pid, 4 , Choose3id)



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
        endif

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
        endif

        if Choose3type == 1 then
        set TextureFile_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Art")
        set ChooseAndShowText_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Tip") + "|n"  + YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, Choose3id, "Ubertip")
        elseif Choose3type == 2 then
        set TextureFile_Choose3[pid] = YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ABILITY, Choose3id, "Art")
        set ChooseAndShowText_Choose3[pid] = LoadStr(AbStr , Choose3id , 1) + "|n"  + LoadStr(AbStr , Choose3id , 2)
        if skillid[3] then
        set Chosse_3_TJ[pid] = true
        //call BJDebugMsg("3号技能可合成")
        else
        set Chosse_3_TJ[pid] = false               
        endif
        endif



        set Choose_1_Type[pid]  =    Choose1type
        set Choose_2_Type[pid]  =    Choose2type
        set Choose_3_Type[pid]  =    Choose3type

        set Choose_1_Id[pid]    =    Choose1id
        set Choose_2_Id[pid]    =    Choose2id
        set Choose_3_Id[pid]    =    Choose3id

        call ShowChooseOneForThreeUi(WillShowPlayer)
    endfunction

endlibrary

#endif  /// YDWEAbilityStateIncluded


#ifndef FuncItemSystemIncluded
#define FuncItemSystemIncluded

library FuncItemSystem requires optional YDWEBase,YDWETriggerEvent,YDWEEventDamageData,YDWEAbilityState,MmrApi
	
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
		private hashtable Item = InitHashtable()
		private trigger array trg
		//0是三维技能，1是攻击技能，2是防御技能
		private integer array GreenValueSkill
        private integer array MonsterCheckSkill

        private integer array Time_Add_Attack
        private integer array Time_Add_Str
        private integer array Time_Add_Agi
        private integer array Time_Add_Int
        private integer array Time_Add_MaxHealth
        private integer array Time_Add_MaxMana
        private integer array Time_Add_Gold
        private integer array Time_Add_Wood
        private integer array Time_Add_Health
        private integer array Time_Add_Mana


        private integer array Kill_Add_Attack
        private integer array Kill_Add_Str
        private integer array Kill_Add_Agi
        private integer array Kill_Add_Int
        private integer array Kill_Add_MaxHealth
        private integer array Kill_Add_MaxMana
        private integer array Kill_Add_Exp
        private integer array Kill_Add_Exp_Percent
        private integer array Kill_Add_Gold
        private integer array Kill_Add_Gold_Percent
        private integer array Kill_Add_Wood
        private integer array Kill_Add_Wood_Percent

        private integer array Player_Physical_Critical_Value
        private integer array Player_Physical_Critical_Percent
        private integer array Player_Magic_Critical_Value
        private integer array Player_Magic_Critical_Percent
        private integer array Player_Skill_Damage_Percent
        private integer array Player_Skill_Damage_Append
        private integer array Player_Attack_Damage_Append


        private integer array Player_Physical_Damage_Percent
        private integer array Player_Magic_Damage_Percent
        private integer array Player_Last_Damage_Percent
        private integer array Player_Normal_Damage_Percent
        private integer array Player_Elite_Damage_Percent
        private integer array Player_Boss_Damage_Percent

        private integer array Player_Physical_Sucking
        private integer array Player_Magic_Sucking
        private integer array Player_Physical_LessDamage
        private integer array Player_Magic_LessDamage

        private integer array Player_Normal_Physical_MultipliedValue
        private integer array Player_Elite_Physical_MultipliedValue
        private integer array Player_Boss_Physical_MultipliedValue
        private integer array Player_Normal_Magic_MultipliedValue
        private integer array Player_Elite_Magic_MultipliedValue
        private integer array Player_Boss_Magic_MultipliedValue

        private integer array Player_Skill_Cold_Donw

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
        endif
	endfunction

	private function trg3Ac takes nothing returns nothing
		///攻击之后添加属性
	endfunction
	private function trg4Ac takes nothing returns nothing
		///每秒事件，每秒加属性和每秒回血
        local integer Sy = 0
        local unit tunit 
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
	endfunction

	private function trg5Co takes nothing returns boolean
		///任意单位伤害事件的条件，筛选用的
    	return GetEventDamage() >= 1.00 and IsUnitEnemy(GetTriggerUnit(), GetOwningPlayer(GetEventDamageSource())) == true
	endfunction

    //暴击检测
    private function CheckAndCalcutePhysicalOrMagic_CriticalStrike takes real damagevalue ,integer pid , boolean isphysical ,real damagepower returns real damage
        local real needreturn = 0
        if isphysical then
            if (Player_Physical_Critical_Percent[pid]) >= GetRandomInt(1,100) then
                set needreturn = damagevalue * (1 + (Player_Physical_Critical_Value[pid]/100))
                if  damagepower > 100000000 then
                     call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn)) + "亿",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                elseif  damagepower > 1000000  then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn)) + "百万",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                elseif damagepower > 10000 then
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn)) + "万",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                else 
                    call PFWZ("|cfffc2c2c物理暴击" + I2S(R2I(needreturn)) ,GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                endif
                return needreturn
            else
                return damagevalue
            endif
        else
            if (Player_Magic_Critical_Percent[pid]) >= GetRandomInt(1,100) then
                set needreturn = damagevalue * (1 + (Player_Magic_Critical_Value[pid]/100))

                if  damagepower > 100000000 then
                    call PFWZ("|cff2c5dfc魔法暴击" + R2S(needreturn) + "亿",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                elseif  damagepower > 1000000  then
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn)) + "百万",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                elseif damagepower > 10000 then
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn)) + "万",GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)
                else 
                    call PFWZ("|cff2c5dfc魔法暴击" + I2S(R2I(needreturn)) ,GetTriggerUnit(),0.02,255,255,255,0.00,0.05,1.0)             
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
        local real damagepower = 1

        if getdamage > 1000000 then
            set getdamage = getdamage / 10000
            set damagepower = damagepower * 10000
        endif
        if getdamage > 10000 then
            set getdamage = getdamage / 100
            set damagepower = damagepower * 100
        endif


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
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true, damagepower) * damagepower
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (Player_Physical_Sucking[pid]/100 ) > 0 then
                        set suckingvalue = realdamage*(Player_Physical_Sucking[pid]/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif 
                else
                    set realdamage = (Player_Attack_Damage_Append[pid] + getdamage) * magicDamageMult 
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false, damagepower) * damagepower
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (Player_Magic_Sucking[pid]/100 ) > 0 then
                        set suckingvalue = needsetdamage*(Player_Magic_Sucking[pid]/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif            
                endif
                call YDWESetEventDamage(needsetdamage) 
            else 
                if (YDWEIsEventPhysicalDamage() == true) then
                    set realdamage = (Player_Skill_Damage_Append[pid] + getdamage) * physicalDamageMmult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true, damagepower) * damagepower
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (Player_Physical_Sucking[pid]/100 ) > 0 then
                        set suckingvalue = needsetdamage*(Player_Physical_Sucking[pid]/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif
                else
                    set realdamage = (Player_Skill_Damage_Append[pid] + getdamage) * magicDamageMult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false, damagepower) * damagepower
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (Player_Magic_Sucking[pid]/100 ) > 0 then
                        set suckingvalue = needsetdamage*(Player_Magic_Sucking[pid]/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif  
                endif
                call YDWESetEventDamage(needsetdamage) 
            endif
        else
            // set pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
            // set AttackValue = GetUnitState(GetEventDamageSource(),ConvertUnitState(0x12)) + GetUnitState(GetEventDamageSource(),ConvertUnitState(0x13))
            // if (YDWEIsEventPhysicalDamage() == true) then
            //     if AttackValue > 10000 then
            //         set AttackValue = AttackValue/100
            //         set realdamage = (((AttackValue * 1 + 100) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (Player_Physical_LessDamage[pid]/100))                
            //         set realdamage = realdamage * 100
            //     else
            //         set realdamage = (((AttackValue * 1 + 100) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (Player_Physical_LessDamage[pid]/100))
            //     endif
            // else
            //     set realdamage = (((getdamage * 1 + 100) * getdamage)/(getdamage +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* 0.5 + 100))) * (1- (Player_Magic_LessDamage[pid]/100))
            //     set realdamage = realdamage  * damagepower
            //     if realdamage >2000000000 or realdamage < 0 then
            //         set realdamage = 2000000000
            //     endif
            // endif
            // call YDWESetEventDamage(realdamage)
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
		call TriggerAddCondition(trg[3], Condition(function trg5Co))
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
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) + STR ,false)
        endif

        if INT != 0 then
            call SetHeroStr(GetItemUnit , GetHeroStr(GetItemUnit , false) + STR ,false)
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
endlibrary

#endif