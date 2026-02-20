function PlayerStateFree(){
	if (place_meeting(x, y + 20, oWall) || place_meeting(x, y + 20, oSlope) ) {
    can_dash = true;
}
	if place_meeting(x,y,oSlope){
		slope = true;
	}else{
		slope = false;
	}
	
	
// === IFRAme Timer ===
if (iframes > 0) {
    iframes -= 1;
}


if (is_kicking || is_rolling || is_dashing) {
    iframes = 20; // stays invincible during attack
}



	
var accel = 1;  // Acceleration rate
var decel = .75;  // Deceleration rate
var max_speed = 12;  // Maximum horizontal speed


if (hascontrol) {

    // ===== GAMEPAD INPUT =====
    var key_left_gp   = gamepad_axis_value(gamepad_index, gp_axislh) < -0.5;
    var key_right_gp  = gamepad_axis_value(gamepad_index, gp_axislh) >  0.5;
    var key_jump_gp   = gamepad_button_check(gamepad_index, gp_face1); // A / Cross
    var key_down_gp   = gamepad_axis_value(gamepad_index, gp_axislv) > 0.5;
    var key_kick_gp   = gamepad_button_check_pressed(gamepad_index, gp_face3); // X / Square
    var key_gp_gp     = gamepad_button_check_pressed(gamepad_index, gp_face4); // Y / Triangle
    var key_roll_gp   = gamepad_button_check(gamepad_index, gp_face2); // B / Circle
 var key_pause_gp   = gamepad_button_check(gamepad_index, gp_touchpadbutton); // B / Circle

        key_left  = key_left_gp;
        key_right = key_right_gp;
        key_jump  = key_jump_gp;
        key_down  = key_down_gp;
        key_kick  = key_kick_gp;
        key_gp    = key_gp_gp;
        key_roll  = key_roll_gp;
		key_pause = key_pause_gp;
    
    

} else {
	if playerid == 1{
	  var key_left_kb   = keyboard_check(ord("A"));
    var key_right_kb  = keyboard_check(ord("D"));
    var key_jump_kb   = keyboard_check(vk_space) || keyboard_check(ord("W"));
    var key_down_kb   = keyboard_check(ord("S"));
    var key_roll_kb   = keyboard_check(ord("E")); // Roll with S (hold down)
    var key_kick_kb   = keyboard_check_pressed(ord("E")); // Kick
    var key_gp_kb     = keyboard_check_pressed(ord("E")) && keyboard_check(ord("S")); // E + Down = Ground Pound
	var key_pause_kb     = keyboard_check_pressed(vk_escape);//pause

		key_left  = key_left_kb;
        key_right = key_right_kb;
        key_jump  = key_jump_kb;
        key_down  = key_down_kb;
        key_kick  = key_kick_kb;
        key_gp    = key_gp_kb;
        key_roll  = key_roll_kb;
		key_pause = key_pause_kb;
	}
if playerid == 2	{
	var key_left_kb   = keyboard_check(vk_left);
    var key_right_kb  = keyboard_check(vk_right);
    var key_jump_kb   = keyboard_check(vk_up);
    var key_down_kb   = keyboard_check(vk_down);
    var key_roll_kb   = keyboard_check(ord("M")); // Roll with S (hold down)
    var key_kick_kb   = keyboard_check_pressed(ord("M")); // Kick
    var key_gp_kb     = keyboard_check_pressed(ord("M")) && keyboard_check(vk_down); // E + Down = Ground Pound
	var key_pause_kb     = keyboard_check_pressed(vk_escape);//pause

		key_left  = key_left_kb;
        key_right = key_right_kb;
        key_jump  = key_jump_kb;
        key_down  = key_down_kb;
        key_kick  = key_kick_kb;
        key_gp    = key_gp_kb;
        key_roll  = key_roll_kb;
		key_pause = key_pause_kb;
}
}

if (key_pause)&& !instance_exists(oPauseScreen){
	instance_create_layer(x,y,"Player", oPauseScreen);
}



// ======= ROLLING =======
// ======= START ROLL =======
if (!is_rolling && (place_meeting(x, y+20, oWall) || place_meeting(x, y+20 , oSlope)) && key_roll && !key_down && abs(hsp) >= roll_threshold && !groundpounding) {
    is_rolling = true;
    roll_speed = hsp * 2;          // inherit momentum
    roll_direction = sign(hsp);    // lock direction
    sprite_index = roll;
    image_index = 0;
    image_speed = 1;
}

// ======= ROLLING LOGIC =======
if (is_rolling) {

    // === INPUT ACCELERATION ===
    if (key_left)  roll_speed -= accel / 3;
    if (key_right) roll_speed += accel / 3;

    mask_index = sRoll;

    // ======= APPLY GRAVITY =======
    vsp += grv;

    // === VERTICAL COLLISIONS ===
    if (vsp != 0) {
        var step = sign(vsp);
        var remaining = abs(vsp);
        while (remaining > 0) {
            if (!place_meeting(x, y + step, oWall)) {
                y += step;
            } else {
                vsp = 0;
                break;
            }
            remaining -= 1;
        }
    }

    // ======= HORIZONTAL ROLL MOVEMENT (Slope-Aware, Safe) =======
    var target_x = x + roll_speed;
    var target_y = y;

    // Slope adjustment
    if (place_meeting(target_x, target_y + 1, oSlope)) {
        while (place_meeting(target_x, target_y, oSlope) && target_y > 0) {
            target_y -= 1;
        }
    }

    // Horizontal collision (incremental)
    var move_dir = sign(roll_speed);
    var move_amt = abs(roll_speed);
    var moved = 0;
    while (moved < move_amt) {
        if (!place_meeting(x + move_dir, target_y, oWall)) {
            x += move_dir;
        } else {
            // Bounce off wall safely
            roll_speed = -roll_speed * 0.5; // bounce back a little
            break;
        }
        moved += 1;
    }
    y = target_y;
    hsp = roll_speed;

    // ======= ENEMY COLLISION (Safe Increment) =======
    var hsign = sign(hsp);
    if (place_meeting(x + hsign, y, enemyplayer)) {
   
        roll_speed = -hsp;
        enemyplayer.hsp = -enemyplayer.hsp;
    }

    if (place_meeting(x + hsign, y, oEnemy)) {
     
        roll_speed = -hsp;
        oEnemy.hsp = -oEnemy.hsp;
    }

    // ======= SOUND HIT CHECKS (simplified) =======
    var enemy_offsets = [-20, 20];
    for (var i = 0; i < 2; i++) {
        var ex = enemy_offsets[i];
        if (place_meeting(x + ex, y, oEnemy)) {
            if (!audio_is_playing(sndThud)) {
                var pitch = random_range(0.8, 1.2);
                var sid = audio_play_sound(sndThud, 1, false);
                audio_sound_pitch(sid, pitch);
            }
            if (!audio_is_playing(sndPunch)) {
                var pitch = random_range(0.8, 1.2);
                var sid = audio_play_sound(sndPunch, 1, false);
                audio_sound_pitch(sid, pitch);
            }
        }
    }

    // ======= ENEMY DAMAGE =======
    if (roll_speed != 0){
        var hit_types = [oEnemyMelee, oEnemyJumper, oEnemyProjectile];
        for (var i = 0; i < array_length(hit_types); i++) {
            for (var dir = -1; dir <= 1; dir += 2) {
                var hit_inst = instance_place(x + 20 * dir, y, hit_types[i]);
                if (hit_inst != noone) {
                    with (hit_inst) {
                        flash = 4;
                        hp-= .5;
                    }
                    instance_create_layer(x, y, "Player", oHitstop);
                    screenshake(5, 5);
                }
            }
        }
    }

    // ======= BOSS PHASE COLLISIONS =======
    var boss_offsets = [-20, 20];
    for (var i = 0; i < 2; i++) {
        var off = boss_offsets[i];
        if (place_meeting(x + off, y, oBossPhaseProjectile)) {
            instance_create_layer(x, y, "Player", oHitstop);
            screenshake(5,5);
            oBossPhaseProjectile.flash = 4;
            oBossCollision. hp-= .5;
		
        }
        if (place_meeting(x + off, y, oBossPhaseMelee)) {
            instance_create_layer(x, y, "Player", oHitstop);
            screenshake(5,5);
            oBossPhaseMelee.flash = 4;
            oBossCollision.hp-= .5;
			
        }
    }

    // ======= SLOPE ADJUSTMENT =======
    slope = place_meeting(x, y + 1, oSlope);
    if (slope) SlopeAdjust2();

    if (place_meeting(x, y + 1, oSlopeR)) roll_speed += grv * 3;
    if (place_meeting(x, y + 1, oSlopeL)) roll_speed -= grv * 3;

    // ======= DECELERATION =======
    if (roll_speed > 0) {
        roll_speed -= roll_decel;
        if (roll_speed < 0) roll_speed = 0;
    } else if (roll_speed < 0) {
        roll_speed += roll_decel;
        if (roll_speed > 0) roll_speed = 0;
    }

    // ======= CANCEL ROLL / JUMP / GROUND POUND =======
    if (key_jump)|| vsp<0 {
        is_rolling = false;
        vsp = -20;
        mask_index = sIdle;
    }

    if ( key_gp && !is_kicking && !place_meeting(x, y+20, oWall)){
        is_rolling = false;
        is_kicking = true;
        groundpounding = true;
        sprite_index = groundpound;
        vsp +=   22;
		        mask_index = sIdle;
    }
	


    if (!key_roll) {
        is_rolling = false;
        mask_index = sIdle;
    }

    // ======= UPDATE SPRITE =======
    sprite_index = roll;
    image_speed = max(0.1, abs(hsp) / 8); // never freeze animation
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
if ((place_meeting(x, y + 20, oWall) ||place_meeting(x, y + 20, oSlope) ) && key_jump) {
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
if (place_meeting(x + hsp, y, oEnemy)) {
    while (!place_meeting(x + sign(hsp), y, oEnemy)) {
        x = x + sign(hsp);
    }
	screenshake(1,1)

    hsp = -hsp;
	oEnemy.hsp = -hsp*1.1
	
	
	
	 if !audio_is_playing(sndThud){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndThud, 1, false);
    audio_sound_pitch(snd_id, pitch);
 }
 
 
 
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

        vsp = -vsp*1.1; // bounce
		if !place_meeting(enemyplayer.x, enemyplayer.y, oWall){
			enemyplayer.vsp = -vsp
			enemyplayer.hsp = -hsp
		}
    }
	

	    if (vsp != 0 && place_meeting(x, y + vsp, oEnemy)) {
        var dir = sign(vsp);
        while (!place_meeting(x, y + dir, oEnemy)) {
            y += dir;
        }
	screenshake(2,2)

        vsp = -vsp*1.1; // bounce
		
				 if !audio_is_playing(sndThud){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndThud, 1, false);
    audio_sound_pitch(snd_id, pitch);
 }
		
		
		if !place_meeting(oEnemy.x, oEnemy.y, oWall){
			oEnemy.vsp = -vsp*1.1

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

if (!place_meeting(x, y + 20, oWall))&& !place_meeting(x,y+20,enemyplayer) && !place_meeting(x,y+20,oEnemy)&&  !place_meeting(x,y+20,oSlope) {
    // Airborne
    if (key_gp && !is_kicking && !place_meeting(x, y, oWall)) {
        is_kicking = true;
        groundpounding = true; // <- Commit to the ground pound
        sprite_index = groundpound;
        image_index = 0;
        image_speed = 1;
        
        // Cancel upward movement and slam down immediately
        vsp = max(vsp, 0); // Cancel any upward motion
        vsp += 22;         // Slam down force
    }
    if (!is_kicking && key_kick && can_dash) {
		instance_create_layer(x,y,"Player",oDashPuff);
        is_kicking = true;
        groundpounding = false;
        sprite_index = kick;
        image_index = 0;
        image_speed = 1;
		
    }

if (is_kicking) {

    if (!groundpounding) {

        // === DASH SETTINGS ===
        var dash_speed = -13;      // forward speed
        var dash_lift = 2;        // optional lift
        var dash_duration = 18;   // frames
        var dash_decel = 0.5;     // deceleration rate per frame

        if (!is_dashing && can_dash ) {
            is_dashing = true;
            dash_timer = dash_duration;
            hsp = dash_speed * sign(image_xscale);
            vsp = dash_lift;
			can_dash = false; 
				if !audio_is_playing(sndDash){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndDash, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
        }

      if (is_dashing) && (!place_meeting(x-20,y,enemyplayer) || !place_meeting(x+20,y,enemyplayer) ||!place_meeting(x+20,y,oEnemy)||!place_meeting(x-20,y,oEnemy)) {
    has_dashed = true;

    // Optionally ignore gravity during dash
    vsp = 0;

    // --- DASH MOVEMENT WITH COLLISION CHECK ---
    var dash_x = hsp;
    var dash_y = vsp;

    // Horizontal movement
    if (place_meeting(x + dash_x, y, oWall)) {
        // Move until just before collision
        while (!place_meeting(x + sign(dash_x), y, oWall)) {
            x += sign(dash_x);
        }
        hsp = -hsp;
    } else {
        x += dash_x;
    }

    // Vertical movement (if any)
    if (place_meeting(x, y + dash_y, oWall)) {
        while (!place_meeting(x, y + sign(dash_y), oWall)) {
            y += sign(dash_y);
        }
        vsp = 0;
    } else {
        y += dash_y;
    }

    // === DECELERATION ===
    if (dash_timer <= 20) { // last few frames slow down
        if (hsp > 0) hsp = max(0, hsp - dash_decel);
        else if (hsp < 0) hsp = min(0, hsp + dash_decel);
    }

    dash_timer -= 1;
    if (dash_timer <= 0) {
        is_dashing = false;
        hsp = 0;
        is_kicking = false;
    }
}


        // === ENEMY INTERACTION ===
        if (place_meeting(x+20, y, enemyplayer)) {
            screenshake(4, 4);
            if (enemyplayer.vsp == 0) {
                enemyplayer.vsp += vsp / 1.75;
				hsp = -hsp
            } else {
                enemyplayer.vsp -= vsp;
				hsp = -hsp
				
            }
            
            // enemyplayer.hp -= 5;
        }
		        if (place_meeting(x-20, y, enemyplayer)) {
            screenshake(4, 4);
            if (enemyplayer.vsp == 0) {
                enemyplayer.hsp += hsp / 1.75;
				hsp = -hsp
            } else {
                enemyplayer.vsp -= vsp;
			hsp = -hsp
            }
            
            // enemyplayer.hp -= 5;
        }
	 
	
			   
			   
		if (!hitstop_active && place_meeting(x+20, y, oEnemy)) {
 if !audio_is_playing(sndPunch){
	 hsp =  -hsp
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndPunch, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	screenshake(10,5);
}
 
// Check for enemy collision to the left
if (!hitstop_active && place_meeting(x-20, y, oEnemy)) {
	hsp =  -hsp
 if !audio_is_playing(sndPunch){
	 
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndPunch, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	screenshake(10,5);
	 
}
	 		if (!hitstop_active && place_meeting(x, y-20, oEnemy)) {
 if !audio_is_playing(sndPunch){
	 hsp =  -hsp
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndPunch, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	screenshake(10,5);
}
 
// Check for enemy collision to the left
if (!hitstop_active && place_meeting(x, y+20, oEnemy)) {
	hsp =  -hsp
 if !audio_is_playing(sndPunch){
	 
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndPunch, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	screenshake(10,5);
}
	  
			   // Check for enemy collision to the right
			   
// ==== Enemy Melee Hit Detection ====
if (!hitstop_active) {
    var melee_hit_right = instance_place(x + 20, y, oEnemyMelee);
    var melee_hit_left  = instance_place(x - 20, y, oEnemyMelee);
    
    if (melee_hit_right != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (melee_hit_right) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
    else if (melee_hit_left != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (melee_hit_left) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
}


// ==== Enemy Jumper Hit Detection ====
if (!hitstop_active) {
    var jumper_hit_right = instance_place(x + 20, y, oEnemyJumper);
    var jumper_hit_left  = instance_place(x - 20, y, oEnemyJumper);
    
    if (jumper_hit_right != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (jumper_hit_right) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
    else if (jumper_hit_left != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (jumper_hit_left) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
}


// ==== Enemy Projectile Hit Detection ====
if (!hitstop_active) {
    var proj_hit_right = instance_place(x + 20, y, oEnemyProjectile);
    var proj_hit_left  = instance_place(x - 20, y, oEnemyProjectile);
    
    if (proj_hit_right != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (proj_hit_right) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
    else if (proj_hit_left != noone) {
        screenshake(10, 5);
        hitstop_active = true;
        with (proj_hit_left) {
            hp--;
            flash = 4;
        }
        instance_create_layer(x, y, "Player", oHitstop);
    }
}


if (!hitstop_active && place_meeting(x+20, y, oBossPhaseMelee)) {
	screenshake(10,5);
    hitstop_active = true;      // Activate hitstop
    oBossCollision.hp--;                        // Damage player
    oBossPhaseMelee.flash = 4;            // Enemy flash effect
    instance_create_layer(x, y, "Player", oHitstop); // Spawn hitstop object
	
}
 
// Check for enemy collision to the left
if (!hitstop_active && place_meeting(x-20, y, oBossPhaseMelee)) {
	screenshake(10,5);
    hitstop_active = true;      // Activate hitstop
    oBossCollision.hp--;                        // Damage player
    oBossPhaseMelee.flash = 4;
    instance_create_layer(x, y, "Player", oHitstop);
	
}
 // 
 
 if (!hitstop_active && place_meeting(x+20, y, oBossPhaseProjectile)) {
	screenshake(10,5);
    hitstop_active = true;      // Activate hitstop
    oBossCollision.hp--;                        // Damage player
    oBossPhaseProjectile.flash = 4;            // Enemy flash effect
    instance_create_layer(x, y, "Player", oHitstop); // Spawn hitstop object
	
}
 
// Check for enemy collision to the left
if (!hitstop_active && place_meeting(x-20, y, oBossPhaseProjectile)) {
	screenshake(10,5);
    hitstop_active = true;      // Activate hitstop
    oBossCollision.hp--;                        // Damage player
    oBossPhaseProjectile.flash = 4;
    instance_create_layer(x, y, "Player", oHitstop);
	
}

 
 
 


// Optional: reset hitstop flag after a short duration
if (hitstop_active) {
    hitstop_timer += 1;
    if (hitstop_timer > 2) { // 2 steps later, allow next hit
        hitstop_active = false;
        hitstop_timer = 0;
    }
	
	
	
	
	
	
}

		
		
		
		
		
		
		
    }

    // === ANIMATION HANDLING ===
    if (groundpounding) sprite_index = groundpound;
    else sprite_index = kick;

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
		
	 if ( place_meeting(x, y + 20, oEnemy)) {
 if !audio_is_playing(sndPunch){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndPunch, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	  if !audio_is_playing(sndSlam){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndSlam, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
        screenshake(vsp/3,vsp/3);
        vsp = -min(vsp*.75, 25);
	
		
		is_kicking= false;
		groundpounding = false;
    }
	
	//
	
	// ==== Enemy Melee Collision ====
var melee_hit = instance_place(x, y + 20, oEnemyMelee);
if (melee_hit != noone) {
    with (melee_hit) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}

var melee_hit2 = instance_place(x+20, y , oEnemyMelee);
if (melee_hit2 != noone) {
    with (melee_hit2) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}

var melee_hit3 = instance_place(x-20, y , oEnemyMelee);
if (melee_hit3 != noone) {
    with (melee_hit3) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}

// ==== Enemy Jumper Collision ====
var jumper_hit = instance_place(x, y + 20, oEnemyJumper);
if (jumper_hit != noone) {
    with (jumper_hit) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}
var jumper_hit2 = instance_place(x+ 20, y , oEnemyJumper);
if (jumper_hit2 != noone) {
    with (jumper_hit2) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}
var jumper_hit3 = instance_place(x-20, y, oEnemyJumper);
if (jumper_hit3 != noone) {
    with (jumper_hit3) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}


// ==== Enemy Projectile Collision ====
var proj_hit = instance_place(x, y + 20, oEnemyProjectile);
if (proj_hit != noone) {
    with (proj_hit) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}

var proj_hit2 = instance_place(x+ 20, y , oEnemyJumper);
if (proj_hit2 != noone) {
    with (proj_hit2) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}
var proj_hit3 = instance_place(x-20, y, oEnemyJumper);
if (proj_hit3 != noone) {
    with (proj_hit3) {
        flash = 4;
        hp--;
    }
    instance_create_layer(x, y, "Player", oHitstop);
}



	
		 if ( place_meeting(x, y + 20, oBossPhaseProjectile)) {

		oBossPhaseProjectile.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;

	
		

    }
	
			 if ( place_meeting(x- 20, y , oBossPhaseProjectile)) {

		oBossPhaseProjectile.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;

	
		

    }
			 if ( place_meeting(x+ 20, y , oBossPhaseProjectile)) {

		oBossPhaseProjectile.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;

	
		

    }
	
	
	//
	
	 if ( place_meeting(x, y + 20, oBossPhaseMelee)) {

		oBossPhaseMelee.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;
		
	
		

    }
	
	
	
	
	if ( place_meeting(x+ 20, y , oBossPhaseMelee)) {

		oBossPhaseMelee.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;
		
	
		

    }
	
		
	if ( place_meeting(x- 20, y , oBossPhaseMelee)) {

		oBossPhaseMelee.flash = 4;
		instance_create_layer(x,y,"Player",oHitstop);
		oBossCollision.hp--;
		
	
		

    }
	
    // Landed after a ground pound
 if vsp >= 0{
	 
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
        vsp = -min(vsp*.8, 37);

	
		
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
        vsp = -min(vsp*0.75, 30); 
	
 

		if place_meeting(x, y+20, oSlopeL){
			hsp-=20
		}
	if place_meeting(x, y+20, oSlopeR){
			hsp +=20
		}
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

if (hsp != 0) image_xscale = sign(hsp) *-3;

//wall slide\

if (place_meeting(x + 1, y, oWall) || place_meeting(x - 1, y, oWall))  {
    // Reduce horizontal speed to half to make jump easier? maybe take this out well see
    //hsp *= 0.5;
	can_dash = true;
	sprite_index = wallslide; // wall jump sprite
    // Accelerate vertical speed from 0 to 1 gradually
    if (vsp <= vsp + grv) { 
        vsp -= 0.115; // perfect fucking number
    }
}
if slope = false{
if(place_meeting(x + 10, y, oWall)){
	image_xscale = 3
}

if (place_meeting(x - 10, y, oWall)){
	image_xscale = -3
}
}
if key_jump && (place_meeting(x + 20, y, oWall) || place_meeting(x - 20, y, oWall)) {

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
