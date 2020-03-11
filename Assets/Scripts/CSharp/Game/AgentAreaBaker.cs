using UnityEngine;
using UnityEngine.AI;
using SLua;

namespace KG{
    [CustomLuaClass]
    public class AgentAreaBaker : MonoBehaviour
    {
        public NavMeshSurface surface;
        public float volumeX = 200f;
        public float volumeY = 200f;
        public float volumeZ = 200f;
        public float voxelSize = 0.24f;
        public float distanceThreshold = 150f;

        void Awake()
        {
            surface = (NavMeshSurface)FindObjectOfType(typeof(NavMeshSurface));
            SetVolumn(volumeX, volumeY, volumeZ);
            SetVoxelSize(voxelSize);
            UpdateNavMesh();
        }

        void Update()
        {
            if (Vector3.Distance(transform.position, surface.center) >= distanceThreshold)
                UpdateNavMesh();
        }

        void UpdateNavMesh()
        {
            surface.RemoveData();
            surface.center = transform.position;
            surface.BuildNavMesh();
        }

        public void SetOverrideVoxelSize(bool overrideVoxelSize)
        {
            surface.overrideVoxelSize = overrideVoxelSize;
        }

        public void SetVoxelSize(float voxelSize)
        {
            surface.voxelSize = voxelSize;
            SetOverrideVoxelSize(true);
        }

        public void SetVolumn(float x, float y, float z)
        {
            volumeX = x;
            volumeY = y;
            volumeZ = z;
            surface.size = new Vector3(x, y, z);
        }

        public void SetDistanceThreshold(float distanceThreshold)
        {
            this.distanceThreshold = distanceThreshold;  
        }
    }
}