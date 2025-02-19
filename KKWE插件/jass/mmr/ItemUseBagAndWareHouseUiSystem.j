#include"mmr\\mmrapi.j"

#ifndef ItemUseBagIncluded 
#define ItemUseBagIncluded 

library ItemUseBag initializer ItemUseBag_Main requires optional FuncItemSystem , BagPackApi

    globals
        private integer array ItemUseBagFrame
        private string ItemUseBagFrameBaseArtTexter = "ItemUseBag\\BagPackBaseUi.blp"
        private string ItemUseBagFrameSoltNullArtTexter
        private integer array WichItemInSolt
        private integer array ItemKKid
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

    function ItemUseBag_AddItmeToItemUseBag takes integer itemid  , integer kid returns nothing
        if WichItemInSolt[1] == 0 or WichItemInSolt[1] == null or WichItemInSolt[1] == -1 then
            set WichItemInSolt[1] = itemid
            set ItemKKid[1] = kid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[2] == 0 or WichItemInSolt[2] == null or WichItemInSolt[2] == -1  then
            set WichItemInSolt[2] = itemid
            set ItemKKid[2] = kid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[3] == 0 or WichItemInSolt[3] == null or WichItemInSolt[3] == -1  then
            set WichItemInSolt[3] = itemid
            set ItemKKid[3] = kid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[4] == 0 or WichItemInSolt[4] == null or WichItemInSolt[4] == -1  then
            set WichItemInSolt[4] = itemid
            set ItemKKid[4] = kid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[5] == 0 or WichItemInSolt[5] == null or WichItemInSolt[5] == -1  then
            set WichItemInSolt[5] = itemid
            set ItemKKid[5] = kid
            call ItemUseBag_ReArt()
            return
        elseif WichItemInSolt[6] == 0 or WichItemInSolt[6] == null or WichItemInSolt[6] == -1  then
            set WichItemInSolt[6] = itemid
            set ItemKKid[6] = kid
            call ItemUseBag_ReArt()
            return
        endif
    endfunction

    private function ItemUseBag_RemoveItem takes integer soltid returns nothing
        set WichItemInSolt[soltid] = 0
        set ItemKKid[soltid] = 0 
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
        local integer kid = ItemKKid[soltid]
        if kid >=  10 then
            call DzSyncData("ItemUseBag_Remove" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + I2S(kid) + I2S(itemtypel))
        else
            call DzSyncData("ItemUseBag_Remove" , I2S(GetPlayerId(DzGetTriggerUIEventPlayer())) + "0" +I2S(kid) + I2S(itemtypel))
        endif
        call ItemUseBag_RemoveItem(soltid)
    endfunction

    private function ItemUseBag_RemoveAbAndRemoveItemF takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer kid = S2I(SubStringBJ(basedata, 2 , 3) )
        local integer itemtypeinteger = S2I( SubStringBJ(basedata , 4 , 20) )  
        
        call BagPackApi_SetItemTypeToBagWithKK(Player(pid) , itemtypeinteger ,kid )
        call RemoveAttributeAsItemType(itemtypeinteger , Player(pid) )
    endfunction

    private function ItemUseBag_AddAbToUnitF takes nothing returns nothing
        local string basedata = DzGetTriggerSyncData()
        local integer pid = S2I( SubStringBJ(basedata, 1 , 1) )
        local integer kkid = S2I( SubStringBJ(basedata, 2 , 3) )
        local integer itemtypeinteger = S2I( SubStringBJ(basedata , 4 , 20) )
        call AddAttributeAsItemType(itemtypeinteger , Player(pid) )
        if Player(pid) == GetLocalPlayer() then
            call ItemUseBag_AddItmeToItemUseBag(itemtypeinteger , kkid )
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
        private boolean IsRun = false

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
        //仓库排序
    private function WareHouseUiSystem_BubbleSort takes player p returns integer flag
        local integer l = 57
        local integer loopa = 1
        local integer temp1 = 0
        local integer temp2 = 0
        local integer fllag = 0 
        local integer lv1 = 0
        local integer lv2 = 0
        loop
            exitwhen loopa >= l
            set temp1 = 0
            set temp2 = 0
            set lv1 = YDWEGetObjectPropertyInteger(YDWE_OBJECT_TYPE_ITEM, LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ), "Level")
            set lv2 = YDWEGetObjectPropertyInteger(YDWE_OBJECT_TYPE_ITEM, LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa + 1) , 0 ), "Level")
            if lv1 < lv2 then
                set temp1 = LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa + 1) , 0 )
                set temp2 = LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 )
                call SaveInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa + 1) , 0 , temp2)
                call SaveInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa ) , 0 , temp1)
			 	// call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa + 1)  , 1 ) , YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, temp2 , "Art"), 0 )
			 	// call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa)  , 1 ) , YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, temp1 , "Art"), 0 )
                set fllag = 1
            endif
            set loopa = loopa + 1
        endloop
        return fllag
    endfunction
		///仓库一键合成
	private function WareHouseUiSystem_RSItemTNewItem_AllWareHouse takes player p returns nothing
		local integer loopa = 1
        local integer flagw = 1
        if IsRun == false then
            set IsRun = true
           	loop
			    exitwhen loopa > LoadInteger(ItemSolt , 0 , 0)
			    call WareHouseUiSystem_RemoveSameItemOfTwoOnceAndAddNewItem.evaluate(loopa , 'rag1', p )
			    set loopa = loopa + 1
		    endloop
            loop
                exitwhen flagw == 0 
                set flagw = WareHouseUiSystem_BubbleSort.evaluate(p)
            endloop
            set loopa = 1
            loop
                exitwhen loopa >= 57
                if LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) == 0 or LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) == null then
			        call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa)  , 1 ) ,"UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp", 0 )
                else
                    call DzFrameSetTexture( LoadInteger(ItemSolt , LoadInteger(ItemSolt , 0 , loopa)  , 1 ) , YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, LoadInteger( ItemSolt , LoadInteger(ItemSolt , 0 , loopa) , 0 ) , "Art"), 0 )
                endif
                set loopa = loopa + 1
            endloop 
            set IsRun = false
        endif

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
        set IsRun = false
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