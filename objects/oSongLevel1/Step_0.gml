audio_stop_sound(sndLevelComicSong)



if room = Room1 || room = Room2 || room = Room3 || room = Room4 || room = Room5 {
if !audio_is_playing(sndMenuSong){
	audio_play_sound(sndMenuSong,1,true);
}	
	
}else{
	audio_stop_sound(sndMenuSong)
	
}

