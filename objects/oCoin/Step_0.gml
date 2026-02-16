// Step Event (frame-rate independent; uses delta_time in microseconds)
t += delta_time * 0.000001; // delta_time is microseconds per step -> convert to seconds

var hover_phase = t * (2 * pi) * hover_speed; // radians
var rot_phase   = t * (2 * pi) * rot_speed;

y = ystart + sin(hover_phase) * hover_height;
image_xscale = sin(rot_phase);
