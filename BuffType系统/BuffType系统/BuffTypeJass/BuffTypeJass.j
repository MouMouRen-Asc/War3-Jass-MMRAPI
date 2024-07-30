//! zinc
library Buff
{
    private
    {
        hashtable BuffHT = InitHashtable();

        struct BuffType
        {
            // 心跳间隔
            real dur;
            // 名字
            string name;
            // 回调
            trigger addEventId;
            trigger removeEvnetId;
            trigger updateEventId;
            // 是否为可叠加
            boolean flag;
        }

        // 触发的Buff实例
        Buff triggerBuff;

        // 最后创建的Buff
        BuffType lastCreatedBuffType;

        // 执行回调
        function callBackAddEventBuffTypeXw(Buff bf)
        {
            triggerBuff = bf;
            if (TriggerEvaluate(bf.buffType.addEventId)) {
                TriggerExecute(bf.buffType.addEventId);
            }
        }
        function callBackRemoveEventBuffTypeXw(Buff bf)
        {
            triggerBuff = bf;
            if (TriggerEvaluate(bf.buffType.removeEvnetId)) {
                TriggerExecute(bf.buffType.removeEvnetId);
            }
        }
        function callBackUpdateEventBuffTypeXw(Buff bf)
        {
            triggerBuff = bf;
            if (TriggerEvaluate(bf.buffType.updateEventId)) {
                TriggerExecute(bf.buffType.updateEventId);
            }
        }
    }

    public
    {
        // 构造BuffType
        function createBuffTypeXw(string name, real time, boolean isFlag) ->BuffType
        {
            BuffType bt = BuffType.create();
            // 基础参数
            bt.name = name;
            bt.dur = time;
            bt.flag = isFlag;
            // 绑定
            SaveInteger(BuffHT, <?= StringHash("bufftype实例") ?>, StringHash(name), integer(bt));
            lastCreatedBuffType = bt;
            return bt;
        }
        // 注册回调
        function onAddEventBuffTypeXw(BuffType bt, trigger trig)
        {
            bt.addEventId = trig;
        }
        function onRemoveEventBuffTypeXw(BuffType bt, trigger trig)
        {
            bt.removeEvnetId = trig;
        }
        function onUpdateEventBuffTypeXw(BuffType bt, trigger trig)
        {
            bt.updateEventId = trig;
        }
        // 获取触发的Buff实例
        function getTriggerBuff() ->Buff
        {
            return triggerBuff;
        }
        // 获取最后创建的BuffType
        function getLastCreatedBuffType() ->BuffType
        {
            return lastCreatedBuffType;
        }
    }

    private
    {
        struct Buff
        {
            //
            real tdur;
            // 持续时间
            real dur;
            // 来源和目标
            unit source;
            unit target;
            // 重复判断需求
            boolean repeat;
            real repeatTime;
            // Buff唯一Id
            trigger id;
            integer handleId;
            // BuffType
            BuffType buffType;
            timer time;
            // Buff层数
            integer buffnumber;
        }
    }

    public
    {
        // 构造Buff，来源，目标，Buff名称，持续时间
        function createBuffXw(unit Source, unit Target, string whichName, real whichTime , integer num) ->Buff
        {
            Buff bf = 0;
            BuffType bt = LoadInteger(BuffHT, <?= StringHash("bufftype实例") ?>, StringHash(whichName));
            if (LoadInteger(BuffHT, GetHandleId(Target), integer(bt)) > 0) {
                bf = LoadInteger(BuffHT, GetHandleId(Target), integer(bt));
                bf.repeat = true;
                bf.repeatTime = whichTime;
                // 执行回调
                if (bt.addEventId != null) callBackAddEventBuffTypeXw(bf);
                return bf;
            }
            // 注册信息
            bf = Buff.create();
            bf.source = Source;
            bf.target = Target;
            bf.buffType = bt;
            bf.dur = whichTime;
            bf.tdur = whichTime;
            bf.id = CreateTrigger();
            bf.handleId = GetHandleId(bf.id);
            bf.buffnumber = num;
            bf.time = null;
            bf.repeat = false;
            bf.repeatTime = 0.0;
            // 绑定实例
            SaveInteger(BuffHT, GetHandleId(Target), integer(bt), integer(bf));
            // 执行周期
            if (bf.dur > 0.0) {
                bf.time = CreateTimer();
                SaveInteger(BuffHT, GetHandleId(bf.time), 0, integer(bf));
                TimerStart(bf.time, bt.dur, true, function() {
                    timer exTimer = GetExpiredTimer();
                    Buff bf = LoadInteger(BuffHT, GetHandleId(exTimer), 0);
                    bf.dur = bf.dur - bf.buffType.dur;
                    if (bf.buffType.updateEventId != null) callBackUpdateEventBuffTypeXw(bf);
                    if (bf.dur <= 0.0) {
                        if(bf.buffnumber <= 1){
                            if (bf.buffType.removeEvnetId != null) callBackRemoveEventBuffTypeXw(bf);
                            RemoveSavedInteger(BuffHT, GetHandleId(exTimer), 0);
                            DestroyTimer(exTimer);
                            RemoveSavedInteger(BuffHT, GetHandleId(bf.target), integer(bf.buffType));
                            DestroyTrigger(bf.id);
                            bf.destroy();
                        }
                        else{
                        bf.buffnumber = bf.buffnumber - 1;
                        bf.dur = bf.tdur;
                        }
                    }
                    exTimer = null;
                });
            }
            // 执行添加
            if (bt.addEventId != null) callBackAddEventBuffTypeXw(bf);
            return bf;
        }

        // 转换Buff为整数
        function buffToIntegerXw(Buff bf) ->integer
        {
            return bf.handleId;
        }

        // 事件参数
        function getSourceBuffXw(Buff bf) ->unit
        {
            return bf.source;
        }
        function getTargetBuffXw(Buff bf) ->unit
        {
            return bf.target;
        }
        function getTimeBuffXw(Buff bf) ->real
        {
            return bf.dur;
        }
        function setTimeBuffXw(Buff bf, real value)
        {
            bf.dur = value;
        }
        function addTimeBuffXw(Buff bf, real value)
        {
            bf.dur = bf.dur + value;
        }
        function subTimeBuffXw(Buff bf, real value)
        {
            bf.dur = bf.dur - value;
        }
        function endTimeBuffXw(Buff bf)
        {
            bf.dur = 0.0;
        }
        // 判断是否为可叠加
        function IsFlagBuffXw(Buff bf) ->boolean
        {
            return bf.buffType.flag;
        }
        // 处理重复相关
        function IsRepeatBuffXw(Buff bf) ->boolean
        {
            return bf.repeat;
        }
        function getRepeatTimeBuffXw(Buff bf) ->real
        {
            return bf.repeatTime;
        }
        function getBuffNumber(Buff bf) ->integer
        {
            return bf.buffnumber;
        }
        function addBuffNumber(Buff bf , integer value)
        {
            bf.buffnumber = bf.buffnumber + value ;
        }
    }
}
//! endzinc
