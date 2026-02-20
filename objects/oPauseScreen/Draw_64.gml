// --- ALIGNMENT SETTINGS ---
draw_set_halign(fa_center);  // We'll center manually
draw_set_valign(fa_middle);

// --- SCREEN CENTER (GUI) ---
var screen_center_x = display_get_gui_width() / 2;
var screen_center_y = display_get_gui_height() / 2;

// --- MENU LAYOUT SETTINGS ---
var menu_padding = 40;             // space *between* items (tweak this)
var total_menu_height = (menu_itemheight + menu_padding) * menu_items - menu_padding;
var start_y = screen_center_y - (total_menu_height / 2) + 20;  // slight downward shift

// --- DRAW MENU ITEMS ---
for (var i = 0; i < menu_items; i++)
{
    var txt = menu[i];
    var col;
    var font_to_use = fMenu;

    // --- FONT SELECTION ---
    if (i == 1)
        font_to_use = fMenuSmall;

    draw_set_font(font_to_use);

    // --- TEXT COLOR BASED ON SELECTION ---
    if (menu_cursor == i)
        col = make_color_rgb(255,150,0);  // Selected
    else
        col = make_color_rgb(220,220,150); // Default

    // --- POSITION CALCULATION ---
    var yy = start_y + i * (menu_itemheight + menu_padding);
    var text_width = string_width(txt);
    var xx = screen_center_x-20; // Manual centering

    // --- BACKDROP SHADOW ---
    draw_set_color(make_color_rgb(0,0,0));
    draw_text(xx + 2, yy + 2, txt);

    // --- MAIN TEXT ---
    draw_set_color(col);
    draw_text(xx, yy, txt);
}
