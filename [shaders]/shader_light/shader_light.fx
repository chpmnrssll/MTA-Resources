// Road shine settings
float3 gLightDir = float3(0.507,-0.507,-0.2);
float3 gLightColor = float3(1,1,1);
float gSpecularPower = 16;
texture reflection_Tex;

// Flags for MTA to do something about
int CUSTOMFLAGS			< string createNormals = "yes"; >;		// Some models do not have normals by default. Setting this to 'yes' will add them to the VertexShaderInput as NORMAL0

// These parameters are set by MTA whenever a shader is drawn
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float3 gCameraPos : CAMERAPOSITION;

// renderState - String value should be one of D3DRENDERSTATETYPE without the D3DRS_  http://msdn.microsoft.com/en-us/library/bb172599%28v=vs.85%29.aspx
float4 gGlobalAmbient	< string renderState="AMBIENT"; >;
int gSourceAmbient		< string renderState="AMBIENTMATERIALSOURCE"; >;
int gSourceDiffuse		< string renderState="DIFFUSEMATERIALSOURCE"; >;
int gSourceSpecular		< string renderState="SPECULARMATERIALSOURCE"; >;
int gSourceEmissive		< string renderState="EMISSIVEMATERIALSOURCE"; >;
int gLighting			< string renderState="LIGHTING"; >;

// materialState - String value should be one of the members from D3DMATERIAL9  http://msdn.microsoft.com/en-us/library/bb172571%28v=VS.85%29.aspx
float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;

// textureState - String value should be a texture number followed by 'Texture'
texture gTexture0			< string textureState="0,Texture"; >;


// Samplers for textures
sampler texsampler = sampler_state {
	Texture = (gTexture0);
};

samplerCUBE reflectionMapCube = sampler_state
{
   Texture = (reflection_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   AddressU = Mirror;
   AddressV = Mirror;
   Filter = ANISOTROPIC;
   MIPMAPLODBIAS = 16;
};

// Structures for vertex and pixel shader data
struct VertexShaderInput {
	float3 Position : POSITION0;
	float3 Normal : NORMAL0;
	float4 Diffuse : COLOR0;
	float2 TexCoords : TEXCOORD0;
};

struct PixelShaderInput {
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float2 TexCoords : TEXCOORD0;
	float3 Normal : TEXCOORD1;
	float3 WorldPos : TEXCOORD2;
    float3 Tangent : TEXCOORD3;
    float3 Binormal : TEXCOORD4;
    float3 NormalSurf : TEXCOORD5;
    float3 View : TEXCOORD6;
};

// VertexShaderFunction
PixelShaderInput VertexShaderFunction(VertexShaderInput input) {
	PixelShaderInput output = (PixelShaderInput)0;
	
	// Incase we have no normal inputted
	if(length(input.Normal) == 0)
		input.Normal = float3(0,0,1);
	
	// Calc screen pos of vertex
	float4 posWorld = mul(float4(input.Position,1), gWorld);
	float4 posWorldView = mul(posWorld, gView);
	output.Position = mul(posWorldView, gProjection);
	
    // Fake tangent and binormal
    float3 Tangent = input.Normal.yxz;
    Tangent.xz = input.TexCoords.xy;
    float3 Binormal = normalize( cross(Tangent, input.Normal) );
    Tangent = normalize( cross(Binormal, input.Normal) );

	// Pass through tex coords
	output.TexCoords = input.TexCoords;
	
	// Set information to do specular calculation in pixel shader
	output.Normal = mul(input.Normal, (float3x3)gWorld);
	output.WorldPos = posWorld.xyz;
	
    output.Tangent = normalize( mul(Tangent, (float3x3)gWorld) );
    output.Binormal = normalize( mul(Binormal, (float3x3)gWorld) );
    output.NormalSurf = input.Normal;
    output.View = posWorldView;
	
	// Calc GTA lighting for buildings
	if(!gLighting) {
		// If lighting render state is off, pass through the vertex color
		output.Diffuse = input.Diffuse;
	} else {
		// If lighting render state is on, calculate diffuse color by doing what D3D usually does
		float4 ambient  = gSourceAmbient  == 0 ? gMaterialAmbient  : input.Diffuse;
		float4 diffuse  = gSourceDiffuse  == 0 ? gMaterialDiffuse  : input.Diffuse;
		float4 emissive = gSourceEmissive == 0 ? gMaterialEmissive : input.Diffuse;
		output.Diffuse = gGlobalAmbient * saturate(ambient + emissive);
		output.Diffuse.a *= diffuse.a;
	}
	
	return output;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PixelShaderInput input) : COLOR0 {
	float brightnessFactor = 0.1;
	
	// Get texture pixel
	float4 texel = tex2D(texsampler, input.TexCoords);
	
	// Apply diffuse lighting
	float4 finalColor = input.Diffuse;
	
	float3 vView = -normalize(input.View);
    float3x3 mTangentToWorld = transpose( float3x3( input.Tangent, input.Binormal, input.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, input.Normal ));
    float fNdotV = saturate(dot( vNormalWorld, vView));
    float3 vReflection = (vNormalWorld * fNdotV - vView);
	
	float4 envMap = texCUBE( reflectionMapCube, vReflection);
	envMap += texCUBE( reflectionMapCube, vReflection - 0.5);
	envMap += texCUBE( reflectionMapCube, vReflection + 0.5);
	envMap /= 3;
	envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;
	envMap.rgb *= brightnessFactor;
	
	float fEnvContribution = 1.0 - 0.5 * fNdotV;
	envMap *= fEnvContribution + input.Diffuse;
	
	// Specular calculation
	float3 lightDir = normalize(gLightDir);
	
	// Using Blinn half angle modification for performance over correctness
	float3 h = normalize(normalize(gCameraPos - input.WorldPos) - lightDir);
	float specLighting = pow(saturate(dot(h, input.Normal)), gSpecularPower);
	
	// Apply specular
	finalColor += input.Diffuse + envMap * fEnvContribution;
	//finalColor.rgb += (specLighting * gLightColor * texel.rgb) * 0.5;
	finalColor.rgb += (specLighting * gLightColor) * 0.5;
	finalColor.a *= texel.a;
	
	return finalColor;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0 {
	pass P0 {
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

// Fallback
technique fallback {
	pass P0{
		// Just draw normally
	}
}
