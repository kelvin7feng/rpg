Shader "XS/Special/EnergyBar" 
{
	Properties 
	{
		_MainTex ("Main (RGB) Alpha (A)", 2D) = "white" {}
		_NoiseTex ("Norse (RGB) Alpha (A)", 2D) = "white" {}
		_MaskTex("Mask Alpha (A)", 2D) = "white" {}
		_EdgeColor("Edge Color", Color) = (1,1,1,1)
		_OutputColor("Out Color", Color) = (1,1,1,1)
		_TexRange ("Texture Range", Range(0,1)) = 0.8
		_Distrub ("Distrub Parameter", Range(0,1)) = 0.3
		_DistrubEdge ("Distrub Edge", Range(0,3)) = 0.3
		_EdgeThickness("Edge Thickness", Range(0,0.2)) = 0
		_FinalColorBoost("Final Color Boost", Range(0,20)) = 1
		_Speed("Speed", Vector) = (1, 1, 1, 1)
		_PixelSpeed("Pixel Speed", Vector) = (1, 1, 1, 1)

		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
		_ColorMask("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
	}
	SubShader
	{
		Tags 
		{
			"Queue" = "Transparent"
			"RenderType"="Transparent" 
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
			"IgnoreProjector" = "True"
		}

		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		LOD 100
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		ZTest [unity_GUIZTestMode]
		ColorMask [_ColorMask]
		// ZTest Always
		
		CGPROGRAM
		#pragma surface surf NoLighting vertex:vert alpha:blend noambient
		#pragma target 2.0

		sampler2D _MainTex;
		sampler2D _NoiseTex;
		sampler2D _MaskTex;

		uniform half4 _MainTex_ST;
		uniform half4 _NoiseTex_ST;
		//uniform half4 _MaskTex_ST;

		fixed4 _EdgeColor;
		fixed4 _OutputColor;
		fixed _TexRange;
		fixed _Distrub;
		fixed _DistrubEdge;
		fixed _EdgeThickness;
		half _FinalColorBoost;
		half4 _Speed;
		half4 _PixelSpeed;

		struct Input 
		{
			half2 rawUV : TEXCOORD0;
			half2 mainUV : TEXCOORD1;
			half2 edgeUV : TEXCOORD2;
			half2 noiseUV : TEXCOORD3;
		};

		fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.rawUV = v.texcoord;
			o.mainUV = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.noiseUV = TRANSFORM_TEX(v.texcoord, _NoiseTex);
			o.edgeUV = o.rawUV - _TexRange;
			// o.edgeUV.x = clamp(o.edgeUV.x, 0, 1);
		}

		void surf (Input i, inout SurfaceOutput o) 
		{
			half2 mainUV = i.mainUV;
			half2 noiseUV = i.noiseUV;
			half2 edgeUV = i.edgeUV;

			half currentTopY = _TexRange - i.rawUV.x;
			currentTopY = clamp(currentTopY, 0, 1);

			half2 translationTime = _Time.y * 0.01f * _Speed.xy;
			half4 noiseColor = tex2D(_NoiseTex, noiseUV + translationTime);
			edgeUV = edgeUV + noiseColor.xy * _DistrubEdge;
			// half4 edgeColor = tex2D(_EdgeTex, edgeUV) * _EdgeColor;

			half2 distrubUV = noiseColor.xy * _Distrub  + _Time.y * 0.01f * _PixelSpeed;
			fixed4 finalColor = tex2D (_NoiseTex, mainUV + distrubUV) * _OutputColor;// + edgeColor;

			half alphaBoost = 1.0f;
			half parameterA = _TexRange - edgeUV.x;

			half ratioA = max(0, sign(parameterA - i.rawUV.x));
			alphaBoost = alphaBoost * ratioA;
			// if(i.rawUV.x > parameterA)
			// {
			// 	alphaBoost = 0.0f;
			// }

			// if(i.rawUV.x > parameterA - _EdgeThickness)
			// {
			// 	finalColor = finalColor + _EdgeColor;
			// }

			parameterA = parameterA - _EdgeThickness;
			ratioA = max(0, sign(i.rawUV.x - parameterA));
			finalColor = finalColor + _EdgeColor * fixed4(ratioA, ratioA, ratioA, ratioA);
			fixed4 mainTexColor = tex2D(_MainTex, mainUV);
			fixed4 maskTexColor = tex2D(_MaskTex, mainUV);

			o.Albedo = finalColor.rgb * _FinalColorBoost;
			o.Alpha = alphaBoost * _OutputColor.a * mainTexColor.a * maskTexColor.a;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
