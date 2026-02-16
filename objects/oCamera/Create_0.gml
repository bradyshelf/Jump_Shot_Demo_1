

p1 = oPlayer1
p2= oPlayer2
cam = view_camera[0];
zoom_factor = 1;

view_w_half = camera_get_view_width(cam) * 0.5;
view_h_half = camera_get_view_height(cam) * 0.5;
view_w = camera_get_view_width(cam);
view_h = camera_get_view_height(cam);
xTo = xstart;
yTo = ystart;

shake_length = 0;
shake_magnitude = 0;
shake_remain = 0;
shake_frame_count = 0;

 direction_timer = 0; // Timer to track how long the player has been moving in one direction

target_zoom_factor = 1; // Target zoom factor
transition_speed = 0.01; // Speed of the transition