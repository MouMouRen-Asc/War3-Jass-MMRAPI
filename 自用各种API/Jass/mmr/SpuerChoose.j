#include"mmr\\mmrapi.j"

#ifndef MSuperChooseIncluded 
#define MSuperChooseIncluded 

library MSuperChoose requires MmrApi

    globals
        private hashtable ChooseUiData = InitHashtable()
        private integer BaseFrame
        private integer BaseFrameTiltle
        private integer array ChooseBackGround
        private integer array ChooseBootom
        private integer array ChooseTiltle_Text
        private integer array ChooseTiltle_BackGround
        private integer array ChooseTexter
        private integer array ChooseTexterSPRITE
        private integer array ChooseMessage_Text
        private integer array DisLike
        private integer array ReFresh
        private integer farmenum 
        private real bx =200
        private real by =500
        private integer array pchoosetime
        private trigger cbtrg = null
        private trigger mytrg = null

        ///async
        private string LocPlayerNowEvent = "null"

        //texterdata,0是基础背景，1是标题，2是三选一默认状态，3是三选一进入状态，4是文字标题背景,5关闭按钮默认状态，6关闭按钮进入状态，7刷新按钮默认状态，8刷新按钮进入状态
        private string array texterdata

    endglobals

    function MSC_SetPlayerIDTo2I takes player p returns string
        local integer pid = GetPlayerId(p)
        if (pid/10) >= 1 then
            return I2S(pid)
        endif
        return "0" + I2S(pid)
    endfunction

    function MSC_SetTimeTo4I takes integer time returns string
        if (I2R(time)/10) < 1 then
            return "000" + I2S(time)
        endif
        if (I2R(time)/100) < 1 then
            return "00" + I2S(time)
        endif
        if (I2R(time)/1000) < 1 then
            return "0" + I2S(time)
        endif

        if (I2R(time)/9999) >= 1 then
            return "9999"
        endif
            return I2S(time)
    endfunction

    function MSC_IsEventIdVail takes string eid returns boolean
        return HaveSavedString(ChooseUiData,StringHash(eid),0)
    endfunction


    function MSC_AddPlayerChooseTime takes player p , string Re , string close returns string 
        local string EventId ="null"
        set pchoosetime[GetPlayerId(p)]  = pchoosetime[GetPlayerId(p)] + 1
        set EventId = MSC_SetPlayerIDTo2I(p)+MSC_SetTimeTo4I(pchoosetime[GetPlayerId(p)])
        call SaveStr(ChooseUiData,StringHash(EventId),0,"TRUE")
        call SaveStr(ChooseUiData,StringHash(EventId),1,Re)
        call SaveStr(ChooseUiData,StringHash(EventId),2,close)
        
        return EventId
    endfunction

    function MSC_AsEvnentIdAddChoose takes string eid , integer cnum ,string til ,string texter ,string message,string rtn returns string
        if MSC_IsEventIdVail(eid) then
            call SaveStr(ChooseUiData,StringHash(eid),5 +((cnum - 1)*4),rtn)//5-9-13
            call SaveStr(ChooseUiData,StringHash(eid),5 + 1 +((cnum - 1)*4),til)//6-10-12
            call SaveStr(ChooseUiData,StringHash(eid),5 + 2 +((cnum - 1)*4),texter)//7-11-13
            call SaveStr(ChooseUiData,StringHash(eid),5 + 3 +((cnum - 1)*4),message)//8-12-14
            return "AddSuc"
        endif
            return "AddFail"
    endfunction

    function MSC_AsEventIdGetRtn takes string eid ,integer cnum returns  string
       return LoadStr(ChooseUiData,StringHash(eid),5+((cnum - 1)*4))
    endfunction

    function MSC_AsEventIdGetTil takes string eid ,integer cnum returns string
        return LoadStr(ChooseUiData,StringHash(eid),5+1+((cnum - 1)*4))
    endfunction

    function MSC_AsEventIdGetTexter takes string eid ,integer cnum returns  string
       return LoadStr(ChooseUiData,StringHash(eid),5+2+((cnum - 1)*4))
    endfunction

    function MSC_AsEventIdGetMessage takes string eid ,integer cnum returns  string
       return LoadStr(ChooseUiData,StringHash(eid),5+3+((cnum - 1)*4))
    endfunction

    function MSC_GetChooseNum takes nothing returns integer
        local string data  = DzGetTriggerSyncData()
        return S2I(SubString(data,0,1))
    endfunction

    function MSC_GetChoosePlayer takes nothing returns integer
        local string data  = DzGetTriggerSyncData()
        return S2I(SubString(data,1,3))+1
    endfunction

    function MSC_GetChooseEid takes nothing returns string
        local string data  = DzGetTriggerSyncData()
        return SubString(data,1,7)
    endfunction

    function MSC_GetChooseValue takes nothing returns string
        local string data  = DzGetTriggerSyncData()
        return SubString(data,7,71)
    endfunction

    function MSC_DestroyChooseEvent takes string eeid returns boolean
        if HaveSavedString(ChooseUiData,StringHash(eeid),0) then
            call FlushChildHashtable(ChooseUiData,StringHash(eeid))
            return true
        endif
        return false
    endfunction

    function MSC_ECB_GoCallBackEvent takes nothing returns nothing
        if MSC_GetChooseNum() != 0 then
            call SaveInteger(ChooseUiData,StringHash(MSC_GetChooseEid()),3,MSC_GetChooseNum()) 
        endif
        if mytrg != null then
            call TriggerExecute(mytrg)
        endif
    endfunction

    function MSC_ReCalcuteFrameByShow takes integer uinum ,real wlength ,real hlength  returns nothing
        local real basewidget =300
        local real jgprecent = 0.15
        local real wreal_jg = (jgprecent*wlength)/(I2R(uinum) + 1)
        local real w = 300
        local real h = hlength
        local integer lp = 0
        local real fw
        local real fh
        local string eventid_loc = LocPlayerNowEvent
        set w = (wlength-(jgprecent*wlength))/I2R(uinum)
        call DzFrameSetTexture(BaseFrame,texterdata[0],0)
        call DzFrameSetTexture(BaseFrameTiltle,texterdata[1],0)
        //set LocPlayerNowEvent = "null"
        loop
            exitwhen lp > farmenum
            if lp < uinum then
                set fw = bx+(lp*w)+((lp+1)*wreal_jg)
                set fh = by-50
                call DzFrameSetSize(ChooseBackGround[lp],Math_UIWidget(w),Math_UIHight(h-200))
                call DzFrameSetAbsolutePoint(ChooseBackGround[lp],3,Math_UIWidget(fw),Math_UIHight(fh))
                call DzFrameSetTexture(ChooseBackGround[lp],texterdata[2],0)


                set fw = bx+(lp*w)+((lp+1)*wreal_jg) + (w/2)
                call DzFrameSetSize(ChooseTiltle_BackGround[lp],Math_UIWidget(w*0.7),Math_UIHight(50))
                call DzFrameSetAbsolutePoint(ChooseTiltle_BackGround[lp],4,Math_UIWidget(fw),Math_UIHight(fh+170))
                call DzFrameSetTexture(ChooseTiltle_BackGround[lp],texterdata[4],0)

                call DzFrameSetSize(ChooseTiltle_Text[lp],Math_UIWidget(w*0.5),Math_UIHight(20))
                call DzFrameSetPoint(ChooseTiltle_Text[lp],3,ChooseTiltle_BackGround[lp],3,0.02,0)
                call DzFrameSetText(ChooseTiltle_Text[lp],MSC_AsEventIdGetTil(eventid_loc,lp+1))

                call DzFrameSetSize(ChooseTexter[lp],0.03,0.03)
                call DzFrameSetAbsolutePoint(ChooseTexter[lp],4,Math_UIWidget(fw),Math_UIHight(fh+120))
                call DzFrameSetTexture(ChooseTexter[lp],MSC_AsEventIdGetTexter(eventid_loc,lp+1),0)
                call DzFrameSetSize(ChooseTexterSPRITE[lp],0.0001,0.0001)
                call DzFrameSetPoint(ChooseTexterSPRITE[lp],4,ChooseTexter[lp],4,-0.02,-0.02)
                call DzFrameSetModel(ChooseTexterSPRITE[lp],"UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl",0,0)

                set fw = bx+(lp*w)+((lp+1)*wreal_jg) + (w/2)
                call DzFrameSetSize(ChooseMessage_Text[lp],Math_UIWidget(w*0.8),Math_UIHight(h-350))
                call DzFrameSetAbsolutePoint(ChooseMessage_Text[lp],4,Math_UIWidget(fw),Math_UIHight(fh-50))
                call DzFrameSetText(ChooseMessage_Text[lp],MSC_AsEventIdGetMessage(eventid_loc,lp+1))

                set fw = bx+(lp*w)+((lp+1)*wreal_jg)
                set fh = by-50
                call DzFrameSetSize(ChooseBootom[lp],Math_UIWidget(w),Math_UIHight(h-200))
                call DzFrameSetAbsolutePoint(ChooseBootom[lp],3,Math_UIWidget(fw),Math_UIHight(fh))



                call DzFrameShow(ChooseBackGround[lp],true)
                call DzFrameShow(ChooseTiltle_BackGround[lp],true) 
                call DzFrameShow(ChooseTiltle_Text[lp],true)
                call DzFrameShow(ChooseTexter[lp],true) 
                call DzFrameShow(ChooseMessage_Text[lp],true) 
                call DzFrameShow(ChooseBootom[lp],true) 
            else
                call DzFrameShow(ChooseBackGround[lp],false)
                call DzFrameShow(ChooseTiltle_BackGround[lp],false) 
                call DzFrameShow(ChooseTiltle_Text[lp],false)
                call DzFrameShow(ChooseTexter[lp],false) 
                call DzFrameShow(ChooseMessage_Text[lp],false) 
                call DzFrameShow(ChooseBootom[lp],false) 
            endif

            set lp = lp + 1
        endloop
    endfunction

    function MSC_DisLikeKick takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        local integer father = DzFrameGetParent(Tui)
        local string eid = LocPlayerNowEvent
        set LocPlayerNowEvent = "null"
        call DzFrameShow(BaseFrame,false)
        call DzSyncDataImmediately( "PCSON", I2S(0)+eid+LoadStr(ChooseUiData,StringHash(eid),2))
    endfunction

    function MSC_RefreshKick takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        local integer father = DzFrameGetParent(Tui)
        local string eid = LocPlayerNowEvent
        set LocPlayerNowEvent = "null"
        call DzFrameShow(BaseFrame,false)
        call DzSyncDataImmediately( "PCSON", I2S(0)+eid+LoadStr(ChooseUiData,StringHash(eid),1))
    endfunction

    function MSC_ChooseBottomKick takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        local integer father = DzFrameGetParent(Tui)
        local integer ChooseId = LoadInteger(ChooseUiData,father,0) + 1
        local string eid = LocPlayerNowEvent
        set LocPlayerNowEvent = "null"
        //call BJDebugMsg("选择了第：" + I2S(ChooseId)+"选择，他的事件ID为"+eid+"回调值为："+ AsEventIdGetRtn(eid,ChooseId))
        call DzFrameShow(BaseFrame,false)
        call DzSyncDataImmediately( "PCSON", I2S(ChooseId)+eid+MSC_AsEventIdGetRtn(eid,ChooseId))
    endfunction

    function MSC_ChooseBottomIn takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        local integer father = DzFrameGetParent(Tui)
        if Tui == DisLike[1] then
            call DzFrameSetTexture(DisLike[0],texterdata[6],0)
            return
        elseif Tui == ReFresh[1]  then
            call DzFrameSetTexture(ReFresh[0],texterdata[8],0)
            return
        endif
        call DzFrameShow(LoadInteger(ChooseUiData,father,1),true)
        call DzFrameSetTexture(father,texterdata[3],0)
    endfunction

    function MSC_ChooseBottomOut takes nothing returns nothing
        local integer Tui = DzGetTriggerUIEventFrame()
        local player Tplayer = DzGetTriggerUIEventPlayer()
        local integer playerid = GetPlayerId(Tplayer)
        local integer father = DzFrameGetParent(Tui)
        if Tui == DisLike[1] then
            call DzFrameSetTexture(DisLike[0],texterdata[5],0)
            return
        elseif Tui == ReFresh[1]  then
            call DzFrameSetTexture(ReFresh[0],texterdata[7],0)
            return
        endif
        call DzFrameShow(LoadInteger(ChooseUiData,father,1),false)
        call DzFrameSetTexture(father,texterdata[2],0)
    endfunction

    function MSC_Create_ChooseUi takes integer ChooseNumber returns nothing
        local integer lopnum_a = 0
        local string namestr = ""
        local real uiw = 0
        set BaseFrame = DzCreateFrameByTagName("BACKDROP", "BASE", DzGetGameUI(), "template", 0)
        call DzFrameSetSize(BaseFrame,Math_UIWidget(1200),Math_UIHight(600))
        call DzFrameShow(BaseFrame,false)
        call DzFrameSetTexture(BaseFrame,"UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp",0)
        call DzFrameSetAbsolutePoint(BaseFrame,3,Math_UIWidget(bx),Math_UIHight(by))

        set BaseFrameTiltle = DzCreateFrameByTagName("BACKDROP", "BASE", BaseFrame, "template", 0)
        call DzFrameSetSize(BaseFrameTiltle,Math_UIWidget(800),Math_UIHight(100))
        call DzFrameShow(BaseFrameTiltle,true)
        call DzFrameSetTexture(BaseFrameTiltle,"",0)
        call DzFrameSetAbsolutePoint(BaseFrameTiltle,3,Math_UIWidget(bx+200),Math_UIHight(by+250))

        loop
            exitwhen lopnum_a>=ChooseNumber
            set namestr = "ChooseBackGround"+I2S(lopnum_a)
            set ChooseBackGround[lopnum_a] = DzCreateFrameByTagName("BACKDROP", namestr,BaseFrame, "template", 0)
            call DzFrameSetTexture(ChooseBackGround[lopnum_a],"UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp",0)
            call DzFrameShow(ChooseBackGround[lopnum_a],true)
            call SaveInteger(ChooseUiData,ChooseBackGround[lopnum_a],0,lopnum_a)

            set namestr = "ChooseTiltle_BackGround"+I2S(lopnum_a)
            set ChooseTiltle_BackGround[lopnum_a] = DzCreateFrameByTagName("BACKDROP", namestr,ChooseBackGround[lopnum_a], "template", 0)
            call DzFrameSetTexture(ChooseTiltle_BackGround[lopnum_a],"UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp",0)
            call DzFrameShow(ChooseTiltle_BackGround[lopnum_a],true)

            set namestr = "ChooseTiltle_Text"+I2S(lopnum_a)
            set ChooseTiltle_Text[lopnum_a] = DzCreateFrameByTagName("TEXT", namestr,ChooseTiltle_BackGround[lopnum_a], "template", 0)
            call DzFrameSetText(ChooseTiltle_Text[lopnum_a],"【召唤系】召唤天雷")
            call DzFrameShow(ChooseTiltle_Text[lopnum_a],true)
            
            set namestr = "ChooseTexter"+I2S(lopnum_a)
            set ChooseTexter[lopnum_a] = DzCreateFrameByTagName("BACKDROP", namestr,ChooseTiltle_BackGround[lopnum_a], "template", 0)
            call DzFrameSetTexture(ChooseTexter[lopnum_a],"ReplaceableTextures\\CommandButtons\\BTNSpellBreaker.blp",0)
            call DzFrameShow(ChooseTexter[lopnum_a],true)
            
            set namestr = "ChooseTexterSPRITE"+I2S(lopnum_a)
            set ChooseTexterSPRITE[lopnum_a] = DzCreateFrameByTagName("SPRITE", namestr,ChooseTexter[lopnum_a], "template", 0)
            call DzFrameShow(ChooseTexterSPRITE[lopnum_a],false)
            call SaveInteger(ChooseUiData,ChooseBackGround[lopnum_a],1,ChooseTexterSPRITE[lopnum_a])


            set namestr = "ChooseMessage_Text"+I2S(lopnum_a)
            set ChooseMessage_Text[lopnum_a] = DzCreateFrameByTagName("TEXT", namestr,ChooseBackGround[lopnum_a], "template", 0)
            call DzFrameSetText(ChooseMessage_Text[lopnum_a],"文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字文字")
            call DzFrameShow(ChooseMessage_Text [lopnum_a],true)

            set namestr = "ChooseBootom"+I2S(lopnum_a)
            set ChooseBootom[lopnum_a] = DzCreateFrameByTagName("BUTTON",namestr,ChooseBackGround[lopnum_a], "template", 0)
            if GetLocalPlayer() == GetLocalPlayer() then
            	call DzFrameSetScriptByCode( ChooseBootom[lopnum_a] , 1 , function MSC_ChooseBottomKick, false)
                call DzFrameSetScriptByCode( ChooseBootom[lopnum_a] , 2 , function MSC_ChooseBottomIn, false)
                call DzFrameSetScriptByCode( ChooseBootom[lopnum_a] , 3 , function MSC_ChooseBottomOut, false)
            endif
            set lopnum_a = lopnum_a + 1
        endloop

        set DisLike[0] = DzCreateFrameByTagName("BACKDROP", "DisLikeBack", BaseFrame, "template", 0)
        call DzFrameSetSize(DisLike[0],Math_UIWidget(80),Math_UIHight(80))
        call DzFrameShow(DisLike[0],true)
        call DzFrameSetTexture(DisLike[0],"",0)
        call DzFrameSetAbsolutePoint(DisLike[0],3,Math_UIWidget(bx+1160),Math_UIHight(by+280))
        set DisLike[1] = DzCreateFrameByTagName("BUTTON", "DisLikeBottom", DisLike[0], "template", 0)
        call DzFrameSetSize(DisLike[1],Math_UIWidget(80),Math_UIHight(80))
        call DzFrameShow(DisLike[1],true)
        call DzFrameSetTexture(DisLike[1],"",0)
        call DzFrameSetAbsolutePoint(DisLike[1],3,Math_UIWidget(bx+1160),Math_UIHight(by+280))
        call DzFrameSetScriptByCode( DisLike[1] , 1 , function MSC_DisLikeKick, false)
        call DzFrameSetScriptByCode( DisLike[1] , 2 , function MSC_ChooseBottomIn, false)
        call DzFrameSetScriptByCode( DisLike[1] , 3 , function MSC_ChooseBottomOut, false)

        set ReFresh[0] = DzCreateFrameByTagName("BACKDROP", "ReFreshBack", BaseFrame, "template", 0)
        call DzFrameSetSize(ReFresh[0],Math_UIWidget(400),Math_UIHight(100))
        call DzFrameShow(ReFresh[0],true)
        call DzFrameSetTexture(ReFresh[0],"",0)
        call DzFrameSetAbsolutePoint(ReFresh[0],3,Math_UIWidget(bx+400),Math_UIHight(by-330))
        set ReFresh[1] = DzCreateFrameByTagName("BUTTON", "ReFreshBottom", ReFresh[0], "template", 0)
        call DzFrameSetSize(ReFresh[1],Math_UIWidget(400),Math_UIHight(100))
        call DzFrameShow(ReFresh[1],true)
        call DzFrameSetTexture(ReFresh[1],"",0)
        call DzFrameSetAbsolutePoint(ReFresh[1],3,Math_UIWidget(bx+400),Math_UIHight(by-330))
        call DzFrameSetScriptByCode( ReFresh[1] , 1 , function MSC_RefreshKick, false)
        call DzFrameSetScriptByCode( ReFresh[1] , 2 , function MSC_ChooseBottomIn, false)
        call DzFrameSetScriptByCode( ReFresh[1] , 3 , function MSC_ChooseBottomOut, false)
        
        call MSC_ReCalcuteFrameByShow(ChooseNumber,1200,600)
    endfunction

    function MSC_Refresh_ChooseThreeOfOne_Async takes integer number returns nothing
        call MSC_ReCalcuteFrameByShow(number,1200,600)
        call DzFrameShow(BaseFrame,true)
    endfunction

    function MSC_ResEventByT takes trigger trg returns nothing
        set mytrg = trg
    endfunction

    function MSC_OpUiAsPlayer takes player p ,string eid ,integer number returns nothing
        if MSC_IsEventIdVail(eid) == false then
            return
        endif
        if p == GetLocalPlayer() then
            if LocPlayerNowEvent == "null" then
                set LocPlayerNowEvent = eid
                call MSC_Refresh_ChooseThreeOfOne_Async(number)
            endif
        endif
    endfunction
    function MSC_In_ChooseUI takes integer ChooseNumber ,string Bakc_k,string Bakc_t,string Bakc_B1,string Bakc_B2,string Bakc_tx , string Back_Dis1 , string Back_Dis2 , string Back_Re1 , string Back_Re2 returns nothing
        set texterdata[0] = Bakc_k 
        set texterdata[1] = Bakc_t 
        set texterdata[2] = Bakc_B1 
        set texterdata[3] = Bakc_B2 
        set texterdata[4] = Bakc_tx
        set texterdata[5] = Back_Dis1 
        set texterdata[6] = Back_Dis2 
        set texterdata[7] = Back_Re1 
        set texterdata[8] = Back_Re2 
        set farmenum = ChooseNumber
        call MSC_Create_ChooseUi(ChooseNumber)
        set cbtrg = CreateTrigger()
        call DzTriggerRegisterSyncData(cbtrg,"PCSON",false)
        call TriggerAddAction(cbtrg,function MSC_ECB_GoCallBackEvent)
    endfunction
endlibrary
#endif
