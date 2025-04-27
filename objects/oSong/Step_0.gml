if room = Menu{
if !audio_is_playing(sndMenuSong){
	audio_play_sound(sndMenuSong,1,true);
}	
	
}else{
	audio_stop_sound(sndMenuSong)
	
}


if room = Room1{
if !audio_is_playing(sndGymSong){
	audio_play_sound(sndGymSong,1,true);
}	
	
}else{
	audio_stop_sound(sndGymSong)
	
}