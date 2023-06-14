﻿Shader "Daltonize/Deuteranope"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			float3 custom_add(float3 a, float3 b)
			{
				return a + b;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				
			float3 custom = custom_add(3.5,2.1);

			float3 deuteranope1;
			float3 deuteranope2;
			float3 deuteranope3;

			float L, M, S, l, m, s, R, G, B, RR, GG, BB, scaled_r, scaled_g, scaled_b;

			scaled_r = col.r * 255.0;
			scaled_g = col.g * 255.0;
			scaled_b = col.b * 255.0;

			deuteranope1[0] = 1.0;
			deuteranope1[1] = 0.0;
			deuteranope1[2] = 0.0;
			deuteranope2[0] = 0.494207;
			deuteranope2[1] = 0.0;
			deuteranope2[2] = 1.24827;
			deuteranope3[0] = 0.0;
			deuteranope3[1] = 0.0;
			deuteranope3[2] = 1.0;

			L = (17.8824 * scaled_r) + (43.5161 * scaled_g) + (4.11935 * scaled_b);
			M = (3.45565 * scaled_r) + (27.1554 * scaled_g) + (3.86714 * scaled_b);
			S = (0.0299566 * scaled_r) + (0.184309 * scaled_g) + (1.46709 * scaled_b);

			l = deuteranope1[0] * L + deuteranope1[1] * M + deuteranope1[2] * S;
			m = deuteranope2[0] * L + deuteranope2[1] * M + deuteranope2[2] * S;
			s = deuteranope3[0] * L + deuteranope3[1] * M + deuteranope3[2] * S;

			R = (0.0809444479 * l) + (-0.130504409 * m) + (0.116721066 * s);
			G = (-0.0102485335 * l) + (0.0540193266 * m) + (-0.113614708 * s);
			B = (-0.000365296938 * l) + (-0.00412161469 * m) + (0.693511405 * s);

			R = scaled_r - R;
			G = scaled_g - G;
			B = scaled_b - B;

			RR = (0.0 * R) + (0.0 * G) + (0.0 * B);
			GG = (0.7 * R) + (1.0 * G) + (0.0 * B);
			BB = (0.7 * R) + (0.0 * G) + (1.0 * B);

			R = RR + scaled_r;
			G = GG + scaled_g;
			B = BB + scaled_b;

			if (R < 0.0) R = 0.0;
			if (R > 255.0) R = 255.0;
			if (G < 0.0) G = 0.0;
			if (G > 255.0) G = 255.0;
			if (B < 0.0) B = 0.0;
			if (B > 255.0) B = 255.0;

			R = R / 255.0;
			G = G / 255.0;
			B = B / 255.0;

			col.r = R;
			col.g = G;
			col.b = B;
                return col;
            }
            ENDCG
        }
    }
}
