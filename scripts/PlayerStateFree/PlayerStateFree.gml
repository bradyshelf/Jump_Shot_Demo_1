function PlayerStateFree(){
	
	if place_meeting(x,y,oSlope){
		slope = true;
	}else{
		slope = false;
	}
	if hp <= 0{		
		instance_destroy();
	}	
var accel = 1;  // Acceleration rate
var decel = 1;  // Deceleration rate
var max_speed = 12;  // Maximum horizontal speed


if (hascontrol){

	//keyboard input check

	
	//gamepad input check
    var key_left_gp = gamepad_axis_value(gamepad_index, gp_axislh) < -0.5;
    var key_right_gp = gamepad_axis_value(gamepad_index, gp_axislh) > 0.5;
    var key_jump_gp = gamepad_button_check(gamepad_index, gp_face1);
    var key_down_gp = gamepad_axis_value(gamepad_index, gp_axislv) > 0.5;
    var key_kick_gp = gamepad_button_check_pressed(gamepad_index, gp_face3);
    var key_gp_gp = gamepad_button_check_pressed(gamepad_index, gp_face4);
	  var key_roll_gp = gamepad_button_check(gamepad_index, gp_face2);
    // cobiniation of gamepad and keyboard input
    key_left =  key_left_gp;
    key_right =  key_right_gp;
    key_jump = key_jump_gp;
	key_down =  key_down_gp;
	key_kick = key_kick_gp;
	key_gp = key_gp_gp;
	key_roll =  key_roll_gp
} else {
    key_right = 0;
    key_left = 0;
    key_jump = 0;
	key_down = 0;
	key_kick = 0;
}

// ======= ROLL START =======
if (!is_rolling && (place_meeting(x, y + 20, oWall)||place_meeting(x, y + 20, oSlope) ) && key_roll && abs(hsp) >= roll_threshold) {
    is_rolling = true;
    roll_speed = hsp*2;        // inherit current momentum
    roll_direction = sign(hsp); // lock direction
    sprite_index = roll;
    image_index = 0;
    image_speed = 1;
}

// ======= ROLLING =======
// ======= START ROLL =======
if (!is_rolling && (place_meeting(x, y + 20, oWall) || place_meeting(x, y + 20, oSlope)) && key_roll && abs(hsp) >= roll_threshold) {
    is_rolling = true;
    roll_speed = hsp * 2;          // inherit momentum
    roll_direction = sign(hsp);    // lock direction
    sprite_index = roll;
    image_index = 0;
    image_speed = 1;
}

// ======= ROLLING LOGIC =======
if (is_rolling) {

    // ======= APPLY GRAVITY =======
    vsp += grv;

    // Vertical collision (falling)
    if (vsp > 0) {
        if (place_meeting(x, y + vsp, oWall)) {
            while (!place_meeting(x, y + 1, oWall)) {
                y += 1;
            }
            vsp = 0;
        } else {
            y += vsp;
        }
    }
    // Vertical collision (rising)
    else if (vsp < 0) {
        if (place_meeting(x, y + vsp, oWall)) {
            while (!place_meeting(x, y - 1, oWall)) {
                y -= 1;
            }
            vsp = 0;
        } else {
            y += vsp;
        }
    }

    // ======= HORIZONTAL ROLL MOVEMENT (Slope-Aware) =======
    var target_x = x + roll_speed;
    var target_y = y;

    // Slope adjustment at the target position
    if (place_meeting(target_x, target_y + 1, oSlope)) {
        while (place_meeting(target_x, target_y, oSlope)) {
            target_y -= 1; // move up until not inside slope
        }
    }

    // Wall collision at slope-adjusted position
    if (place_meeting(target_x, target_y, oWall)) {
        // Move as close as possible
        while (!place_meeting(x + roll_direction, y, oWall)) {
            x += roll_direction;
        }
        hsp = 0;
        roll_speed = 0;
        is_rolling = false;
    } else {
        // Commit movement
        x = target_x;
        y = target_y;
        hsp = roll_speed;
    }

    // ======= ENEMY COLLISION =======
    if (place_meeting(x + hsp, y, enemyplayer)) {
        while (!place_meeting(x + sign(hsp), y, enemyplayer)) {
            x += sign(hsp);
        }
        roll_speed = -hsp;
        enemyplayer.hsp = -hsp;
    }

    // ======= SLOPE FLAG =======
    slope = place_meeting(x, y + 1, oSlope);
    if (slope) SlopeAdjust2();

    // ======= DECELERATION =======
    if (roll_speed > 0) {
        roll_speed -= roll_decel;
        if (roll_speed < 0) roll_speed = 0;
    } else if (roll_speed < 0) {
        roll_speed += roll_decel;
        if (roll_speed > 0) roll_speed = 0;
    }

    // ======= CANCEL ROLL =======
    if (key_jump) {
        is_rolling = false;
        vsp = -20; // jump normally
    }
    if (!key_roll) {
        is_rolling = false;
    }

    // ======= UPDATE SPRITE =======
    sprite_index = roll;
    image_speed = abs(hsp) / 8;
}


else{

if (key_left) {
    hsp -= accel; //Accelerate
} else if (key_right) {
    hsp += accel; //Accelerate
} else {
    if (hsp > 0) {
        hsp -= decel;  // Decelerate
        if (hsp < 0) hsp = 0; 
    } else if (hsp < 0) {
        hsp += decel;  
        if (hsp > 0) hsp = 0;  
    }
}

//max speed 
if (hsp > max_speed) hsp = max_speed;
if (hsp < -max_speed) hsp = -max_speed;

// Vertical speed
vsp = vsp + grv ;

//jump
if (place_meeting(x, y + 20, oWall) && key_jump) {
//screenshake(5,5);
//flash =4;
     vsp = -20;
	 if !audio_is_playing(sndBounce){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndBounce, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
}

//COLLISION//
// Horizontal Collision
//Wall
if (place_meeting(x + hsp, y, oWall)) {
    var dir = sign(hsp);
    var remaining = abs(hsp);

    while (remaining > 0) {
        // Tentative move
        var next_x = x + dir;
        var next_y = y;

        // Adjust for slope at the next horizontal position
        if (place_meeting(next_x, next_y + 1, oSlope)) {
            while (place_meeting(next_x, next_y, oSlope)) {
                next_y -= 1; // Move up along slope
            }
        }

        // Stop if wall blocks the next position
        if (place_meeting(next_x, next_y, oWall)) {
            hsp = 0;
            break;
        }

        // Commit movement
        x = next_x;
        y = next_y;
        remaining -= 1;
    }
}


if (place_meeting(x + hsp, y, enemyplayer)) {
    while (!place_meeting(x + sign(hsp), y, enemyplayer)) {
        x = x + sign(hsp);
    }
	screenshake(1,1)
    hsp = -hsp;
	enemyplayer.hsp = -hsp
}

//Backboard
if (place_meeting(x + hsp, y, oBackboard)) {
    while (!place_meeting(x + sign(hsp), y, oBackboard)) {
        x = x + sign(hsp);
    }
    hsp = -hsp;
}
//THIS SINGULAR PIECE OF CODE IS THE BACKBONE OF THIS GAME DO NOT DELETE
x = x + hsp;






// Vertical Collision
if (!groundpounding){
if (place_meeting(x, y + vsp, oWall))  {
    while (!place_meeting(x, y + sign(vsp), oWall)) {
        y = y + sign(vsp);
    }
    vsp = 0;
	
}

if (place_meeting(x, y+vsp, oWall)) {
    // On the ground: stop vertical movement if hitting the other player
    if (vsp != 0 && place_meeting(x, y + vsp, enemyplayer)) {
        var dir = sign(vsp);
        while (!place_meeting(x, y + dir, enemyplayer)) {
            y += dir;
        }
        vsp = 0;
		slope = false
    }
} else {
    if (vsp != 0 && place_meeting(x, y + vsp, enemyplayer)) {
        var dir = sign(vsp);
        while (!place_meeting(x, y + dir, enemyplayer)) {
            y += dir;
        }
	screenshake(2,2)

        vsp = -vsp; // bounce
		if !place_meeting(enemyplayer.x, enemyplayer.y, oWall){
			enemyplayer.vsp = -vsp
		}
    }
}



}
//THIS SINGULAR PIECE OF CODE IS THE BACKBONE OF THIS GAME DO NOT DELETE
y = y + vsp;



if (place_meeting(x + hsp, y, oSlope)) {
    while (!place_meeting(x + sign(hsp), y, oSlope)) {
        x = x + sign(hsp);
    }
SlopeAdjust();
slope = true
}

// ANIMATION LOGIC
if (hsp != 0) {
    sprite_index = run;
}

// Track falling
if (vsp > 4) was_falling = true;

if (!place_meeting(x, y + 20, oWall))&& !place_meeting(x,y+20,enemyplayer &&  !place_meeting(x,y+20,oSlope)) {
    // Airborne
    if (key_kick && key_down&& !is_kicking) {
        is_kicking = true;
        groundpounding = true; // <- Commit to the ground pound
        sprite_index = groundpound;
        image_index = 0;
        image_speed = 1;
        
        // Cancel upward movement and slam down immediately
        vsp = max(vsp, 0); // Cancel any upward motion
        vsp += 22;         // Slam down force
    }
    if (!is_kicking && key_kick) {
        is_kicking = true;
        groundpounding = false;
        sprite_index = kick;
        image_index = 0;
        image_speed = 1;
    }

    if (is_kicking) {
		 if ( place_meeting(x, y, enemyplayer)) {

        screenshake(vsp/3,vsp/3);
        vsp = -min(vsp*0.75, 37);
		enemyplayer.hp -= 5;
		enemyplayer.flash = 4;
		
		if enemyplayer.vsp = 0 {
		enemyplayer.vsp +=vsp/1.75;
		//enemyplayer.vsp = -abs(vsp / 1.5);
		}else{
	
			enemyplayer.vsp -= vsp;
		}
		
		is_kicking= false;
		groundpounding = false;
    }
        if (groundpounding) {
            // Committed to ground pound
            sprite_index = groundpound;
        } else {
            sprite_index = kick;
        }

        // Freeze animation on last frame
        if (image_index >= image_number - 1) {
            image_index = image_number - 1;
            image_speed = 0;
        }
    } 
	
	else {
        // Normal jump/fall
		if place_meeting(x,y+20,oSlope){
			if (hsp != 0) {
     sprite_index = run;
	
		image_speed = 1;
}else{
	    sprite_index = idle;
}
		
			
		}else{
			
		
        sprite_index = jump;
        image_speed = 0;
        image_index = (sign(vsp) > 0) ? 1 : 0;
		}
    }

} else {
    // On the ground
    if (groundpounding) {
    // Landed after a ground pound
 if vsp > 0{
	 
var pitch = random_range(.8, 1.2); // Slightly vary the pitch
	 	 if !audio_is_playing(sndThud){

    var snd_id = audio_play_sound(sndSlam, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	 	 if !audio_is_playing(sndThud){
    var snd_id2 = audio_play_sound(sndThud, 1, false);
    audio_sound_pitch(snd_id2, pitch);
	 }
	
 if ( place_meeting(x, y + 20, enemyplayer)) {

        screenshake(vsp/3,vsp/3);
        vsp = -min(vsp*0.75, 37);
		enemyplayer.hp -= 5;
		enemyplayer.flash = 4;
		
		if enemyplayer.vsp = 0 {
		enemyplayer.vsp +=vsp/1.75;
		//enemyplayer.vsp = -abs(vsp / 1.5);
		}else{
	
			enemyplayer.vsp -= vsp;
		}
		
		is_kicking= false;
		groundpounding = false;
    }
	
	else{
		screenshake(vsp/5,vsp/5);
        vsp = -min(vsp*0.75, 37); // Bounce up but cap the bounce speed to -20
	}
 }
 
    is_kicking = false;
    groundpounding = false;
    image_speed = 1;
    sprite_index = groundpound;
    image_index = 0;
}
 else if (is_kicking) {
        // Landed from a kick
        is_kicking = false;
        image_speed = 1;
    }

    image_speed = abs(hsp) / 8;

    sprite_index = (hsp == 0) ? idle : run;
}

if (hsp != 0) image_xscale = sign(hsp) *-.5;

//wall slide\

if (place_meeting(x + 1, y, oWall) || place_meeting(x - 1, y, oWall))  {
    // Reduce horizontal speed to half to make jump easier? maybe take this out well see
    //hsp *= 0.5;
	sprite_index = wallslide; // wall jump sprite
    // Accelerate vertical speed from 0 to 1 gradually
    if (vsp <= vsp + grv) { 
        vsp -= 0.115; // perfect fucking number
    }
}
if slope = false{
if(place_meeting(x + 10, y, oWall)){
	image_xscale = .5
}

if (place_meeting(x - 10, y, oWall)){
	image_xscale = -.5
}
}
if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(gamepad_index, gp_face1)) && (place_meeting(x + 20, y, oWall) || place_meeting(x - 20, y, oWall)) {

	var wall_jump_speed = 50;  //  x Speed for the wall jump
    var wall_jump_vspeed = -12;  // y speed for the wall jump

    // Determine the direction of the wall jump
    if (place_meeting(x + 20, y, oWall)) {
        hsp = -wall_jump_speed;  // Jump left if wall is to the right
    } else if (place_meeting(x - 20, y, oWall)) {
        hsp = wall_jump_speed;  // Jump right if wall is to the left
    }
    vsp = wall_jump_vspeed;
}

}

if sprite_index = run && hsp >= 0 {
image_speed = hsp/8
}

if sprite_index = run && hsp <= 0{
		image_speed = -hsp/8
}
}
