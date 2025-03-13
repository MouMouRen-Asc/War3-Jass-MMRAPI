
<?local slk = require 'slk' ?>
#include"mmr\\mmrapi.j"

#ifndef DamageShowIncluded
#define DamageShowIncluded
library DamageShow requires optional MmrApi

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

        private real array Player_Normal_Physical_MultipliedValue
        private real array Player_Elite_Physical_MultipliedValue
        private real array Player_Boss_Physical_MultipliedValue
        private real array Player_Normal_Magic_MultipliedValue
        private real array Player_Elite_Magic_MultipliedValue
        private real array Player_Boss_Magic_MultipliedValue

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
        private boolean IsSimArmor = false
        private real AttackMult = 1
        private real ArmorMult = 0.5
        private real BaseMult = 100
        private integer CantUseItemUnitType = 0
        private boolean IsCantUseItemUnitTypeBeSet = false
	endglobals

    function AddAbSkill takes integer pid , unit  u returns nothing
        call UnitAddAbility(u, GreenValueSkill[0])
		call SetUnitAbilityLevel(u , GreenValueSkill[0] , pid + 2)
        call UnitAddAbility(u, GreenValueSkill[1])
		call SetUnitAbilityLevel(u , GreenValueSkill[1] , pid + 2)	
        call UnitAddAbility(u, GreenValueSkill[2])
		call SetUnitAbilityLevel(u , GreenValueSkill[2] , pid + 2)		
    endfunction

    function WichUnitTypeCantUse takes integer w returns nothing
        set IsCantUseItemUnitTypeBeSet = true
        set CantUseItemUnitType = w
    endfunction

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

    private function ShowDamageAsTx takes unit HTU , unit DMGU , integer Damage  , boolean IsMagic  , boolean IsBJ returns nothing
        local player p = GetOwningPlayer(DMGU)
        local real x = GetUnitX(HTU)
        local real y = GetUnitY(HTU)
        local location point = Location( x + I2R(GetRandomInt( -30 , 30 )), y)
        local location pointmove
        local string zfc = I2S(Damage)
        local string z
        local string effectstr
        local integer a 
        local integer b 
        local string ismagicstr 
        local string isbj
        local effect ceffect

        if Damage > 1 and IsBJ then
            if IsMagic then
                set ismagicstr = "M.mdl"
            else
                set ismagicstr = ".mdl"
            endif

            if IsBJ then
                //set isbj = "DamageShow\\BigDamage\\"
                set isbj = "DamageShow\\NotBigDamage\\"
            else
                //set isbj = "DamageShow\\NotBigDamage\\"
            endif

            set a = 1
            loop
                exitwhen a > StringLength(zfc)
                set z = SubStringBJ(zfc, a, a)
                set b = 0 
                set effectstr = ""
                loop
                    exitwhen b > 9
                    set pointmove = PolarProjectionBJ(point , ( 50.00 * I2R(a)) , 0 )
                    set effectstr =  isbj + z + ismagicstr
                    set ceffect = AddSpecialEffectLocBJ(pointmove , effectstr)
                    call DzSetEffectScale(ceffect , 2)
                    call EXSetEffectSpeed(ceffect , 2.5)
                    call YDWETimerDestroyEffect( 1.00 , ceffect )
                    call DzSetEffectVisible( ceffect , false)
                    if GetLocalPlayer() == p then
                        call DzSetEffectVisible( ceffect , true)
                    endif
                    call RemoveLocation(pointmove)
                    set b = b + 1
                endloop
                set a = a + 1
            endloop
        endif
        call RemoveLocation(point)
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

    function RemoveAllAB takes unit u returns nothing
        if GetUnitAbilityLevel(u,GreenValueSkill[0]) >0 then
          call  UnitRemoveAbility(u,GreenValueSkill[0])
        endif
        if GetUnitAbilityLevel(u,GreenValueSkill[1]) >0 then
          call  UnitRemoveAbility(u,GreenValueSkill[1])
        endif
        if GetUnitAbilityLevel(u,GreenValueSkill[2]) >0 then
          call  UnitRemoveAbility(u,GreenValueSkill[2])
        endif
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
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true and ( (GetUnitTypeId(GetManipulatingUnit()) != CantUseItemUnitType)  or IsCantUseItemUnitTypeBeSet == false ) then

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
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true and ( (GetUnitTypeId(GetManipulatingUnit()) != CantUseItemUnitType)  or IsCantUseItemUnitTypeBeSet == false ) then
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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
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
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true and ( (GetUnitTypeId(GetManipulatingUnit()) != CantUseItemUnitType)  or IsCantUseItemUnitTypeBeSet == false ) then

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
	if IsUnitType(GetItemUnit, UNIT_TYPE_HERO) == true and ( (GetUnitTypeId(GetManipulatingUnit()) != CantUseItemUnitType)  or IsCantUseItemUnitTypeBeSet == false ) then
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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
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
    	return GetEventDamage() >= 1.00 and (IsUnitEnemy(GetTriggerUnit(), GetOwningPlayer(GetEventDamageSource())) == true)
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
        local real magicDamageMult
        local real physicalDamageMmult
        local integer pid
        local unit damageunit = GetEventDamageSource()
        local unit targetunit = GetTriggerUnit()
        local real suckingvalue
        local real needsetdamage

        if GetPlayerController(GetOwningPlayer(damageunit)) == MAP_CONTROL_USER and (IsUnitType(GetEventDamageSource(), UNIT_TYPE_HERO) == true) then
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
                    set realdamage =  getdamage * physicalDamageMmult
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true)
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    //call ShowDamageAsTx(targetunit , damageunit , R2I(needsetdamage) , false , (needsetdamage > realdamage) )
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Physical_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = realdamage*(I2R(Player_Physical_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif 
                else
                    set realdamage = getdamage * magicDamageMult 
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false) + Player_Attack_Damage_Append[pid]
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    //call ShowDamageAsTx(targetunit , damageunit , R2I(needsetdamage) , true , (needsetdamage > realdamage) )
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Magic_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Magic_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif            
                endif
                call YDWESetEventDamage(needsetdamage +  Player_Attack_Damage_Append[pid]) 
            else 
                if (YDWEIsEventPhysicalDamage() == true) or (YDWEIsEventDamageType(DAMAGE_TYPE_NORMAL) == true) then
                    set realdamage = getdamage * physicalDamageMmult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , true)
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    //call ShowDamageAsTx(targetunit , damageunit , R2I(needsetdamage) , false , (needsetdamage  > realdamage) )
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Physical_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Physical_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif
                else
                    set realdamage = getdamage * magicDamageMult * (1 + (Player_Skill_Damage_Percent[pid]/100))
                    set needsetdamage = CheckAndCalcutePhysicalOrMagic_CriticalStrike(realdamage , pid , false) 
                    call DAMAGESHOW_DamageAdd(Player(pid) , needsetdamage)
                    //call ShowDamageAsTx(targetunit , damageunit , R2I(needsetdamage) , true , (needsetdamage  > realdamage) )
                    if needsetdamage >2000000000 or needsetdamage < 0 then
                        set needsetdamage = 2000000000
                    endif
                    if (I2R(Player_Magic_Sucking[pid])/100 ) > 0 then
                        set suckingvalue = needsetdamage*(I2R(Player_Magic_Sucking[pid])/100)
                        call SetUnitState(damageunit , UNIT_STATE_LIFE , (GetUnitState(damageunit,UNIT_STATE_LIFE) +suckingvalue )) 
                    endif  
                endif
                call YDWESetEventDamage( needsetdamage + Player_Skill_Damage_Append[pid] ) 
            endif
        elseif GetPlayerController(GetOwningPlayer(damageunit)) != MAP_CONTROL_USER then
            if IsSimArmor == false then
                set pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
                if (YDWEIsEventPhysicalDamage() == true) then
                    set realdamage = getdamage * (1- (I2R(Player_Physical_LessDamage[pid])/100))
                else
                    set realdamage = getdamage * (1- (I2R(Player_Magic_LessDamage[pid])/100))
                endif
                call YDWESetEventDamage(realdamage)
            else
                
                set pid = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
                set AttackValue = GetUnitState(GetEventDamageSource(),ConvertUnitState(0x12)) + GetUnitState(GetEventDamageSource(),ConvertUnitState(0x13))
                if (YDWEIsEventPhysicalDamage() == true) then
                    if AttackValue > 10000 then
                        set realdamage = (((AttackValue * AttackMult + BaseMult) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* ArmorMult + BaseMult))) * (1- (I2R(Player_Physical_LessDamage[pid])/100))                
                    else
                        
                        set realdamage = (((AttackValue * AttackMult + BaseMult) * AttackValue)/(AttackValue +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* ArmorMult + BaseMult))) * (1- (I2R(Player_Physical_LessDamage[pid])/100))
                    endif
                else
                    set realdamage = (((getdamage * AttackMult + BaseMult) * getdamage)/(getdamage +(GetUnitState(GetTriggerUnit(),ConvertUnitState(0x20))* ArmorMult + BaseMult))) * (1- (I2R(Player_Magic_LessDamage[pid])/100))
                endif
                if realdamage >2000000000 or realdamage < 0 then
                        set realdamage = 2000000000
                endif
                call YDWESetEventDamage(realdamage)
            endif
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
        call MNAnyUnitDamaged(trg[5] , 180)
		//call YDWESyStemAnyUnitDamagedRegistTrigger(trg[5])
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

    function FuncItemAddGreenAb takes unit u ,integer typ ,real value returns nothing
        //复制的物品增加属性代码，不要管命名了
        local unit GetItemUnit = u
		local integer PlayerId =  GetPlayerId(GetOwningPlayer(GetItemUnit))
		local integer NeedSkillLevel = PlayerId +2
        local real GJLAD = 0
        local real HJAD = 0
        local real STRADD = 0
        local real AGIADD = 0
        local real INTADD = 0

        if typ == 0 then
            set GJLAD = value
        elseif typ == 1 then
            set HJAD = value
        elseif typ == 2 then
            set STRADD = value
        elseif typ == 3 then
            set AGIADD = value
        elseif typ == 4 then
            set INTADD = value
        endif
        if GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[1]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)
		elseif GJLAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[1])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		elseif GJLAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[1]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[1]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[1] , NeedSkillLevel)	
		endif	


		if HJAD != 0 and GetUnitAbilityLevel(GetItemUnit, GreenValueSkill[2]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + value)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)
		elseif HJAD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[2])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + value)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		elseif HJAD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[2]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[2]),NeedSkillLevel,108) + value)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[2] , NeedSkillLevel)	
		endif	


		if STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif STRADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif STRADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 110, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,110) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif AGIADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif AGIADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 108, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,108) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
		if INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == NeedSkillLevel then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , 1)
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)
		elseif INTADD != 0 and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) == 0 then
		call UnitAddAbility(GetItemUnit, GreenValueSkill[0])
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		elseif INTADD != 0 and (GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != NeedSkillLevel and GetUnitAbilityLevel(GetItemUnit,GreenValueSkill[0]) != 0 )then
		call EXSetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]), NeedSkillLevel, 109, EXGetAbilityDataReal(EXGetUnitAbility(GetItemUnit, GreenValueSkill[0]),NeedSkillLevel,109) + R2I(value))
		call SetUnitAbilityLevel(GetItemUnit , GreenValueSkill[0] , NeedSkillLevel)	
		endif
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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

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

    set Player_Normal_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Physical_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))

    set Player_Normal_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Normal_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Elite_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Elite_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
    set Player_Boss_Magic_MultipliedValue[PlayerId] = ( 1 + (I2R(Player_Boss_Damage_Percent[PlayerId])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[PlayerId])/100)) * (1 + (I2R(Player_Last_Damage_Percent[PlayerId])/100))
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
    set Player_Normal_Physical_MultipliedValue[pid] = ( 1 + (I2R(Player_Normal_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))
    set Player_Elite_Physical_MultipliedValue[pid] = ( 1 + (I2R(Player_Elite_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))
    set Player_Boss_Physical_MultipliedValue[pid] = ( 1 + (I2R(Player_Boss_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Physical_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))

    set Player_Normal_Magic_MultipliedValue[pid] = ( 1 + (I2R(Player_Normal_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))
    set Player_Elite_Magic_MultipliedValue[pid] = ( 1 + (I2R(Player_Elite_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))
    set Player_Boss_Magic_MultipliedValue[pid] = ( 1 + (I2R(Player_Boss_Damage_Percent[pid])/100)) * ( 1 + (I2R(Player_Magic_Damage_Percent[pid])/100)) * (1 + (I2R(Player_Last_Damage_Percent[pid])/100))
    endfunction

    function AddAttributeForPlayer takes player wichplayer , integer wihcattribute , integer value returns nothing
        call SetAttributeForPlayer(wichplayer,wihcattribute ,GetAttributeForPlayer(wichplayer , wihcattribute) + value)
    endfunction

    function GetAttributeForPlayerAsStr takes player wichplayer , integer wihcattribute returns string
        local integer v = GetAttributeForPlayer(wichplayer, wihcattribute)
        if wihcattribute == 1 then
            return "每秒攻击力：" + I2S(v)
        elseif wihcattribute == 2 then
            return "每秒力量：" + I2S(v)
        elseif wihcattribute == 3 then
            return "每秒敏捷：" + I2S(v)
        elseif wihcattribute == 4 then
            return "每秒智力：" + I2S(v)
        elseif wihcattribute == 5 then
            return "每秒最大生命值：" + I2S(v)
        elseif wihcattribute == 6 then
            return "每秒最大魔法值：" + I2S(v)
        elseif wihcattribute == 7 then
            return "每秒金币：" + I2S(v)
        elseif wihcattribute == 8 then
            return "每秒木材：" + I2S(v)
        elseif wihcattribute == 9 then
            return "每秒生命回复：" + I2S(v)
        elseif wihcattribute == 10 then
            return "每秒魔法回复：" + I2S(v)
        elseif wihcattribute == 11 then
            return "杀敌攻击力：" + I2S(v)
        elseif wihcattribute == 12 then
            return "杀敌力量：" + I2S(v)
        elseif wihcattribute == 13 then
            return "杀敌敏捷：" + I2S(v)
        elseif wihcattribute == 14 then
            return "杀敌智力：" + I2S(v)
        elseif wihcattribute == 15 then
            return "杀敌最大生命：" + I2S(v)
        elseif wihcattribute == 16 then
            return "杀敌最大魔法：" + I2S(v)
        elseif wihcattribute == 17 then
            return "杀敌经验：" + I2S(v)
        elseif wihcattribute == 18 then
            return "杀敌经验增加(百分比)：" + I2S(v) + "%"
        elseif wihcattribute == 19 then
            return "杀敌金币增加：" + I2S(v)
        elseif wihcattribute == 20 then
            return "杀敌金币增加(百分比)：" + I2S(v) + "%"
        elseif wihcattribute == 21 then
            return "杀敌木材增加：" + I2S(v)
        elseif wihcattribute == 22 then
            return "杀敌木材增加(百分比)："+ I2S(v) + "%"
        elseif wihcattribute == 23 then
            return "物理暴击伤害：" + I2S(v)+ "%"
        elseif wihcattribute == 24 then
            return "物理暴击率：" + I2S(v) + "%"
        elseif wihcattribute == 25 then
            return "魔法暴击伤害：" + I2S(v) + "%"
        elseif wihcattribute == 26 then
            return "魔法暴击率：" + I2S(v) + "%"
        elseif wihcattribute == 27 then
            return "技能伤害百分比：" + I2S(v) + "%"
        elseif wihcattribute == 28 then
            return "技能伤害附加：" + I2S(v)
        elseif wihcattribute == 29 then
            return "攻击伤害附加：" + I2S(v)
        elseif wihcattribute == 30 then
            return "物理伤害：" + I2S(v) + "%"
        elseif wihcattribute == 31 then
            return "魔法伤害：" + I2S(v) + "%"
        elseif wihcattribute == 32 then
            return "最终伤害：" + I2S(v) + "%"
        elseif wihcattribute == 33 then
            return "普通怪增伤：" + I2S(v) + "%"
        elseif wihcattribute == 34 then
            return "精英怪增伤：" + I2S(v) + "%"
        elseif wihcattribute == 35 then
            return "Boss增伤：" + I2S(v) + "%"
        elseif wihcattribute == 36 then
            return "物理吸血：" + I2S(v) + "%"
        elseif wihcattribute == 37 then
            return "魔法吸血：" + I2S(v) + "%"
        elseif wihcattribute == 38 then
            return "物理减伤：" + I2S(v) + "%"
        elseif wihcattribute == 39 then
            return "魔法减伤：" + I2S(v) + "%"
        elseif wihcattribute == 40 then
            return "冷却时间减少：" + I2S(v) + "%"
        elseif wihcattribute == 41 then
            return "力量百分比：" + I2S(v) + "%"
        elseif wihcattribute == 42 then
            return "敏捷百分比：" + I2S(v) + "%"
        elseif wihcattribute == 43 then
            return "智力百分比：" + I2S(v) + "%"
        elseif wihcattribute == 44 then
            return "攻击力百分比：" + I2S(v) + "%"
        elseif wihcattribute == 45 then
            return "生命最大值百分比：" + I2S(v) + "%"
        elseif wihcattribute == 46 then
            return "魔法最大值百分比：" + I2S(v) + "%"
         elseif wihcattribute == 47 then
            return "每十秒增加攻击力：" + I2S(v)
        elseif wihcattribute == 48 then
            return "每十秒增加力量：" + I2S(v)
        elseif wihcattribute == 49 then
            return "每十秒增加敏捷：" + I2S(v)
        elseif wihcattribute == 50 then
            return "每十秒增加智力：" + I2S(v)
        elseif wihcattribute == 51 then
            return "每十秒增加最大生命值：" + I2S(v)
        elseif wihcattribute == 52 then
            return "每十秒增加最大魔法值：" + I2S(v)
        elseif wihcattribute == 53 then
            return "每十秒增加金币：" + I2S(v)
        elseif wihcattribute == 54 then
            return "每十秒增加木材：" + I2S(v)
        elseif wihcattribute == 55 then
            return "杀十敌获得攻击力：" + I2S(v)
        elseif wihcattribute == 56 then
            return "杀十敌获得力量：" + I2S(v)
        elseif wihcattribute == 57 then
            return "杀十敌获得敏捷：" + I2S(v)
        elseif wihcattribute == 58 then
            return "杀十敌获得智力：" + I2S(v)
        elseif wihcattribute == 59 then
            return "杀十敌获得最大生命值：" + I2S(v)
        elseif wihcattribute == 60 then
            return "杀十敌获得最大魔法值：" + I2S(v)
        elseif wihcattribute == 61 then
            return "杀十敌获得经验值：" + I2S(v)
        elseif wihcattribute == 62 then
            return "杀十敌获得经验值百分比加成：" + I2S(v)  + "%"
        elseif wihcattribute == 63 then
            return "杀十敌获得金币：" + I2S(v)
        elseif wihcattribute == 64 then
            return "杀十敌获得金币百分比加成：" + I2S(v) + "%"
        elseif wihcattribute == 65 then
            return "杀十敌获得木材：" + I2S(v)
        elseif wihcattribute == 66 then
            return "杀十敌获得木材百分比加成：" + I2S(v) + "%"
        endif
            return ""





    endfunction

    function ChangeIsArmorSim takes boolean can returns nothing
        set IsSimArmor = can
    endfunction

    function ChangeArmorSimValue takes real ATKM , real ARMM , real BM returns nothing
        set AttackMult = ATKM
        set ArmorMult = ARMM
        set BaseMult = BM
    endfunction
endlibrary

#endif
