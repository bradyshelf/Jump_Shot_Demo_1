		 if !audio_is_playing(sndHurt){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndHurt, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }
		
//audio_play_sound(sndHit, 1, false);
instance_create_layer(x,y,"Player",oHitstop);
screenshake(4,4);
 // Freeze for 15 frames
// Calculate direction and distance between the bullet and the enemy
var dx = other.x - x;
var dy = other.y - y;
var distance = point_distance(x, y, other.x, other.y);

// Normalize the direction vector
var knockback_x = dx / distance;
var knockback_y = dy / distance;

// Add some vertical knockback
var vertical_knockback = -1; // Adjust this value for more or less vertical movement

// Set knockback strength
var knockback_strength_x = 5; // Adjust the horizontal knockback strength
var knockback_strength_y = 5; // Adjust the vertical knockback strength

// Apply knockback to the enemy
with (oPlayer2)
{
screenshake(2, 5);
hp -= 10;
flash = 4;

    // Calculate new position
    var new_x = x + knockback_x * knockback_strength_x;
    var new_y = y + knockback_y * knockback_strength_y + vertical_knockback;
    
    // Check for collision at new position
    if (place_meeting(new_x, y, oWall)) {
        // Bounce horizontally
        knockback_x = -knockback_x;
        new_x = x + knockback_x * knockback_strength_x;
    }
    
    if (place_meeting(x, new_y, oWall)) {
        // Bounce vertically
        knockback_y = -knockback_y;
        new_y = y + knockback_y * knockback_strength_y + vertical_knockback;
    }
            if (place_meeting(new_x, y, oPlayer1)) {
        // Bounce horizontally
        knockback_x = -knockback_x;
        new_x = x + knockback_x * knockback_strength_x;
    }
    
    if (place_meeting(x, new_y, oPlayer1)) {
        // Bounce vertically
        knockback_y = -knockback_y;
        new_y = y + knockback_y * knockback_strength_y + vertical_knockback;
    }
	
	
		        if (place_meeting(new_x, y, oEnemy)) {
        // Bounce horizontally
        knockback_x = -knockback_x;
        new_x = x + knockback_x * knockback_strength_x;
    }
    
    if (place_meeting(x, new_y, oEnemy)) {
        // Bounce vertically
        knockback_y = -knockback_y;
        new_y = y + knockback_y * knockback_strength_y + vertical_knockback;
    }
    // Update position
    x = new_x;
    y = new_y;
}


speed = 0;
// Change the bullet instance to the hit spark
instance_change(oHitSpark, true);


