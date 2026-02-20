// === Position Sync ===
if instance_exists(oScreenPause) {
    exit;
} else {
    x = owner.x;
    y = owner.y;

    image_xscale = abs(owner.image_xscale);
    image_yscale = abs(owner.image_yscale);

    // === Recoil Decay ===
    recoil = max(0, recoil - 1);

    // === Find the closest player ===
    var closestPlayer = noone;
    var closestDist   = 100000; // arbitrarily large number

    // Loop through all player instances (includes children)
    with (oPlayer) {
        var distToGun = point_distance(x, y, other.x, other.y);
        if (distToGun < closestDist) {
            closestDist = distToGun;
            closestPlayer = id;
        }
    }

    // === Fire if a player exists and is within range ===
    if (closestPlayer != noone && closestDist < 1000) {
        countdown--;

        if (countdown <= 0) {
            if (burstTimer <= 0) {

                // === Fire full 360° spread ===
                var bullet_total = 12;
                var angle_step   = 360 / bullet_total;

                var direction_flip = (burstCount mod 2 == 0) ? 1 : -1;
                var base_angle = (burstCount * 10 * direction_flip) mod 360;

                for (var i = 0; i < bullet_total; i++) {
					
					 if (!audio_is_playing(sndFogHorn)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndFogHorn, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
		
		
			    if (!audio_is_playing(sndPush)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndPush, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
					
					
			    if (!audio_is_playing(sndSpell)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndSpell, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
		
				    if (!audio_is_playing(sndThunder)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndThunder, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
				
					
					
					
                    var dir = base_angle + i * angle_step;

                    var b = instance_create_layer(x, y, "bullets", oBossBullet);
                    if (b != noone) {
	
                        var angleToPlayer = point_direction(x, y, closestPlayer.x, closestPlayer.y);
                        b.direction = dir + angleToPlayer;
                        b.speed = 5;
                        b.image_angle = b.direction;
                    }
                }

                burstCount++;
                burstTimer = burstDelay;

                if (burstCount >= burstTotal) {
                    countdown = countdownrate;
                    burstCount = 0;
                }

                recoil = 5;

            } else {
                burstTimer--;
			
            }
        }
    }

    // === Apply Recoil ===
    x -= lengthdir_x(recoil, image_angle);
    y -= lengthdir_y(recoil, image_angle);
}
