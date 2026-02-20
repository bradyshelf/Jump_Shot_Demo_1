audio_stop_sound(sndMenuSong)

if room = BossRoom{
if !audio_is_playing(sndLevelBossSong){
	audio_play_sound(sndLevelBossSong,1,true);
}	
	
}else{
	audio_stop_sound(sndLevelBossSong)
	
}
