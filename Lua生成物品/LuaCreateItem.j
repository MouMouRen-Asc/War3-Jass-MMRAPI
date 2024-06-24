<?local slk = require 'slk'?>
library KIRIN
private function cccccccc takes nothing returns nothing
<?

    local sxzf = { [[生命值]],[[魔法值]],[[攻击力]],[[护甲]],[[力量]],[[敏捷]],[[智力]],[[暴击几率]],[[暴击伤害]],[[伤害增幅]],[[伤害免疫]],[[攻击吸血]],[[闪避]],[[杀敌加全属性]],[[攻击加全属性]],[[每秒加全属性]]}
    local name = {
        ["等级礼包"] = {
            [1] = {name = "等级礼包1", sx = {[14]=10, [15]=15, [16]=20,}, ewsm = "|cffff0000需求：地图等级2"},
            [2] = {name = "等级礼包2", sx = {[14]=12, [15]=17, [16]=22,}, ewsm = "|cffff0000需求：地图等级4"},
            [3] = {name = "等级礼包3", sx = {[14]=14, [15]=19, [16]=24,}, ewsm = "|cffff0000需求：地图等级6"},
            [4] = {name = "等级礼包4", sx = {[14]=16, [15]=21, [16]=26,[9]=50,}, ewsm = "|cffff0000需求：地图等级10"},
            [5] = {name = "等级礼包5", sx = {[14]=18, [15]=23, [16]=28,}, ewsm = "|cffff0000需求：地图等级15"},
            [6] = {name = "等级礼包6", sx = {[14]=20, [15]=25, [16]=30,[10]=50,}, ewsm = "|cffff0000需求：地图等级20"},
            [7] = {name = "等级礼包7", sx = {[14]=22, [15]=27, [16]=32,}, ewsm = "|cffff0000需求：地图等级25"},
            [8] = {name = "等级礼包8", sx = {[14]=24, [15]=29, [16]=34,[8]=20,}, ewsm = "|cffff0000需求：地图等级30"},
            [9] = {name = "等级礼包9", sx = {[14]=26, [15]=31, [16]=36,}, ewsm = "|cffff0000需求：地图等级35"},
        },
        ["肝帝礼包"] = {
            [1] = {name="肝帝礼包1", sx={[14]=10,[15]=15,[16]=20,}, ewsm=""},
            [2] = {name="肝帝礼包2", sx={[14]=12,[15]=17,[16]=22,}, ewsm=""},
            [3] = {name="肝帝礼包3", sx={[14]=14,[15]=19,[16]=24,}, ewsm=""},
            [4] = {name="肝帝礼包4", sx={[14]=16,[15]=21,[16]=26,[9]=50,}, ewsm=""},
            [5] = {name="肝帝礼包5", sx={[14]=18,[15]=23,[16]=28,}, ewsm=""},
            [6] = {name="肝帝礼包6", sx={[14]=20,[15]=25,[16]=30,[10]=50,}, ewsm=""},
            [7] = {name="肝帝礼包7", sx={[14]=22,[15]=27,[16]=32,}, ewsm=""},
            [8] = {name="肝帝礼包8", sx={[14]=24,[15]=29,[16]=34,[8]=20,}, ewsm=""},
            [9] = {name="肝帝礼包9", sx={[14]=26,[15]=31,[16]=36,}, ewsm=""},
        },
        ["通关礼包"] = {
            [1] = {name="通关礼包1", sx={[14]=10,[15]=15,[16]=20,}, ewsm="|cffff0000需求：通关难度1"},
            [2] = {name="通关礼包2", sx={}, ewsm="|cffff9900获得通关英雄|n|cffff0000需求：通关难度2"},
            [3] = {name="通关礼包3", sx={[14]=12,[15]=17,[16]=22,[9]=20,}, ewsm="|cffff0000需求：通关难度3"},
            [4] = {name="通关礼包4", sx={}, ewsm="|cffff9900获得通关英雄|n|cffff0000需求：通关难度4"},
            [5] = {name="通关礼包5", sx={[14]=14,[15]=19,[16]=24,[10]=10,}, ewsm="|cffff0000需求：通关难度5"},
            [6] = {name="通关礼包6", sx={}, ewsm="|cffff9900获得通关英雄|n|cffff0000需求：通关难度6"},
            [7] = {name="通关礼包7", sx={[14]=20,[15]=25,[16]=30,[8]=5,}, ewsm="|cffff0000需求：通关难度7"},
            [8] = {name="通关礼包8", sx={}, ewsm="|cffff9900获得通关英雄|n|cffff0000需求：通关难度8"},
        },
    }

    local djlb = {}
    for k,v in pairs(name["等级礼包"]) do
        objk=slk.upgrade.Rhpm:new('djk'..k)
        objk.name=name["等级礼包"][k].name
        objk.Buttonpos1=0
        objk.Buttonpos2=-11
        objk.race=""
        obj=slk.ability.AEev:new('djl'..k)
        obj.name=name["等级礼包"][k].name
        obj.Tip="|cffff9900"..name["等级礼包"][k].name
        local zf = ""
        for c,cc in pairs(name["等级礼包"][k].sx) do
            if c ~= 8 and c ~= 9 and c ~= 10 and c ~= 11 and c ~= 12  and c ~= 13 then
                zf = zf..sxzf[c].."："..name["等级礼包"][k].sx[c].."|n"
            else
                zf = zf..sxzf[c].."："..name["等级礼包"][k].sx[c].."％".."|n"
            end
        end
        obj.Ubertip="|cffff9900"..zf..name["等级礼包"][k].ewsm
        obj.levels=1
        obj.DataA1=0
        obj.Requires=objk.get_id()
        djlb[k] = obj.get_id()
    end
    local gdlb = {}
    for k,v in pairs(name["肝帝礼包"]) do
        objk=slk.upgrade.Rhpm:new('gdk'..k)
        objk.name=name["肝帝礼包"][k].name
        objk.Buttonpos1=0
        objk.Buttonpos2=-11
        objk.race=""
        obj=slk.ability.AEev:new('gdl'..k)
        obj.name=name["肝帝礼包"][k].name
        obj.Tip="|cffff9900"..name["肝帝礼包"][k].name
        local zf = ""
        for c,cc in pairs(name["肝帝礼包"][k].sx) do
            if c ~= 8 and c ~= 9 and c ~= 10 and c ~= 11 and c ~= 12  and c ~= 13 then
                zf = zf..sxzf[c].."："..name["肝帝礼包"][k].sx[c].."|n"
            else
                zf = zf..sxzf[c].."："..name["肝帝礼包"][k].sx[c].."％".."|n"
            end
        end
        obj.Ubertip="|cffff9900"..zf..name["肝帝礼包"][k].ewsm
        obj.levels=1
        obj.DataA1=0
        obj.Requires=objk.get_id()
        gdlb[k] = obj.get_id()
    end
    local tglb = {}
    for k,v in pairs(name["通关礼包"]) do
        objk=slk.upgrade.Rhpm:new('tgk'..k)
        objk.name=name["通关礼包"][k].name
        objk.Buttonpos1=0
        objk.Buttonpos2=-11
        objk.race=""
        obj=slk.ability.AEev:new('tgl'..k)
        obj.name=name["通关礼包"][k].name
        obj.Tip="|cffff9900"..name["通关礼包"][k].name
        local zf = ""
        for c,cc in pairs(name["通关礼包"][k].sx) do
            if c ~= 8 and c ~= 9 and c ~= 10 and c ~= 11 and c ~= 12  and c ~= 13 then
                zf = zf..sxzf[c].."："..name["通关礼包"][k].sx[c].."|n"
            else
                zf = zf..sxzf[c].."："..name["通关礼包"][k].sx[c].."％".."|n"
            end
        end
        obj.Ubertip="|cffff9900"..zf..name["通关礼包"][k].ewsm
        obj.levels=1
        obj.DataA1=0
        obj.Requires=objk.get_id()
        tglb[k] = obj.get_id()
    end

    obj = slk.ability.Aspb:new('djlb')
    obj.hero = 1
    obj.DataC1 = #djlb
    obj.DataD1 = #djlb
    obj.levels = 1
    obj.DataA1 = djlb[1]..","..djlb[2]..","..djlb[3]..","..djlb[4]..","..djlb[5]..","..djlb[6]..","..djlb[7]..","..djlb[8]..","..djlb[9]
    obj.Name="等级礼包"
    obj.Tip="|cffff9900等级礼包"
    obj.Buttonpos1=1
    obj.Buttonpos2=0
    obj.DataE1="thunderbolt"
    obj = slk.ability.Aspb:new('gdlb')
    obj.hero = 1
    obj.DataC1 = #gdlb
    obj.DataD1 = #gdlb
    obj.levels = 1
    obj.DataA1 = gdlb[1]..","..gdlb[2]..","..gdlb[3]..","..gdlb[4]..","..gdlb[5]..","..gdlb[6]..","..gdlb[7]..","..gdlb[8]..","..gdlb[9]
    obj.Name="肝帝礼包"
    obj.Tip="|cffff9900肝帝礼包"
    obj.Buttonpos1=2
    obj.Buttonpos2=0
    obj.DataE1="thunderclap"
    obj = slk.ability.Aspb:new('tglb')
    obj.hero = 1
    obj.DataC1 = #tglb
    obj.DataD1 = #tglb
    obj.levels = 1
    obj.DataA1 = tglb[1]..","..tglb[2]..","..tglb[3]..","..tglb[4]..","..tglb[5]..","..tglb[6]..","..tglb[7]..","..tglb[8]
    obj.Name="通关礼包"
    obj.Tip="|cffff9900通关礼包"
    obj.Buttonpos1=3
    obj.Buttonpos2=0
    obj.DataE1="tornado"
?>
endfunction
endlibrary
