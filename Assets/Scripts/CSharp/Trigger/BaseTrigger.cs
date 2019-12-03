using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClassAttribute]
    public class BaseTrigger : MonoBehaviour
    {
        [HideInInspector]
        public uint triggerId = 0;
        private bool isActive = true;
        protected Collider mCollider;
        protected uint triggerCount = 1;
        protected uint curTriggerCount = 0;
        private int lastOther = 0;
        public static int CUTOMN_TRIGGER = 13;  //关卡触发器
        public static int MASK_FOR_CUTOMN_TRIGGER = 1 << CUTOMN_TRIGGER;
        protected int layerMask = MASK_FOR_CUTOMN_TRIGGER;

        /*
         * triggerName会组合成msg_base_trigger_enter和triggerName会组合成msg_base_trigger_exit
         * lua层在pkgEventType里定义，在相关代码里监听事件即可收到触发器事件
         */
        protected string triggerName = "base_trigger";

        private static LuaFunction callBackTriggerEnter = null;
        private static LuaFunction callBackTriggerExit = null;

        public bool IsActive
        {
            get { return isActive; }
            set
            {
                isActive = value;
                mCollider.enabled = value;
            }
        }

        protected void SetTriggerCount(uint triggerCount)
        {
            this.triggerCount = triggerCount;
        }

        public uint GetTriggerCount()
        {
            return this.triggerCount;
        }

        protected void SetTriggerName(string name)
        {
            this.triggerName = name;
        }

        protected virtual void Start()
        {
            if (TriggerMgr.Instance != null)
                this.triggerId = TriggerMgr.Instance.AddTrigger(this);
            mCollider = gameObject.GetComponent<Collider>();
            curTriggerCount = 0;
        }

        private bool IsActor(Collider collider)
        {
            return true;
        }

        protected virtual void OnTriggerEnter(Collider other)
        {
            if (!IsActor(other))
            {
                return;
            }
            if (triggerCount > 0 && curTriggerCount >= triggerCount)
            {
                return;
            }
            if (callBackTriggerEnter == null)
            {
                callBackTriggerEnter = LuaSvr.mainState.getFunction("pkgTriggerManager.OnTriggerEnter");
            }
            callBackTriggerEnter.call(other, this, triggerName + "_enter");
            curTriggerCount++;
            lastOther = other.GetHashCode();
        }

        protected virtual void OnTriggerExit(Collider other)
        {
            int layer = 1 << other.gameObject.layer;
            if ((layerMask & layer) != layer)
            {
                return;
            }
            if (!IsActor(other))
            {
                return;
            }
            if (lastOther != 0 && lastOther != other.GetHashCode())
            {
                return;
            }
            if (callBackTriggerExit == null)
            {
                callBackTriggerExit = LuaSvr.mainState.getFunction("pkgTriggerManager.OnTriggerExit");
            }
            callBackTriggerExit.call(other, this, "msg_" + triggerName + "_exit");
            if (triggerCount > 0 && curTriggerCount >= triggerCount)
            {
                IsActive = false;
            }
        }

        protected virtual void OnDestroy()
        {
            if (TriggerMgr.Instance != null && this.triggerId != 0)
                TriggerMgr.Instance.RemoveTrigger(this.triggerId);
        }
    }
}