using UnityEngine;
using UnityEngine.AI;
using SLua;

namespace KG
{
    [CustomLuaClass]
    public class NavMeshSurfaceMgr : MonoBehaviour
    {
        public static NavMeshSurfaceMgr Instance;
        public enum AreaMask 
        {
            Walkable,
            NotWalkable,
        }

        public void Awake()
        {
            if (Instance != null && Instance != this)
            {
                SLua.Logger.LogError("inited twice");
                Destroy(this);
                return;
            }
            Instance = this;
        }

        public void SetObjectWalkable(GameObject go, bool walkable)
        {
            NavMeshModifierVolume navMeshModifierVolume  = go.GetComponent<NavMeshModifierVolume>();
            if (navMeshModifierVolume)
            {
                int areaMask = walkable ? (int)AreaMask.Walkable : (int)AreaMask.NotWalkable;
                navMeshModifierVolume.area = areaMask;
                UpdateModifierVolumn(go);
            }
        }

        public NavMeshSurface FindSurface(GameObject go)
        {
            NavMeshSurface surface = go.GetComponentInParent<NavMeshSurface>();
            return surface;
        }

        public void UpdateModifierVolumn(GameObject go)
        {
            NavMeshSurface surface = FindSurface(go);
            if (surface == null)
            {
                Debug.Log("can not find surface component in parents.");
                surface = (NavMeshSurface)FindObjectOfType(typeof(NavMeshSurface));
                if(surface == null)
                {
                    Debug.LogWarning("can not find any object with surface.");
                    return;
                }
                go.gameObject.transform.parent = surface.gameObject.transform;
            }
            
            surface.BuildNavMesh();
        }
    }
}