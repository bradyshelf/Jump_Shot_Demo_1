global.coin_count++;

 if !audio_is_playing(sndCollect1){
	  var pitch = random_range(0.8, 1.2); // Slightly vary the pitch
    var snd_id = audio_play_sound(sndCollect1, 1, false);
    audio_sound_pitch(snd_id, pitch);
	 }



instance_destroy();