float FurLength = 0;
float UVScale   = 1.0f;
float Layer     = 0;		//0 to 1 for the level
const float3 vGravity = float3(0,-2.0,0);
const float4 vecLightDir = float4(0.8,0.8,1,0);
texture FurTexture;

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
sampler TextureSampler = sampler_state {
	Texture = (gTexture0);
};

// Structures for vertex and pixel shader data
struct VertexShaderInput {
	float4 Position : POSITION0;
	float4 Normal : NORMAL0;
	float4 TexCoord : TEXCOORD0;
};

struct PixelShaderInput {
	float4 Position : POSITION0;
	float4 To : TEXCOORD0;		//Fur alpha
	float4 Normal : TEXCOORD1;
	float2 TexCoords : TEXCOORD2;
};

PixelShaderInput VertexShaderFunction(VertexShaderInput input) {
	PixelShaderInput output = (PixelShaderInput)0;
	
	//This single line is responsible for creating the layers!  This is it! Nothing more nothing less!
	float4 P = input.Position + (input.Normal * FurLength);
	
	//Modify our normal so it faces the correct direction for lighting if we want any lighting
	float4 normal = normalize(mul(input.Normal, gWorld));
	
	// Couple of lines to give a swaying effect! Additional Gravity/Force Code
	/*
	vGravity = mul(vGravity, gWorld);
	float k =  pow(Layer, 3);	// We use the pow function, so that only the tips of the hairs bend
								// As layer goes from 0 to 1, so by using pow(..) function is still
								// goes form 0 to 1, but it increases faster! exponentially
	P = P + vGravity*k;
	*/
	// End Gravity Force Addit Code
	
	output.To = input.TexCoord * UVScale;	// Pass long texture data
	// UVScale??  Well we scale the fur texture alpha coords so this effects the fur thickness
	// thinness, sort of stretches or shrinks the fur over the object!
	
	//output.Position = mul(float4(P, 1.0f), gView);		// Output Vertice Position Data
	output.Position = mul(P, gView);		// Output Vertice Position Data
	output.Normal = normal;		// Output Normal
	
	output.TexCoords = input.TexCoord;
	return output;
}

float4 PixelShaderFunction(PixelShaderInput input) : COLOR0 {
	float4 FurColour = tex2D( TextureSampler, input.TexCoords);	// Fur Texture - alpha is VERY IMPORTANT!
	float4 FinalColour = FurColour;
	
	//Basic Directional Lighting
	float4 ambient = {0.3, 0.3, 0.3, 0.0};
	ambient = ambient * FinalColour;
	float4 diffuse = FinalColour;
	FinalColour = ambient + diffuse * dot(vecLightDir, input.Normal);
	//End Basic Lighting Code
	
	FinalColour.a = FurColour.a;
	//return FinalColour;      // fur colour only!
	return FinalColour;       // Use texture colour
	//return float4(0,0,0,0); // Use for totally invisible!  Can't see
}

technique tec0 {
	pass P0 {
		VertexShader = compile vs_2_0 VertexShaderFunction();
		PixelShader = compile ps_2_0 PixelShaderFunction();
	}
}

technique fallback {
	pass P0{
	}
}
