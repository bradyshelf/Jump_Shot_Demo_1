draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// Center of the screen
var screen_center_x = display_get_gui_width() / 2;
var screen_center_y = display_get_gui_height() / 2;

// Total height of the menu
var total_menu_height = menu_itemheight * 1 * menu_items;

// Adjust the starting Y to center the whole menu
var start_y = screen_center_y - (total_menu_height / 2) + 125;

for (var i = 0; i < menu_items; i++)
{
    var txt = menu[i];
    var col;
    var font_to_use = fMenu;

    if (menu_cursor == i)
    {
        txt = string_insert("", txt, 0); // Optional bullet
		col = make_color_rgb(255, 85, 0);
    }
    else
    {
     col = make_color_rgb(255, 200, 0)
    }

    if (i == 1)
    {

    yy += 20; 

        font_to_use = fMenuSmall; // Use smaller font for index 1
    }

    var xx = screen_center_x;
    var yy = start_y + (menu_itemheight * 1* i);

    draw_set_font(font_to_use);

    // BACKDROP TEXT (shadow or outline)
    draw_set_color(make_color_rgb(128, 0, 128)); // You could also use make_color_rgba(0,0,0,160) for semi-transparent
    draw_text(xx + 2.5, yy + 2.5, txt); // Offset slightly to bottom right for shadow

    // MAIN TEXT
    draw_set_color(col);
    draw_text(xx, yy, txt);
}
