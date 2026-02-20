hsp = 4;    
vsp = 0;    
walksp = 4; 

hp = 2;              // or whatever your starting HP is
hp_previous = hp;     // must exist before Step runs
hit_timer = 0;
hit_duration = 12;     // fallback frames for single-frame hit sprite


flash = 0;
hitfrom=0;
hasweapon = true;

if (hasweapon)
{
	mygun = instance_create_layer(x,y,"Gun", oGun)
	with (mygun)
	{
		owner = other.id
	}
	
	
}
else instance_destroy(mygun);


