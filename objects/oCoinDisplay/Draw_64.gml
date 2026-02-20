if (instance_exists(oPlayer)) {
    // === Coin Counter ===
    var coin_x = 700;
    var coin_y = 80; // position of text
    var coin_icon_x = coin_x - 40; // shift sprite slightly left of text
    var coin_icon_y = coin_y-20 ;  // minor vertical adjust to align nicely

    // Draw coin icon
    draw_sprite(sCoin, 0, coin_icon_x, coin_icon_y);

    // Draw coin number
	draw_set_font(fMenu);
    draw_set_color(c_white);
    draw_text(coin_x, coin_y, string(global.coin_count));
}
