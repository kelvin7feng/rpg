using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace ESRemoteDeviceDebug
{
    public class ParticleSystemElement : BaseComponentElement, IComponentDraw
    {
        const string c_Name = "TempParticleSystem";
        ParticleSystem particleSystem;

        bool m_HasChange = false;

        bool[] m_FoldoutArray = { false, false, false };

        static int[] s_ParticleSystemCurveModeIndexArray = (int[])Enum.GetValues(typeof(ParticleSystemCurveMode));
        static string[] s_ParticleSystemCurveModeIndexNameArray = Enum.GetNames(typeof(ParticleSystemCurveMode));

        static int[] s_ParticleSystemGradientModeIndexArray = (int[])Enum.GetValues(typeof(ParticleSystemGradientMode));
        static string[] s_ParticleSystemGradientModeIndexNameArray = Enum.GetNames(typeof(ParticleSystemGradientMode));

        static Rect s_SignRange = new Rect(0, -1, 1, 2);
        static Rect s_UnsignRange = new Rect(0, 0, 1, 1);

        string m_CustomSimulationSpace;

        public ParticleSystemElement(int componentInstanceId, InspectorView inspectorView) : base(componentInstanceId, inspectorView)
        {
            particleSystem = (ParticleSystem)GetTempComponent(c_Name, typeof(ParticleSystem));
            InitParticleSystem();
        }

        public void Draw()
        {
            StartDraw();

            m_ColorIndex = 0;

            if (m_IsFoldout)
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    DrawMainModule();
                    DrawVelocityModule();
                }
            }

            EndDraw();
        }

        #region InitParticleSystem

        void InitParticleSystem()
        {
            InitMainModule();
            InitVelocityModule();
        }

        #region InitMainModule

        void InitMainModule()
        {
            var main = particleSystem.main;

            ChangeData mainData = GetChangeData("main");
            JObject obj = JsonConvert.DeserializeObject<JObject>(mainData.StringValue, ChangeData.CUSTOM_JSON_CONVERTS);

            main.duration = obj["duration"].Value<float>();
            main.loop = obj["loop"].Value<bool>();
            main.prewarm = obj["prewarm"].Value<bool>();

            main.startDelay = obj["startDelay"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startDelayMultiplier = obj["startDelayMultiplier"].Value<float>();

            main.startLifetime = obj["startLifetime"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startLifetimeMultiplier = obj["startLifetimeMultiplier"].Value<float>();

            main.startSpeed = obj["startSpeed"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSpeedMultiplier = obj["startSpeedMultiplier"].Value<float>();

            main.startSize3D = obj["startSize3D"].Value<bool>();
            main.startSize = obj["startSize"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSizeMultiplier = obj["startSizeMultiplier"].Value<float>();

            main.startRotation3D = obj["startRotation3D"].Value<bool>();
            main.startRotation = obj["startRotation"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startRotationMultiplier = obj["startRotationMultiplier"].Value<float>();

            main.flipRotation = obj["flipRotation"].Value<float>();

            main.startColor = obj["startColor"].ToObject<ParticleSystem.MinMaxGradient>();
            main.gravityModifier = obj["gravityModifier"].ToObject<ParticleSystem.MinMaxCurve>();
            main.gravityModifierMultiplier = obj["gravityModifierMultiplier"].Value<float>();

            main.simulationSpace = (ParticleSystemSimulationSpace)obj["simulationSpace"].Value<int>();
            m_CustomSimulationSpace = obj["customSimulationSpace"].Value<string>();

            main.simulationSpeed = obj["simulationSpeed"].Value<float>();

            main.useUnscaledTime = obj["useUnscaledTime"].Value<bool>();

            main.scalingMode = (ParticleSystemScalingMode)obj["scalingMode"].Value<int>();
            main.playOnAwake = obj["playOnAwake"].Value<bool>();

            main.emitterVelocityMode = (ParticleSystemEmitterVelocityMode)obj["emitterVelocityMode"].Value<int>();
            main.maxParticles = obj["maxParticles"].Value<int>();

            main.stopAction = (ParticleSystemStopAction)obj["stopAction"].Value<int>();
        }

        #endregion

        #region InitVelocityModule

        void InitVelocityModule()
        {
            var velocity = particleSystem.velocityOverLifetime;

            ChangeData velocityOverLifetimeData = GetChangeData("velocityOverLifetime");
            JObject obj = JsonConvert.DeserializeObject<JObject>(velocityOverLifetimeData.StringValue, ChangeData.CUSTOM_JSON_CONVERTS);

            velocity.enabled = obj["enabled"].Value<bool>();
            velocity.x = obj["x"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.y = obj["y"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.z = obj["z"].ToObject<ParticleSystem.MinMaxCurve>();

            velocity.space = (ParticleSystemSimulationSpace)obj["space"].Value<int>();

            velocity.orbitalX = obj["orbitalX"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.orbitalY = obj["orbitalY"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.orbitalZ = obj["orbitalZ"].ToObject<ParticleSystem.MinMaxCurve>();

            velocity.orbitalOffsetX = obj["orbitalOffsetX"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.orbitalOffsetY = obj["orbitalOffsetY"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.orbitalOffsetZ = obj["orbitalOffsetZ"].ToObject<ParticleSystem.MinMaxCurve>();

            velocity.radial = obj["radial"].ToObject<ParticleSystem.MinMaxCurve>();
            velocity.speedModifier = obj["speedModifier"].ToObject<ParticleSystem.MinMaxCurve>();
        }

        #endregion

        #endregion

        #region DrawProperty

        uint m_ColorIndex = 0;

        Color GetCurveColor()
        {
            Color color;
            switch (m_ColorIndex)
            {
                case 0:
                    color = Color.red;
                    break;
                case 1:
                    color = Color.green;
                    break;
                case 2:
                    color = Color.yellow;
                    break;
                case 3:
                    color = Color.blue;
                    break;
                case 4:
                    color = Color.cyan;
                    break;
                case 5:
                    color = Color.magenta;
                    break;
                default:
                    m_ColorIndex = 0;
                    color = Color.red;
                    break;
            }

            m_ColorIndex++;
            return color;
        }

        ParticleSystem.MinMaxCurve DrawMinMaxCurve(string label, ParticleSystem.MinMaxCurve value, Rect range, float factor = 1, int[] indexArray = null, string[] indexNameArray = null)
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;

            rect.width = EditorGUIUtility.labelWidth;
            EditorGUI.LabelField(rect, label);

            int level = EditorGUI.indentLevel;
            EditorGUI.indentLevel = 0;

            float modeWidth = 16;

            rect.x = EditorGUIUtility.labelWidth;
            rect.width = DrawPosition.width - rect.x - modeWidth;

            float old = EditorGUIUtility.labelWidth;

            string minTitle = "Min";
            string maxTitle = "Max";

            float maxWidth = ESGUIHelper.CalcSize(maxTitle).x;

            switch (value.mode)
            {
                case ParticleSystemCurveMode.Constant:
                    EditorGUIUtility.labelWidth = 4;
                    value.constant = EditorGUI.FloatField(rect, " ", value.constant * factor) / factor;
                    break;
                case ParticleSystemCurveMode.Curve:
                    rect.x += 4;
                    rect.width -= 4;
                    value.curve = EditorGUI.CurveField(rect, value.curve, GetCurveColor(), range);
                    break;
                case ParticleSystemCurveMode.TwoCurves:
                    EditorGUIUtility.labelWidth = maxWidth;
                    Color color = GetCurveColor();
                    value.curveMin = EditorGUI.CurveField(rect, minTitle, value.curveMin, color, range);

                    Rect minRect = rect;
                    minRect.y = minRect.yMax + m_Space;
                    m_LineCount++;
                    rect.y = rect.yMax + m_Space;

                    value.curveMax = EditorGUI.CurveField(minRect, maxTitle, value.curveMax, color, range);
                    break;
                case ParticleSystemCurveMode.TwoConstants:
                    rect.width /= 2;
                    EditorGUIUtility.labelWidth = maxWidth;

                    value.constantMin = EditorGUI.FloatField(rect, minTitle, value.constantMin * factor) / factor;

                    rect.x += rect.width;
                    value.constantMax = EditorGUI.FloatField(rect, maxTitle, value.constantMax * factor) / factor;
                    break;
            }
            EditorGUIUtility.labelWidth = old;

            rect.x += rect.width + 4;
            rect.width = modeWidth;

            if (indexArray == null)
                indexArray = s_ParticleSystemCurveModeIndexArray;

            if (indexNameArray == null)
                indexNameArray = s_ParticleSystemCurveModeIndexNameArray;

            value.mode = (ParticleSystemCurveMode)EditorGUI.IntPopup(rect, (int)value.mode, indexNameArray, indexArray, "MiniPullDown");

            EditorGUI.indentLevel = level;

            m_LineCount++;
            DrawPosition.y = rect.yMax + m_Space;
            return value;
        }

        static MethodInfo s_GradientField;
        static MethodInfo GradientField
        {
            get
            {
                if (s_GradientField == null)
                {
                    Type type = typeof(EditorGUI);
                    Type gradientType = typeof(Gradient);
                    foreach (var method in type.GetMethods(BindingFlags.Static | BindingFlags.NonPublic))
                    {
                        if (!method.IsStatic)
                            continue;

                        if (method.ReturnType != gradientType)
                            continue;

                        if (method.Name != "GradientField")
                            continue;

                        ParameterInfo[] parameterInfos = method.GetParameters();
                        if (parameterInfos.Length != 2)
                            continue;

                        if (parameterInfos[0].ParameterType != typeof(Rect))
                            continue;

                        if (parameterInfos[1].ParameterType != gradientType)
                            continue;

                        s_GradientField = method;
                        break;
                    }
                }

                return s_GradientField;
            }
        }

        static MethodInfo s_GradientFieldLabel;
        static MethodInfo GradientFieldLabel
        {
            get
            {
                if (s_GradientFieldLabel == null)
                {
                    Type type = typeof(EditorGUI);
                    Type gradientType = typeof(Gradient);
                    foreach (var method in type.GetMethods(BindingFlags.Static | BindingFlags.NonPublic))
                    {
                        if (!method.IsStatic)
                            continue;

                        if (method.ReturnType != gradientType)
                            continue;

                        if (method.Name != "GradientField")
                            continue;

                        ParameterInfo[] parameterInfos = method.GetParameters();
                        if (parameterInfos.Length != 3)
                            continue;

                        if (parameterInfos[0].ParameterType != typeof(string))
                            continue;

                        if (parameterInfos[1].ParameterType != typeof(Rect))
                            continue;

                        if (parameterInfos[2].ParameterType != gradientType)
                            continue;

                        s_GradientFieldLabel = method;
                        break;
                    }
                }

                return s_GradientFieldLabel;
            }
        }

        ParticleSystem.MinMaxGradient DrawMinMaxGradient(string label, ParticleSystem.MinMaxGradient value, int[] indexArray = null, string[] indexNameArray = null)
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;

            rect.width = EditorGUIUtility.labelWidth;
            EditorGUI.LabelField(rect, label);

            int level = EditorGUI.indentLevel;
            EditorGUI.indentLevel = 0;

            float modeWidth = 16;

            rect.x = EditorGUIUtility.labelWidth + 4;
            rect.width = DrawPosition.width - rect.x - modeWidth;

            string minTitle = "Min";
            string maxTitle = "Max";

            float maxWidth = ESGUIHelper.CalcSize(maxTitle).x;

            float old = EditorGUIUtility.labelWidth;
            switch (value.mode)
            {
                case ParticleSystemGradientMode.Color:
                    value.color = EditorGUI.ColorField(rect, value.color);
                    break;
                case ParticleSystemGradientMode.RandomColor:
                case ParticleSystemGradientMode.Gradient:
                    EditorGUIUtility.labelWidth = 4;

                    if (value.gradientMax == null)
                        value.gradientMax = new Gradient();

                    value.gradientMax = (Gradient)GradientField.Invoke(null, new object[] { rect, value.gradientMax });

                    break;
                case ParticleSystemGradientMode.TwoColors:
                    EditorGUIUtility.labelWidth = maxWidth;
                    value.colorMin = EditorGUI.ColorField(rect, minTitle, value.colorMin);

                    Rect minRect = rect;
                    minRect.y = minRect.yMax + m_Space;
                    m_LineCount++;
                    rect.y = rect.yMax + m_Space;

                    value.colorMax = EditorGUI.ColorField(minRect, maxTitle, value.colorMax);
                    break;
                case ParticleSystemGradientMode.TwoGradients:
                    EditorGUIUtility.labelWidth = maxWidth;
                    value.gradientMin = (Gradient)GradientFieldLabel.Invoke(null, new object[] { minTitle, rect, value.gradientMin });

                    minRect = rect;
                    minRect.y = minRect.yMax + m_Space;
                    m_LineCount++;
                    rect.y = rect.yMax + m_Space;

                    value.gradientMax = (Gradient)GradientFieldLabel.Invoke(null, new object[] { maxTitle, minRect, value.gradientMax });
                    break;
            }

            EditorGUIUtility.labelWidth = old;

            rect.x += rect.width + 4;
            rect.width = modeWidth;

            if (indexArray == null)
                indexArray = s_ParticleSystemGradientModeIndexArray;

            if (indexNameArray == null)
                indexNameArray = s_ParticleSystemGradientModeIndexNameArray;

            value.mode = (ParticleSystemGradientMode)EditorGUI.IntPopup(rect, (int)value.mode, indexNameArray, indexArray, "MiniPullDown");

            EditorGUI.indentLevel = level;

            m_LineCount++;
            DrawPosition.y = rect.yMax + m_Space;
            return value;
        }

        bool DrawEnableFoldout(string label, int foldoutIndex, bool enabled)
        {
            Rect rect = DrawPosition;
            rect.height = LINE_HEIGHT;

            m_LineCount++;

            rect.width = FOLDOUT_INDENT + EditorGUI.indentLevel * 15;
            m_FoldoutArray[foldoutIndex] = EditorGUI.Foldout(rect, m_FoldoutArray[foldoutIndex], "");

            rect.x += rect.width;
            rect.width = DrawPosition.width - (rect.x - DrawPosition.x);

            DrawPosition.y = rect.yMax + m_Space;

            return GUI.Toggle(rect, enabled, label);
        }

        bool DrawBoolAsPopup(string label, bool value, string[] nameArray)
        {
            int newInt = DrawPopup(label, value ? 1 : 0, nameArray);
            return newInt == 1;
        }

        #endregion

        #region Equal

        bool IsEqualMinMaxCurve(ParticleSystem.MinMaxCurve a, ParticleSystem.MinMaxCurve b)
        {
            return (a.mode == b.mode
                && a.constantMax == b.constantMax
                && a.constantMin == b.constantMin
                && a.curveMultiplier == b.curveMultiplier
                && IsEqualAnimationCurve(a.curveMax, b.curveMax)
                && IsEqualAnimationCurve(a.curveMin, b.curveMin));
        }

        bool IsEqualMinMaxGradient(ParticleSystem.MinMaxGradient a, ParticleSystem.MinMaxGradient b)
        {
            return (a.mode == b.mode
                && a.colorMax.Equals(b.colorMax)
                && a.colorMin.Equals(b.colorMin)
                && IsEqualGradient(a.gradientMax, b.gradientMax)
                && IsEqualGradient(a.gradientMin, b.gradientMin));
        }

        #endregion

        #region Draw ParticleSystem Module

        #region DrawMainModule

        void DrawMainModule()
        {
            var mainModule = particleSystem.main;

            m_FoldoutArray[0] = DrawFoldout("Main", m_FoldoutArray[0]);
            if (!m_FoldoutArray[0])
                return;

            float newFloat;
            bool newBool;
            int newInt;
            ParticleSystem.MinMaxCurve newMinMaxCurve;
            ParticleSystem.MinMaxGradient newMinMaxGradient;

            using (new EditorGUI.IndentLevelScope())
            {
                newFloat = DrawFloatField("Duration", mainModule.duration);
                if (newFloat != mainModule.duration)
                {
                    m_HasChange = true;
                    mainModule.duration = newFloat;
                }

                newBool = DrawToggle("Looping", mainModule.loop);
                if (newBool != mainModule.loop)
                {
                    m_HasChange = true;
                    mainModule.loop = newBool;
                }

                using (new EditorGUI.DisabledScope(!mainModule.loop))
                {
                    newBool = DrawToggle("Prewarm", mainModule.prewarm);
                    if (newBool != mainModule.prewarm)
                    {
                        m_HasChange = true;
                        mainModule.prewarm = newBool;
                    }
                }

                using (new EditorGUI.DisabledScope(mainModule.prewarm && mainModule.loop))
                {
                    newMinMaxCurve = DrawMinMaxCurve("Start Delay", mainModule.startDelay, new Rect(), 1,
                        new int[]{
                        s_ParticleSystemCurveModeIndexArray[0], s_ParticleSystemCurveModeIndexArray[3]
                    }, new string[]{
                        s_ParticleSystemCurveModeIndexNameArray[0], s_ParticleSystemCurveModeIndexNameArray[3]
                    });
                    if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startDelay))
                    {
                        m_HasChange = true;
                        mainModule.startDelay = newMinMaxCurve;
                    }
                }

                newMinMaxCurve = DrawMinMaxCurve("StartLifetime", mainModule.startLifetime, s_UnsignRange);
                if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startLifetime))
                {
                    m_HasChange = true;
                    mainModule.startLifetime = newMinMaxCurve;
                }

                newMinMaxCurve = DrawMinMaxCurve("Start Speed", mainModule.startSpeed, s_SignRange);
                if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startSpeed))
                {
                    m_HasChange = true;
                    mainModule.startSpeed = newMinMaxCurve;
                }

                newBool = DrawToggle("3D Start Size", mainModule.startSize3D);
                if (newBool != mainModule.startSize3D)
                {
                    m_HasChange = true;
                    mainModule.startSize3D = newBool;
                }

                if (!mainModule.startSize3D)
                {
                    newMinMaxCurve = DrawMinMaxCurve("Start Size", mainModule.startSize, s_UnsignRange);
                    if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startSize))
                    {
                        m_HasChange = true;
                        mainModule.startSize = newMinMaxCurve;
                    }
                }
                else
                {
                    using (new EditorGUI.IndentLevelScope())
                    {
                        newMinMaxCurve = DrawMinMaxCurve("Start Size X", mainModule.startSizeX, s_UnsignRange);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startSizeX))
                        {
                            m_HasChange = true;
                            mainModule.startSizeX = newMinMaxCurve;
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Start Size Y", mainModule.startSizeY, s_UnsignRange);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startSizeY))
                        {
                            m_HasChange = true;
                            mainModule.startSizeY = newMinMaxCurve;
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Start Size Z", mainModule.startSizeZ, s_UnsignRange);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startSizeZ))
                        {
                            m_HasChange = true;
                            mainModule.startSizeZ = newMinMaxCurve;
                        }
                    }
                }

                newBool = DrawToggle("3D Start Rotation", mainModule.startRotation3D);
                if (newBool != mainModule.startRotation3D)
                {
                    m_HasChange = true;
                    mainModule.startRotation3D = newBool;
                }

                if (!mainModule.startRotation3D)
                {
                    newMinMaxCurve = DrawMinMaxCurve("Start Rotation", mainModule.startRotation, s_SignRange, Mathf.Rad2Deg);
                    if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startRotation))
                    {
                        m_HasChange = true;
                        mainModule.startRotation = newMinMaxCurve;
                    }
                }
                else
                {
                    using (new EditorGUI.IndentLevelScope())
                    {
                        newMinMaxCurve = DrawMinMaxCurve("Start Rotation X", mainModule.startRotationX, s_SignRange, Mathf.Rad2Deg);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startRotationX))
                        {
                            m_HasChange = true;
                            mainModule.startRotationX = newMinMaxCurve;
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Start Rotation Y", mainModule.startRotationY, s_SignRange, Mathf.Rad2Deg);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startRotationY))
                        {
                            m_HasChange = true;
                            mainModule.startRotationY = newMinMaxCurve;
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Start Rotation Z", mainModule.startRotationZ, s_SignRange, Mathf.Rad2Deg);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.startRotationZ))
                        {
                            m_HasChange = true;
                            mainModule.startRotationZ = newMinMaxCurve;
                        }
                    }
                }

                newFloat = DrawFloatField("Flip Rotation", mainModule.flipRotation);
                if (!newFloat.Equals(mainModule.flipRotation))
                {
                    m_HasChange = true;
                    mainModule.flipRotation = newFloat;
                }

                newMinMaxGradient = DrawMinMaxGradient("Start Color", mainModule.startColor);
                if (!IsEqualMinMaxGradient(newMinMaxGradient, mainModule.startColor))
                {
                    m_HasChange = true;
                    mainModule.startColor = newMinMaxGradient;
                }

                newMinMaxCurve = DrawMinMaxCurve("Gravity Modifier", mainModule.gravityModifier, s_SignRange);
                if (!IsEqualMinMaxCurve(newMinMaxCurve, mainModule.gravityModifier))
                {
                    m_HasChange = true;
                    mainModule.gravityModifier = newMinMaxCurve;
                }

                newInt = DrawEnumPopup("Simulation Space", (int)mainModule.simulationSpace, typeof(ParticleSystemSimulationSpace));
                if (newInt != (int)mainModule.simulationSpace)
                {
                    m_HasChange = true;
                    mainModule.simulationSpace = (ParticleSystemSimulationSpace)newInt;
                }

                if (mainModule.simulationSpace == ParticleSystemSimulationSpace.Custom)
                {
                    using (new EditorGUI.DisabledGroupScope(true))
                    {
                        DrawTextField("Custom Simulation Space", m_CustomSimulationSpace);
                    }
                }

                newFloat = DrawFloatField("Simulation Speed", mainModule.simulationSpeed);
                if (!newFloat.Equals(mainModule.simulationSpeed))
                {
                    m_HasChange = true;
                    mainModule.simulationSpeed = newFloat;
                }

                newBool = DrawBoolAsPopup("Delta Time", mainModule.useUnscaledTime, new string[] { "Scaled", "Unscaled" });
                if (newBool != mainModule.useUnscaledTime)
                {
                    m_HasChange = true;
                    mainModule.useUnscaledTime = newBool;
                }

                // TODO
                newInt = DrawEnumPopup("Scaling Mode", (int)mainModule.scalingMode, typeof(ParticleSystemScalingMode));
                if (newInt != (int)mainModule.scalingMode)
                {
                    m_HasChange = true;
                    mainModule.scalingMode = (ParticleSystemScalingMode)newInt;
                }

                newBool = DrawToggle("Play On Awake*", mainModule.playOnAwake);
                if (newBool != mainModule.playOnAwake)
                {
                    m_HasChange = true;
                    mainModule.playOnAwake = newBool;
                }

                newInt = DrawEnumPopup("Emitter Velocity", (int)mainModule.emitterVelocityMode, typeof(ParticleSystemEmitterVelocityMode));
                if (newInt != (int)mainModule.emitterVelocityMode)
                {
                    m_HasChange = true;
                    mainModule.emitterVelocityMode = (ParticleSystemEmitterVelocityMode)newInt;
                }

                newInt = DrawIntField("Max Particles", mainModule.maxParticles);
                if (newInt != mainModule.maxParticles)
                {
                    m_HasChange = true;
                    mainModule.maxParticles = newInt;
                }

                ChangeData useAutoRandomSeedData = GetChangeData("useAutoRandomSeed");
                DrawProperty(GetChangeData("useAutoRandomSeed"));

                if (!useAutoRandomSeedData.BoolValue)
                    DrawProperty(GetChangeData("randomSeed"));

                newInt = DrawEnumPopup("Stop Action", (int)mainModule.stopAction, typeof(ParticleSystemStopAction));
                if (newInt != (int)mainModule.stopAction)
                {
                    m_HasChange = true;
                    mainModule.stopAction = (ParticleSystemStopAction)newInt;
                }
            }

            if (m_HasChange)
            {
                m_HasChange = false;
                ChangeData data = GetChangeData("main");
                data.StringValue = JsonConvert.SerializeObject(particleSystem.main, ChangeData.CUSTOM_JSON_CONVERTS);
                UpdateProperty(data);
            }
        }

        #endregion

        #region DrawVelocityModule

        static readonly string[] s_VelocitySpace = { ParticleSystemSimulationSpace.Local.ToString(), ParticleSystemSimulationSpace.World.ToString() };

        void DrawVelocityModule()
        {
            var velocityModule = particleSystem.velocityOverLifetime;

            bool newBool;
            int newInt;
            ParticleSystem.MinMaxCurve newMinMaxCurve;

            newBool = DrawEnableFoldout("Velocity Over Lifetime", 2, velocityModule.enabled);
            if (newBool != velocityModule.enabled)
            {
                m_HasChange = true;
                velocityModule.enabled = newBool;
            }

            using (new EditorGUI.DisabledGroupScope(!velocityModule.enabled))
            {
                using (new EditorGUI.IndentLevelScope())
                {
                    if (m_FoldoutArray[2])
                    {
                        DrawLabelField("Linear");
                        using (new EditorGUI.IndentLevelScope())
                        {
                            newMinMaxCurve = DrawMinMaxCurve("X", velocityModule.x, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.x))
                            {
                                m_HasChange = true;
                                velocityModule.x = newMinMaxCurve;
                            }

                            newMinMaxCurve = DrawMinMaxCurve("Y", velocityModule.y, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.y))
                            {
                                m_HasChange = true;
                                velocityModule.y = newMinMaxCurve;
                            }

                            newMinMaxCurve = DrawMinMaxCurve("Z", velocityModule.z, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.z))
                            {
                                m_HasChange = true;
                                velocityModule.z = newMinMaxCurve;
                            }
                        }

                        newInt = DrawPopup("Space", (int)velocityModule.space, s_VelocitySpace);
                        if (newInt != (int)velocityModule.space)
                        {
                            m_HasChange = true;
                            velocityModule.space = (ParticleSystemSimulationSpace)newInt;
                        }

                        DrawLabelField("Orbital");
                        using (new EditorGUI.IndentLevelScope())
                        {
                            newMinMaxCurve = DrawMinMaxCurve("X", velocityModule.orbitalX, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.orbitalX))
                            {
                                m_HasChange = true;
                                velocityModule.orbitalX = newMinMaxCurve;
                            }

                            newMinMaxCurve = DrawMinMaxCurve("Y", velocityModule.orbitalY, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.orbitalY))
                            {
                                m_HasChange = true;
                                velocityModule.orbitalY = newMinMaxCurve;
                            }

                            newMinMaxCurve = DrawMinMaxCurve("Z", velocityModule.orbitalZ, s_SignRange);
                            if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.orbitalZ))
                            {
                                m_HasChange = true;
                                velocityModule.orbitalZ = newMinMaxCurve;
                            }
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Radial", velocityModule.radial, s_SignRange);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.radial))
                        {
                            m_HasChange = true;
                            velocityModule.radial = newMinMaxCurve;
                        }

                        newMinMaxCurve = DrawMinMaxCurve("Speed Modifier", velocityModule.speedModifier, s_SignRange);
                        if (!IsEqualMinMaxCurve(newMinMaxCurve, velocityModule.speedModifier))
                        {
                            m_HasChange = true;
                            velocityModule.speedModifier = newMinMaxCurve;
                        }
                    }
                }
            }

            if (m_HasChange)
            {
                m_HasChange = false;
                ChangeData data = GetChangeData("velocityOverLifetime");
                data.StringValue = JsonConvert.SerializeObject(particleSystem.velocityOverLifetime, ChangeData.CUSTOM_JSON_CONVERTS);
                UpdateProperty(data);
            }
        }

        #endregion

        #endregion
    }
}

