// === Constants ===
var acceleration = 2;     // Speed increase rate
var deceleration = 0.2;   // Slowdown rate
var maxSpeed = 1.5;       // Max movement speed
var minDistance = 150;    // Too close → move away
var maxDistance = 300;    // Too far → move closer

// === Check for player ===
if (instance_exists(oPlayer)) {
	        if (place_meeting(x + hsp, y, oPlayer)) {
        while (!place_meeting(x + sign(hsp), y, oPlayer)) {
            x += sign(hsp);
        }
        hsp = -hsp*2;
    }
 if (place_meeting(x , y+ vsp, oPlayer)) {
        while (!place_meeting(x , y+ sign(vsp), oPlayer)) {
            y += sign(vsp);
        }
        vsp = -vsp*2;
    }

    var playerX = oPlayer.x;
    var playerY = oPlayer.y;
    var distToPlayer = point_distance(x, y, playerX, playerY);
    
    // Direction toward player
    var dirToPlayer = point_direction(x, y, playerX, playerY);
    
    // Default acceleration directions
    var horizontal = 0;
    var vertical = 0;
    
    // === Maintain ideal range ===
    if (collision_line(x, y, playerX, playerY - 20, oWall, true, false) == noone) {
        // Too far → move TOWARD player
        if (distToPlayer > maxDistance) {
            horizontal = lengthdir_x(1, dirToPlayer);
            vertical   = lengthdir_y(1, dirToPlayer);
        }
        // Too close → move AWAY from player
        else if (distToPlayer < minDistance) {
            horizontal = -lengthdir_x(1, dirToPlayer);
            vertical   = -lengthdir_y(1, dirToPlayer);
        }
        // Within range → slow down
        else {
            horizontal = 0;
            vertical = 0;
        }
    }

    // === Horizontal movement ===
    if (horizontal != 0) {
        hsp += horizontal * acceleration;
    } else {
        // Apply deceleration
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    // === Vertical movement ===
    if (vertical != 0) {
        vsp += vertical * acceleration;
    } else {
        // Apply deceleration
        var signVsp = sign(vsp);
        vsp -= signVsp * deceleration;
        if (sign(vsp) != signVsp) vsp = 0;
    }
}

// === Gravity (if you’re using it) ===
vsp += grv;

// === Clamp speeds ===
hsp = clamp(hsp, -maxSpeed, maxSpeed);
vsp = clamp(vsp, -maxSpeed, maxSpeed);

// === Horizontal collision ===
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// === Vertical collision ===
if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
y += vsp;



