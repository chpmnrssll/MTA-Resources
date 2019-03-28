//-- Declare the textures. These are set using dxSetShaderValue( shader, "Tex0", texture )
texture Tex0;
texture Tex1;
 
//-- Very simple technique
technique complercated
{
    pass P0
    {
        //-- Set up texture stage 0
        //Texture[0] = Tex0;
        //ColorOp[0] = Dotproduct3;
		//ColorOp[0] = Disable;
        //ColorArg1[0] = Texture;
        //AlphaOp[0] = 6;
        //AlphaArg1[0] = Tex0;
		
		AlphaBlendEnable = True;
		//Ambient = float4(1.0f, 0.0f, 0.0f, 1.0f);
		//FogColor = 0x00FF00;
		
    }
}
