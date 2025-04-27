draw_self();

if (flash > 0){
	flash--;
shader_set(HitFlashBlue);
draw_self();
shader_reset();
}