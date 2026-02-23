// --- ALIGNMENT SETTINGS ---
draw_set_halign(fa_left);   // Align text to the left
draw_set_valign(fa_bottom); // Align text to the bottom

// --- SCREEN OFFSET (BOTTOM-LEFT) ---
var margin_x = 20;          // Distance from left edge
var margin_y = 20;          // Distance from bottom edge

// --- MENU POSITIONING ---
var total_menu_height = menu_itemheight * menu_items;
var start_y = display_get_gui_height() - margin_y - total_menu_height;

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
        col = make_color_rgb(50, 255, 40); // Selected
    }
    else
    {
        col = make_color_rgb(200, 150, 0); // Not selected
    }

    // --- POSITION CALCULATION ---
    var xx = margin_x; // Left-aligned
    var yy = start_y + ((menu_itemheight + 20) * i);

    // --- BACKDROP SHADOW ---
    draw_set_color(c_teal);
    draw_text(xx + 2, yy + 2, txt);

    // --- MAIN TEXT ---
    draw_set_color(col);
    draw_text(xx, yy, txt);
}