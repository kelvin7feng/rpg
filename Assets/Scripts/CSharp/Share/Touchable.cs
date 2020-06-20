// file Touchable.cs
// Correctly backfills the missing Touchable concept in Unity.UI's OO chain.
//http://answers.unity3d.com/questions/801928/46-ui-making-a-button-transparent.html?childToView=851816#answer-851816

using UnityEngine;
using UnityEngine.UI;
#if UNITY_EDITOR
using UnityEditor;

[CustomEditor(typeof(Touchable))]
public class Touchable_Editor : Editor
{
    public override void OnInspectorGUI() { }
}
#endif
public class Touchable : Text
{
    protected override void Awake()
    {
        base.Awake();
    }
}