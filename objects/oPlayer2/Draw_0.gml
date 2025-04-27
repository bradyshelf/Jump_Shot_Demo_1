
draw_self();

if (flash > 0){
	flash--;
shader_set(HitFlashRed);
draw_self();
shader_reset();
}