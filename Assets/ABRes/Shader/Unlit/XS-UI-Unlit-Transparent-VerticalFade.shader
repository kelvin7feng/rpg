Shader "XS-UI/Unlit/Transparent Vertical Fade" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Color ("Color", Color) = (1, 1, 1, 1)
	_Alpha ("Alpha", Range(0, 1)) = 1

	_OutlineColor("Outline Color", Color) = (0,0,0,1)
	_OutlineScaler("Outline Scaler", Range(0.0001, 0.1)) = 0.02

	_FadeBaseHeight("VerticalFade Base Height", float) = 0
	_FadeTotalHeight("VerticalFade Total Height", Range(0, 10)) = 0.5
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	Pass
	{
        ZWrite On  
        ColorMask 0  
    }

	Pass
	{
		Name "Outline"

		Cull Front  
		Lighting Off  
		ZWrite Off 
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma multi_compile __ CHARACTER_OUTLINE
		#pragma vertex vertOutline
		#pragma fragment fragOutline

		float _OutlineScaler;
		fixed4 _OutlineColor;
		float _FadeBaseHeight;
		float _FadeTotalHeight;

		struct appdataOutline {
			half4 vertex : POSITION;
			half3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct V2FOutLine {
			half4 pos : POSITION;
			float3 worldPos : TEXCOORD0;
		};

		V2FOutLine vertOutline(appdataOutline v)
		{
			V2FOutLine o;

			float4 pos = mul( UNITY_MATRIX_MV, v.vertex);  

			#if defined(CHARACTER_OUTLINE)
			float3 normal = mul( (float3x3)UNITY_MATRIX_IT_MV, v.normal);    
			normal.z = -0.5;  
			pos = pos + float4(normalize(normal),0) * _OutlineScaler;  
			#endif
			
			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			o.pos = mul(UNITY_MATRIX_P, pos);  

			return o;
		}

		fixed4 fragOutline(V2FOutLine i) : COLOR
		{
			#if !defined(CHARACTER_OUTLINE)
			clip(-0.1f);
			#endif

			fixed4 col = _OutlineColor;

			float heightAlpha = 1.0f;
			heightAlpha = smoothstep(_FadeBaseHeight, _FadeBaseHeight + _FadeTotalHeight * 3.0f, i.worldPos.y);

			col.a = col.a * heightAlpha;

			return col;
		}

		ENDCG
	}
	
	Pass {  
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha 

		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			//#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			//用于程序控制场景统一色调
			fixed4 _GlobalColor;
			fixed4 _Color;
			fixed _Alpha;
			float _FadeBaseHeight;
			float _FadeTotalHeight;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * _Color;

				float heightAlpha = 1.0f;
				heightAlpha = smoothstep(_FadeBaseHeight, _FadeBaseHeight + _FadeTotalHeight, i.worldPos.y);

				col.a = col.a * _Alpha * heightAlpha;
				//col.xyz = i.worldPos.yyy + (-_FadeBaseHeight + 10.0).xxx;
				
				return col;
			}
		ENDCG
	}
}

}
