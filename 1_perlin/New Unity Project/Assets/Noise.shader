﻿Shader "Unlitstudy/MultiNoise"
{

	SubShader
	{
	   Lighting off

		Pass
		{
			CGPROGRAM
			#include "UnityCustomRenderTexture.cginc"

			#pragma vertex CustomRenderTextureVertexShader
			#pragma fragment frag
			#pragma target 3.0

			fixed2 random2(float2 st)
			{
				st = float2(dot(st,fixed2(127.1, 311.7)),
							dot(st,fixed2(269.5, 183.3)));
				return -1.0 + 2.0 * frac(sin(st)* 43758.5453123);
			}

			float Noise(float2 st)
			{
				float2 p = floor(st);
				float2 f = frac(st);
				float2 u = f * f * (3.0 - 2.0 * f);

				float v00 = random2(p + fixed2(0, 0));
				float v10 = random2(p + fixed2(1, 0));
				float v01 = random2(p + fixed2(0, 1));
				float v11 = random2(p + fixed2(1, 1));

				return lerp(lerp(dot(random2(p + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
					dot(random2(p + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
					lerp(dot(random2(p + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
						dot(random2(p + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
			}
			
			

			fixed4 frag(v2f_customrendertexture i) : SV_Target
			{
				float noise = (Noise(i.globalTexcoord *  4.0 + _Time.y * 0.05))
							+ (Noise(i.globalTexcoord *  8.0 + _Time.y * 0.20)) * 0.5
							+ (Noise(i.globalTexcoord * 16.0 + _Time.y * 0.80)) * 0.25;
				noise = noise / (1.0 + 0.5 + 0.25) ;
				noise = sin(100 * noise);
				return float4(noise, noise, noise, 1);
			}
			ENDCG
		}
	}
}
