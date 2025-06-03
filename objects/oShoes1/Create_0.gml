if gamepad_is_connected(4) && gamepad_is_connected(0){
	gamepad_index = 0
}

if gamepad_is_connected(4) && gamepad_is_connected(5){
	gamepad_index = 4
}
if gamepad_is_connected(1) && gamepad_is_connected(0){
	gamepad_index = 0
}
//gamepad_index = 4

state = PlayerStateFree;
//MOVEMENT//
groundpound_has_hit = false;
run = sShoeRun_1
jump = sShoeJump_1
kick = sShoeKick_1
idle = sShoeIdle_1
wallslide = sShoeWallSlide_1
player = oShoes1
enemyplayer = oShoes2
groundpound = sShoeGroundPound_1


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
