using UnityEngine;
using NodeCanvas.Framework;
using SLua;
using ParadoxNotion.Design;

namespace KG
{
    [CustomLuaClass]
    abstract public class LuaBaseCondition : ConditionTask<Transform>
    {
        protected string luaClsName;
        protected static LuaFunction onInit = null;
        protected static LuaFunction onCheck = null;
        private bool bIsChecked = false;

        public bool isChecked
        {
            get { return bIsChecked; }
            set { bIsChecked = value; }
        }

        public Transform Agent
        {
            get
            {
                return agent;
            }
        }

        //Called only the first time the action is executed and before anything else.
        ///Override in Tasks. This is called after a NEW agent is set, after initialization and before execution
        ///Return null if everything is ok, or a string with the error if not. 
        protected override string OnInit()
        {
            if (onInit == null)
            {
                onInit = LuaSvr.mainState.getFunction("pkgAIManager.OnConditionInit");
                onCheck = LuaSvr.mainState.getFunction("pkgAIManager.OnConditionCheck");
            }

            callLuaInit();

            return null;
        }

        //call lua init function
        protected virtual void callLuaInit()
        {
            onInit.call(this, luaClsName);
        }

        //call lua onCheck function
        protected virtual void callLuaOnCheck()
        {
            onCheck.call(this);
        }

        protected override bool OnCheck()
        {
            callLuaOnCheck();
            return isChecked;
        }

        protected override string info
        {
            get
            {
                var attrs = this.GetType().GetCustomAttributes(true);
                foreach (var attr in attrs)
                {
                    if (attr.GetType() == typeof(NameAttribute))
                    {
                        return ((NameAttribute)attr).name;
                    }
                }
                if (luaClsName == null || luaClsName == null) return base.info;
                else return luaClsName;
            }
        }
    }
}
