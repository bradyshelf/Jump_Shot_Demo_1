
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

playerid=1

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
run = sPlayerRun
jump = sPlayerJump
kick = sPlayerKick
idle = sPlayerIdle
wallslide = sPlayerWallSlide
player = oPlayer1
enemyplayer = oPlayer2
groundpound = sPlayerGroundPound
roll = sPlayer2Roll
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
