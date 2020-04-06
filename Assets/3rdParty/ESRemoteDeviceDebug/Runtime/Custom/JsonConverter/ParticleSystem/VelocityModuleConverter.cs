using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Newtonsoft.Json.Converters
{
    public class VelocityModuleConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(ParticleSystem.VelocityOverLifetimeModule);
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

            var velocityModule = (ParticleSystem.VelocityOverLifetimeModule)value;
            writer.WriteStartObject();
            {
                writer.WritePropertyName("enabled");
                writer.WriteValue(velocityModule.enabled);

                writer.WritePropertyName("x");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.x, new MinMaxCurveConverter()));

                writer.WritePropertyName("y");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.y, new MinMaxCurveConverter()));

                writer.WritePropertyName("z");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.z, new MinMaxCurveConverter()));

                writer.WritePropertyName("space");
                writer.WriteValue(velocityModule.space);

                writer.WritePropertyName("orbitalX");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalX, new MinMaxCurveConverter()));

                writer.WritePropertyName("orbitalY");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalY, new MinMaxCurveConverter()));

                writer.WritePropertyName("orbitalZ");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalZ, new MinMaxCurveConverter()));

                writer.WritePropertyName("orbitalOffsetX");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalOffsetX, new MinMaxCurveConverter()));

                writer.WritePropertyName("orbitalOffsetY");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalOffsetY, new MinMaxCurveConverter()));

                writer.WritePropertyName("orbitalOffsetZ");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.orbitalOffsetZ, new MinMaxCurveConverter()));

                writer.WritePropertyName("radial");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.radial, new MinMaxCurveConverter()));

                writer.WritePropertyName("speedModifier");
                writer.WriteRawValue(JsonConvert.SerializeObject(velocityModule.speedModifier, new MinMaxCurveConverter()));
            }
            writer.WriteEndObject();
        }
    }
}

