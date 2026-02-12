

window_set_fullscreen(true);
last_hovered = -1

#macro SAVEFILE "Save.sav"

global.fullscreen = true;

gui_height = display_get_gui_height();
gui_width = display_get_gui_width();
gui_margin = 32;

menu_x = gui_width;
menu_y = gui_height - gui_margin;
menu_x_target = gui_width - gui_margin;
menu_speed = 25;
menu_font = fMenu;
menu_itemheight = font_get_size(fMenu);
menu_committed = -1;
menu_control = true;


menu[0] = "PLAY";
menu[1] = "QUIT";

menu_items = array_length(menu);

menu_top = menu_y -((menu_itemheight * 1.5) * menu_items);

menu_cursor = 2;


