
state = PlayerStateFree;
//MOVEMENT//
groundpound_has_hit = false;
run = sShoe2Run
jump = sShoe2Jump
kick = sShoe2Kick
idle = sShoe2Idle
wallslide = sShoe2WallSlide
player = oShoes2
enemyplayer = oShoes1
groundpound = sShoe2GroundPound


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
