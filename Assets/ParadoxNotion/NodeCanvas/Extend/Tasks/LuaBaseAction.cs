using UnityEngine;
using NodeCanvas.Framework;
using SLua;
using ParadoxNotion.Design;

namespace KG
{
    [CustomLuaClass]
    abstract public class LuaBaseAction : ActionTask<Transform>
    {
        protected string luaClsName;
        protected static LuaFunction onInit = null;
        protected static LuaFunction onStop = null;
        protected static LuaFunction onPause = null;
        protected static LuaFunction onExecute = null;
        protected bool isEnded = false;
        protected bool isSuccess = false;
        protected bool isCalledEndAction = false;

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
                onInit = LuaSvr.mainState.getFunction("pkgAIManager.OnActionInit");
                onStop = LuaSvr.mainState.getFunction("pkgAIManager.OnActionStop");
                onPause = LuaSvr.mainState.getFunction("pkgAIManager.OnActionPause");
                onExecute = LuaSvr.mainState.getFunction("pkgAIManager.OnActionExecute");
            }

            callLuaInit();

            return null;
        }

        //call lua init function
        protected virtual void callLuaInit()
        {
            onInit.call(this, luaClsName);
        }

        //call lua onEnter function
        protected virtual void callLuaOnEnter()
        {
            onExecute.call(this);
        }

        //Called once when the action is executed.
        protected override void OnExecute()
        {
            isEnded = false;
            isCalledEndAction = false;
            callLuaOnEnter();
        }


        //Called every frame while the action is running.
        protected override void OnUpdate()
        {
            if (isEnded && !isCalledEndAction)
            {
                isCalledEndAction = true;
                EndAction(isSuccess);
            }
        }

        //Called when the action stops for any reason.
        //Either because you called EndAction or cause the action was interrupted.
        protected override void OnStop()
        {
            onStop.call(this);
        }

        //Called when the action is paused comonly when it was still running while the behaviour graph gets paused.
        protected override void OnPause()
        {
            onPause.call(this);
        }

        public void EndActionLua(bool bSuccess)
        {
            isEnded = true;
            isSuccess = bSuccess;
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
                if (luaClsName == null || luaClsName == "") return base.info;
                else return luaClsName;
            }
        }
    }
}

