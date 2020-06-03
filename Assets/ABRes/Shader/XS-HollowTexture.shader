Shader "XS/HollowTexture"
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

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

		_Region_X ("x", Range(0,1)) = 0
		_Region_Y ("y", Range(0,1)) = 0
		_Region_Width ("width", Range(0,1)) = 0
		_Region_Height ("height", Range(0,1)) = 0
		_IsRotundity("IsRotundity", Range(0,1)) = 0
		_RotundityRadius("Rotundity Radius", Range(0,2)) = 0
		_ScreenRatio("Screen Ratio", Float) = 1.777
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
			float4 _ClipRect;

			float _Region_X;
			float _Region_Y;
			float _Region_Width;
			float _Region_Height;
			fixed _IsRotundity;
			half _RotundityRadius;
			half _ScreenRatio;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
				
				float a = step(IN.texcoord.x, _Region_X) + step(_Region_X + _Region_Width, IN.texcoord.x) + step(IN.texcoord.y, _Region_Y) + step(_Region_Y + _Region_Height, IN.texcoord.y);	
				a = clamp(a, 0, 1);
				a *= 1.0f - _IsRotundity;

				// a = 1.0f;
				half rotundityDistance = distance(half2(_Region_X + _Region_Width / 2.0f, (_Region_Y + _Region_Height / 2.0f) / _ScreenRatio), half2(IN.texcoord.x, IN.texcoord.y / _ScreenRatio));
				// half rotundityDistance = distance(half2(_Region_X, _Region_Y / 1.777f), half2(IN.texcoord.x, IN.texcoord.y / 1.777f));
				

				//half b = max(0, sign(rotundityDistance - _RotundityRadius));

				//half b = 1.0f;
				//if (rotundityDistance < _RotundityRadius)
				//{
				//b = 0.0f;
				//}

				//if(rotundityDistance >= _RotundityRadius)
				//{
					//half b = 1.0f - 0.5f * _RotundityRadius / (rotundityDistance * 1.5f);
					rotundityDistance = (rotundityDistance - _RotundityRadius);
					half b = smoothstep(0.0f, 1.0f, rotundityDistance * 18.0f);
				//}

				b *= _IsRotundity;
				b = saturate(b);

				color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				color.a *= a + b;
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001f);
				#endif

				return color;
			}
		ENDCG
		}
	}
}
