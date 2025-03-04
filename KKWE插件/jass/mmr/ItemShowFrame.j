#include"mmr\\mmrapi.j"

#ifndef ItemShowIncluded 
#define ItemShowIncluded 

library ItemShow requires MmrApi , FuncItemSystem

globals
    hashtable GroundShowHashTable
    integer array GroundShow
    string TocFile = "ShowItemUITexter\\custom_frame.toc"


    trigger trgUi
    trigger ChooseUnit
    trigger SetItemUiColor
    integer array ItemShowFrame[11]
    unit array ItemShowFrame_Show_Unit[16]
    string array ItemLevelModele
    hashtable itemhash
endglobals


function ItemShow_ReShowItem takes nothing returns nothing
    local integer ydul_a
    local real W
    local real H
    local real X
    local real Y
    local integer pid
    local item castitme
    set ydul_a = 1
    loop
        exitwhen ydul_a > 4
        set pid = ydul_a
        call FlushChildHashtable( GroundShowHashTable, pid )
        call SaveFogStateHandle( GroundShowHashTable, pid, 1, ConvertFogState(GetHandleId(DzGetUnitUnderMouse())) )
        set castitme =  LoadItemHandle(GroundShowHashTable, pid, 1)
        //call BJDebugMsg(I2S(GetHandleId(DzGetUnitUnderMouse())))
        if ((ConvertedPlayer(pid) == GetLocalPlayer())) then
            if (castitme != null) then
                set W = 0.17
                set H = 0.30
                set X = I2R(( DzGetMouseX() - DzGetWindowX() )) / ( I2R(DzGetWindowWidth()) / 0.80 )
                set Y = I2R(( ( DzGetWindowHeight() + DzGetWindowY() ) - DzGetMouseY() )) / ( I2R(DzGetWindowHeight()) / 0.60 )
                if (Y > ( 0.60 - ( H / 2.00 ) )) then
                    set Y = 0.60 - ( H / 2.00 )
                else
                endif
                if (Y < ( -0.60 + ( H / 2.00 ) )) then
                    set Y = -0.60 + ( H / 2.00 )
                else
                endif
                if (X > ( 0.80 - ( 0.04 + W ) )) then
                    set X = X-( 0.04 + W )
                else
                endif
                call DzFrameClearAllPoints( GroundShow[2] )
                call DzFrameSetAbsolutePoint( GroundShow[2], 3, ( X + 0.02 ), Y )
                call DzFrameSetText( GroundShow[3], GetItemName(castitme) )
                call DzFrameSetText( GroundShow[5], YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, GetItemTypeId(castitme), "Description")  )
                call DzFrameSetText( GroundShow[2], YDWEGetItemDataString(GetItemTypeId(castitme), 3) + LoadStr(itemhash,GetHandleId(castitme),0))
                call DzFrameSetTexture( GroundShow[4], YDWEGetItemDataString(GetItemTypeId(castitme), 1), 0 )
                call DzFrameShow( GroundShow[0], true )
            else
                call DzFrameShow( GroundShow[0], false )
            endif
        else
        endif
        set ydul_a = ydul_a + 1
    endloop
endfunction

function ItemShow_RegisterTimer takes nothing returns nothing
    local trigger trg = CreateTrigger()
    call TriggerRegisterTimerEventPeriodic( trg , 0.03 )
    call TriggerAddAction(trg , function ItemShow_ReShowItem )
endfunction

function ItemShow_InGroundInitializer takes nothing returns nothing
    set GroundShowHashTable = InitHashtable()
    call DzLoadToc( TocFile )
    // 背景
    set GroundShow[0] = DzCreateFrame("Item_Backdrop", DzGetGameUI(), 0)
    set GroundShow[2] = DzCreateFrameByTagName("TEXT", "物品属性", GroundShow[0], "template", 0)
    set GroundShow[3] = DzCreateFrameByTagName("TEXT", "物品名字", GroundShow[0], "template", 0)
    set GroundShow[4] = DzCreateFrameByTagName("BACKDROP", "物品贴图", GroundShow[0], "template", 0)
    set GroundShow[5] = DzCreateFrameByTagName("TEXT", "技能大名字", GroundShow[0], "template", 0)
    // 设置大小
    call DzFrameSetSize( GroundShow[0], 0.20, 0.20 )
    call DzFrameSetSize( GroundShow[2], 0.20, 0.00 )
    call DzFrameSetSize( GroundShow[4], 0.032, 0.032 )
    // 设置贴图
    // 设置文本
    call DzFrameSetFont( GroundShow[2], "fonts.ttf", 0.011, 0 )
    call DzFrameSetFont( GroundShow[3], "fonts.ttf", 0.016, 0 )
    call DzFrameSetFont( GroundShow[5], "fonts.ttf", 0.014, 0 )
    // 设置锚点
    call DzFrameSetPoint( GroundShow[3], 3, GroundShow[4], 5, 0.006, 0.00 )
    call DzFrameSetPoint( GroundShow[4], 6, GroundShow[2], 0, 0, 0.020 )
    call DzFrameSetPoint( GroundShow[5], 0, GroundShow[4], 6, 0.00, -0.005 )
    // 自适应
    call DzFrameSetPoint( GroundShow[0], 0, GroundShow[4], 0, -0.01, 0.01 )
    call DzFrameSetPoint( GroundShow[0], 8, GroundShow[2], 8, 0.01, -0.01 )
    // 设置隐藏
    call DzFrameShow( GroundShow[0], false )
    call ItemShow_RegisterTimer()
endfunction

function ItemShowBag_OpenIteamUi takes nothing returns nothing
local integer ydul_xh
local unit dw
local item wp 
local integer A 
local integer B 
local string mz 
local string jg 
local string kz 
local string j 
local integer Value
local integer sellgoldcost 
local integer sellwoodcost
set dw = ItemShowFrame_Show_Unit[GetPlayerId(DzGetTriggerUIEventPlayer())]
set ydul_xh = 0
    loop
        exitwhen ydul_xh > 5
        set wp = UnitItemInSlot(dw , ydul_xh)
        set A = DzF2I(DzFrameGetItemBarButton(ydul_xh))
        set B = DzF2I(DzGetTriggerUIEventFrame())
        if ((UnitItemInSlot(dw , ydul_xh) != null) and (B == A)) then
            call DzFrameShow(DzFrameGetTooltip(), false)
            call DzFrameShow(ItemShowFrame[0], true)
            set mz = GetItemName(wp)
            set sellgoldcost = S2I(YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, GetItemTypeId(wp), "goldcost")) / 2
            set sellwoodcost = S2I(YDWEGetObjectPropertyString(YDWE_OBJECT_TYPE_ITEM, GetItemTypeId(wp), "lumbercost")) / 2
            set jg = ("|cFFFFFF00出售黄金:" +I2S(sellgoldcost) + "|c9a00995e出售木材:" + I2S(sellwoodcost))
            set kz = YDWEGetItemDataString(GetItemTypeId(wp), 3)
            set j = LoadStr(itemhash , GetHandleId(wp) , 0)
            call DzFrameSetText(ItemShowFrame[3], mz)
            call DzFrameSetText(ItemShowFrame[5], jg)
            call DzFrameSetText(ItemShowFrame[2], kz)
            call DzFrameSetText(ItemShowFrame[1], j)
            call DzFrameSetTexture(ItemShowFrame[4], YDWEGetItemDataString(GetItemTypeId(wp), 1), 0)
            call DzFrameSetModel(ItemShowFrame[10], ItemLevelModele[GetItemLevel(wp)], 0, 0)
        else
        endif
        call DzFrameShow(DzFrameGetTooltip(), true)
        set ydul_xh = ydul_xh + 1
    endloop
endfunction

function ItemShowBag_CloseIteamUi takes nothing returns nothing
    // 鼠标离开隐藏ui
    call DzFrameShow(ItemShowFrame[0], false)    
endfunction

//创建UI实际函数
function ItemShowBag_CreateUi takes nothing returns nothing
    local integer ydul_l
    set itemhash = InitHashtable()
    // 创建ui
    set ItemShowFrame[0] = DzCreateFrameByTagName("FRAME", "提示背景", DzGetGameUI(), "template", 0)
    set ItemShowFrame[7] = DzCreateFrameByTagName("BACKDROP", "提示边框上", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[8] = DzCreateFrameByTagName("BACKDROP", "提示边框中", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[9] = DzCreateFrameByTagName("BACKDROP", "提示边框下", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[1] = DzCreateFrameByTagName("TEXT", "物品描述", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[2] = DzCreateFrameByTagName("TEXT", "物品属性", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[3] = DzCreateFrameByTagName("TEXT", "物品名字", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[4] = DzCreateFrameByTagName("BACKDROP", "物品贴图", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[5] = DzCreateFrameByTagName("TEXT", "物品价格", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[6] = DzCreateFrameByTagName("BACKDROP", "金币贴图", ItemShowFrame[0], "template", 0)
    set ItemShowFrame[10] = DzCreateFrameByTagName("SPRITE", "物品特效", ItemShowFrame[0], "template", 0)
    // 设置大小
    call DzFrameSetSize(ItemShowFrame[0], 0.17, 0.20)
    call DzFrameSetSize(ItemShowFrame[1], 0.18, 0.00)
    call DzFrameSetSize(ItemShowFrame[2], 0.18, 0.00)
    call DzFrameSetSize(ItemShowFrame[4], 0.035, 0.035)
    call DzFrameSetSize(ItemShowFrame[5], 0.18, 0.00)
    call DzFrameSetSize(ItemShowFrame[6], 0.013, 0.013)
    call DzFrameSetSize(ItemShowFrame[7], 0.205, 0.016)
    call DzFrameSetSize(ItemShowFrame[9], 0.205, 0.016)
    // 设置贴图
    call DzFrameSetTexture(ItemShowFrame[4], "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0)
    call DzFrameSetTexture(ItemShowFrame[6], "ShowItemUITexter\\bj-jinbi.blp", 0)
    call DzFrameSetTexture(ItemShowFrame[7], "ShowItemUITexter\\tishikuang-1.blp", 0)
    call DzFrameSetTexture(ItemShowFrame[8], "ShowItemUITexter\\tishikuang-4.blp", 0)
    call DzFrameSetTexture(ItemShowFrame[9], "ShowItemUITexter\\tishikuang-3.blp", 0)
    call DzFrameSetModel(ItemShowFrame[10], "ShowItemUITexter\\txk-mb-lvse.mdx", 0, 0)
    // 设置文本
    call DzFrameSetText(ItemShowFrame[3], "物品名字")
    call DzFrameSetText(ItemShowFrame[5], "|cFFFFFF001234")
    call DzFrameSetText(ItemShowFrame[2], "物品属性这里显示物品的属性")
    call DzFrameSetText(ItemShowFrame[1], "这里显示物品的说明")
    // 设置锚点
    call DzFrameSetPoint(ItemShowFrame[1], 7, DzFrameGetCommandBarButton(0, 1), 1, 0.015, 0.04)
    call DzFrameSetPoint(ItemShowFrame[2], 6, ItemShowFrame[1], 0, 0, 0)
    call DzFrameSetPoint(ItemShowFrame[3], 0, ItemShowFrame[2], 0, 0.044, 0.037)
    call DzFrameSetPoint(ItemShowFrame[4], 6, ItemShowFrame[2], 0, 0.005, 0.007)
    call DzFrameSetPoint(ItemShowFrame[5], 0, ItemShowFrame[2], 0, 0.061, 0.02)
    call DzFrameSetPoint(ItemShowFrame[6], 6, ItemShowFrame[2], 0, 0.045, 0.007)
    call DzFrameSetPoint(ItemShowFrame[7], 7, ItemShowFrame[0], 1, 0.00, -0.005)
    call DzFrameSetPoint(ItemShowFrame[9], 1, ItemShowFrame[0], 7, 0.00, 0.005)
    call DzFrameSetPoint(ItemShowFrame[10], 4, ItemShowFrame[4], 4, 0, 0)
    // 自适应
    call DzFrameSetPoint(ItemShowFrame[0], 1, ItemShowFrame[3], 1, 0, 0.006)
    call DzFrameSetPoint(ItemShowFrame[0], 3, ItemShowFrame[2], 3, -0.005, 0)
    call DzFrameSetPoint(ItemShowFrame[0], 5, ItemShowFrame[2], 5, 0.005, 0)
    call DzFrameSetPoint(ItemShowFrame[0], 7, ItemShowFrame[1], 7, 0, -0.005)
    call DzFrameSetPoint(ItemShowFrame[8], 1, ItemShowFrame[7], 7, 0.00, 0.00)
    call DzFrameSetPoint(ItemShowFrame[8], 3, ItemShowFrame[7], 3, 0.00, 0.00)
    call DzFrameSetPoint(ItemShowFrame[8], 5, ItemShowFrame[7], 5, 0.00, 0.00)
    call DzFrameSetPoint(ItemShowFrame[8], 7, ItemShowFrame[9], 1, 0.00, 0.00)
    // 设置隐藏
    call DzFrameShow(ItemShowFrame[0], false)
    // 异步显示|隐藏
    // 循环
    set ydul_l = 0
    loop
        exitwhen ydul_l > 5
        call DzFrameSetScriptByCode(DzFrameGetItemBarButton(ydul_l), 2, function ItemShowBag_OpenIteamUi, false)
        call DzFrameSetScriptByCode(DzFrameGetItemBarButton(ydul_l), 3, function ItemShowBag_CloseIteamUi, false)
        set ydul_l = ydul_l + 1
    endloop    
endfunction
//保存被选择的单位
function ItemShowBag_SaveChooseUnit takes nothing returns nothing
    set ItemShowFrame_Show_Unit[GetPlayerId(GetTriggerPlayer())] = GetTriggerUnit()
endfunction

//创建创建UI事件
function ItemShowBag_CreatCreateUiEventAndAddAction takes nothing returns nothing
    set trgUi = CreateTrigger()
    call TriggerRegisterTimerEventSingle(trgUi, 0.01)
    call TriggerAddAction(trgUi, function ItemShowBag_CreateUi)        
endfunction
//创建选择单位事件
function ItemShowBag_CreatChooseUnitEventAndAddAction takes nothing returns nothing
    set ChooseUnit = CreateTrigger()
    #define YDTRIGGER_COMMON_LOOP(n)     call TriggerRegisterPlayerSelectionEventBJ(ChooseUnit, Player(n), true)
    #define YDTRIGGER_COMMON_LOOP_LIMITS (0, 15)
    #include <YDTrigger/Common/loop.h>
    call TriggerAddAction(ChooseUnit, function ItemShowBag_SaveChooseUnit)       
endfunction

function init_ItemUi takes nothing returns nothing
    call ItemShowBag_CreatChooseUnitEventAndAddAction()
    call ItemShowBag_CreatCreateUiEventAndAddAction()
endfunction

function ItemShow_Init takes nothing returns nothing
    call ItemShow_InGroundInitializer()
    call init_ItemUi()
    set ItemLevelModele[0] = "ShowItemUITexter\\txk-mb-lvse.mdx"
    set ItemLevelModele[1] = "ShowItemUITexter\\txk-mb-lanse.mdx"
    set ItemLevelModele[2] = "ShowItemUITexter\\txk-mb-lanse.mdx"
    set ItemLevelModele[3] = "ShowItemUITexter\\txk-mb-zise.mdx"
    set ItemLevelModele[4] = "ShowItemUITexter\\txk-mb-zise.mdx"
    set ItemLevelModele[5] = "ShowItemUITexter\\txk-mb-jinse.mdx"
    set ItemLevelModele[6] = "ShowItemUITexter\\txk-mb-jinse.mdx"
    set ItemLevelModele[7] = "ShowItemUITexter\\txk-mb-fense.mdx"
    set ItemLevelModele[8] = "ShowItemUITexter\\txk-mb-fense.mdx"
    set ItemLevelModele[9] = "ShowItemUITexter\\txk-mb-hongse.mdx"

endfunction

function ItemShowBag_SaveItemToHash takes item needchange , string needaddstr returns nothing
    call SaveStr(itemhash , GetHandleId(needchange), 0 , needaddstr)
endfunction

function ItemShowBag_CleanItemToHash takes item needchange returns nothing
    call FlushChildHashtable(itemhash , GetHandleId(needchange))
endfunction

endlibrary

#endif