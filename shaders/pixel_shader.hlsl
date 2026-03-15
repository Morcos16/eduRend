cbuffer CameraLightBuffer : register(b0)
{
	float4 CameraPos;
	float4 LightPos;
};

cbuffer PhongBuffer : register(b1)
{
    float4 AmbientColor;
    float4 DiffuseColor;
    float4 SpecularColor;
    float AmbientAmmount;
    float DiffuseAmmount;
    float SpecularAmmount;
    float Shininess;
};

Texture2D texDiffuse : register(t0);

struct PSIn
{
	float4 Pos  : SV_Position;
	float3 Normal : NORMAL;
	float2 TexCoord : TEX;
    float4 Pos3D : TEXCOORD;
};

//-----------------------------------------------------------------------------------------
// Pixel Shader
//-----------------------------------------------------------------------------------------

float4 PS_main(PSIn input) : SV_Target
{
	// Debug shading #1: map and return normal as a color, i.e. from [-1,1]->[0,1] per component
	// The 4:th component is opacity and should be = 1
	//return float4(input.Normal*0.5+0.5, 1);
    
    //ambient
    float3 color = AmbientColor.rgb * AmbientAmmount;
    
    //diffuse
    float3 N = normalize(input.Normal);
    float3 L = normalize(LightPos.xyz - input.Pos3D.xyz);
    color += DiffuseColor.rgb * DiffuseAmmount * max(0, dot(N, L));
    
    //specular
    float3 V = normalize(CameraPos.xyz - input.Pos3D.xyz);
    float3 R = reflect(-L, N);
    color += SpecularColor.rgb * SpecularAmmount * pow(max(0, dot(V, R)), Shininess);
    
    
	return float4(color, 1);
	
	// Debug shading #2: map and return texture coordinates as a color (blue = 0)
//return float4(input.TexCoord, 0, 1);
}
