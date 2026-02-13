draw_self();

if (flash > 0){
	flash--;
shader_set(HitFlashWhite);
draw_self();
shader_reset();
}