
//---------------------------------------------------------------------
// Car paint settings
//---------------------------------------------------------------------
texture reflection_Tex;

//---------------------------------------------------------------------
// These parameters are set by MTA whenever a shader is drawn
//---------------------------------------------------------------------
float4x4 gWorld : WORLD;
float4x4 gView : VIEW;
float4x4 gProjection : PROJECTION;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;

float3 gCameraPosition : CAMERAPOSITION;

float gTime : TIME;

float4 gLightAmbient : LIGHTAMBIENT;
float4 gLightDiffuse : LIGHTDIFFUSE;
float4 gLightSpecular : LIGHTSPECULAR;
float3 gLightDirection : LIGHTDIRECTION;


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
// textureState - String value should be a texture number followed by 'Texture'
//------------------------------------------------------------------------------------------
texture gTexture0           < string textureState="0,Texture"; >;

//------------------------------------------------------------------------------------------
// Samplers for the textures
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

samplerCUBE reflectionMapCube = sampler_state
{
   Texture = (reflection_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   AddressU = Mirror;
   //AddressV = Mirror;
   Filter = ANISOTROPIC;
   MIPMAPLODBIAS = 16;
};


//---------------------------------------------------------------------
// Structure of data sent to the vertex and pixel shaders
//---------------------------------------------------------------------
struct VertexShaderInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord0 : TEXCOORD0;
};

struct PixelShaderInput
{
    float4 Pos  : POSITION;
    float4 Diffuse : COLOR0;
    float2 Tex : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 NormalSurf : TEXCOORD4;
    float3 View : TEXCOORD5;
    float3 SparkleTex : TEXCOORD6;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PixelShaderInput VertexShaderFunction(VertexShaderInput In)
{
    PixelShaderInput Out = (PixelShaderInput)0;

    // Transform postion
    Out.Pos = mul(float4(In.Position, 1), gWorldViewProjection);
    float3 worldPosition = mul(float4(In.Position, 1), (float4x3)gWorld);
    float3 viewDirection = normalize(gCameraPosition - worldPosition);

    // Fake tangent and binormal
    float3 Tangent = In.Normal.yxz;
    Tangent.xz = In.TexCoord0.xy;
    float3 Binormal = -normalize( cross(Tangent, In.Normal) );
    Tangent = normalize( cross(Binormal, In.Normal) );

    // Transfer some stuff
    Out.Tex = In.TexCoord0;
    Out.Tangent = normalize( mul(Tangent, (float3x3)gWorld) );
    Out.Binormal = normalize( mul(Binormal, (float3x3)gWorld) );
    Out.Normal = normalize( mul(In.Normal, (float3x3)gWorld) );
    Out.NormalSurf = In.Normal;
    Out.View = viewDirection;
	
    // Calc lighting
    {
        float4 ambient  = gSourceAmbient  == 0 ? gMaterialAmbient  : In.Diffuse;
        float4 diffuse  = gSourceDiffuse  == 0 ? gMaterialDiffuse  : In.Diffuse;
        float4 emissive = gSourceEmissive == 0 ? gMaterialEmissive : In.Diffuse;

        float4 TotalAmbient = ambient * ( gGlobalAmbient + gLightAmbient );

	    float DirectionFactor = max(0,dot(Out.Normal, -gLightDirection ));
        float4 TotalDiffuse = ( diffuse * gLightDiffuse * DirectionFactor );

        Out.Diffuse = saturate(TotalDiffuse + TotalAmbient + emissive);
        Out.Diffuse.a *= diffuse.a;
    }

    return Out;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PixelShaderInput In) : COLOR0
{
    float4 OutColor = 1;

    // Some settings for something or another
    float brightnessFactor = 0.1;
	
    // The view vector (which is currently in world space) needs to be normalized.
    // This vector is normalized in the pixel shader to ensure higher precision of
    // the resulting view vector. For this highly detailed visual effect normalizing
    // the view vector in the vertex shader and simply interpolating it is insufficient
    // and produces artifacts.
    float3 vView = normalize(In.View);

    // Transform the surface normal into world space (in order to compute reflection
    // vector to perform environment map look-up):
    float3x3 mTangentToWorld = transpose( float3x3( In.Tangent, In.Binormal, In.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, In.Normal ));
	
    // Compute reflection vector resulted from the clear coat of paint on the metallic
    // surface:
    float fNdotV = saturate(dot( vNormalWorld, vView));
    float3 vReflection = vNormalWorld * fNdotV - vView;

    // Sample environment map using this reflection vector:
    float4 envMap = texCUBE( reflectionMapCube, vReflection );

    // Premultiply by alpha:
    envMap.rgb = envMap.rgb * envMap.rgb * envMap.rgb;

    // Brighten the environment map sampling result:
    envMap.rgb *= brightnessFactor;

    // Combine result of environment map reflection with the paint color:
    float fEnvContribution = 1.0 - 0.5 * fNdotV;

    float4 finalColor;
	finalColor = envMap * fEnvContribution + gMaterialAmbient;
    finalColor.a = 1.0;

    // Bodge in the car colors
    float4 Color = 1;
    Color = finalColor / 1 + In.Diffuse * 0.5;
    Color += finalColor * In.Diffuse;
    Color.a = In.Diffuse.a;
    return Color;
}

//-----------------------------------------------------------------------------
// Techniques
//-----------------------------------------------------------------------------
technique carpaint
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}


technique fallback
{
    pass P0
    {
    }
}
