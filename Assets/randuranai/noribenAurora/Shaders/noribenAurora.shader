// 2020/6/15 Version 001
Shader "Noriben/noribenAurora"
{
    Properties
    {
        [HDR]_Color1 ("Color 1" , Color) = (.2, .9, .6, 1.0)
        [HDR]_Color2 ("Color 2" , Color) = (1.5, .1, 1.1, 1.0)

        [NoScaleOffset]_Volume ("3D Noise Tex", 3D) = ""{}
        [PowerSlider(3.)]_NoiseSize ("Noise Size", Range(0,1)) = 1
        _NoisePower ("Noise Power", Range(0,1)) = 0

        _Intensity ("Intensity" ,Range(0,3)) = 1
        _Scroll ("Scroll", Range(-10, 10)) = .1
        _VertexMove ("Move", Range(0,3)) = 1.
    }
    SubShader
    {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
		Cull Off
		Blend One One
		Zwrite Off
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 objworldPos: TEXCOORD2; //オブジェクト原点のワールド座標用
                float3 uv2 : TEXCOORD3; //3Dノイズ用UV
            };

            float _Intensity;
            float3 _Color1;
            float3 _Color2;
            sampler3D _Volume;
            float _NoiseSize;
            float _NoisePower;
            float _Scroll;
            float _VertexMove;

            //1D randam noise
            float rand1d(float t)
            {
                return frac(sin(t) * 100000.);
            }

            //1D smooth randam noise
            float smoothrand1d (float t)
            {
                return rand1d(t)/2 + rand1d(t-1)/4 + rand1d(t+1)/4;
            }

            //1D Perlin noise
            float noise1d(float t)
            {
                float i = floor(t);
                float f = frac(t);
                return lerp(rand1d(i),rand1d(i + 1.), smoothstep(0., 1. , f));
            }

            //1D smooth Perlin noise
            float smoothnoise1d(float t)
            {
                float i = floor(t);
                float f = frac(t);
                return lerp(smoothrand1d(i),smoothrand1d(i + 1.), smoothstep(0., 1. , f));
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.objworldPos = mul(unity_ObjectToWorld, float4(1,1,1,1));
                //オブジェクト原点のワールド座標によって頂点移動の具合を変える
                float vHeight = smoothnoise1d(_Time.y * .2 * _Scroll   + v.uv.x * 42.+ o.objworldPos.z + o.objworldPos.x + o.objworldPos.y) ;
                
                v.vertex.xyz = v.vertex.xyz + v.normal * _VertexMove * vHeight;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                //ワールド座標の3Dノイズ用
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv2 = worldPos.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float time = _Time.y;
                float2 uv = i.uv;
                
                uv.y = pow(uv.y, 2.2);

                //オブジェクトのワールド座標によってノイズの出方を変える
                //（複数オブジェクトを使うときノイズの出方がそろわないように）
                float wposRandom = i.objworldPos.x + i.objworldPos.y + i.objworldPos.z;
                //ノイズ重ね合わせ
                float a = noise1d(time * .4  * _Scroll + uv.x * 21. + wposRandom) ;
                float b = noise1d(time * .2  * _Scroll + uv.x * 32. + wposRandom) ;
                float c = noise1d(time * .5  * _Scroll + uv.x * 60. + wposRandom) ;
                float d = noise1d(time * .52  * _Scroll + uv.x * 156. + wposRandom) ;
                float e= noise1d(time * .1  * _Scroll + uv.x * 1050. + wposRandom) ;
                float f = (a * 3. + b + c + (d * 1.) + e * .3) / 6.;

                //カラー
                float3 col1 =  float3(f,f,f) * _Color1 * (1.- uv.y);
                float m = lerp(f, 1., .6);
                float3 col2 =  m * _Color2 * uv.y;
                col1 = saturate(col1);
                col2 = saturate(col2);
                
                //クロップ
                float clop = smoothstep(0., .14, uv.y) * smoothstep(0., 0.8, 1.-uv.y);
                float clopside = smoothstep(0, .3, uv.x) * smoothstep(.0, 0.3, 1.-uv.x);
                clop *= clopside;

                //3d noise
                float3 tex3dUV = i.uv2 * _NoiseSize;
                float4 tex3d = tex3D(_Volume, tex3dUV);
                float tp = 2.2;
                tex3d.x = pow(tex3d.x, .9);
                tex3d.y = pow(tex3d.y, 1.2);
                tex3d.z = pow(tex3d.z, 1.2);
                tex3d = lerp(1, tex3d, _NoisePower);

                float3 col =   (col1 + col2 * .6) * clop * tex3d;
                
                col *= _Intensity;

                float  p = 4.2;
                col = pow(col, float3(p,p,p));


                col = clamp(col, 0, 10);

                float4 finalcol = float4(float3(col), 1);


                return finalcol;
            }
            ENDCG
        }
    }
}
