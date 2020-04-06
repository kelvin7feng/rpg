using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace ESRemoteDeviceDebug
{

    public static class CustomUpdatePropertyUtility
    {
        public static void AddCustomUpdateProperty()
        {
            UpdatePropertyUtility.AddUpdatePropertyDelegate(typeof(ParticleSystem), UpdateParticleSystemProperty);
        }

        #region ParticleSystem

        static void UpdateParticleSystemProperty(Component component, ChangeData data)
        {
            ParticleSystem particleSystem = component as ParticleSystem;

            bool isPlaying = particleSystem.isPlaying;
            if (isPlaying)
                particleSystem.Pause();

            switch (data.propertyName)
            {
                case "main":
                    UpdateParticleSystemMainProperty(particleSystem, data);
                    break;
                case "velocityOverLifetime":
                    UpdateParticleSystemVelocityProperty(particleSystem, data);
                    break;
                default:
                    UpdatePropertyUtility.CommonUpdateProperty(component, data);
                    break;
            }

            if (isPlaying)
                particleSystem.Play();
        }

        static void UpdateParticleSystemMainProperty(ParticleSystem particleSystem, ChangeData data)
        {
            ParticleSystem.MainModule main = particleSystem.main;

            JObject obj = JsonConvert.DeserializeObject<JObject>(data.StringValue, ChangeData.CUSTOM_JSON_CONVERTS);

            main.duration = obj["duration"].Value<float>();
            main.loop = obj["loop"].Value<bool>();
            main.prewarm = obj["prewarm"].Value<bool>();

            main.startDelay = obj["startDelay"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startLifetime = obj["startLifetime"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSpeed = obj["startSpeed"].ToObject<ParticleSystem.MinMaxCurve>();

            main.startSize3D = obj["startSize3D"].Value<bool>();
            main.startSize = obj["startSize"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSizeX = obj["startSizeX"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSizeY = obj["startSizeY"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startSizeZ = obj["startSizeZ"].ToObject<ParticleSystem.MinMaxCurve>();

            main.startRotation3D = obj["startRotation3D"].Value<bool>();
            main.startRotation = obj["startRotation"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startRotationX = obj["startRotationX"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startRotationY = obj["startRotationY"].ToObject<ParticleSystem.MinMaxCurve>();
            main.startRotationZ = obj["startRotationZ"].ToObject<ParticleSystem.MinMaxCurve>();

            main.flipRotation = obj["flipRotation"].Value<float>();

            main.startColor = obj["startColor"].ToObject<ParticleSystem.MinMaxGradient>();
            main.gravityModifier = obj["gravityModifier"].ToObject<ParticleSystem.MinMaxCurve>();

            main.simulationSpace = (ParticleSystemSimulationSpace)obj["simulationSpace"].Value<int>();
            main.simulationSpeed = obj["simulationSpeed"].Value<float>();

            main.useUnscaledTime = obj["useUnscaledTime"].Value<bool>();

            main.scalingMode = (ParticleSystemScalingMode)obj["scalingMode"].Value<int>();
            main.playOnAwake = obj["playOnAwake"].Value<bool>();

            main.emitterVelocityMode = (ParticleSystemEmitterVelocityMode)obj["emitterVelocityMode"].Value<int>();
            main.maxParticles = obj["maxParticles"].Value<int>();

            main.stopAction = (ParticleSystemStopAction)obj["stopAction"].Value<int>();
        }

        static void UpdateParticleSystemVelocityProperty(ParticleSystem particleSystem, ChangeData data)
        {
            ParticleSystem.VelocityOverLifetimeModule velocity = particleSystem.velocityOverLifetime;

            JObject obj = JsonConvert.DeserializeObject<JObject>(data.StringValue, ChangeData.CUSTOM_JSON_CONVERTS);

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
    }
}

