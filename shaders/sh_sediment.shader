//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 fragCoord;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    
    fragCoord = in_Position.xy;
}


//######################_==_YOYO_SHADER_MARKER_==_######################@~//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 fragCoord;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    vec3 col1 = vec3(94.0/255.0, 76.0/255.0, 59.0/255.0);
    vec3 col2 = vec3(255.0/255.0, 218.0/255.0, 183.0/255.0);
    vec3 col3 = vec3(173.0/255.0, 63.0/255.0, 12.0/255.0);
    vec3 col4 = vec3(135.0/255.0, 73.0/255.0, 58.0/255.0);
    
    gl_FragColor.r = sin(fragCoord.y/15.0-sin(fragCoord.x/30.0)/8.0);
    if (gl_FragColor.r > 0.75){gl_FragColor.rgb = col2;}else{
    if (gl_FragColor.r > 0.50){gl_FragColor.rgb = col3;}else{
    if (gl_FragColor.r > 0.25){gl_FragColor.rgb = col1;}else{
    if (gl_FragColor.r < 0.25){gl_FragColor.rgb = col4;}}}}
    
}

