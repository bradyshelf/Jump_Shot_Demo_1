/// === CAMERA LOCKED SMOOTHLY WITH ZOOM ===
if !instance_exists(oPlayer){
room_restart();
}
// Target position
var target_x = 1950;
var target_y = 0;

// Smoothly interpolate camera position
var cam_speed = 0.05; // smaller = slower, smoother
var current_x = camera_get_view_x(view_camera[0]);
var current_y = camera_get_view_y(view_camera[0]);
var new_x = lerp(current_x, target_x, cam_speed);
var new_y = lerp(current_y, target_y, cam_speed);

// Apply new position
camera_set_view_pos(view_camera[0], new_x, new_y);

// === ZOOM AND VIEWPORT SETTINGS ===
var target_width = 2560;  // Width of the camera view (smaller = zoomed in, larger = zoomed out)
var target_height = 1440;  // Height of the camera view

// Get current size
var current_width = camera_get_view_width(view_camera[0]);
var current_height = camera_get_view_height(view_camera[0]);

// Smoothly interpolate size for zoom effect
var zoom_speed = 0.05; 
var new_width = lerp(current_width, target_width, zoom_speed);
var new_height = lerp(current_height, target_height, zoom_speed);

// Apply new size
camera_set_view_size(view_camera[0], new_width, new_height);
