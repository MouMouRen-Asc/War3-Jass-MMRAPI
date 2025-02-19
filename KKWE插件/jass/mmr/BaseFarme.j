#include"KKAPI.j"

library BaseFrameLib
    function M_NativeFrame takes integer tp returns integer
        if tp == 1 then
           return DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0)
        elseif tp == 2 then
            return DzSimpleFontStringFindByName("SimpleNameValue", 0)
        elseif tp == 3 then
            return DzSimpleFrameFindByName("SimpleHeroLevelBar", 0)
        elseif tp == 4 then
            return DzSimpleFontStringFindByName("SimpleClassValue", 0)
        elseif tp == 5 then
            return DzSimpleFrameFindByName("SimpleInfoPanelIconDamage", 0)
        elseif tp == 6 then
            return DzSimpleTextureFindByName("InfoPanelIconBackdrop", 0)
        elseif tp == 7 then
            return DzSimpleFontStringFindByName("InfoPanelIconLevel", 0)
        elseif tp == 8 then
            return DzSimpleFontStringFindByName("InfoPanelIconLabel", 0)
        elseif tp == 9 then
            return DzSimpleFontStringFindByName("InfoPanelIconValue", 0)
        elseif tp == 10 then
            return DzSimpleTextureFindByName("InfoPanelIconBackdrop", 1)
        elseif tp == 11 then
            return DzSimpleFontStringFindByName("InfoPanelIconLevel", 1)
        elseif tp == 12 then
            return DzSimpleFontStringFindByName("InfoPanelIconLabel", 1)
        elseif tp == 13 then
            return DzSimpleFontStringFindByName("InfoPanelIconValue", 1)
        elseif tp == 14 then
            return DzSimpleFrameFindByName("SimpleInfoPanelIconArmor", 2)
        elseif tp == 15 then
            return DzSimpleTextureFindByName("InfoPanelIconBackdrop", 2)
        elseif tp == 16 then
            return DzSimpleFontStringFindByName("InfoPanelIconLevel", 2)
        elseif tp == 17 then
            return DzSimpleFontStringFindByName("InfoPanelIconLabel", 2)
        elseif tp == 18 then
            return DzSimpleFontStringFindByName("InfoPanelIconValue", 2)
        elseif tp == 19 then
            return DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6)
        elseif tp == 20 then
            return DzSimpleFrameFindByName("SimpleInfoPanelIconHeroText", 6)
        elseif tp == 21 then
            return DzSimpleTextureFindByName("InfoPanelIconHeroIcon", 6)
        elseif tp == 22 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroStrengthLabel", 6)
        elseif tp == 23 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroStrengthValue", 6)
        elseif tp == 24 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroAgilityLabel", 6)
        elseif tp == 25 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroAgilityValue", 6)
        elseif tp == 26 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroIntellectLabel", 6)
        elseif tp == 27 then
            return DzSimpleFontStringFindByName("InfoPanelIconHeroIntellectValue", 6)
        elseif tp == 28 then
            return DzSimpleTextureFindByName("InfoPanelIconBackdrop", 4)
        elseif tp == 29 then
            return DzSimpleFontStringFindByName("InfoPanelIconLabel", 4)
        elseif tp == 30 then
            return DzSimpleFontStringFindByName("InfoPanelIconValue", 4)
        elseif tp == 31 then
            return DzSimpleFontStringFindByName("InfoPanelIconAllyTitle", 7)
        elseif tp == 32 then
            return DzSimpleTextureFindByName("InfoPanelIconAllyGoldIcon", 7)
        elseif tp == 33 then
            return DzSimpleFontStringFindByName("InfoPanelIconAllyGoldValue", 7)
        elseif tp == 34 then
            return DzSimpleTextureFindByName("InfoPanelIconAllyWoodIcon", 7)
        elseif tp == 35 then
            return DzSimpleFontStringFindByName("InfoPanelIconAllyWoodValue", 7)
        elseif tp == 36 then
            return DzSimpleTextureFindByName("InfoPanelIconAllyFoodIcon", 7)
        elseif tp == 37 then
            return DzSimpleFontStringFindByName("InfoPanelIconAllyFoodValue", 7)
        elseif tp == 38 then
            return DzSimpleFontStringFindByName("InfoPanelIconAllyUpkeep", 7)
        elseif tp == 39 then
            return DzSimpleFrameFindByName("ResourceBarFrame", 0)
        elseif tp == 40 then
            return DzSimpleFontStringFindByName("ResourceBarGoldText", 0)
        elseif tp == 41 then
            return DzSimpleFontStringFindByName("ResourceBarLumberText", 0)
        elseif tp == 42 then
            return DzSimpleFontStringFindByName("ResourceBarSupplyText", 0)
        elseif tp == 43 then
            return DzSimpleFontStringFindByName("ResourceBarUpkeepText", 0)
        elseif tp == 44 then
            return DzSimpleFrameFindByName("SimpleInfoPanelItemDetail", 3)
        elseif tp == 45 then
            return DzSimpleFontStringFindByName("SimpleItemNameValue", 3)
        elseif tp == 46 then
            return DzSimpleFontStringFindByName("SimpleItemDescriptionValue", 3)
        elseif tp == 47 then
            return DzSimpleFrameFindByName("SimpleInfoPanelBuildingDetail", 1)
        elseif tp == 48 then
            return DzSimpleFontStringFindByName("SimpleBuildingNameValue", 1)
        elseif tp == 49 then
            return DzSimpleFrameFindByName("SimpleBuildTimeIndicator", 1)
        elseif tp == 50 then
            return DzSimpleFontStringFindByName("SimpleBuildingActionLabel", 1)
        elseif tp == 51 then
            return DzSimpleTextureFindByName("SimpleBuildQueueBackdrop", 1)
        elseif tp == 52 then
            return DzSimpleFrameFindByName("SimpleInfoPanelCargoDetail", 2)
        elseif tp == 53 then
            return DzSimpleFontStringFindByName("SimpleHoldNameValue", 2)
        elseif tp == 54 then
            return DzSimpleFrameFindByName("ConsoleUI", 0)
        endif
        return 0
    endfunction
endlibrary
