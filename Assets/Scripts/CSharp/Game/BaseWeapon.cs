using SLua;
using UnityEngine;

public class BaseWeapon : MonoBehaviour
{
    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            LuaFunction callback = LuaSvr.mainState.getFunction("pkgSysPlayer.OnHitPlayer");
            if (callback != null)
            {
                PlayerController playerCtrl = gameObject.GetComponentInParent<PlayerController>();
                if (playerCtrl)
                {
                    int playerId = playerCtrl.GetPlayerId();
                    callback.call(playerId, this);
                }
            }
        }
    }

    void OnTriggerExit(Collider other)
    {
        
    }
}
