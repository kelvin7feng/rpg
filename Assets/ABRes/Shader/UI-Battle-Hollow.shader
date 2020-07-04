// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "XS/UI/BattleHollow"
{
	//战斗规则说明特用的shader，其他业务不通用。
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

		_RectHollow_1("Rect", Vector) = (0, 0, 0, 0)
		_RectHollow_2("Rect", Vector) = (0, 0, 0, 0)
		_RectHollow_3("Rect", Vector) = (0, 0, 0, 0)
		_RectHollow_4("Rect", Vector) = (0, 0, 0, 0)
		_RectHollow_5("Rect", Vector) = (0, 0, 0, 0)

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
				float4 screenPosition :TEXCOORD2;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				OUT.screenPosition = ComputeScreenPos(UnityObjectToClipPos(IN.vertex));
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;
			float4 _RectHollow_1;
			float4 _RectHollow_2;
			float4 _RectHollow_3;
			float4 _RectHollow_4;
			float4 _RectHollow_5;

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
				color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);

				//计算屏幕坐标
				float2 screenPosition = IN.screenPosition.xy / IN.screenPosition.w * _ScreenParams.xy;

				float rectClip_1 = UnityGet2DClipping(screenPosition, _RectHollow_1);
				color.a *= 1 - rectClip_1; //判断是否在第一个Rect矩形区域内，是的话a为0

				float rectClip_2 = UnityGet2DClipping(screenPosition, _RectHollow_2);
				color.a *= 1 - rectClip_2; //判断是否在第二个Rect矩形区域内，是的话a为0

				float rectClip_3 = UnityGet2DClipping(screenPosition, _RectHollow_3);
				color.a *= 1 - rectClip_3; //判断是否在第三个Rect矩形区域内，是的话a为0

				float rectClip_4 = UnityGet2DClipping(screenPosition, _RectHollow_4);
				color.a *= 1 - rectClip_4; //判断是否在第四个Rect矩形区域内，是的话a为0

				float rectClip_5 = UnityGet2DClipping(screenPosition, _RectHollow_5);
				color.a *= 1 - rectClip_5; //判断是否在第五个Rect矩形区域内，是的话a为0
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
}
