
#ifndef MNzIncluded 
#define MNzIncluded 

library MNz 
    function MNz_RunCheckLeakage takes nothing returns nothing
        call AbilityId("exec-lua:script\\CheckLeakage")
    endfunction
    function MNz_RunSetWindoInMid takes nothing returns nothing
        call AbilityId("exec-lua:script\\窗口自适应居中")
    endfunction
    function MNz_RunHookMessage takes nothing returns nothing
        call AbilityId("exec-lua:script\\屏幕消息事件")
    endfunction
endlibrary


#endif