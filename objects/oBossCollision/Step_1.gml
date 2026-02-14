if (hp <= 0)
{
	//with(instance_create_layer(x, y, layer, oded))
	//{
	//	direction = other.hitfrom;
	//	hsp = lengthdir_x(3,direction);
	//	vsp = lengthdir_y(3,direction)-2;
	//}
	instance_destroy(oBossPhaseMelee);
	instance_destroy(oBossPhaseProjectile);
	instance_destroy(oBossGun);
	instance_destroy(self);
}

