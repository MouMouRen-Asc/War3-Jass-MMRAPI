#ifndef SplLevelIncluded 
#define SplLevelIncluded 

library SplLevel 
    globals
        private hashtable SplLevelTable
        private string array SplLevelName
        private real array SplNeed
        private integer SplNum = 0
    endglobals


    function SplLevel_UseIt takes nothing returns nothing
        set SplLevelTable = InitHashtable()
    endfunction

    function SplLevel_SetLevelData takes string SplName ,real SplNeed returns nothing
        set SplLevelName[SplLevel] = SplName
        set SplNeed[SplLevel] = SplNeed
        set SplNum = SplNum + 1
    endfunction

    function SplLevel_AddUnitLevelData takes unit u ,real data returns string
        local real d = data
        if HaveSavedInteger(SplLevelTable,GetHandleId(u),0) == true then
            set d = d + LoadReal(SplLevelTable,GetHandleId(u),1)
            if d>= SplNeed[LoadInteger(SplLevelTable,GetHandleId(u),0)] then
                set  d = d - SplNeed[LoadInteger(SplLevelTable,GetHandleId(u),0)]
                if LoadInteger(SplLevelTable,GetHandleId(u),0) < SplNum then
                    call SaveReal(SplLevelTable,GetHandleId(u),1,d)
                    call SaveInteger(SplLevelTable,GetHandleId(u),0,LoadInteger(SplLevelTable,GetHandleId(u),0) + 1)
                    return SplLevelName[LoadInteger(SplLevelTable,GetHandleId(u),0)]
                else
                    return "0"
                endif
                return "0"
            else
                call SaveReal(SplLevelTable,GetHandleId(u),1,d)
                return "0"
            endif
        else
            call SaveInteger(SplLevelTable,GetHandleId(u),0,0)
            call SaveReal(SplLevelTable,GetHandleId(u),1,0)
            return "0"
        endif
        return "0"
    endfunction

    function SplLevel_SetUnitLevelData takes unit u , integer lvl ,real data returns nothing
        call SaveInteger(SplLevelTable,GetHandleId(u),0,lvl)
        call SaveReal(SplLevelTable,GetHandleId(u),1,data)
    endfunction

    function SplLevel_GetLevelNeedByInteger takes integer i returns real
        return SplNeed[i]
    endfunction

    function SplLevel_GetUnitLevelNeedByInteger takes unit u returns real
        if HaveSavedInteger(SplLevelTable,GetHandleId(u),0) == true then
            return SplLevel_GetLevelNeedByInteger(LoadInteger(SplLevelTable,GetHandleId(u),0)) - LoadReal(SplLevelTable,GetHandleId(u),1)
        endif
        return -1
    endfunction

    function SplLevel_GetLevelNameByInteger takes integer i returns string 
        return SplLevelName[i]
    endfunction

    function SplLevel_GetUnitLevelNameByInteger takes unit u returns string
        return SplLevel_GetLevelNameByInteger((LoadInteger(SplLevelTable,GetHandleId(u),0)))
    endfunction

    function SplLevel_GetUnitNextLevelNameByInteger takes unit u returns string
        return SplLevel_GetLevelNameByInteger((LoadInteger(SplLevelTable,GetHandleId(u),0))+1)
    endfunction
endlibrary



#endif