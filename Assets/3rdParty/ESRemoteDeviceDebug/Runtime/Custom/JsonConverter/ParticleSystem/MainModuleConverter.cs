using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Newtonsoft.Json.Converters
{
    public class MainModuleConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(ParticleSystem.MainModule);
        }

        public override bool CanRead
        {
            get { return true; }
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.Null)
                return null;

            return JObject.Load(reader);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (value == null)
            {
                writer.WriteNull();
                return;
            }

            var mainModule = (ParticleSystem.MainModule)value;
            writer.WriteStartObject();
            {
                writer.WritePropertyName("loop");
                writer.WriteValue(mainModule.loop);

                writer.WritePropertyName("prewarm");
                writer.WriteValue(mainModule.prewarm);

                writer.WritePropertyName("duration");
                writer.WriteValue(mainModule.duration);

                writer.WritePropertyName("startSize");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startSize, new MinMaxCurveConverter()));

                writer.WritePropertyName("startColor");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startColor, new MinMaxGradientConverter()));

                writer.WritePropertyName("startDelay");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startDelay, new MinMaxCurveConverter()));

                writer.WritePropertyName("startSizeX");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startSizeX, new MinMaxCurveConverter()));

                writer.WritePropertyName("startSizeY");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startSizeY, new MinMaxCurveConverter()));

                writer.WritePropertyName("startSizeZ");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startSizeZ, new MinMaxCurveConverter()));

                writer.WritePropertyName("startSpeed");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startSpeed, new MinMaxCurveConverter()));

                writer.WritePropertyName("stopAction");
                writer.WriteValue(mainModule.stopAction);

                writer.WritePropertyName("playOnAwake");
                writer.WriteValue(mainModule.playOnAwake);

                writer.WritePropertyName("scalingMode");
                writer.WriteValue(mainModule.scalingMode);

                writer.WritePropertyName("startSize3D");
                writer.WriteValue(mainModule.startSize3D);

                writer.WritePropertyName("flipRotation");
                writer.WriteValue(mainModule.flipRotation);

                writer.WritePropertyName("maxParticles");
                writer.WriteValue(mainModule.maxParticles);

                writer.WritePropertyName("startLifetime");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startLifetime, new MinMaxCurveConverter()));

                writer.WritePropertyName("startRotation");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startRotation, new MinMaxCurveConverter()));

                writer.WritePropertyName("startRotationX");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startRotationX, new MinMaxCurveConverter()));

                writer.WritePropertyName("startRotationY");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startRotationY, new MinMaxCurveConverter()));

                writer.WritePropertyName("startRotationZ");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.startRotationZ, new MinMaxCurveConverter()));

                writer.WritePropertyName("gravityModifier");
                writer.WriteRawValue(JsonConvert.SerializeObject(mainModule.gravityModifier, new MinMaxCurveConverter()));

                writer.WritePropertyName("simulationSpace");
                writer.WriteValue(mainModule.simulationSpace);

                writer.WritePropertyName("customSimulationSpace");
                writer.WriteValue(JsonHelper.GetComponentValue(mainModule.customSimulationSpace, typeof(Transform)));

                writer.WritePropertyName("simulationSpeed");
                writer.WriteValue(mainModule.simulationSpeed);

                writer.WritePropertyName("startRotation3D");
                writer.WriteValue(mainModule.startRotation3D);

                writer.WritePropertyName("useUnscaledTime");
                writer.WriteValue(mainModule.useUnscaledTime);

                writer.WritePropertyName("emitterVelocityMode");
                writer.WriteValue(mainModule.emitterVelocityMode);

                writer.WritePropertyName("startSizeMultiplier");
                writer.WriteValue(mainModule.startSizeMultiplier);

                writer.WritePropertyName("startDelayMultiplier");
                writer.WriteValue(mainModule.startDelayMultiplier);

                writer.WritePropertyName("startSizeXMultiplier");
                writer.WriteValue(mainModule.startSizeXMultiplier);

                writer.WritePropertyName("startSizeYMultiplier");
                writer.WriteValue(mainModule.startSizeYMultiplier);

                writer.WritePropertyName("startSizeZMultiplier");
                writer.WriteValue(mainModule.startSizeZMultiplier);

                writer.WritePropertyName("startSpeedMultiplier");
                writer.WriteValue(mainModule.startSpeedMultiplier);

                writer.WritePropertyName("startLifetimeMultiplier");
                writer.WriteValue(mainModule.startLifetimeMultiplier);

                writer.WritePropertyName("startRotationMultiplier");
                writer.WriteValue(mainModule.startRotationMultiplier);

                writer.WritePropertyName("startRotationXMultiplier");
                writer.WriteValue(mainModule.startRotationXMultiplier);

                writer.WritePropertyName("startRotationYMultiplier");
                writer.WriteValue(mainModule.startRotationYMultiplier);

                writer.WritePropertyName("startRotationZMultiplier");
                writer.WriteValue(mainModule.startRotationZMultiplier);

                writer.WritePropertyName("gravityModifierMultiplier");
                writer.WriteValue(mainModule.gravityModifierMultiplier);
            }
            writer.WriteEndObject();
        }
    }
}
