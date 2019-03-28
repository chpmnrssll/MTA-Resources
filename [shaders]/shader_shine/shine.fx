float3 gLightPos = float3(0,0,0);
float gLightAmount = 16.0;

int CUSTOMFLAGS
<
string createNormals = "yes";     // Some models do not have normals by default. Setting this to 'yes' will add them to the VertexShaderInput as NORMAL0
>;

//---------------------------------------------------------------------
// These parameters are set by MTA whenever a shader is drawn
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float3 gCameraPos : CAMERAPOSITION;

//-------------------------------------------------------------------------------------------------------------------------------------------------------
// renderState - String value should be one of D3DRENDERSTATETYPE without the D3DRS_  http://msdn.microsoft.com/en-us/library/bb172599%28v=vs.85%29.aspx
//-------------------------------------------------------------------------------------------------------------------------------------------------------
float4 gGlobalAmbient       < string renderState="AMBIENT"; >;
int gSourceAmbient          < string renderState="AMBIENTMATERIALSOURCE"; >;
int gSourceDiffuse          < string renderState="DIFFUSEMATERIALSOURCE"; >;
int gSourceSpecular         < string renderState="SPECULARMATERIALSOURCE"; >;
int gSourceEmissive         < string renderState="EMISSIVEMATERIALSOURCE"; >;
int gLighting               < string renderState="LIGHTING"; >;

//-------------------------------------------------------------------------------------------------------------------------------------------------
// materialState - String value should be one of the members from D3DMATERIAL9  http://msdn.microsoft.com/en-us/library/bb172571%28v=VS.85%29.aspx
//-------------------------------------------------------------------------------------------------------------------------------------------------
float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;

//------------------------------------------------------------------------------------------
// textureState - String value should be a texture number followed by 'Texture'
//------------------------------------------------------------------------------------------
texture gTexture0           < string textureState="0,Texture"; >;

sampler texsampler = sampler_state
{
	Texture = (gTexture0);
};

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float3 Normal : NORMAL0;
	float4 Diffuse : COLOR0;
	float2 TexCoords : TEXCOORD0;
};

struct PixelShaderInput
{
	float4 Position : POSITION0;
	float4 Diffuse : COLOR0;
	float2 TexCoords : TEXCOORD0;
	float3 Normal : TEXCOORD1;
	float3 WorldPos : TEXCOORD2;
};

PixelShaderInput VertexShaderFunction(VertexShaderInput input)
{
	PixelShaderInput output = (PixelShaderInput)0;
	
	float4 posWorld = mul(float4(input.Position,1), gWorld);
	float4 posWorldView = mul(posWorld, gView);
	output.Position = mul(posWorldView, gProjection);
	output.TexCoords = input.TexCoords;
	output.WorldPos = posWorld.xyz;
	
	if(!gLighting)
	{
		output.Diffuse = input.Diffuse;
	}
	else
	{
		float4 ambient  = gSourceAmbient  == 0 ? gMaterialAmbient  : input.Diffuse;
		float4 diffuse  = gSourceDiffuse  == 0 ? gMaterialDiffuse  : input.Diffuse;
		float4 emissive = gSourceEmissive == 0 ? gMaterialEmissive : input.Diffuse;
		output.Diffuse = gGlobalAmbient * saturate(ambient + emissive);
		output.Diffuse.a *= diffuse.a;
	}
	
	return output;
}

float4 PixelShaderFunction(PixelShaderInput input) : COLOR0
{
	float dist = distance(gLightPos, input.WorldPos) / gLightAmount;
	float4 texel = tex2D(texsampler, input.TexCoords);
	float4 finalColor = texel * input.Diffuse;
	finalColor /= max(dist, 1);
	
	return finalColor;
}

technique tec0
{
	pass P0
	{
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique fallback
{
	pass P0
	{
		// Just draw normally
	}
}
