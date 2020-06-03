// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "XS-UI/UI-DefaultWorldPosFade"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15
		_FadeSideRect("Fade Side Rect", Vector) = (1,1,1,1)
		_FadeLeft("Fade Left", Range(0, 2)) = 0
		_FadeLength("Fade Length", Range(0, 2)) = 0.5

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
			Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _FadeSideRect;
			half _FadeLength;
			half _FadeLeft;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				OUT.worldPosition = mul(unity_ObjectToWorld, IN.vertex);
				// OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;

			inline float SmoothGet2DClipping (in float2 position, in float4 clipRect)
			{
				half fadeLength = _FadeLength;
				half fadeLeft = _FadeLeft;
				float2 pointPos = float2(position.x, clipRect.y);
				float pointDistance = distance(position, pointPos);
				float result = smoothstep(fadeLeft, fadeLength, pointDistance);

				pointPos = float2(position.x, clipRect.w);
				pointDistance = distance(position, pointPos);
				result = result * smoothstep(fadeLeft, fadeLength, pointDistance);

				pointPos = float2(clipRect.x, position.y);
				pointDistance = distance(position, pointPos);
				result = result * smoothstep(fadeLeft, fadeLength, pointDistance);

				pointPos = float2(clipRect.z, position.y);
				pointDistance = distance(position, pointPos);
				result = result * smoothstep(fadeLeft, fadeLength, pointDistance);

				return result;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
				
				color.a *= SmoothGet2DClipping(IN.worldPosition.xy, _FadeSideRect);
				// color.a *= UnityGet2DClipping(IN.worldPosition.xy, _FadeSideRect);
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
}
