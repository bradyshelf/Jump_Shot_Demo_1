if gamepad_is_connected(4) && gamepad_is_connected(0){
	gamepad_index = 4
}
if gamepad_is_connected(4) && gamepad_is_connected(5){
	gamepad_index = 5
}
if gamepad_is_connected(1) && gamepad_is_connected(0){
	gamepad_index = 1
}


state = PlayerStateFree;
//MOVEMENT//
groundpound_has_hit = false;
run = sShoe2Run_1
jump = sShoe2Jump_1
kick = sShoe2Kick_1
idle = sShoe2Idle_1
wallslide = sShoe2WallSlide_1
player = oShoes2
enemyplayer = oShoes1
groundpound = sShoe2GroundPound_1


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
