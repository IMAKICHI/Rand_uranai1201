Shader "Custom/Season"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _SeasonColor("SeasonColor", Color) = (1,1,1,1)
        _DebugColor("DebugColor", Color) = (1,1,1,1)

        _SubTex("SubAlbedo (RGB)", 2D) = "white" {}
        _Sub("Sub", Range(0,2)) = 0.0

        _SeasonShift("SeasonShift", Range(0,4)) = 0.0

        _SpringTex("Spring", 2D) = "white" {}
        _Spring("Spring", Range(0,1)) = 0.0
        _SummerTex("Summer", 2D) = "white" {}
        _Summer("Summer", Range(0,1)) = 0.0
        _AutumnTex("Autumn", 2D) = "white" {}
        _Autumn("Autumn", Range(0,1)) = 0.0
        _WinterTex("Winter", 2D) = "white" {}
        _Winter("Winter", Range(0,1)) = 0.0

        _Snow("Snow", Range(0,2)) = 0.0
        _Power("Power", Range(0,10)) = 1.0
        _Step("Step", Range(0,1)) = 0.5

        _Satuation("Satuation", Range(-1,1)) = 0.0
        _Value("Value", Range(-1, 1)) = 0.0

        _Hue("Hue", Range(-1,1)) = 0
        _HueRange("HueRange", Range(0,1)) = 0.2
        _LerpValue("LerpValue", Range(0,10)) = 0.5

        _Height("Height", Range(-5,5)) = 0.0

        _max_h("maxHeight", Range(-1,1)) = 1.0
        _min_h("minHeight", Range(-1,1)) = 0.0

        _NoiseScale("NoiseScale", Range(0, 100)) = 5
        _Radius("Radius", Range(0, 10)) = 1.0

        _GradationTex("SubAlbedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _GradationTex;

        half _SeasonShift;

        sampler2D _SpringTex;
        half _Spring;
        sampler2D _SummerTex;
        half _Summer;
        sampler2D _AutumnTex;
        half _Autumn;
        sampler2D _WinterTex;
        half _Winter;


        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed4 _SeasonColor;
        fixed4 _DebugColor;

        half _Sub;

        half _Snow;
        half _Power;
        half _Step;

        half _Satuation;
        half _Value;

        half _Hue;
        half _HueRange;
        half _LerpValue;

        half _Height;

        half _max_h;
        half _min_h;

        float _NoiseScale;
        float _Radius;

        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)



        fixed4 rgb2hsv(fixed4 c)
        {
            fixed4 K = fixed4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
            fixed4 p = lerp(fixed4(c.bg, K.wz), fixed4(c.gb, K.xy), step(c.b, c.g));
            fixed4 q = lerp(fixed4(p.xyw, c.r), fixed4(c.r, p.yzx), step(p.x, c.r));

            float d = q.x - min(q.w, q.y);
            float e = 1.0e-10;
            return fixed4(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x, c.a);
        }

        fixed4 hsv2rgb(fixed4 c)
        {
            fixed4 K = fixed4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            fixed3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
            fixed3 d = c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
            return fixed4(d.x, d.y, d.z, c.a);
        }

        inline float hash(float n)
        {
            return frac(sin(n) * 43758.5453);
        }

        inline float noise(float3 x)
        {
            float3 p = floor(x);
            float3 f = frac(x);
            f = f * f * (3.0 - 2.0 * f);
            float n = p.x + p.y * 57.0 + 113.0 * p.z;
            float res =
                lerp(lerp(lerp(hash(n + 0.0), hash(n + 1.0), f.x),
                    lerp(hash(n + 57.0), hash(n + 58.0), f.x), f.y),
                    lerp(lerp(hash(n + 113.0), hash(n + 114.0), f.x),
                        lerp(hash(n + 170.0), hash(n + 171.0), f.x), f.y), f.z);
            return res;
        }

        inline float fbm(float3 p)
        {
            float3x3 m = float3x3(
                +0.00, +0.80, +0.60,
                -0.80, +0.36, -0.48,
                -0.60, -0.48, +0.64);
            float f = 0.0;
            f += 0.5 * noise(p); p = mul(m, p) * 2.02;
            f += 0.3 * noise(p); p = mul(m, p) * 2.03;
            f += 0.2 * noise(p);

            /*
            if (f > 0.5)f = 1;
            else f = 0;
            */

            return f;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //ローカル座標の計算
            float3 localPos = IN.worldPos - mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
            float dist = distance(float3(localPos.x, _max_h, localPos.z), float3(localPos.x, _min_h, localPos.z));

            float value = (localPos.y - _min_h)/dist;
            if (localPos.y > _max_h) {
                value = 1;
            }

            //ノーマルと上向き度合
            float d = dot(IN.worldNormal, fixed3(0, 1, 0));

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            fixed4 c_season = tex2D(_SubTex, IN.uv_MainTex);

            //c = lerp(c, _SeasonColor, d * _Snownow       
            fixed4 red = fixed4(1, 0, 0, 1);

            //c = step(d, _Step);


            if (_Hue - _HueRange/2 < rgb2hsv(c).x && rgb2hsv(c).x < _Hue +_HueRange/2) {

                half change = abs(_Hue - rgb2hsv(c).x);

                c = lerp(c, _DebugColor, 1+_LerpValue-exp(-(_HueRange / 2 - change)/ (_HueRange/2)));
            }

            c = lerp(c, c_season, _Sub);

            fixed4 colormap = tex2D(_SubTex, IN.uv_MainTex);
            fixed4 shiftcolor = tex2D(_MainTex, IN.uv_MainTex);
            shiftcolor = rgb2hsv(shiftcolor);
            shiftcolor = fixed4(_Hue + shiftcolor.x, _Satuation + shiftcolor.y, shiftcolor.z, shiftcolor.w);
            shiftcolor = hsv2rgb(shiftcolor);

            colormap = lerp(c, shiftcolor, colormap.r);
            c = colormap;

            fixed4 white = fixed4(1, 1, 1, 1);

            fixed4 SpringTex = tex2D(_SpringTex, IN.uv_MainTex);
            fixed4 SummerTex = tex2D(_SummerTex, IN.uv_MainTex);
            fixed4 AutumnTex = tex2D(_AutumnTex, IN.uv_MainTex);
            fixed4 WinterTex = tex2D(_WinterTex, IN.uv_MainTex);

            fixed4 season = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            season = lerp(season, SpringTex, _Spring);
            season = lerp(season, SummerTex, _Summer);
            season = lerp(season, AutumnTex, _Autumn);
            season = lerp(season, WinterTex, _Winter);

            c = season;

            /*
            sampler2D _SpringTex;
            sampler2D _SummerTex;
            sampler2D _AutumnTex;
            sampler2D _WinterTex;
            */

            fixed4 black = fixed4(0, 0, 0, 1);


            fixed4 g_tex = tex2D(_GradationTex, IN.uv_MainTex * 6);
            g_tex = lerp(white,black,g_tex);


            float3 v = float3(localPos.x, value, localPos.z);
            float n = (fbm(localPos * _NoiseScale) - value * _Radius) * 2;
            /*
            if (n < 0.5)n = 0;
            else n = 1;
            */
            
            n = lerp(1, 0, n) * _Snow * _Snow * d * d * d * d;


            c = lerp(c, white, n);

            if (localPos.y < _min_h) {
                //c = colormap;
                c = season;
            }

            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
