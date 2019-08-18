Shader "Unlit/BackGround"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint("Tint Color", Color) = (1,1,1,1)
        _Offset("Offset", Range(-1, 1)) = 0
    }
    SubShader
    {

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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed4 _Tint;
            float _Offset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv.y -= _Offset;
                fixed4 col = tex2D(_MainTex, i.uv) * (1 - i.uv.y);
                return col * _Tint;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
