using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace KG
{
    public class TriggerMgr : MonoBehaviour
    {
        private uint triggerIndex = 0;
        public static TriggerMgr Instance;

        private Dictionary<uint, BaseTrigger> triggers = new Dictionary<uint, BaseTrigger>();

        private void Awake()
        {
            if (Instance != null && Instance != this)
            {
                GameObject.Destroy(this);
                SLua.Logger.LogError("you inited Trigger manager twice!");
                return;
            }
            Instance = this;
        }

        public BaseTrigger GetTrigger(uint triggerId)
        {
            return triggers[triggerId];
        }

        public uint AddTrigger(BaseTrigger trigger)
        {
            triggerIndex++;
            triggers.Add(triggerIndex, trigger);
            return triggerIndex;
        }

        public void RemoveTrigger(uint triggerId)
        {
            if (triggers.ContainsKey(triggerId))
                triggers.Remove(triggerId);
        }
    }
}