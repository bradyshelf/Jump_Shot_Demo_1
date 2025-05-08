
function PlayerStateFree(){
	if hp <= 0{
		
		instance_destroy();
	}
	
	

var accel = 1;  // Acceleration rate
var decel = 1;  // Deceleration rate
var max_speed = 12;  // Maximum horizontal speed


if (hascontrol) {

	

		
	//keyboard input check
	var key_left_kb = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var key_right_kb = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var key_jump_kb = keyboard_check(vk_space) || keyboard_check(ord("W"));
    var key_down_kb = keyboard_check(vk_down) || keyboard_check(ord("S"));
	var key_kick_kb = mouse_check_button_pressed(mb_left);
	
	
	//gamepad input check
    
    var key_left_gp = gamepad_axis_value(gamepad_index, gp_axislh) < -0.5;
    var key_right_gp = gamepad_axis_value(gamepad_index, gp_axislh) > 0.5;
    var key_jump_gp = gamepad_button_check(gamepad_index, gp_face1);
    var key_down_gp = gamepad_axis_value(gamepad_index, gp_axislv) > 0.5;
    var key_kick_gp = gamepad_button_check_pressed(gamepad_index, gp_face3);
	

    
    // cobiniation of gamepad and keyboard input
    key_left = key_left_kb || key_left_gp;
    key_right = key_right_kb || key_right_gp;
    key_jump = key_jump_kb || key_jump_gp;
	key_down = key_down_kb || key_down_gp;
	key_kick = key_kick_kb || key_kick_gp;

	
} else {
    key_right = 0;
    key_left = 0;
    key_jump = 0;
	key_down = 0;
	key_kick = 0;

}



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


//if (!place_meeting(x, y + 20, oWall) && key_down && sprite_index!=groundpound) {
//grv = 1
//}else{
//grv = 0.6
//}


//COLLISION//

// Horizontal Collision


//Wall

if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) {
        x = x + sign(hsp);
    }
    hsp = 0;

}

if (place_meeting(x + hsp, y, enemyplayer)) {
    while (!place_meeting(x + sign(hsp), y, enemyplayer)) {
        x = x + sign(hsp);
    }
	screenshake(1,1)
    hsp = -hsp;
	enemyplayer.hsp = -hsp
	

}







if (place_meeting(x + hsp, y, oBackboard)) {
    while (!place_meeting(x + sign(hsp), y, oBackboard)) {
        x = x + sign(hsp);
    }
    hsp = -hsp;

}

x = x + hsp;



//Backboard


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




y = y + vsp;






// ANIMATION LOGIC

if (hsp != 0) {
    sprite_index = run;
}

// Track falling
if (vsp > 4) was_falling = true;

if (!place_meeting(x, y + 20, oWall))&& !place_meeting(x,y+20,enemyplayer) {
    // Airborne
    if (key_kick && key_down && !is_kicking) {
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
    } else {
        // Normal jump/fall
        sprite_index = jump;
        image_speed = 0;
        image_index = (sign(vsp) > 0) ? 1 : 0;
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


//wall slide


if (place_meeting(x + 1, y, oWall) || place_meeting(x - 1, y, oWall))  {

    // Reduce horizontal speed to half to make jump easier? maybe take this out well see
    //hsp *= 0.5;
	sprite_index = wallslide; // wall jump sprite
    // Accelerate vertical speed from 0 to 1 gradually
    if (vsp <= vsp + grv) { 
        vsp -= 0.115; // perfect fucking number
    }
	
}

if(place_meeting(x + 10, y, oWall)){
	
	image_xscale = .5
}



if (place_meeting(x - 10, y, oWall)){
	
	image_xscale = -.5
}

if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(gamepad_index, gp_face1)) && (place_meeting(x + 20, y, oWall) || place_meeting(x - 20, y, oWall)) {

    var wall_jump_speed = 15;  //  x Speed for the wall jump
    var wall_jump_vspeed = -9;  // y speed for the wall jump

    // Determine the direction of the wall jump
    if (place_meeting(x + 20, y, oWall)) {
        hsp = -wall_jump_speed;  // Jump left if wall is to the right
    } else if (place_meeting(x - 20, y, oWall)) {
        hsp = wall_jump_speed;  // Jump right if wall is to the left
    }


    vsp = wall_jump_vspeed;
	
}



if sprite_index = run && hsp >= 0 {

		
image_speed = hsp/8
	
}

if sprite_index = run && hsp <= 0{
	
	
		image_speed = -hsp/8
		
}
	




}