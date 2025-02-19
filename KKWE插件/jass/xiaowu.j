#include"japi\YDWEAbilityState.j"
#include"japi\YDWEEventDamageData.j"
#include"japi\YDWEJapiEffect.j"
#include"japi\YDWEJapiOther.j"
#include"japi\YDWEJapiScript.j"
#include"japi\YDWEJapiUnit.j"
#include"japi\YDWEState.j"
library XIAOWU

    globals
        hashtable XIAOWU_hxb = InitHashtable()
        attacktype XIAOWU_BSESH_A_bb
        damagetype XIAOWU_BSESH_A_cc
    endglobals
//贝塞尔曲线x计算公式
    function XIAOWU_BSE_AA takes real t, real x1, real x2, real x3 returns real
        local real t2 = (1 - t) * (1 - t)
        local real t_2 = t * t
        local real zz = (t2 * x1 + 2 * t * (1 - t) * x2 + t_2 * x3)
        return zz
    endfunction
//贝塞尔曲线y计算公式
    function XIAOWU_BSE_AB takes real t, real y1, real y2, real y3 returns real
        local real t2 = (1 - t) * (1 - t)
        local real t_2 = t * t
        local real zz = (t2 * y1 + 2 * t * (1 - t) * y2 + t_2 * y3)
        return zz
    endfunction
//极坐标位移点
    function XIAOWU_BSE_A takes location source, real dist, real angle returns location
        local real x = GetLocationX(source) + dist * Cos(angle * (3.14159/180.0))
        local real y = GetLocationY(source) + dist * Sin(angle * (3.14159/180.0))
        return Location(x, y)
    endfunction
//单位到单位的角度
    function XIAOWU_BSE_D takes unit fromUnit, unit toUnit returns real
        return (180.0/3.14159) * Atan2(GetUnitY(toUnit) - GetUnitY(fromUnit), GetUnitX(toUnit) - GetUnitX(fromUnit))
    endfunction
//单位到单位的贝塞尔曲线计时器
    function XIAOWU_BSE_B takes nothing returns nothing
        local timer XW_JSQ=GetExpiredTimer()
        local real z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8)
        local location d = GetUnitLoc(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1))
        local location d1 = XIAOWU_BSE_A(d,LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7),XIAOWU_BSE_D(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1),LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2)) + LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6))
        local location d2 = GetUnitLoc(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2))
        local real x0 = EXGetEffectX(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
        local real y0 = EXGetEffectY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
        local real x1 = GetLocationX(d1)
        local real y1 = GetLocationY(d1)
        local real x2 = GetLocationX(d2)
        local real y2 = GetLocationY(d2)
        local real x = XIAOWU_BSE_AA(z,x0,x1,x2)
        local real y = XIAOWU_BSE_AB(z,y0,y1,y2)
        local real c = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4)+(1.00*z*(1.00-z)*(LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5)*6.66*z))
        set z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8) + 0.02
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,z)
        call EXSetEffectXY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),x,y)
        call EXSetEffectZ(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),c)
        call RemoveLocation(d)
        call RemoveLocation(d1)
        call RemoveLocation(d2)
        if z >= 1.00 then
            call DestroyEffect(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
            call FlushChildHashtable(XIAOWU_hxb,GetHandleId(XW_JSQ))
            call DestroyTimer(XW_JSQ)
        endif
    endfunction
//单位到单位的贝塞尔曲线的动作及传参
    function XIAOWU_BSE_C takes unit a , unit b , effect c , real d , real e , real f , real g returns nothing
        local timer XW_JSQ = null
        set XW_JSQ =CreateTimer()
        call SaveUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1,a)
        call SaveUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2,b)
        call SaveEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3,c)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4,d)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5,e)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6,f)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7,g)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,0.00)
        call TimerStart(XW_JSQ,0.02,true,function XIAOWU_BSE_B)
        set XW_JSQ = null
    endfunction
//点到点的贝塞尔曲线计时器
    function XIAOWU_BSE_E takes nothing returns nothing
        local timer XW_JSQ=GetExpiredTimer()
        local real z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8)
        local location d1 = XIAOWU_BSE_A(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1),LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7),AngleBetweenPoints(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1),LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2)) + LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6))
        local real x0 = EXGetEffectX(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
        local real y0 = EXGetEffectY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
        local real x1 = GetLocationX(d1)
        local real y1 = GetLocationY(d1)
        local real x2 = GetLocationX(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2))
        local real y2 = GetLocationY(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2))
        //local real x = ((Pow(1.00 - z,2)*x0))+((2.00*z)*(1.00-z)*x1)+(z*z*x2)
        //local real y = ((Pow(1.00 - z,2)*y0))+((2.00*z)*(1.00-z)*y1)+(z*z*y2)
        local real x = XIAOWU_BSE_AA(z,x0,x1,x2)
        local real y = XIAOWU_BSE_AB(z,y0,y1,y2)
        local real c = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4)+(1.00*z*(1.00-z)*(LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5)*6.66*z))
        set z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8) + 0.02
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,z)
        call EXSetEffectXY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),x,y)
        call EXSetEffectZ(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),c)
        call RemoveLocation(d1)
        if z >= 1.00 then
            call DestroyEffect(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
            call RemoveLocation(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1))
            call RemoveLocation(LoadLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2))
            call FlushChildHashtable(XIAOWU_hxb,GetHandleId(XW_JSQ))
            call DestroyTimer(XW_JSQ)
        endif
    endfunction
//点到点的贝塞尔曲线的动作及传参
    function XIAOWU_BSE_F takes location a , location b , effect c , real d , real e , real f , real g returns nothing
        local timer XW_JSQ = null
        set XW_JSQ =CreateTimer()
        call SaveLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1,a)
        call SaveLocationHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2,b)
        call SaveEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3,c)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4,d)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5,e)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6,f)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7,g)
        call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,0.00)
        call TimerStart(XW_JSQ,0.02,true,function XIAOWU_BSE_E)
        set XW_JSQ = null
    endfunction

//单位到单位的贝塞尔曲线计时器[带伤害]
function XIAOWU_BSESH_B takes nothing returns nothing
    local timer XW_JSQ=GetExpiredTimer()
    local real z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8)
    local location d = GetUnitLoc(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1))
    local location d1 = XIAOWU_BSE_A(d,LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7),XIAOWU_BSE_D(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1),LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2)) + LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6))
    local location d2 = GetUnitLoc(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2))
    local real x0 = EXGetEffectX(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
    local real y0 = EXGetEffectY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
    local real x1 = GetLocationX(d1)
    local real y1 = GetLocationY(d1)
    local real x2 = GetLocationX(d2)
    local real y2 = GetLocationY(d2)
    local real x = XIAOWU_BSE_AA(z,x0,x1,x2)
    local real y = XIAOWU_BSE_AB(z,y0,y1,y2)
    local real c = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4)+(1.00*z*(1.00-z)*(LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5)*6.66*z))
    set z = LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8) + 0.02
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,z)
    call EXSetEffectXY(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),x,y)
    call EXSetEffectZ(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3),c)
    call RemoveLocation(d)
    call RemoveLocation(d1)
    call RemoveLocation(d2)
    if z >= 1.00 then
        call UnitDamageTarget(LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1), LoadUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2), LoadReal(XIAOWU_hxb,GetHandleId(XW_JSQ),9), true, false, XIAOWU_BSESH_A_bb, XIAOWU_BSESH_A_cc, WEAPON_TYPE_WHOKNOWS )
        call DestroyEffect(LoadEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3))
        call FlushChildHashtable(XIAOWU_hxb,GetHandleId(XW_JSQ))
        call DestroyTimer(XW_JSQ)
    endif
endfunction
//单位到单位的贝塞尔曲线的动作及传参
function XIAOWU_BSESH_A takes unit a , unit b , effect c , real d , real e , real f , real g, real aa, attacktype bb, damagetype cc returns nothing
    local timer XW_JSQ = null
    set XW_JSQ =CreateTimer()
    set XIAOWU_BSESH_A_bb = bb
    set XIAOWU_BSESH_A_cc = cc
    call SaveUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),1,a)
    call SaveUnitHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),2,b)
    call SaveEffectHandle(XIAOWU_hxb,GetHandleId(XW_JSQ),3,c)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),4,d)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),5,e)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),6,f)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),7,g)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),8,0.00)
    call SaveReal(XIAOWU_hxb,GetHandleId(XW_JSQ),9,aa)
    call TimerStart(XW_JSQ,0.02,true,function XIAOWU_BSESH_B)
    set XW_JSQ = null
endfunction

//单位生命值小于等于0
    function XIAOWU_XQDWDR_AA takes unit a returns boolean
        return GetUnitState(a, UNIT_STATE_LIFE) <= 0
    endfunction
//单位生命值大于0
    function XIAOWU_XQDWDR_AB takes unit a returns boolean
        return not XIAOWU_XQDWDR_AA(a)
    endfunction
//把（单位不等于建筑）and（单位生命值大于0）and（单位是玩家的敌对单位）这3个条件合成到一起
    function XIAOWU_XQDWDR_A takes unit a, player b returns boolean
        if ((IsUnitType(a, UNIT_TYPE_STRUCTURE) == false) and (XIAOWU_XQDWDR_AB(a) == true) and (IsUnitEnemy(a, b) == true)) then
            return true
        else
            return false
        endif
    endfunction

//Coc()角度
    function XIAOWU_COS_A takes real degrees returns real
        return Cos(degrees * (3.14159/180))
    endfunction

//Sin()角度
    function XIAOWU_SIN_A takes real degrees returns real
        return Sin(degrees * (3.14159/180))
    endfunction
//扇形选取并造成伤害
    function XIAOWU_SXXQ_A takes unit a,real b,real c,real d,boolean e,boolean f,attacktype g, damagetype h returns nothing
        local group dwz
        local unit dw
        set dwz = CreateGroup()
        call GroupEnumUnitsInRange(dwz,GetUnitX(a),GetUnitY(a),b,null)
        loop
            set dw =FirstOfGroup(dwz)
            exitwhen dw == null
            if ((XIAOWU_XQDWDR_A(dw,GetOwningPlayer(a))) and (XIAOWU_COS_A((XIAOWU_BSE_D(a,dw) - GetUnitFacing(a))) > XIAOWU_COS_A(c/2))) then
                call UnitDamageTarget(a, dw, d, e, f, g, h, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(dwz,dw)
        endloop
        call DestroyGroup(dwz)
        set dwz = null
        set dw = null
    endfunction

//绝对值
    function XIAOWU_JDZ_A takes real a returns real
        if (a >= 0) then
            return a
        else
            return -a
        endif
    endfunction
//任意矩形选取
    function XIAOWU_JXXQ_A takes unit aa,location b,real c,real d,boolean e,boolean f,attacktype g, damagetype h returns nothing
        local location a = GetUnitLoc(aa)
        local real jla = DistanceBetweenPoints(a,b) / 2
        local real jlb = DistanceBetweenPoints(a,b)
        local location p1 = XIAOWU_BSE_A(b,jla,AngleBetweenPoints(b,a))
        local real jd = AngleBetweenPoints(a,p1)
        local real x0 = GetLocationX(p1)
        local real y0 = GetLocationY(p1)
        local real xt = (x0 * XIAOWU_COS_A(jd)) + (y0 * XIAOWU_SIN_A(jd))
        local real yt = (y0 * XIAOWU_COS_A(jd)) - (x0 * XIAOWU_SIN_A(jd))
        local real r = SquareRoot((Pow((jlb/2),2.00)) + (Pow((c/2),2.00)))
        local group dwz
        local unit dw

        local real x1
        local real y1
        local real x2
        local real y2

        set dwz = CreateGroup()
        call GroupEnumUnitsInRange(dwz,GetLocationX(p1),GetLocationY(p1),r,null)
        loop
            set dw =FirstOfGroup(dwz)
            exitwhen dw == null
            set x1 = GetUnitX(dw)
            set y1 = GetUnitY(dw)
            set x2 = (x1 * XIAOWU_COS_A(jd)) + (y1 * XIAOWU_SIN_A(jd))
            set y2 = (y1 * XIAOWU_COS_A(jd)) - (x1 * XIAOWU_SIN_A(jd))
            if (XIAOWU_JDZ_A(xt-x2) <= jla) and (XIAOWU_JDZ_A(yt-y2) <= (c/2) and (XIAOWU_XQDWDR_A(dw,GetOwningPlayer(aa)))) then
                call UnitDamageTarget(aa, dw, d, e, f, g, h, WEAPON_TYPE_WHOKNOWS )
            endif
            call GroupRemoveUnit(dwz,dw)
        endloop
        call DestroyGroup(dwz)
        set dwz = null
        set dw = null
        call RemoveLocation(a)
        call RemoveLocation(b)
        call RemoveLocation(p1)
    endfunction

endlibrary



