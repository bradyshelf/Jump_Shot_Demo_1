// Constants for acceleration and deceleration
var acceleration = 2; // Adjust as needed
var deceleration = 0.2; // Adjust as needed
var maxSpeed = 1.5; // Adjust as needed
var pursueDistance = 10; // Distance threshold to start pursuing the player
var stopDistance = 200; // Distance threshold to stop pursuing the player

// Check if the player exists
if (instance_exists(oPlayer)) {
    // Get the player's position
    var playerX = oPlayer.x + chase;
    var playerY = oPlayer.y + chase;

    // Calculate the distance to the player
    var distToPlayer = point_distance(x, y, playerX, playerY);

    // Movement direction
    var horizontal = 0;
    var vertical = 0;

    // Pursue the player if further than the pursueDistance and within the stopDistance
    if (distToPlayer > pursueDistance && distToPlayer <= stopDistance && collision_line(x, y, oPlayer.x, oPlayer.y -20, oWall, true, false) == noone) { 
        if (playerX > x) {
            horizontal = -0.5;
        } else if (playerX < x) {
            horizontal = 0.5;
        }

        if (playerY > y) {
            vertical = -0.5;
        } else if (playerY < y) {
            vertical = 0.5;
        }
    }

    // Horizontal acceleration and deceleration
    if (horizontal != 0) {
        hsp += horizontal * acceleration;
    } else if (hsp != 0) {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) {
            hsp = 0;
        }
    }
}

// Apply gravity
vsp = vsp + grv;

// Apply maximum speed limits
hsp = clamp(hsp, -maxSpeed, maxSpeed);

// Horizontal collision
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp);
    }
    hsp = -hsp; // Stop horizontal speed upon collision
} 
x += hsp;

// Vertical collision
if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp);
    }
    vsp = 0; // Stop vertical speed upon collision
}

x += hsp;
y += vsp;


