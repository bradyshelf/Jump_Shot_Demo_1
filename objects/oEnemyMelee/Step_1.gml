if (hp <= 0)
{
	 if (!audio_is_playing(sndZombie)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndZombie, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
		
	
//	if !audio_is_playing(sndZombieDead){
//		  var s1 = audio_play_sound(sndZombieDead, 0, false);
//    audio_sound_pitch(s1, random_range(0.9, 1.4)); 
	
//}



	//with(instance_create_layer(x, y, layer, oded))
	//{
	//	direction = other.hitfrom;
	//	hsp = lengthdir_x(3,direction);
	//	vsp = lengthdir_y(3,direction)-2;
	//}
	
	instance_change(oDead, true);
}


