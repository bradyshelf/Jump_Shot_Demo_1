if instance_exists(oScreenPause) {
    exit;
} else {

    // === Positioning and recoil management ===
    x = owner.x;
    y = owner.y;

    image_xscale = abs(owner.image_xscale);
    image_yscale = abs(owner.image_yscale);

    recoil = max(0, recoil - 1);

    // === Find closest player ===
    var closestPlayer = noone;
    var closestDist = 100000; // arbitrary large number

    with (oPlayer) {
        var distToGun = point_distance(x, y, other.x, other.y);
        if (distToGun < closestDist) {
            closestDist = distToGun;
            closestPlayer = id;
        }
    }

    // === Check range and line-of-sight ===
    if (closestPlayer != noone && closestDist < 600) {
        image_angle = point_direction(x, y, closestPlayer.x - 20, closestPlayer.y - 20);
        countdown--;

        if (countdown <= 0 && collision_line(x, y, closestPlayer.x, closestPlayer.y - 20, oWall, true, true) == noone) {

            // === Handle burst firing ===
            if (burstTimer <= 0) {
                // Fire a bullet
                with (instance_create_layer(x, y, "bullets", oEnemyBullet)) {
					
					        if (!audio_is_playing(sndBatSpit)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndBatSpit, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
		
		
			    if (!audio_is_playing(sndFart)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndFart, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
                    speed = 10;
                    direction = other.image_angle + random_range(-1, 1);
                    image_angle = direction;
                }

                // Update burst state
                burstCount++;
                burstTimer = burstDelay; // Reset burst delay

                // Check if the burst is complete
                if (burstCount >= burstTotal) {
                    countdown = countdownrate; // Reset countdown after full burst
                    burstCount = 0; // Reset burst count
                }

                recoil = 5;

            } else {
                // Decrease the burst timer
                burstTimer--;
            }
        }
    }

    // === Apply recoil to position ===
    x -= lengthdir_x(recoil, image_angle);
    y -= lengthdir_y(recoil, image_angle);
}
