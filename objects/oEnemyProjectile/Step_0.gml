/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === CONSTANTS ===
var acceleration = 2;     // Speed increase rate
var deceleration = 0.2;   // Slowdown rate
var maxSpeed     = 1.5;   // Max movement speed
var minDistance  = 150;   // Too close → move away
var maxDistance  = 300;   // Too far → move closer

/// === PLAYER TRACKING ===
var horizontal = 0;
var vertical   = 0;

if (instance_exists(oPlayer)) {
    var playerX = oPlayer.x;
    var playerY = oPlayer.y - 200;
    var distToPlayer = point_distance(x, y, playerX, playerY);
    var dirToPlayer  = point_direction(x, y, playerX, playerY);

    // Maintain ideal range if line of sight is clear
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
}

/// === APPLY MOVEMENT FORCES ===
// Horizontal acceleration / deceleration
if (horizontal != 0) {
    hsp += horizontal * acceleration;
} else {
    var signH = sign(hsp);
    hsp -= signH * deceleration;
    if (sign(hsp) != signH) hsp = 0;
}

// Vertical acceleration / deceleration
if (vertical != 0) {
    vsp += vertical * acceleration;
} else {
    var signV = sign(vsp);
    vsp -= signV * deceleration;
    if (sign(vsp) != signV) vsp = 0;
}

/// === GRAVITY (optional) ===
vsp += grv; // Set grv = 0 if not used for flying enemies

/// === CLAMP SPEEDS ===
hsp = clamp(hsp, -maxSpeed, maxSpeed);
vsp = clamp(vsp, -maxSpeed, maxSpeed);


/// === COLLISION HANDLING ===

// --- Horizontal collisions ---
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp);
    }
    hsp = 0;
}
else if (place_meeting(x + hsp, y, oPlayer)) {
    while (!place_meeting(x + sign(hsp), y, oPlayer)) {
        x += sign(hsp);
    }
    hsp = -hsp * 1.5; // Bounce horizontally
}
x += hsp;


// --- Vertical collisions ---
if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp);
    }
    vsp = 0;
}
else if (place_meeting(x, y + vsp, oPlayer)) {
    // Coming down onto player → bounce
    if (vsp > 0) {
        while (!place_meeting(x, y + sign(vsp), oPlayer)) {
            y += sign(vsp);
        }
        vsp = -abs(vsp) * 1.5;
    }
    // Moving upward into player → stop to prevent glitch
    else if (vsp < 0) {
        vsp = 0;
    }
}
y += vsp;
