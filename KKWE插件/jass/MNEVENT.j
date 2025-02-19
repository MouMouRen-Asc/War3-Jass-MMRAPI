#ifndef MNEVENTINCLUDE
#define MNEVENTINCLUDE


library MNEVENT

    globals
        private trigger MNDamageEventTrigger = null
        private trigger array DamageEventQueue
        private integer DamageEventNumber = 0
        private timer time = CreateTimer()
        private group UnitGroup = CreateGroup()
        private triggeraction ta




    endglobals
    //===========================================================================  
    //任意单位伤害事件 
    //===========================================================================

    private function UnitDeathconditions takes nothing returns boolean//单位是否英雄
        return (IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO)!= true)
    endfunction
   


    private function UnitDeathAction takes nothing returns nothing//单位死亡移出单位组
       call GroupRemoveUnit(UnitGroup,GetTriggerUnit())
       //call RemoveUnit(GetTriggerUnit())
    endfunction
    

    private function enumunitdamaged takes nothing returns nothing//给选取单位注册接受伤害事件
        call TriggerRegisterUnitEvent(MNDamageEventTrigger, GetEnumUnit(), EVENT_UNIT_DAMAGED)
    endfunction

    private function MNAnyUnitDamagedAction takes nothing returns nothing
        local integer i = 0
        
        loop
            exitwhen i >= DamageEventNumber
            if DamageEventQueue[i] != null and IsTriggerEnabled(DamageEventQueue[i]) and TriggerEvaluate(DamageEventQueue[i]) then
                call TriggerExecute(DamageEventQueue[i])//如果触发不为空,触发开启,则运行触发器i
            endif
            set i = i + 1  
        endloop    
    endfunction
    
    private function MNAnyUnitDamagedFilter takes nothing returns boolean     
        if GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0 then 
            //单位组加入该单位
            call GroupAddUnit(UnitGroup,GetFilterUnit())
            call TriggerRegisterUnitEvent(MNDamageEventTrigger, GetFilterUnit(), EVENT_UNIT_DAMAGED)
            //注册指定单位接受伤害事件
        endif
        return false
    endfunction
    



    private function MNAnyUnitDamagedEnumUnit takes nothing returns nothing   
        local trigger t = CreateTrigger()
        local region  r = CreateRegion()
        local group   g = CreateGroup()
        local trigger trideath = CreateTrigger()
    
        call RegionAddRect(r, GetWorldBounds())
        call TriggerRegisterEnterRegion(t, r, Condition(function MNAnyUnitDamagedFilter))
        //非蝗虫单位进入区域 注册指定单位接受伤害事件
        call GroupEnumUnitsInRect(g, GetWorldBounds(), Condition(function MNAnyUnitDamagedFilter))
        //选取可用地图上现存的非蝗虫单位 注册指定单位接受伤害事件

        //注册单位死亡事件
        call TriggerRegisterAnyUnitEventBJ(trideath, EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(trideath, Condition(function UnitDeathconditions))
        call TriggerAddAction(trideath, function UnitDeathAction)

        call DestroyGroup(g)
        set r = null
        set t = null
        set g = null
    endfunction
        
    private function timeout takes nothing returns nothing //计时器到期后自动清除接受伤害触发,并重新注册
        call TriggerRemoveAction(MNDamageEventTrigger,ta)//删除触发器动作
        call DestroyTrigger(MNDamageEventTrigger)
        set MNDamageEventTrigger = CreateTrigger()
        set ta = TriggerAddAction(MNDamageEventTrigger, function MNAnyUnitDamagedAction) 
        call ForGroupBJ(UnitGroup, function enumunitdamaged)
    endfunction


    function MNAnyUnitDamaged takes trigger trg , real miao returns nothing
        if trg == null then
            return
        endif
            
        if DamageEventNumber == 0 then
            set MNDamageEventTrigger = CreateTrigger()
            set ta = TriggerAddAction(MNDamageEventTrigger, function MNAnyUnitDamagedAction) 
            call MNAnyUnitDamagedEnumUnit()
            call TimerStart(time,miao,true,function timeout)


        endif   
        
        set DamageEventQueue[DamageEventNumber] = trg
        set DamageEventNumber = DamageEventNumber + 1
    endfunction
    
    endlibrary
    
    #endif


    