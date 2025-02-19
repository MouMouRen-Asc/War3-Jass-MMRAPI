    #include"mmr\\mmrapi.j"
    #ifndef TalentTreeByDota2Included 
    #define TalentTreeByDota2Included 
    library TalentTreeByDota2 requires MmrApi
        globals
            private real array BasePoint
            //0=基础按钮打开状态，1=基础按钮关闭状态，2= 天赋UI背景板图片，3=天赋UI指定天赋按钮默认状态，4=天赋UI指定天赋按钮进入状态
            //5=天赋按钮已经被选择状态，6=说明标题背景图片，7=说明标题图片
            //8 = 提示背景贴图 9 = 提示文字标题
            private string array AllTexture
            private integer Base
            //0 = 提示信息基础背景 1 = 提示信息文字标题背景 2 = 提示信息文字标题 3 = 提示信息文字详情
            private integer array MessageUi
            private integer array Choose_BackGround
            private integer array Choose_Text
            private integer array Choose_Buttom
            private integer array OpenBottom

        endglobals

        private function TTBD_SwichShowState takes nothing returns nothing
            if DzFrameIsVisible(Base) then
                call DzFrameShow(Base,false)
                call DzFrameSetTexture(OpenBottom[0],AllTexture[1],0)
            else
                call DzFrameShow(Base,true)
                call DzFrameSetTexture(OpenBottom[0],AllTexture[0],0)
            endif
        endfunction


        private function TTBD_ChooseBottomKick takes nothing returns nothing
            local integer Tui = DzGetTriggerUIEventFrame()
            local player Tplayer = DzGetTriggerUIEventPlayer()
            local integer playerid = GetPlayerId(Tplayer)
        endfunction

        private function TTBD_ChooseBottomIn takes nothing returns nothing
            local integer Tui = DzGetTriggerUIEventFrame()
            local player Tplayer = DzGetTriggerUIEventPlayer()
            local integer playerid = GetPlayerId(Tplayer)
        endfunction

        private function TTBD_ChooseBottomOut takes nothing returns nothing
            local integer Tui = DzGetTriggerUIEventFrame()
            local player Tplayer = DzGetTriggerUIEventPlayer()
            local integer playerid = GetPlayerId(Tplayer)
        endfunction

        private function CreatChooseButtom takes nothing returns nothing
            local integer lop = 0
            local real h = BasePoint[3] + 450
            local real w = BasePoint[2]
            loop
                exitwhen lop>=6
                set Choose_BackGround[lop] = DzCreateFrameByTagName("BACKDROP","Choose_BackGround"+I2S(lop),Base, "template", 0)
                set Choose_Text[lop] = DzCreateFrameByTagName("TEXT","Choose_Text"+I2S(lop),Choose_BackGround[lop], "template", 0)
                set Choose_Buttom[lop] = DzCreateFrameByTagName("BUTTON","Choose_Buttom"+I2S(lop),Choose_BackGround[lop], "template", 0)
                call DzFrameSetSize(Choose_BackGround[lop],Math_UIWidget(150),Math_UIHight(45))
                call DzFrameSetSize(Choose_Text[lop],Math_UIWidget(150),Math_UIHight(45))
                call DzFrameSetSize(Choose_Buttom[lop],Math_UIWidget(150),Math_UIHight(45))
                
                call DzFrameSetTexture(Choose_BackGround[lop],AllTexture[3],0)

                call DzFrameSetAbsolutePoint(Choose_BackGround[lop],0,Math_UIWidget(w+30),Math_UIHight(h-(((lop+1)*25)+(lop*45))))
                call DzFrameSetAbsolutePoint(Choose_Text[lop],0,Math_UIWidget(w+30),Math_UIHight(h-(((lop+1)*25)+(lop*45))))
                call DzFrameSetAbsolutePoint(Choose_Buttom[lop],0,Math_UIWidget(w+30),Math_UIHight(h-(((lop+1)*25)+(lop*45))))

                call DzFrameShow(Choose_BackGround[lop],true)
                call DzFrameShow(Choose_Text[lop],true)
                call DzFrameShow(Choose_Buttom[lop],true)
                if GetLocalPlayer() == GetLocalPlayer() then
            	    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 1 , function TTBD_ChooseBottomKick, false)
                    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 2 , function TTBD_ChooseBottomIn, false)
                    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 3 , function TTBD_ChooseBottomOut, false)
                endif
            set lop = lop + 1
            endloop
            loop
                exitwhen lop>=12
                set Choose_BackGround[lop] = DzCreateFrameByTagName("BACKDROP","Choose_BackGround"+I2S(lop),Base, "template", 0)
                set Choose_Text[lop] = DzCreateFrameByTagName("TEXT","Choose_Text"+I2S(lop),Choose_BackGround[lop], "template", 0)
                set Choose_Buttom[lop] = DzCreateFrameByTagName("BUTTON","Choose_Buttom"+I2S(lop),Choose_BackGround[lop], "template", 0)
                call DzFrameSetSize(Choose_BackGround[lop],Math_UIWidget(150),Math_UIHight(45))
                call DzFrameSetSize(Choose_Text[lop],Math_UIWidget(150),Math_UIHight(45))
                call DzFrameSetSize(Choose_Buttom[lop],Math_UIWidget(150),Math_UIHight(45))
                
                call DzFrameSetTexture(Choose_BackGround[lop],AllTexture[3],0)

                call DzFrameSetAbsolutePoint(Choose_BackGround[lop],0,Math_UIWidget(w+220),Math_UIHight(h-(((lop+1-6)*25)+((lop-6)*45))))
                call DzFrameSetAbsolutePoint(Choose_Text[lop],0,Math_UIWidget(w+220),Math_UIHight(h-(((lop+1-6)*25)+((lop-6)*45))))
                call DzFrameSetAbsolutePoint(Choose_Buttom[lop],0,Math_UIWidget(w+220),Math_UIHight(h-(((lop+1-6)*25)+((lop-6)*45))))

                call DzFrameShow(Choose_BackGround[lop],true)
                call DzFrameShow(Choose_Text[lop],true)
                call DzFrameShow(Choose_Buttom[lop],true)

                if GetLocalPlayer() == GetLocalPlayer() then
            	    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 1 , function TTBD_ChooseBottomKick, false)
                    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 2 , function TTBD_ChooseBottomIn, false)
                    call DzFrameSetScriptByCode( Choose_Buttom[lop] , 3 , function TTBD_ChooseBottomOut, false)
                endif
            set lop = lop + 1
            endloop
        endfunction

        function TTBD_CreateTTBD takes nothing returns nothing
            set OpenBottom[0] = DzCreateFrameByTagName("BACKDROP","TTBD_OpenBottomBack",DzGetGameUI(), "template", 0)
            call DzFrameSetSize(OpenBottom[0],Math_UIWidget(150),Math_UIHight(50))
            call DzFrameShow(OpenBottom[0],true)
            call DzFrameSetAbsolutePoint(OpenBottom[0],6,Math_UIWidget(BasePoint[0]),Math_UIHight(BasePoint[1]))
            call DzFrameSetTexture(OpenBottom[0],AllTexture[1],0)
            set OpenBottom[1] = DzCreateFrameByTagName("BUTTON","TTBD_OpenBottom",DzGetGameUI(), "template", 0)
            call DzFrameSetSize(OpenBottom[1],Math_UIWidget(150),Math_UIHight(50))
            call DzFrameShow(OpenBottom[1],true)
            call DzFrameSetAbsolutePoint(OpenBottom[1],6,Math_UIWidget(BasePoint[0]),Math_UIHight(BasePoint[1]))
            if GetLocalPlayer()==GetLocalPlayer() then
                call DzFrameSetScriptByCode(OpenBottom[1],1,function TTBD_SwichShowState,false)
            endif

            set Base = DzCreateFrameByTagName("BACKDROP","TTBD_BaseBack",DzGetGameUI(), "template", 0)
            call DzFrameSetSize(Base,Math_UIWidget(400),Math_UIHight(450))
            call DzFrameShow(Base,false)
            call DzFrameSetAbsolutePoint(Base,6,Math_UIWidget(BasePoint[2]),Math_UIHight(BasePoint[3]))
            call DzFrameSetTexture(Base,AllTexture[2],0)

            set MessageUi[0] = DzCreateFrameByTagName("BACKDROP","TTBD_MessageUi",Base, "template", 0)
            call DzFrameSetSize(MessageUi[0],Math_UIWidget(200),Math_UIHight(200))
            call DzFrameSetAbsolutePoint(MessageUi[0],6,Math_UIWidget(BasePoint[0]+400),Math_UIHight(BasePoint[1]))
            call DzFrameSetTexture(MessageUi[0],AllTexture[8],0)


            set MessageUi[1] = DzCreateFrameByTagName("BACKDROP","TTBD_Messa",MessageUi[0], "template", 0)
            call DzFrameSetSize(MessageUi[1],Math_UIWidget(120),Math_UIHight(35))
            call DzFrameSetPoint(MessageUi[1],1,MessageUi[0],1,Math_UIWidget(0),Math_UIHight(-15))
            set MessageUi[2] = DzCreateFrameByTagName("TEXT","TTBD_MessageUi2",MessageUi[0], "template", 0)


            set MessageUi[3] = DzCreateFrameByTagName("TEXT","TTBD_MessageUi3",MessageUi[0], "template", 0)


            call DzFrameShow(MessageUi[0],true)
            call DzFrameShow(MessageUi[1],true)
            call DzFrameShow(MessageUi[2],true)
            call DzFrameShow(MessageUi[3],true)





            call CreatChooseButtom()
        endfunction

        function TTBD_GetMouseAndReFresh_Ac takes nothing returns nothing

        endfunction

        function TTBD_GetMouseAndReFresh takes nothing returns nothing
            if GetLocalPlayer() == GetLocalPlayer() then
            endif
        endfunction

        function TTBD_Intlize takes nothing returns nothing
            set BasePoint[0] = 430
            set BasePoint[1] = 200
            set BasePoint[2] = 300
            set BasePoint[3] = 250
            set AllTexture[0] = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
            set AllTexture[1] = ""
            set AllTexture[2] = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
            set AllTexture[3] = ""
            set AllTexture[4] = ""
            set AllTexture[5] = ""
            set AllTexture[6] = ""
            set AllTexture[7] = ""
            set AllTexture[8] = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp"
            set AllTexture[9] = ""
            call TimerStart(CreateTimer(),0.1,true,function TTBD_GetMouseAndReFresh)
        endfunction
    endlibrary
    #endif