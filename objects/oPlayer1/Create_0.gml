hitstop_active = false; // Prevent repeated hitstops
hitstop_timer = 0;      // Optional: for timing duration

hascontrol = false;
if hascontrol == false {
		gamepad_index = -1
	
}
if gamepad_is_connected(4) && gamepad_is_connected(0){
	gamepad_index = 0
		hascontrol = true
}

if gamepad_is_connected(4) && gamepad_is_connected(5){
	gamepad_index = 4
		hascontrol = true
}
if gamepad_is_connected(1) && gamepad_is_connected(0){
	gamepad_index = 0
	hascontrol = true
} 
can_dash = true;
has_dashed=false
playerid=1
// Dash variables
// Dash
is_dashing = false;
dash_timer = 0;
dash_duration = 12; // frames
dash_speed = 18;    // horizontal speed
dash_lift = -2;     // tiny upward boost


slope = false;
roll_threshold = 0; // minimum speed to initiate roll
is_rolling = false;
roll_speed = 0;
roll_accel = 1.5; // optional: acceleration while rolling
roll_decel = 0.25; // optional: natural deceleration
//gamepad_index = 4
state = PlayerStateFree;
//MOVEMENT//
groundpound_has_hit = false;
hit = sHit;
run = sRun
jump = sJump
kick = sDash
idle = sIdle
wallslide = sWallslide
player = oPlayer1
enemyplayer = oPlayer2
groundpound = sGroundPound
roll = sRoll
groundpounding = false;
flash = 0;
is_kicking=false;
just_kicked = false;
was_falling = false
landing_timer=0
last_hdir = 1; // Default facing right



hp = 100;
hp_max = hp;



hsp = 0;    
vsp = 0;    
grv = 0.6;  //gravity built in variable
walksp = 8; 
prev_x = x;
prev_y = y;
distance_traveled = 0;
