state = PlayerStateFree;
//MOVEMENT//

run = sPlayer2Run
jump = sPlayer2Jump
kick = sPlayer2Kick_1
idle = sPlayer2Idle
wallslide = sPlayer2WallSlide
player = oPlayer2
enemyplayer = oPlayer1
groundpound = sPlayer2GroundPound

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
