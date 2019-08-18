Shader "Unlit/EdgeGlow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amount("Amount", Range(1, 20)) = 1
        _GlowColor("Glow Color", Color) = (1,1,1,0)
        _TexColor("Texture Colot", Color) = (1,1,1,1)
        _Modifier("Glow Modifier", Range(1, 20)) = 10
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha 

        Zwrite off
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
            float _Amount;
            float _Modifier;
            fixed4 _GlowColor;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.xy *= _Amount;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float depth = length(abs(i.uv - float2(0.5, 0.5)));
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= pow(1/(1 + depth), _Modifier); 
                return col * _GlowColor;
            }
            ENDCG
        }

        Zwrite on 
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
            fixed4 _TexColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {      
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * _TexColor;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
