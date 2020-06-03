Shader "XS-UI/Scene/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200

CGPROGRAM
#pragma surface surf CustomLight exclude_path:prepass noforwardadd nolightmap nofog nometa novertexlights

sampler2D _MainTex;
fixed4 _Color;

struct Input {
	float2 uv_MainTex;
};

fixed4 LightingCustomLight(SurfaceOutput s, fixed3 lightDir, fixed atten)
{
	half NdotL = dot(s.Normal, lightDir);
	half4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
	c.a = s.Alpha;
	return c;
}

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
