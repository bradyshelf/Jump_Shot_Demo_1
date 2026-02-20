// === Boss Health Bar ===

// Get HP values
var hp_max = 10; // change to your boss's max HP
var hp_current = hp; // your existing hp variable

// --- Health bar position and size ---
var bar_width  = 400;
var bar_height = 30;
var bar_x = (display_get_gui_width() / 2) - (bar_width / 2);
var bar_y = 50;

// --- Outline ---
draw_set_color(c_black);
draw_rectangle(bar_x - 2, bar_y - 2, bar_x + bar_width + 2, bar_y + bar_height + 2, false);

// --- Background (empty part) ---
draw_set_color(make_color_rgb(60, 0, 200));
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// --- Filled portion (HP left) ---
var hp_percent = clamp(hp_current / hp_max, 0, 1);
var fill_width = bar_width * hp_percent;
draw_set_color(make_color_rgb(150, 30, 255));
draw_rectangle(bar_x, bar_y, bar_x + fill_width, bar_y + bar_height, false);

// --- Optional: Boss name ---
draw_set_font(fMenuSmall); // change to your font
draw_set_color(c_white);
draw_text(bar_x + (bar_width / 2) - 85, bar_y , "Swish Witch");