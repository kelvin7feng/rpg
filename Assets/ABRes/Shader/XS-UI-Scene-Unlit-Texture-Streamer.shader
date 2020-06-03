Shader "XS-UI/Scene/Texture Streamer" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}

	_StreamerControlTex("Stream Channel Control(Alpha, R)", 2D) = "while" {}

	_StreamerTex("Streamer Texture", 2D) = "black" {}
	_StreamerColor("S Color", Color) = (1,1,1,1)
	_StreamerSpeed("S Speed", Range(-20, 20)) = 1
	_StreamerStrength("S Strength", Range(0, 10)) = 1
	_StreamerDirectionX("S Direction X", Range(-1, 1)) = 1
	_StreamerDirectionY("S Direction Y", Range(-1, 1)) = 1
	_StreamerWaveSpeed("S Wave Speed", Range(0, 100)) = 1
	_StreamerWaveStrength("S Wave Strength", Range(0, 1)) = 0

	_StreamerTex2("Streamer Texture 2", 2D) = "black" {}
	_StreamerColor2("S Color 2", Color) = (1,1,1,1)
	_StreamerSpeed2("S Speed 2", Range(-20, 20)) = 1
	_StreamerStrength2("S Strength 2", Range(0, 10)) = 1
	_StreamerDirectionX2("S Direction X 2", Range(-1, 1)) = 1
	_StreamerDirectionY2("S Direction Y 2", Range(-1, 1)) = 1
	_StreamerWaveSpeed2("S Wave Speed 2", Range(0, 100)) = 1
	_StreamerWaveStrength2("S Wave Strength 2", Range(0, 1)) = 0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _StreamerControlTex;

			sampler2D _StreamerTex;
			fixed4 _StreamerColor;
			half4 _StreamerTex_ST;
			half _StreamerSpeed;
			half _StreamerStrength;
			fixed _StreamerDirectionX;
			fixed _StreamerDirectionY;
			fixed _StreamerWaveStrength;
			half _StreamerWaveSpeed;

			sampler2D _StreamerTex2;
			fixed4 _StreamerColor2;
			half4 _StreamerTex2_ST;
			half _StreamerSpeed2;
			half _StreamerStrength2;
			fixed _StreamerDirectionX2;
			fixed _StreamerDirectionY2;
			fixed _StreamerWaveStrength2;
			half _StreamerWaveSpeed2;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);

				float2 streamerUV = TRANSFORM_TEX(i.texcoord, _StreamerTex);
				fixed4 streamerColor = tex2D(_StreamerTex, streamerUV + fixed2(_Time.x * _StreamerDirectionX, _Time.x * _StreamerDirectionY) * (_StreamerSpeed).xx) * _StreamerColor;
				fixed4 streamerControlColor = tex2D(_StreamerControlTex, i.texcoord);
				streamerColor = streamerColor * (1.0f - _StreamerWaveStrength) + streamerColor * max(sin(_Time.x * _StreamerWaveSpeed) + 0.6f, 0.0f) * 2.0f * _StreamerWaveStrength;

				col.rgb = col.rgb  + streamerColor.rgb * streamerControlColor.a * _StreamerStrength;

				streamerUV = TRANSFORM_TEX(i.texcoord, _StreamerTex2);
				streamerColor = tex2D(_StreamerTex2, streamerUV + fixed2(_Time.x * _StreamerDirectionX2, _Time.x * _StreamerDirectionY2) * (_StreamerSpeed2).xx) * _StreamerColor2;
				streamerColor = streamerColor * (1.0f - _StreamerWaveStrength2) + streamerColor * max(sin(_Time.x * _StreamerWaveSpeed2) + 0.6f, 0.0f) * 2.0f * _StreamerWaveStrength2;

				col.rgb = col.rgb  + streamerColor.rgb * streamerControlColor.r * _StreamerStrength2;

				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
