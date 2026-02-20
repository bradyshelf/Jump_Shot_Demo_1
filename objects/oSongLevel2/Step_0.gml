audio_stop_sound(sndMenuSong)

if room = Room6 &&room == Room7&&room == Room8&&room == Room9{
if !audio_is_playing(sndLevel2Song){
	audio_play_sound(sndLevel2Song,1,true);
}	
	
}else{
	audio_stop_sound(sndLevel2Song)
	
}
