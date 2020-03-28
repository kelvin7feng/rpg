
using UnityEngine;
using SLua;

namespace KG
{
    [CustomLuaClassAttribute]
    public class TerrianTrigger : BaseTrigger
    {
        public GameObject nextTerrian;

        protected override void Start()
        {
            base.Start();
            SetTriggerCount(0);
            SetTriggerName("terrian_trigger");
        }      
    }
}