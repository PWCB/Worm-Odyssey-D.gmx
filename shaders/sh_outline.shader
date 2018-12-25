//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
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
    float ww = 1.0/1024.0;
    float hh = 1.0/768.0;
    vec2 c1 = vec2(v_vTexcoord.x + ww, v_vTexcoord.y);//right
    vec2 c2 = vec2(v_vTexcoord.x + ww, v_vTexcoord.y - hh);//upright
    vec2 c3 = vec2(v_vTexcoord.x, v_vTexcoord.y - hh);//upmid
    vec2 c4 = vec2(v_vTexcoord.x - ww, v_vTexcoord.y - hh);//upleft
    vec2 c5 = vec2(v_vTexcoord.x - ww, v_vTexcoord.y);//left
    vec2 c6 = vec2(v_vTexcoord.x - ww, v_vTexcoord.y + hh);//downleft
    vec2 c7 = vec2(v_vTexcoord.x, v_vTexcoord.y + hh);//downmid
    vec2 c8 = vec2(v_vTexcoord.x + ww, v_vTexcoord.y + hh);//downright
    
    float i1 = (texture2D(gm_BaseTexture, c1).r + texture2D(gm_BaseTexture, c1).g + texture2D(gm_BaseTexture, c1).b)/3.0;
    float i2 = (texture2D(gm_BaseTexture, c2).r + texture2D(gm_BaseTexture, c2).g + texture2D(gm_BaseTexture, c2).b)/3.0;
    float i3 = (texture2D(gm_BaseTexture, c3).r + texture2D(gm_BaseTexture, c3).g + texture2D(gm_BaseTexture, c3).b)/3.0;
    float i4 = (texture2D(gm_BaseTexture, c4).r + texture2D(gm_BaseTexture, c4).g + texture2D(gm_BaseTexture, c4).b)/3.0;
    float i5 = (texture2D(gm_BaseTexture, c5).r + texture2D(gm_BaseTexture, c5).g + texture2D(gm_BaseTexture, c5).b)/3.0;
    float i6 = (texture2D(gm_BaseTexture, c6).r + texture2D(gm_BaseTexture, c6).g + texture2D(gm_BaseTexture, c6).b)/3.0;
    float i7 = (texture2D(gm_BaseTexture, c7).r + texture2D(gm_BaseTexture, c7).g + texture2D(gm_BaseTexture, c7).b)/3.0;
    float i8 = (texture2D(gm_BaseTexture, c8).r + texture2D(gm_BaseTexture, c8).g + texture2D(gm_BaseTexture, c8).b)/3.0;
    
    float i = (abs(i1 - i5) + abs(i2 - i6) + abs(i3 - i7) + abs(i4 - i8))/4.0;
    
    //float tol = 2.0;
    //gl_FragColor.rgb = vec3(ceil(gl_FragColor.r*i*tol)/tol, ceil(gl_FragColor.g*i*tol)/tol, ceil(gl_FragColor.b*i*tol)/tol);
    float thresh = 0.1;
    vec3 irgb = vec3(gl_FragColor.r*i, gl_FragColor.g*i, gl_FragColor.b*i);
    if (irgb.r > thresh){irgb.r = 1.0;}else{irgb.r = 0.0;}
    if (irgb.g > thresh){irgb.g = 1.0;}else{irgb.g = 0.0;}
    if (irgb.b > thresh){irgb.b = 1.0;}else{irgb.b = 0.0;}
    float iavg = (irgb.r + irgb.g + irgb.b)/3.0;
    gl_FragColor.rgb = vec3(iavg, iavg, iavg);
}

