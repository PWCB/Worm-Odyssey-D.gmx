///draw_text_pop(x, y, str, color)
var xx = argument0, yy = argument1, str = argument2, colr = argument3, w = 3;
draw_set_color(c_black);
draw_text(xx-w, yy, str);
draw_text(xx+w, yy, str);
draw_text(xx, yy-w, str);
draw_text(xx, yy+w+(w/2), str);
draw_text(xx, yy+w, str);
draw_set_color(colr);
draw_set_alpha(0.6);
draw_text(xx, yy+1, str);
draw_set_alpha(1);
draw_text(xx, yy, str);
draw_set_color(c_white);
