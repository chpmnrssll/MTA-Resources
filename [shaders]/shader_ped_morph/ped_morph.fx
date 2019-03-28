//
// Example shader - ped_morph.fx
//

//---------------------------------------------------------------------
// Ped morph settings
//---------------------------------------------------------------------
float3 gMorphSize = float3(0,0,0);


//---------------------------------------------------------------------
// These parameters are set by MTA whenever a shader is drawn
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;

float gTime : TIME;



//------------------------------------------------------------------------------------------
// These parameters mirror the contents of the D3D regsiters.
// They are only relevent when using engineApplyShaderToWorldTexture.
//------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------
// renderState - String value should be one of D3DRENDERSTATETYPE without the D3DRS_  http://msdn.microsoft.com/en-us/library/bb172599%28v=vs.85%29.aspx
//------------------------------------------------------------------------------------------
float4 gGlobalAmbient       < string renderState="AMBIENT"; >;

int gSourceAmbient          < string renderState="AMBIENTMATERIALSOURCE"; >;
int gSourceDiffuse          < string renderState="DIFFUSEMATERIALSOURCE"; >;
int gSourceSpecular         < string renderState="SPECULARMATERIALSOURCE"; >;
int gSourceEmissive         < string renderState="EMISSIVEMATERIALSOURCE"; >;

int gLighting               < string renderState="LIGHTING"; >;


//------------------------------------------------------------------------------------------
// materialState - String value should be one of the members from D3DMATERIAL9  http://msdn.microsoft.com/en-us/library/bb172571%28v=VS.85%29.aspx
//------------------------------------------------------------------------------------------
float4 gMaterialAmbient     < string materialState="Ambient"; >;
float4 gMaterialDiffuse     < string materialState="Diffuse"; >;
float4 gMaterialSpecular    < string materialState="Specular"; >;
float4 gMaterialEmissive    < string materialState="Emissive"; >;
float gMaterialSpecPower    < string materialState="Power"; >;



//------------------------------------------------------------------------------------------
// structs for the vertex shader
//------------------------------------------------------------------------------------------
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
  float4 Specular : COLOR1;
  float2 TexCoords : TEXCOORD0;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PixelShaderInput VertexShaderFunction(VertexShaderInput input)
{
    PixelShaderInput output = (PixelShaderInput)0;

    // Do morph effect by adding surface normal to the vertex position
    input.Position += input.Normal * gMorphSize;

    // Calc screen pos of vertex
    float4 posWorld = mul(float4(input.Position,1), gWorld);
    float4 posWorldView = mul(posWorld, gView);
    output.Position = mul(posWorldView, gProjection);

    // Pass through tex coords
    output.TexCoords = input.TexCoords;

    // Calc GTA lighting for peds
    if ( !gLighting )
    {
        // If lighting render state is off, pass through the vertex color
        output.Diffuse = input.Diffuse;
    }
    else
    {
        // If lighting render state is on, calculate diffuse color by doing what D3D usually does
        float4 ambient  = gSourceAmbient  == 0 ? gMaterialAmbient  : input.Diffuse;
        float4 diffuse = gSourceDiffuse == 0 ? gMaterialDiffuse : input.Diffuse;
        float4 emissive = gSourceEmissive == 0 ? gMaterialEmissive : input.Diffuse;

        output.Diffuse = gGlobalAmbient * saturate( ambient + emissive );
        output.Diffuse.a *= diffuse.a;
    }

    return output;
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
    }
}


technique fallback
{
    pass P0
    {
    }
}
