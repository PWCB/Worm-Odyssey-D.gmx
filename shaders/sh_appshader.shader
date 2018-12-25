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

uniform float u_width;
uniform float u_height;
vec2 res = vec2(u_width, u_height);
vec2 res2 = vec2( 16.0, 16.0 );
uniform sampler2D u_ditherTex;

//the dithering texture should contain the full spectrum of values in the least uniform order
//each pixel should be surrounded by the value least like itself

//8 color palette (edit)
vec3 col0 = vec3( 0.0, 0.0, 0.0 ); //black
vec3 col1 = vec3( 0.0, 0.0, 1.0 ); //blue
vec3 col2 = vec3( 1.0, 0.0, 0.0 ); //red
vec3 col3 = vec3( 1.0, 0.0, 1.0 ); //magenta
vec3 col4 = vec3( 0.0, 1.0, 0.0 ); //green
vec3 col5 = vec3( 0.0, 1.0, 1.0 ); //cyan
vec3 col6 = vec3( 1.0, 1.0, 0.0 ); //yellow
vec3 col7 = vec3( 1.0, 1.0, 1.0 ); //white


//original palette (don't edit)
vec3 ocol0 = vec3( 0.0, 0.0, 0.0 ); //black
vec3 ocol1 = vec3( 0.0, 0.0, 1.0 ); //blue
vec3 ocol2 = vec3( 1.0, 0.0, 0.0 ); //red
vec3 ocol3 = vec3( 1.0, 0.0, 1.0 ); //magenta
vec3 ocol4 = vec3( 0.0, 1.0, 0.0 ); //green
vec3 ocol5 = vec3( 0.0, 1.0, 1.0 ); //cyan
vec3 ocol6 = vec3( 1.0, 1.0, 0.0 ); //yellow
vec3 ocol7 = vec3( 1.0, 1.0, 1.0 ); //white

float roundupto( float num, float n ) {
    return num - mod(num, n);
}

//((75*2) - ((75*2) mod (50))) - ((75) - ((75) mod (50)))
float roundto( float num, float n ) {
    n = clamp(n, 0.0001, 1.0/0.0001);
    return ((num*2.0 - mod(num*2.0, n)) - (num - mod(num, n)));
}

float dither( vec2 pos, float brightness ) {
    pos.x -= roundupto(pos.x, 1.0);
    pos.y -= roundupto(pos.y, 1.0);
    float bayer = texture2D(u_ditherTex, pos).r;
    bayer = pow(abs(bayer), 1.2); //Gamma correction
    return step(bayer, brightness);
}

vec3 colorswap( vec3 col ) {
    if (col == ocol0){col = col0;}
    if (col == ocol1){col = col1;}
    if (col == ocol2){col = col2;}
    if (col == ocol3){col = col3;}
    if (col == ocol4){col = col4;}
    if (col == ocol5){col = col5;}
    if (col == ocol6){col = col6;}
    if (col == ocol7){col = col7;}
    return col;
}

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    vec3 orgb = vec3(gl_FragColor.r, gl_FragColor.g, gl_FragColor.b);
    
    vec2 posi = fragCoord/8.0;
    
    gl_FragColor.r = dither(posi, gl_FragColor.r);
    gl_FragColor.g = dither(posi, gl_FragColor.g);
    gl_FragColor.b = dither(posi, gl_FragColor.b);
    
    gl_FragColor.rgb = colorswap(gl_FragColor.rgb);
    
    
    gl_FragColor.rgb = (orgb.rgb*3.0 + gl_FragColor.rgb*1.0)/4.0;
}
