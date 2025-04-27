
function PlayerStateGP(){
	
	        is_kicking = true;
        groundpounding = true; // <- Commit to the ground pound
        sprite_index = groundpound;
        image_index = 0;
        image_speed = 1;
        
        // Cancel upward movement and slam down immediately
        vsp = max(vsp, 0); // Cancel any upward motion
        vsp += 22;         // Slam down force
	
	
	    if (vsp != 0 && place_meeting(x, y + vsp, enemyplayer)) {
        var dir = sign(vsp);
        while (!place_meeting(x, y + dir, enemyplayer)) {
            y += dir;
        }
		is_kicking= false;
		groundpounding = false;
       screenshake(vsp/3,vsp/3);
        vsp = -min(vsp, 37); 
	
		enemyplayer.hp -= 10;
		enemyplayer.flash = 4;
		
		if place_meeting(enemyplayer.x, enemyplayer.y, oWall){
		enemyplayer.vsp += vsp/1.5;
	
		}else{
			enemyplayer.vsp -= vsp;
		
		}
    }

        if (groundpounding) {
            // Committed to ground pound
            sprite_index = groundpound;
        } else{
		state = PlayerStateFree;	
			
		}
        // Freeze animation on last frame
        if (image_index >= image_number - 1) {
            image_index = image_number - 1;
            image_speed = 0;
        }
    
	
	
	
	
	
	   if (groundpounding) {
    // Landed after a ground pound
 if vsp > 0 {
	 
var pitch = random_range(.8, 1.2); // Slightly vary the pitch
	 	 if !audio_is_playing(sndThud){

    var snd_id = audio_play_sound(sndSlam, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
	 	 	 if !audio_is_playing(sndThud){
    var snd_id2 = audio_play_sound(sndThud, 1, false);
    audio_sound_pitch(snd_id2, pitch);
	 }
	 
	  screenshake(vsp/5,vsp/5);
        vsp = -min(vsp*0.75, 37); // Bounce up but cap the bounce speed to -20
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

}