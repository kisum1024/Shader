﻿Shader "MyStudy/Chapter4/MyToonShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex("Ramp",2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;
		struct Input {
			float2 uv_MainTex;
		};


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			
		}
		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
		{
			//빛의 방향과 표면의 법선에 대한 내젹을 계산한다.
			half NdotL = dot(s.Normal, lightDir);
			
			//NdotL을 램프의 맵의 값으로 다시 매핑한다.
			NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));

			//반환할 색상을 결정한다.
			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
			color.a = s.Alpha;

			//결정된 색 반환
			return color;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
