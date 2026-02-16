// Constants for acceleration, deceleration, and max speed
var acceleration = 2; // Acceleration rate
var maxSpeed = 5; // Maximum horizontal speed

// Initialize move_direction if it doesn't exist
if (!variable_instance_exists(id, "move_direction")) {
    move_direction = 1; // Default direction: 1 = right, -1 = left
}

// Apply horizontal movement to platform (hsp)
hsp += move_direction * acceleration;

// Clamp the speed to the maximum speed
hsp = clamp(hsp, -maxSpeed, maxSpeed);

// Horizontal collision for the platform
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x += sign(hsp); // Move up to the wall
    }
    hsp = 0; // Stop horizontal movement
    move_direction = -move_direction; // Reverse direction
}

// Apply the horizontal speed to the platform's position
x += hsp;

// Check if the player is standing on the platform (collision check)

if (place_meeting(x, y-1, oPlayer1) ) {

    oPlayer1.x += hsp; 
}

if (place_meeting(x+sign(hsp), y, oPlayer1) ) {

    oPlayer1.x += hsp*2; 
	oPlayer1.hsp = hsp *2;
}

if (place_meeting(x, y-1, oPlayer2) ) {

    oPPlayerNormal.x += hsp; 
}

if (place_meeting(x+sign(hsp), y,oPlayer2) ) {

    oPlayer2.x += hsp*2; 
	oPlayer2.hsp = hsp *2;
}
