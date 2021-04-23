Shader "Abandoned Manor Exterior/RimDetailVC" {
Properties {
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_SecTex ("Secondary (RGB) Gloss (A)", 2D) = "white" {}
	_AOTex ("AO (R) DetailAO (G)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_SecBumpMap ("Second Normalmap", 2D) = "bump" {}
	_BumpMapDetail ("NormalmapDetail", 2D) = "bump" {}
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
    _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
    _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    _Bumpness 	("Bump Power", Float) = 1.0
    _DetailBumpness ("Detail Power", Float) = 1.0
}
SubShader
{ 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
	CGPROGRAM
	#pragma surface surf BlinnPhong
	#pragma target 3.0

	sampler2D _MainTex;
	sampler2D _AOTex;
	sampler2D _BumpMap;
	sampler2D _SecBumpMap;
	sampler2D _BumpMapDetail;
	sampler2D _SecTex;
	half _Shininess;
	float4 _RimColor;
	float _RimPower;
	float _Bumpness;
	float _DetailBumpness;

	struct Input {
		float2 uv_MainTex;
		float2 uv_AOTex;
		float2 uv_BumpMap;
		float2 uv_BumpMapDetail;
		float2 uv_SecTex;
		float3 viewDir;
		float4 color : COLOR;
	};

	void surf (Input IN, inout SurfaceOutput o)
	{
		fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		fixed4 sectex = tex2D(_SecTex, IN.uv_SecTex);
		fixed4 AOtex = tex2D(_AOTex, IN.uv_AOTex);
		fixed4 AODtex = tex2D(_AOTex, IN.uv_BumpMapDetail);
		
		float3 normal01 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)) * _Bumpness;
		float3 normal02 = UnpackNormal(tex2D(_BumpMapDetail, IN.uv_BumpMapDetail)) * _DetailBumpness;
		float3 normal03 = UnpackNormal(tex2D(_SecBumpMap, IN.uv_SecTex))* _Bumpness;
		
		float mask = 1-IN.color.r;
		o.Normal = (float3 (normal01.rg + normal02.rg ,1.0) * mask) + (normal03 * IN.color.r);
		//o.Normal = float3 (normal01.rg + normal02.rg ,1.0);
		o.Gloss = tex.a*5;
		o.Alpha = tex.a;
		_SpecColor *= AOtex.r;
		o.Specular = _Shininess;
	    half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
	    o.Emission = _RimColor.rgb * pow (rim, _RimPower);
	    o.Albedo = (tex.rgb * AOtex.r * AODtex.g * mask) + (sectex * AOtex.r * IN.color.r) ;	
	}
	ENDCG
}

SubShader
{ 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
	CGPROGRAM
	#pragma surface surf BlinnPhong

	sampler2D _MainTex;
	sampler2D _AOTex;
	sampler2D _BumpMap;
	sampler2D _SecBumpMap;
	sampler2D _BumpMapDetail;
	sampler2D _SecTex;
	half _Shininess;
	float4 _RimColor;
	float _RimPower;
	float _Bumpness;
	float _DetailBumpness;

	struct Input {
		float2 uv_MainTex;
		float2 uv_AOTex;
		float2 uv_BumpMap;
		float2 uv_BumpMapDetail;
		float2 uv_SecTex;
		float3 viewDir;
		float4 color : COLOR;
	};

	void surf (Input IN, inout SurfaceOutput o)
	{
		fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		fixed4 sectex = tex2D(_SecTex, IN.uv_SecTex);
		fixed4 AOtex = tex2D(_AOTex, IN.uv_AOTex);
		fixed4 AODtex = tex2D(_AOTex, IN.uv_BumpMapDetail);
		
		float3 normal01 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)) * _Bumpness;
		float3 normal02 = UnpackNormal(tex2D(_BumpMapDetail, IN.uv_BumpMapDetail)) * _DetailBumpness;
		float3 normal03 = UnpackNormal(tex2D(_SecBumpMap, IN.uv_SecTex))* _Bumpness;
		
		float mask = 1-IN.color.r;
		o.Normal = (float3 (normal01.rg + normal02.rg ,1.0) * mask) + (normal03 * IN.color.r);
		//o.Normal = float3 (normal01.rg + normal02.rg ,1.0);
		o.Gloss = tex.a;
		o.Alpha = tex.a;
		_SpecColor *= AOtex.r;
		o.Specular = 0;
	    half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
	    o.Emission = _RimColor.rgb * pow (rim, _RimPower);
	    o.Albedo = (tex.rgb * AOtex.r * AODtex.g * mask) + (sectex * AOtex.r * IN.color.r) ;	
	}
	ENDCG
}

FallBack "Diffuse"
}
