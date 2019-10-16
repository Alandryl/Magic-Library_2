// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Flame_V2"
{
	Properties
	{
		_Noise("Noise", 2D) = "white" {}
		_TimeScale("TimeScale", Float) = 0.8
		_PanningSpeed("PanningSpeed", Float) = -1
		_Noise_scale("Noise_scale", Float) = 0.54
		_TimeScale_B("TimeScale_B", Float) = 1
		_Noise_Scale("Noise_Scale", Float) = 0.8
		_Texture0("Texture 0", 2D) = "white" {}
		_FlameFlicker_Speed("FlameFlicker_Speed", Float) = 0.2
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Flicker_TimeScale("Flicker_TimeScale", Float) = 1
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Texture3("Texture 3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform sampler2D _TextureSample3;
		uniform sampler2D _Noise;
		uniform float _Flicker_TimeScale;
		uniform float _FlameFlicker_Speed;
		uniform float _Noise_Scale;
		uniform sampler2D _Texture0;
		uniform float _TimeScale_B;
		uniform float _TimeScale;
		uniform float _PanningSpeed;
		uniform float _Noise_scale;
		uniform sampler2D _TextureSample2;
		uniform sampler2D _Texture3;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth82 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth82 = abs( ( screenDepth82 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float4 color40 = IsGammaSpace() ? float4(0.6509434,0.6509434,0.6509434,0) : float4(0.3812781,0.3812781,0.3812781,0);
			float mulTime12 = _Time.y * _Flicker_TimeScale;
			float4 appendResult13 = (float4(-_FlameFlicker_Speed , -_FlameFlicker_Speed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult3 = (float4(ase_worldPos.x , ase_worldPos.y , 0.0 , 0.0));
			float2 panner14 = ( mulTime12 * appendResult13.xy + ( ( appendResult3 * 0.1 ) + float4( ( _Noise_Scale * i.uv_texcoord ), 0.0 , 0.0 ) ).xy);
			float2 temp_output_20_0 = ( i.uv_texcoord + ( i.uv_texcoord.y * ( float2( 0.5,0.25 ) - (tex2D( _Noise, panner14 )).rg ) * i.uv_texcoord.y ) );
			float mulTime33 = _Time.y * _TimeScale_B;
			float2 appendResult30 = (float2(0.0 , -1.5));
			float2 uv_TexCoord21 = i.uv_texcoord * float2( 1.5,1 );
			float2 panner35 = ( mulTime33 * appendResult30 + ( 1.22 * uv_TexCoord21 ));
			float mulTime29 = _Time.y * _TimeScale;
			float2 appendResult31 = (float2(0.0 , _PanningSpeed));
			float2 panner36 = ( mulTime29 * appendResult31 + ( uv_TexCoord21 * _Noise_scale ));
			float4 temp_output_45_0 = ( ( color40 * tex2D( _TextureSample3, temp_output_20_0 ) ) + ( ( tex2D( _Texture0, ( panner35 + temp_output_20_0 ) ) * tex2D( _Texture0, ( panner36 + temp_output_20_0 ) ) ) * tex2D( _TextureSample2, temp_output_20_0 ) ) );
			float3 appendResult73 = (float3(saturate( temp_output_45_0 ).rg , 0.0));
			o.Emission = ( saturate( distanceDepth82 ) * ( ( step( float4( 0.254717,0.254717,0.254717,0 ) , temp_output_45_0 ) * tex2D( _Texture3, appendResult73.xy, float2( 0,0 ), float2( 0,0 ) ) ) + step( float4( 1,1,1,0 ) , temp_output_45_0 ) ) ).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
107;371;1698;336;2563.775;-1199.434;1.677433;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1780.339,908.8123;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;2;-1869.843,1518.904;Float;False;Property;_FlameFlicker_Speed;FlameFlicker_Speed;8;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1704.63,1367.92;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1629.684,1224.29;Float;False;Property;_Noise_Scale;Noise_Scale;6;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1555.339,1100.36;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-1545.916,947.8829;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1330.339,1043.36;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1421.937,1381.206;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;8;-1636.995,1556.307;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1613.077,1748.957;Float;False;Property;_Flicker_TimeScale;Flicker_TimeScale;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1486.798,1529.236;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-1458.36,1723.907;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1309.378,1252.692;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;14;-1250.076,1380.044;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;15;-1100.214,1484.312;Float;True;Property;_Noise;Noise;0;0;Create;True;0;0;False;0;ba8de44547793e14cbb75f66c36d544b;ba8de44547793e14cbb75f66c36d544b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;16;-788.0754,1671.655;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-871.0436,497.454;Float;False;Property;_Noise_scale;Noise_scale;4;0;Create;True;0;0;False;0;0.54;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-659.4666,-80.50107;Float;False;Property;_TimeScale_B;TimeScale_B;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-843.6125,647.5261;Float;False;Property;_PanningSpeed;PanningSpeed;3;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-688.0886,787.709;Float;False;Property;_TimeScale;TimeScale;2;0;Create;True;0;0;False;0;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-460.2911,1634.729;Float;False;2;0;FLOAT2;0.5,0.25;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-867.3126,351.2818;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-840.1377,130.6857;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;-1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-837.6876,234.7592;Float;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;1.22;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-964.3865,1166.826;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-390.2846,1255.635;Float;True;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-531.5687,29.36325;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-503.2329,-91.26511;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-477.7021,809.0735;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-553.2927,679.783;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-565.1428,258.4587;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-565.1428,515.2036;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-157.2422,1090.874;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;35;-218.1522,86.08309;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;-199.1953,677.2344;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;159.0783,719.1339;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;34;-392.3319,304.5347;Float;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;False;0;f87d8c8d5cc498648a4c4638e2198a53;f87d8c8d5cc498648a4c4638e2198a53;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;43.24204,385.9168;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;38;195.7765,473.1933;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;37;184.4757,162.0334;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;551.5018,124.7425;Float;True;Property;_TextureSample3;Texture Sample 3;11;0;Create;True;0;0;False;0;29fd089ec70863c4b8bbaad2f6854c1d;29fd089ec70863c4b8bbaad2f6854c1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;674.5016,-77.94115;Float;False;Constant;_Color2;Color 2;4;0;Create;True;0;0;False;0;0.6509434,0.6509434,0.6509434,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;581.1532,715.2979;Float;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;29fd089ec70863c4b8bbaad2f6854c1d;29fd089ec70863c4b8bbaad2f6854c1d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;555.0425,336.3997;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;761.0454,328.872;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;931.6812,102.1522;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;1101.674,282.6221;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;74;1300.208,25.36054;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;76;1391.972,-237.0546;Float;True;Property;_Texture3;Texture 3;12;0;Create;True;0;0;False;0;92ed0dec3122fc742a61517ba54e65bd;92ed0dec3122fc742a61517ba54e65bd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;1534.725,128.6349;Float;True;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;72;1829.041,-13.41006;Float;True;Property;_TextureSample5;Texture Sample 5;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;49;1768.851,389.1543;Float;True;2;0;COLOR;0.254717,0.254717,0.254717,0;False;1;COLOR;0.4339623,0.4339623,0.4339623,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;2162.465,208.0524;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;46;1732.647,622.1185;Float;True;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;82;2307.901,675.2025;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;2326.011,387.2148;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;83;2596.56,604.6829;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;2733.846,424.7416;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;368.1208,731.9078;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2922.576,265.1351;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Custom/Flame_V2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;1;1
WireConnection;3;1;1;2
WireConnection;10;0;3;0
WireConnection;10;1;4;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;8;0;2;0
WireConnection;13;0;8;0
WireConnection;13;1;8;0
WireConnection;12;0;7;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;14;0;11;0
WireConnection;14;2;13;0
WireConnection;14;1;12;0
WireConnection;15;1;14;0
WireConnection;16;0;15;0
WireConnection;18;1;16;0
WireConnection;19;0;17;2
WireConnection;19;1;18;0
WireConnection;19;2;17;2
WireConnection;30;1;22;0
WireConnection;33;0;26;0
WireConnection;29;0;24;0
WireConnection;31;1;27;0
WireConnection;28;0;23;0
WireConnection;28;1;21;0
WireConnection;32;0;21;0
WireConnection;32;1;25;0
WireConnection;20;0;17;0
WireConnection;20;1;19;0
WireConnection;35;0;28;0
WireConnection;35;2;30;0
WireConnection;35;1;33;0
WireConnection;36;0;32;0
WireConnection;36;2;31;0
WireConnection;36;1;29;0
WireConnection;54;0;36;0
WireConnection;54;1;20;0
WireConnection;55;0;35;0
WireConnection;55;1;20;0
WireConnection;38;0;34;0
WireConnection;38;1;54;0
WireConnection;37;0;34;0
WireConnection;37;1;55;0
WireConnection;41;1;20;0
WireConnection;42;1;20;0
WireConnection;39;0;37;0
WireConnection;39;1;38;0
WireConnection;43;0;39;0
WireConnection;43;1;42;0
WireConnection;44;0;40;0
WireConnection;44;1;41;0
WireConnection;45;0;44;0
WireConnection;45;1;43;0
WireConnection;74;0;45;0
WireConnection;73;0;74;0
WireConnection;72;0;76;0
WireConnection;72;1;73;0
WireConnection;49;1;45;0
WireConnection;77;0;49;0
WireConnection;77;1;72;0
WireConnection;46;1;45;0
WireConnection;78;0;77;0
WireConnection;78;1;46;0
WireConnection;83;0;82;0
WireConnection;84;0;83;0
WireConnection;84;1;78;0
WireConnection;0;2;84;0
ASEEND*/
//CHKSM=8573C4DCBACBE8CE017064C8ED39EA26C414FD54