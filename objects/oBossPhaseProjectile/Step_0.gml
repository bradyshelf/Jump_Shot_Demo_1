// === Constants ===
/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === CONSTANTS ===
var acceleration   = 1;     // Speed increase rate
var deceleration   = 0.2;   // Slowdown rate
var maxSpeed       = 1.25;  // Max movement speed
var minDistance    = 150;   // Too close → move away
var maxDistance    = 300;   // Too far → move closer
var hoverAmplitude = 6;     // Vertical bobbing height
var hoverSpeed     = 0.05;  // Speed of hover motion

/// === TIMER (Phase change) ===
timer -= 1;
if (timer <= 0) {
    instance_change(oBossPhaseMelee, true);
}

/// === PLAYER TRACKING ===
if (instance_exists(oPlayer)) {
    var playerX = oPlayer.x;
    var playerY = oPlayer.y - 300; // Boss hovers above player
    var distToPlayer = point_distance(x, y, playerX, playerY);
    var dirToPlayer  = point_direction(x, y, playerX, playerY);
    
    var horizontal = 0;
    var vertical   = 0;

    // === Maintain ideal range ===
    if (collision_line(x, y, playerX, playerY - 20, oWall, true, false) == noone) {
        if (distToPlayer > maxDistance) {
            // Too far → move toward player
            horizontal = lengthdir_x(1, dirToPlayer);
            vertical   = lengthdir_y(1, dirToPlayer);
        }
        else if (distToPlayer < minDistance) {
            // Too close → move away
            horizontal = -lengthdir_x(1, dirToPlayer);
            vertical   = -lengthdir_y(1, dirToPlayer);
        }
    }

    // === Horizontal movement ===
    if (horizontal != 0) {
        hsp += horizontal * acceleration;
    } else {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    // === Vertical movement ===
    if (vertical != 0) {
        vsp += vertical * acceleration;
    } else {
        var signVsp = sign(vsp);
        vsp -= signVsp * deceleration;
        if (sign(vsp) != signVsp) vsp = 0;
    }

    // === Clamp speeds ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);
    vsp = clamp(vsp, -maxSpeed, maxSpeed);

    // === Collision with PLAYER ===
    // Horizontal bounce
    if (place_meeting(x + hsp, y, oPlayer)) {
        while (!place_meeting(x + sign(hsp), y, oPlayer)) x += sign(hsp);
        hsp = -hsp * 1.5; // horizontal bounce multiplier
    }
    // Vertical bounce
    if (place_meeting(x, y + vsp, oPlayer)) {
        if (vsp > 0) { // only bounce if falling onto player
            while (!place_meeting(x, y + sign(vsp), oPlayer)) y += sign(vsp);
            vsp = -abs(vsp) * 2; // upward bounce with slight power
	
        }
    }
}

/// === WALL COLLISIONS ===
// Horizontal
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) x += sign(hsp);
    hsp = 0;
}
x += hsp;

// Vertical
if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

/// === HOVER EFFECT ===
// Use instance-local hover time so multiple enemies don’t sync


if !place_meeting(x,y,oPlayer){
if (!variable_instance_exists(id, "hoverTime")) hoverTime = irandom(1000);
hoverTime += hoverSpeed;
y += sin(hoverTime) * hoverAmplitude * 0.1;
}