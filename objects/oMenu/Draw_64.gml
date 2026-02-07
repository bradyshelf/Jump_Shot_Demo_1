// --- ALIGNMENT SETTINGS ---
if (gamepad_is_connected(0)|| gamepad_is_connected(4)) && (gamepad_is_connected(1)|| gamepad_is_connected(5)) {
draw_set_halign(fa_left); // We manually center using string_width
draw_set_valign(fa_bottom);

// --- SCREEN CENTER (GUI) ---
var screen_center_x = display_get_gui_width() / 2;
var screen_center_y = display_get_gui_height() / 2;

// --- MENU POSITIONING ---
var total_menu_height = menu_itemheight * menu_items;
var start_y = screen_center_y - (total_menu_height / 2) + 70;

// --- DRAW MENU ITEMS ---
for (var i = 0; i < menu_items; i++)
{
    var txt = menu[i];
    var col;
    var font_to_use = fMenu;

    // --- FONT SELECTION ---
    if (i == 1)
    {
        font_to_use = fMenuSmall;
    }

    draw_set_font(font_to_use);

    // --- TEXT COLOR BASED ON SELECTION ---
    if (menu_cursor == i)
    {
        col = make_color_rgb(255,150, 0); // Selected
    }
    else
    {
        col = make_color_rgb(220, 220, 150); // Default
    }

    // --- POSITION CALCULATION ---
    var yy = start_y + (menu_itemheight * i);
    var text_width = string_width(txt);
    var xx = screen_center_x - (text_width / 2) +5// Center manually

    // --- BACKDROP SHADOW ---
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_text(xx + 2.5, yy + 2.5, txt);

    // --- MAIN TEXT ---
    draw_set_color(col);
    draw_text(xx, yy, txt);
}
}