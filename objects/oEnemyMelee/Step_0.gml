if instance_exists(oScreenPause){
image_speed = 0;
exit;
}else{
image_speed = 1;	
}

if (instance_exists(oPlayer)) {
        if (place_meeting(x + hsp, y, oPlayer)) {
        while (!place_meeting(x + sign(hsp), y, oPlayer)) {
            x += sign(hsp);
        }
        hsp = -hsp*2;
		oPlayer.flash = 4
		oPlayer.hp -=1;
		instance_create_layer(x,y,"Player",oHitstop);
    }
 if (place_meeting(x , y+ vsp, oPlayer)) {
        while (!place_meeting(x , y+ sign(vsp), oPlayer)) {
            y += sign(vsp);
        }
        vsp = -vsp*1.1;
    }

    // === Constants ===
    var acceleration   = 0.5;
    var deceleration   = 0.25;
    var maxSpeed       = 8.5;
    var pursueDistance = 800;
    var grv            = 0.4;

    // === Local Vars ===
    var playerX = oPlayer.x;
    var playerY = oPlayer.y;
    var distToPlayer = point_distance(x, y, playerX, playerY);

    var horizontal = 0;
    var vertical   = 0;

    // === Gravity (always applies) ===
    vsp += grv;

    // === Pursuit only if within range and grounded ===
    if (distToPlayer <= pursueDistance && place_meeting(x, y + 1, oWall)) {

        // Check line of sight to player
        if (collision_line(x, y, playerX, playerY - 20, oWall, true, false) == noone) {
            
            // Determine direction toward player
            if (playerX > x) horizontal = 1;
            else if (playerX < x) horizontal = -1;
        }

        // === Horizontal Acceleration / Deceleration ===
        if (horizontal != 0) {
            hsp += horizontal * acceleration;
        } else {
            // Slow down when no horizontal input
            var signHsp = sign(hsp);
            hsp -= signHsp * deceleration;
            if (sign(hsp) != signHsp) hsp = 0;
        }

    } else {
        // Not in range or not grounded → gradually stop horizontal movement
        if (hsp != 0) {
            var signHsp = sign(hsp);
            hsp -= signHsp * deceleration;
            if (sign(hsp) != signHsp) hsp = 0;
        }
    }

    // === Clamp Horizontal Speed ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);

    // === Horizontal Collision ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }

    // === Vertical Collision ===
    if (place_meeting(x, y + vsp, oWall)) {
        while (!place_meeting(x, y + sign(vsp), oWall)) {
            y += sign(vsp);
        }
        vsp = 0;
    }

    // === Apply Movement ===
    x += hsp;
    y += vsp;

} else {
    hsp = 0;
}
