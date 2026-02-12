if(place_meeting(x,y,oWall) || place_meeting(x,y,oPlayer)) && (image_index != 0)
{
	speed = 0;
	instance_change(oHitSpark, true);
}
