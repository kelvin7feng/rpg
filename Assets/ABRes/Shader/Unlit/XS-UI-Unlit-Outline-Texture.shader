Shader "XS-UI/Unlit/Outline/Texture" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_OutlineColor("Outline Color", Color) = (0,0,0,1)
	_OutlineScaler("Outline Scaler", Range(0.0001, 0.1)) = 0.01
	//_MainTexBias("Mip Bias(-1 to 1)", Range(-2.0, 10.0)) = -2
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100

	Pass
	{
		Name "Outline"

		Cull Front  
		Lighting Off  
		ZWrite On 

		// ZWrite Off

		CGPROGRAM
		#pragma multi_compile __ CHARACTER_OUTLINE
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		float _OutlineScaler;
		fixed4 _OutlineColor;
		sampler2D _MainTex;
		float4 _MainTex_ST;

		struct appdata {
			half4 vertex : POSITION;
			half3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f {
			half4 pos : POSITION;
			//float2 uv : TEXCOORD0;
		};

		v2f vert(appdata v)
		{
			v2f o;
			// o.pos = UnityObjectToClipPos(v.vertex);
			// half3 norm = mul((half3x3)UNITY_MATRIX_IT_MV, v.normal);
			// half2 offset = TransformViewToProjection(norm.xy);
			// o.pos.xy += offset * _OutlineScaler;

			// o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

			_OutlineScaler = 0.01;

			float4 pos = mul( UNITY_MATRIX_MV, v.vertex);  

			#if defined(CHARACTER_OUTLINE)
			float3 normal = mul( (float3x3)UNITY_MATRIX_IT_MV, v.normal);    
			normal.z = -0.5;  
			pos = pos + float4(normalize(normal),0) * _OutlineScaler;  
			#endif

			o.pos = mul(UNITY_MATRIX_P, pos);  

			return o;
		}

		fixed4 frag(v2f i) : COLOR
		{
			#if !defined(CHARACTER_OUTLINE)
			clip(-0.1f);
			#endif

			//fixed4 texCol = tex2D(_MainTex, i.uv);
			fixed4 col = _OutlineColor;
			//col.rgb = col.rgb;// *texCol.rgb;
			
			return col;
		}

		ENDCG
	}
	
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
			//half _MainTexBias;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//fixed4 col = tex2Dbias(_MainTex, half4(i.texcoord.x,i.texcoord.y, 0.0f, _MainTexBias));
				fixed4 col = tex2D(_MainTex, i.texcoord);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
		ENDCG
	}
}

}
