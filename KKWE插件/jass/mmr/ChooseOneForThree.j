#include"mmr\\mmrapi.j"

#ifndef ChooseOneForThreeIncluded 
#define ChooseOneForThreeIncluded
library ChooseOneForThree  requires MmrApi , FuncItemSystem
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
        set LastTimeChoose[playerid] = 10000
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[0], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[1], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[2], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[3], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[4], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[5], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[6], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseChoose_DB[7], IsShowChooseOneForThree[playerid])
        call DzFrameShow(ChooseOneForThree_BaseShow, IsShowChooseOneForThree[playerid] )
        //call DzSyncData( SyncDataType, "8"+I2S(playerid))        
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

        if false then

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
    if S2I(ChooseType) == 8 then
        return
    endif
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
            call SetWidgetLife( CItem , PlayerId+1)
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
            set LastTimeChoose[LoopTime] = 99999
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
            call ChooseThreeOfOneTimeChange( ShowPlayer , -1 )
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