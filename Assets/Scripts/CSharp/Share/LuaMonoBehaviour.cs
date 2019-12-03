using UnityEngine;
using SLua;

namespace KG
{
	[CustomLuaClass]
	public class LuaMonoBehaviour : MonoBehaviour {

		public string luaTableName;
		private enum BehaviourType:int{
			Awake = 0,
			Start,
			Update,
			LateUpdate,
			FixedUpdate,
			OnDisable,
			OnGUI,
			OnDestroy,
			OnClick,
			OnTriggerEnter,
			OnTriggerExit,
			OnTriggerStay,
			OnApplicationPause,
			OnApplicationQuit,
			OnValidate,
			Max,
		}

		private LuaFunction[] functions;

		protected void Init(){
			InitBaseFunctions ();
			Awake ();
		}

		protected void InitBaseFunctions(){
			if (functions == null || functions.Length <= 0) {
				functions = new LuaFunction[(int)BehaviourType.Max];
			}

			if (LuaSvr.mainState == null) {
				return;
			}

			var luaTable = LuaSvr.mainState.getTable (luaTableName);
			if (luaTable == null) {
				Debug.LogError ("LuaMonoBehaviour.Init can not find tbale:" + luaTableName);
				return;
			}

			for (int i = 0; i < (int)BehaviourType.Max; i++) {
				string behaviourName = ((BehaviourType)i).ToString ();
				functions [i] = (LuaFunction)luaTable [behaviourName];
			}
		}

		public static LuaMonoBehaviour Bind(GameObject targetObject, string tableName){
			if (targetObject == null)
				return null;

			var luaMono = targetObject.AddComponent<LuaMonoBehaviour> ();
			luaMono.luaTableName = tableName;
			luaMono.Init ();
			return luaMono;
		}

		private void Awake(){
			if (functions == null) {
				return;
			}

			if (functions [(int)BehaviourType.Awake] != null)
				functions [(int)BehaviourType.Awake].call (this.gameObject);
		}
				
		private void Start () {
			if (functions == null)
				return;
			
			if (functions [(int)BehaviourType.Start] != null)
				functions [(int)BehaviourType.Start].call (this.gameObject);
		}

		private void Update () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.Update] != null)
				functions [(int)BehaviourType.Update].call (this.gameObject);
		}

		private void LateUpdate () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.LateUpdate] != null)
				functions [(int)BehaviourType.LateUpdate].call (this.gameObject);
		}

		private void FixedUpdate () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.FixedUpdate] != null)
				functions [(int)BehaviourType.FixedUpdate].call (this.gameObject);
		}

		/*private void OnDisable () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnDisable] != null)
				functions [(int)BehaviourType.OnDisable].call (this.gameObject);
		}

		private void OnGUI () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnGUI] != null)
				functions [(int)BehaviourType.OnGUI].call (this.gameObject);
		}
			
		private void OnTriggerEnter () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnTriggerEnter] != null)
				functions [(int)BehaviourType.OnTriggerEnter].call (this.gameObject);
		}

		private void OnTriggerExit () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnTriggerExit] != null)
				functions [(int)BehaviourType.OnTriggerExit].call (this.gameObject);
		}

		private void OnTriggerStay () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnTriggerStay] != null)
				functions [(int)BehaviourType.OnTriggerStay].call (this.gameObject);
		}

		private void OnApplicationPause () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnApplicationPause] != null)
				functions [(int)BehaviourType.OnApplicationPause].call (this.gameObject);
		}

		private void OnApplicationQuit () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnApplicationQuit] != null)
				functions [(int)BehaviourType.OnApplicationQuit].call (this.gameObject);
		}

		private void OnValidate () {
			if (functions == null)
				return;

			if (functions [(int)BehaviourType.OnValidate] != null)
				functions [(int)BehaviourType.OnValidate].call (this.gameObject);
		}*/
	}
}