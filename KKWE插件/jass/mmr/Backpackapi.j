#include"mmr\\mmrapi.j"



#ifndef BagPackApiIncluded 
#define BagPackApiIncluded 

 
library BagPackApi requires BzAPI , YDWEYDWEJapiScript , MmrApi

    native function DzTriggerRegisterMouseEventTrg takes trigger trg, integer status, integer btn returns nothing
    
    struct RandomItem
        integer BaseItem = 0
        integer array TypeValue[6]
        integer array Value[6]
        integer TimeId
        integer KKid

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

        method SetItemInKKid takes integer kkid returns nothing
            set this.KKid = kkid
        endmethod

        method GetItemInKKid takes nothing returns integer kkidd
            return this.KKid
        endmethod
    endstruct

    globals
    private RandomItem array MyBagItem

    private integer array BackPackUi
    private hashtable array BackPackHash
    private integer array BackPackItemValue
    private integer array PlayerChoosePage
    private integer array MouseInBagUi
    private integer array DeleteBottom
    private integer array ChooseItemSolt

    private boolean array PlayerBagCanUse_2
    private boolean array PlayerBagCanUse_3
    private boolean array PlayerBagCanUse_4
 

    private string BagPack_Base_BackGround_1_Texter = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
    private string BagPack_ItemShowBackGround_1_Texter = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
    private string BaseBagPackInmageSolt = "UI\\Widgets\\Console\\Human\\human-inventory-slotfiller.blp"
    private string BagPack_ChooseBagBottomOn = "ReplaceableTextures\\CommandButtons\\BTNMoonKey.blp"
    private string BagPack_ChooseBagBottomOFF = "ReplaceableTextures\\CommandButtons\\BTNGlyph.blp"
    private string BagPakc_DelteItemBottomYes = "WareHouseUiSystem\\BottonTexterOn.tga"
    private string BagPakc_DelteItemBottomNo = "WareHouseUiSystem\\BottonTexterOff.tga"

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
        if MouseInBagUi[GetPlayerId(GetLocalPlayer())] > 0 and DzGetTriggerKeyPlayer() == GetLocalPlayer() and removeitem.GetRandomItemBaseItemType() != 0  and ChooseItemSolt[GetPlayerId(GetLocalPlayer())] == 0 then
            set ChooseItemSolt[GetPlayerId(GetLocalPlayer())] = MouseInBagUi[GetPlayerId(GetLocalPlayer())]
            if DzFrameIsVisible(DeleteBottom[0]) == true then
            else
                call DzFrameShow(DeleteBottom[0] , true)
            endif
        endif
    endfunction

    private function BagPackApi_WhenMouseOutUnitBackPackItem takes nothing returns nothing
            call DzFrameShow(BackPackUi[5] , false)
            call DzFrameShow(BackPackUi[6] , false)
            call DzFrameShow(BackPackUi[7] , false)
            set MouseInBagUi[GetPlayerId(GetLocalPlayer())] = -1
    endfunction

    private function BagPackApi_DeleteBottomYes takes nothing returns nothing
        local RandomItem removeitem = LoadInteger(BackPackHash[GetPlayerId(GetLocalPlayer())], PlayerChoosePage[GetPlayerId(GetLocalPlayer())] , ChooseItemSolt[GetPlayerId(GetLocalPlayer())])

        if ChooseItemSolt[GetPlayerId(GetLocalPlayer())] > 0 and DzGetTriggerUIEventPlayer() == GetLocalPlayer() and removeitem.GetRandomItemBaseItemType() != 0 then
            call DzSyncData("BagPackApi_DeleteItem" , I2S(GetPlayerId(GetLocalPlayer())) + I2S(removeitem.GetItemInKKid()))    
            call removeitem.destroy()
            call SaveInteger(BackPackHash[GetPlayerId(GetLocalPlayer())] ,PlayerChoosePage[GetPlayerId(GetLocalPlayer())] ,ChooseItemSolt[GetPlayerId(GetLocalPlayer())], -1 )
            call BagPackApi_ChangeBagPackLineTexter(PlayerChoosePage[GetPlayerId(GetLocalPlayer())] , ChooseItemSolt[GetPlayerId(GetLocalPlayer())] , GetPlayerId(GetLocalPlayer()))
        endif
        call DzFrameShow(DeleteBottom[0] , false)
        set ChooseItemSolt[GetPlayerId(GetLocalPlayer())] = 0
    endfunction

    private function BagPackApi_DeleteBottomNo takes nothing returns nothing
        if DzGetTriggerUIEventPlayer() == GetLocalPlayer() then
            call DzFrameShow(DeleteBottom[0] , false)
        endif
        set ChooseItemSolt[GetPlayerId(GetLocalPlayer())] = 0
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


    private function BagPackApi_ItemToBagPack takes player wichplayer , integer page , integer solt  , integer initemtype , integer timevalue , integer inkkid returns nothing
        local RandomItem needsaveitem = RandomItem.create()
        call needsaveitem.SetRandomItemBaseItemType(initemtype)
        call needsaveitem.SetRandomItemTimeId(timevalue)
        call needsaveitem.SetItemInKKid(inkkid)
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
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , itemtypeid , 1, 0)
            call RemoveItem(wichitem)
        else
            call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "装备背包已经满了")
        endif
    endfunction

    function BagPackApi_SetItemToBagWithKK takes player wichplayer , item wichitem , integer kkid returns nothing
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
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , itemtypeid , 1, kkid)
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
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , wichitemtype , 1 , 0)
        else
            call DisplayTextToPlayer(GetLocalPlayer() ,0 , 0 , "装备背包已经满了")
        endif
    endfunction

    function BagPackApi_SetItemTypeToBagWithKK takes player wichplayer , integer wichitemtype , integer kid returns nothing
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
            call BagPackApi_ItemToBagPack(wichplayer , pager , nullsolt , wichitemtype , 1 , kid)
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
        local integer itemkkid
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
                        set itemkkid = needcitem.GetItemInKKid()
                        call BagPackApi_RemoveItemFormBagPack(DzGetTriggerSyncPlayer() , page , solt)
                        if itemkkid < 10 then
                            call DzSyncData("ItemUseBag_AddAB" , I2S(GetPlayerId(DzGetTriggerSyncPlayer())) + "0" +I2S(itemkkid) + I2S(itemtypeid))
                        else
                            call DzSyncData("ItemUseBag_AddAB" , I2S(GetPlayerId(DzGetTriggerSyncPlayer())) + I2S(itemkkid) + I2S(itemtypeid))    
                        endif
                        
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

        set DeleteBottom[0] = DzCreateFrameByTagName("BACKDROP", "name", DzGetGameUI(), "template", 0)
        call DzFrameSetPoint( DeleteBottom[0], 4, DzGetGameUI(), 4, 0, 0 )
        call DzFrameSetSize( DeleteBottom[0], 0.2, 0.1 )
        call DzFrameSetTexture( DeleteBottom[0], "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0 )
        call DzFrameShow( DeleteBottom[0], false )
        set DeleteBottom[1] = DzCreateFrameByTagName("TEXT", "name", DeleteBottom[0], "template", 0)
        call DzFrameSetPoint( DeleteBottom[1], 1, DeleteBottom[0], 1, 0, -0.015 )
        call DzFrameSetSize( DeleteBottom[1], 0.09, 0.18 )
        call DzFrameSetFont( DeleteBottom[1], "war3mapImported\\fonts.ttf", 0.013, 0 )
        call DzFrameSetText(DeleteBottom[1] , "是否要删除这件装备")

        set DeleteBottom[2] = DzCreateFrameByTagName("BACKDROP", "name", DeleteBottom[0], "template", 0)
        call DzFrameSetPoint( DeleteBottom[2], 6, DeleteBottom[0], 6, 0.015, 0.015 )
        call DzFrameSetSize( DeleteBottom[2], 0.08, 0.04 )
        call DzFrameSetTexture( DeleteBottom[2], BagPakc_DelteItemBottomYes, 0 )
        call DzFrameShow( DeleteBottom[2], true )
        set DeleteBottom[3] = DzCreateFrameByTagName("TEXT", "name", DeleteBottom[2], "template", 0)
        call DzFrameSetPoint( DeleteBottom[3], 0, DeleteBottom[2], 4, -0.01 , 0.01 )
        call DzFrameSetSize( DeleteBottom[3], 0.05, 0.025 )
        call DzFrameSetFont( DeleteBottom[3], "war3mapImported\\fonts.ttf", 0.04, 0 )
        call DzFrameSetText(DeleteBottom[3] , "是")
        set DeleteBottom[4] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", DeleteBottom[2], "template", 0)
        call DzFrameSetPoint( DeleteBottom[4], 6 , DeleteBottom[2] , 6 , 0, 0 )
        call DzFrameSetSize( DeleteBottom[4], 0.08, 0.04 )


        set DeleteBottom[5] = DzCreateFrameByTagName("BACKDROP", "name", DeleteBottom[0], "template", 0)
        call DzFrameSetPoint( DeleteBottom[5], 8, DeleteBottom[0], 8, -0.015, 0.015 )
        call DzFrameSetSize( DeleteBottom[5], 0.08, 0.04 )
        call DzFrameSetTexture( DeleteBottom[5], BagPakc_DelteItemBottomYes, 0 )
        call DzFrameShow( DeleteBottom[5], true )
        set DeleteBottom[6] = DzCreateFrameByTagName("TEXT", "name", DeleteBottom[5], "template", 0)
        call DzFrameSetPoint( DeleteBottom[6], 0, DeleteBottom[5], 4, -0.01 , 0.01 )
        call DzFrameSetSize( DeleteBottom[6], 0.05, 0.025 )
        call DzFrameSetFont( DeleteBottom[6], "war3mapImported\\fonts.ttf", 0.04, 0 )
        call DzFrameSetText(DeleteBottom[6] , "否")
        set DeleteBottom[7] = DzCreateFrameByTagName("GLUETEXTBUTTON", "name", DeleteBottom[5], "template", 0)
        call DzFrameSetPoint( DeleteBottom[7], 6 , DeleteBottom[5] , 6 , 0, 0 )
        call DzFrameSetSize( DeleteBottom[7], 0.08, 0.04 )

        if GetLocalPlayer() == GetLocalPlayer() then
    	    call DzFrameSetScriptByCode(DeleteBottom[4] , 1 , function BagPackApi_DeleteBottomYes , false)
            call DzFrameSetScriptByCode(DeleteBottom[7] , 1 , function BagPackApi_DeleteBottomNo , false)
        endif


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
