if instance_exists(oScreenPause){
	
var acceleration = 0; // Acceleration rate
var maxSpeed = 0; // Maximum horizontal speed
}
else{

var acceleration = 2; // Acceleration rate
var maxSpeed = 5; // Maximum horizontal speed
}
// Initialize move_direction if it doesn't exist
if (!variable_instance_exists(id, "move_direction")) {
    move_direction = 1; // Default direction: 1 = right, -1 = left
}

// Apply horizontal movement to platform (hsp)
vsp += move_direction * acceleration;

// Clamp the speed to the maximum speed
vsp = clamp(vsp, -maxSpeed, maxSpeed);

// Horizontal collision for the platform
if (place_meeting(x , y+ vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y += sign(vsp); // Move up to the wall
    }
    vsp = 0; // Stop horizontal movement
    move_direction = -move_direction; // Reverse direction
}

// Apply the horizontal speed to the platform's position
y += vsp;

// Check if the player is standing on the platform (collision check)

if (place_meeting(x, y-1, oPlayer1) ) {

    oPlayer1.y += vsp; 
}

if (place_meeting(x, y+sign(vsp), oPlayer1) ) {

    oPlayer1.y += vsp*2; 
	oPlayer1.vsp = vsp *2;
}

if (place_meeting(x, y-1, oPlayer2) ) {

    oPlayer2.x += vsp; 
}

if (place_meeting(x, y+sign(vsp),oPlayer2) ) {

    oPlayer2.x += vsp*2; 
	oPlayer2.vsp = vsp *2;
}
