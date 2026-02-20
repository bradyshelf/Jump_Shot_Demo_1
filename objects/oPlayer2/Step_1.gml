if hp <= 0 {		
if !instance_exists(enemyplayer){
	room_restart();
}
	
		instance_destroy();
		
		
		  if (!audio_is_playing(sndDead)) {
                var pitch = random_range(0.8, 1.2);
                var sid = audio_play_sound(sndDead, 1, false);
                audio_sound_pitch(sid, pitch);
            }
					  if (!audio_is_playing(sndHurt)) {
                var pitch = random_range(0.8, 1.2);
                var sid = audio_play_sound(sndHurt, 1, false);
                audio_sound_pitch(sid, pitch);
            }
	
	}	