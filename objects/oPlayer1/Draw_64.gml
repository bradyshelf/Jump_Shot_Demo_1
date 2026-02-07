// UI

if (instance_exists(oPlayer1)) {
    // Draw the UI backdrop
    var ui_backdrop_x = 50;
    var ui_backdrop_y = 50;
    draw_sprite(sPlayerRoll, 0, ui_backdrop_x, 50);

    // Health bar dimensions
    var health_x = 100;
    var health_y = 40;
    var health_width = (hp / hp_max) * 250;
    var health_height = 20;

    // Draw the health bar background (optional)
    draw_set_color(c_black);
    draw_rectangle(health_x - 2, health_y - 2, health_x + 250 + 2, health_y + 22, false);
 draw_text(100, 100, gamepad_index)
    // Draw the actual health bar (static green color)
    draw_set_color(c_blue); // Or any color you prefer
    draw_rectangle(health_x, health_y, health_x + health_width, health_y + health_height, false);

    // Reset color
    draw_set_color(c_white);


    
}
