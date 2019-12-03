using NodeCanvas.Framework;
using SLua;

namespace KG
{
    [CustomLuaClassAttribute]
    public class LuaAction : LuaBaseAction
    {
        public BBParameter<string> strLuaCls;

        protected override void callLuaInit()
        {
            onInit.call(this, strLuaCls.value);
        }

        protected override string info
        {
            get
            {
                if (strLuaCls == null || strLuaCls.value == null) return base.info;
                else return strLuaCls.value;
            }
        }
    }
}

