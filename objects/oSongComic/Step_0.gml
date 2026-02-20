audio_stop_sound(sndMenuSong)
audio_stop_sound(sndAmbience)

if room = ComicRoom1{
if !audio_is_playing(sndLevelComicSong){
	audio_play_sound(sndLevelComicSong,1,true);
}	
	
}else{
	audio_stop_sound(sndLevelComicSong)
	
}

