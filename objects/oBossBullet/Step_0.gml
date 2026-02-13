
if instance_exists(oScreenPause){
speed = 0;
exit;
}else{
speed = 5;	
}

if(place_meeting(x,y,oWall) || place_meeting(x,y,oPlayer)) && (image_index != 0)
{
	speed = 0;
	instance_change(oHitSpark, true);
}
