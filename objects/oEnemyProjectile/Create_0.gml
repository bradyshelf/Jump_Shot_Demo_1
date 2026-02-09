hsp = 4;    
vsp = 0;    
walksp = 4; 

hp = 1; //hp for single player

grv = 0.25;

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


