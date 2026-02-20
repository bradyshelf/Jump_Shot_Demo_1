// Draw animation in the center of the screen (or anywhere you want)
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
draw_sprite_ext(sprite_index, image_index, gui_w/2, gui_h/2, 1, 1, 0, c_white, 1);