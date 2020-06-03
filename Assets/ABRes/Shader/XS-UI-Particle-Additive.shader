// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "XS-UI/Particles/Additive"
{
	Properties{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}

	Category{
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

		Blend SrcAlpha One
		Cull Off Lighting Off ZWrite Off
		ColorMask [_ColorMask]
		ZTest [unity_GUIZTestMode]

		SubShader {
			Pass {

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile __ UNITY_UI_ALPHACLIP

				#include "UnityCG.cginc"
				#include "UnityUI.cginc"

				sampler2D _MainTex;
				fixed4 _TintColor;
				float4 _ClipRect;
				fixed4 _TextureSampleAdd;

				struct appdata_t {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float4 worldPosition : TEXCOORD1;
				};

				float4 _MainTex_ST;

				v2f vert(appdata_t v)
				{
					v2f o;

					o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.color = v.color;
					o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = 2.0f * i.color * _TintColor * (tex2D(_MainTex, i.texcoord) + _TextureSampleAdd);
					// float2 testPos = i.worldPosition.xy;
					
					col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
					return col;
				}
				ENDCG
			}
		}
	}
}
