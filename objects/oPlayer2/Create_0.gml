

if gamepad_is_connected(4) && gamepad_is_connected(0){
	gamepad_index = 4
}
if gamepad_is_connected(4) && gamepad_is_connected(5){
	gamepad_index = 5
}
if gamepad_is_connected(1) && gamepad_is_connected(0){
	gamepad_index = 1
}
roll_threshold = 0; // minimum speed to initiate roll
is_rolling = false;
roll_speed = 0;
roll_accel = 1.5; // optional: acceleration while rolling
roll_decel = 0.5; // optional: natural deceleration

state = PlayerStateFree;
//MOVEMENT//
groundpound_has_hit = false;
run = sPlayer2Run
jump = sPlayer2Jump
kick = sPlayer2Kick_1
idle = sPlayer2Idle
wallslide = sPlayer2WallSlide
player = oPlayer2
enemyplayer = oPlayer1
groundpound = sPlayer2GroundPound
roll = sPlayer2Roll
groundpounding = false;
flash = 0;
is_kicking=false;
just_kicked = false;
was_falling = false
landing_timer=0
hp = 100;
hp_max = hp;
hascontrol = true
hsp = 0;    
vsp = 0;    
grv = 0.6;  //gravity built in variable
walksp = 8; 
prev_x = x;
prev_y = y;
distance_traveled = 0;
