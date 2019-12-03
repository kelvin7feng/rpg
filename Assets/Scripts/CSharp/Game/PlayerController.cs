using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using SLua;

[CustomLuaClass]
public class PlayerController : MonoBehaviour
{
    private int playerId = 0;
    public LayerMask movementMask;
    public Animator animator;
    public float moveSpeed = 5.0f;
    Camera cam;
    PlayerMotor motor;
    Vector3 destination = Vector3.zero;
    bool isMoving = false;

    #region Debug
    public float lookRadius = 0f;
    #endregion

    void Start()
    {
        cam = Camera.main;
        motor = GetComponent<PlayerMotor>();
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        if (destination != Vector3.zero)
            MoveToDestination(destination);

        if(isMoving && motor.IsArrived())
        {
            OnNavMeshAgentStop();
        }
    }

    public void SetMoveSpeed(float speed)
    {
        moveSpeed = speed;
    }

    public void SetDestination(float x, float y, float z)
    {
        destination.x = x;
        destination.y = y;
        destination.z = z;
    }

    public void MoveToDestination(Vector3 pos)
    {
        if(!isMoving)
            isMoving = true;

        motor.MoveToPoint(pos, moveSpeed);
    }

    public void Stop()
    {
        isMoving = false;
        destination = Vector3.zero;
        motor.Stop();
    }

    public void SetPlayerId(int id)
    {
        playerId = id;
    }

    public int GetPlayerId()
    {
        return playerId;
    }

    public void OnAnimationCallback(string parameter)
    {
        LuaFunction callback = LuaSvr.mainState.getFunction("pkgFSMManger.OnAnimationCallback");
        if (callback != null)
        {
            callback.call(playerId, parameter);
        }
    }

    public void OnNavMeshAgentStop()
    {
        LuaFunction callback = LuaSvr.mainState.getFunction("pkgSysPlayer.OnNavMeshAgentStop");
        if (callback != null)
        {
            callback.call(playerId);
        }
    }

    public void OnDrawGizmosSelected()
    {
        if (lookRadius > 0)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(transform.position, lookRadius);
        }
    }
}