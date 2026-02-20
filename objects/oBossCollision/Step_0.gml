
		    if (!audio_is_playing(sndWitch)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndWitch, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
				
if !instance_exists(oBossPhaseProjectile)&& !instance_exists(oBossPhaseMelee){

instance_destroy();
}

if instance_exists(oBossPhaseProjectile){
		x= oBossPhaseProjectile.x
		y= oBossPhaseProjectile.y
	
}


if instance_exists(oBossPhaseMelee){
	x= oBossPhaseMelee.x
		y= oBossPhaseMelee.y
}

