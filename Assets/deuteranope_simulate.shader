Shader "Simulate/Deuteranope"
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

float k1,k2,k3,r_lin,g_lin,b_lin,scaled_r,scaled_g,scaled_b,pow_temp,GAMMA,lin_temp,r_blind,b_blind,red,blue,R,G,B;

    GAMMA = 2.2;

    k1 = 9591.0;
    k2 = 23173.0;
    k3 = -730.0;

    pow_temp = pow(col.r, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    r_lin = lin_temp * 32767.0;

    pow_temp = pow(col.g, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    g_lin = lin_temp * 32767.0;

    pow_temp = pow(col.b, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    b_lin = lin_temp * 32767.0;


    r_blind = (k1 * r_lin + k2 * g_lin) / pow(2.0,22.0);
    b_blind = (k3 * r_lin - k3 * g_lin + 32768.0 * b_lin) / pow(2.0,22.0);

    if (r_blind < 0.0) {
        r_blind = 0.0;
    } else if (r_blind > 255.0) {
        r_blind = 255.0;
    }

    if (b_blind < 0.0) {
        b_blind = 0.0;
    } else if (b_blind > 255.0) {
        b_blind = 255.0;
    }

    red = 255.0 * pow((r_blind / 255.0), 1.0 / GAMMA);
    if (red < 0.0) red = red + 256.0;
    blue = 255.0 * pow((b_blind / 255.0), 1.0 / GAMMA);
    if (blue < 0.0) blue = blue + 256.0;

    R = red / 255.0;
    G = red / 255.0;
    B = blue / 255.0;

			col.r = R;
			col.g = G;
			col.b = B;
                return col;
            }
            ENDCG
        }
    }
}
