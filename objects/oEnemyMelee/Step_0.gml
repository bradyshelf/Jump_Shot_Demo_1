if (instance_exists(oPlayer)) {
    
    // === Constants ===
    var acceleration = 0.5;
    var deceleration = 0.25;
    var maxSpeed = 8.5;
    var pursueDistance = 500; // Adjusted for better chase radius
    var spd = 6;
    var chase = 0; // Adjust if needed for offsetting targeting
    var grv = 0.4;




  
        // === Enemy Movement Toward Player ===
        if (place_meeting(x, y + 1, oWall)) {

            var playerX = oPlayer.x + chase;
            var playerY = oPlayer.y + chase;
            var distToPlayer = point_distance(x, y, playerX, playerY);
            var horizontal = 0;
            var vertical = 0;

            if (distToPlayer <= pursueDistance || (abs(hsp) > 0.1 || abs(vsp) > 0.1)) {
                if (collision_line(x, y, oPlayer.x, oPlayer.y - 20, oWall, true, false) == noone) {

                    if (playerX > x) horizontal = 1;
                    else if (playerX < x) horizontal = -1;

                    if (playerY > y) vertical = 1;
                    else if (playerY < y) vertical = -1;

                    if (distToPlayer <= 10) {
                        hsp = horizontal * maxSpeed;
                        vsp = vertical * maxSpeed;
                    }
                }
            

            // === Acceleration and Deceleration ===
            if (horizontal != 0) {
                hsp += horizontal * acceleration;
            } else if (hsp != 0) {
                var signHsp = sign(hsp);
                hsp -= signHsp * deceleration;
                if (sign(hsp) != signHsp) hsp = 0;
            }
        }

        // === Apply Gravity ===
        vsp += grv;

        // === Clamp Speed ===
        hsp = clamp(hsp, -maxSpeed, maxSpeed);

        // === Horizontal Collision ===
        if (place_meeting(x + hsp, y, oWall)) {
            while (!place_meeting(x + sign(hsp), y, oWall)) {
                x += sign(hsp);
            }
            hsp = -hsp;
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
    }

    // === Animation Handling ===
//    if (vsp != 0) {
//        sprite_index = ZombieFalling;
//    } else {
//        if (hsp >= 1) {
//            sprite_index = ZombieRun;
//            image_xscale = -1.75;
//            image_speed = hsp / 8;
//        } else if (hsp <= -1) {
//            sprite_index = ZombieRun;
//            image_xscale = 1.75;
//            image_speed = -hsp / 8;
//        } else if (!place_meeting(x, y, oPlayer)) {
//            sprite_index = ZombieIdle;
//        }

//        // Bite when touching player
//        if (place_meeting(x, y, oPlayer)) {
//            sprite_index = ZombieBite;
//            image_speed = 0.5;
//        }

//        // Ensure biting overrides running animation
//        if (sprite_index == ZombieRun && place_meeting(x, y, oPlayer)) {
//            sprite_index = ZombieBite;
//            image_speed = 0.5;
//        }
//    }



} else {
    // Player doesn't exist
    hsp = 0;
    sprite_index = ZombieIdle;
}


