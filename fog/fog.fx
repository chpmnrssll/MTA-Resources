float fogStart = 0;
float fogEnd = 3000;

technique simple
{
	pass P0 {
		FogStart = fogStart;
		FogEnd = fogEnd;
	}
}
