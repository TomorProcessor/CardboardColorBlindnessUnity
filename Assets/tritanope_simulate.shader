Shader "Simulate/Tritanope"
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

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
				

			float k1,k2,k3,a1,b1,c1,a2,b2,c2,r,g,b,L,M,S,ired,igreen,iblue,R,G,B, inflection, GAMMA,pow_temp,lin_temp;

			GAMMA = 2.2;

    k1 = 0.05059983 + 0.08585369 + 0.00952420;
    k2 = 0.01893033 + 0.08925308 + 0.01370054;
    k3 = 0.00292202 + 0.00975732 + 0.07145979;

    inflection = k2 / k1;

    a1 = -k3 * 0.007009;
    b1 = k2 * 0.0914;
    c1 = k1 * 0.007009 - k2 * 0.0914;
    a2 = k2 * 0.3636 - k3 * 0.2237;
    b2 = k3 * 0.1284 - k1 * 0.3636;
    c2 = k1 * 0.2237 - k2 * 0.1284;

    pow_temp = pow(col.r, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    r = lin_temp * 32767.0;

    pow_temp = pow(col.g, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    g = lin_temp * 32767.0;

    pow_temp = pow(col.b, GAMMA);
    lin_temp = 0.992052 * pow_temp + 0.003974;
    b = lin_temp * 32767.0;

    L = (r * 0.05059983 + g * 0.08585369 + b * 0.00952420) / 32767.0;
    M = (r * 0.01893033 + g * 0.08925308 + b * 0.01370054) / 32767.0;
    S = (r * 0.00292202 + g * 0.00975732 + b * 0.07145979) / 32767.0;

    float tmp = M / L;
    if (tmp < inflection) {
        S = -(a1 * L + b1 * M) / c1;
    } else {
        S = -(a2 * L + b2 * M) / c2;
    }

    ired = 255.0 * (L * 30.830854 - M * 29.832659 + S * 1.610474);
    igreen = 255.0 * (-L * 6.481468 + M * 17.715578 - S * 2.532642);
    iblue = 255.0 * (-L * 0.375690 - M * 1.199062 + S * 14.273846);

    if (ired < 0.0) {
        ired = 0.0;
    } else if (ired > 255.0) {
        ired = 255.0;
    } else {
        ired = 255.0 * pow((ired / 255.0), 1.0 / GAMMA);
        ired = ired >= 0.0 ? ired : 256.0 + ired;
    }
    if (igreen < 0.0) {
        igreen = 0.0;
    } else if (igreen > 255.0) {
        igreen = 255.0;
    } else {
        igreen = 255.0 * pow((igreen / 255.0), 1.0 / GAMMA);
        igreen = igreen >= 0.0 ? igreen : 256.0 + igreen;
    }
    if (iblue < 0.0) {
        iblue = 0.0;
    } else if (iblue > 255.0) {
        iblue = 255.0;
    } else {
        iblue = 255.0 * pow((iblue / 255.0), 1.0 / GAMMA);
        iblue = iblue >= 0.0 ? iblue : 256.0 + iblue;
    }

    R = ired / 255.0;
    G = igreen / 255.0;
    B = iblue / 255.0;

			col.r = R;
			col.g = G;
			col.b = B;
                return col;
            }
            ENDCG
        }
    }
}
