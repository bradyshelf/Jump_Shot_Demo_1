// === Get Player Positions ===

if instance_exists(oPlayer1) && instance_exists(oPlayer2){
var px1 = oPlayer1.x;
var py1 = oPlayer1.y ;
var px2 = oPlayer2.x;
var py2 = oPlayer2.y;

// === Smoothed Midpoint Between Players ===
var target_mid_x = (px1 + px2) * 0.5;
var target_mid_y = (py1 + py2) * 0.5;

// === Initialize smooth values if needed ===
if (!variable_global_exists("smooth_mid_x")) {
    global.smooth_mid_x = target_mid_x;
    global.smooth_mid_y = target_mid_y;
}

// === Interpolate midpoint — vertical slower ===
global.smooth_mid_x = lerp(global.smooth_mid_x, target_mid_x, 0.025);
global.smooth_mid_y = lerp(global.smooth_mid_y, target_mid_y, 0.025);

// === Distance between players ===
var dist = point_distance(px1, py1, px2, py2);

// === Zoom factor based on distance ===
var zoom_target = clamp(lerp(1, 1.3, (dist - 400) / 500), 1, 1.3);

// === Smooth zoom interpolation ===
zoom_factor = lerp(zoom_factor, zoom_target, 0.05);

// === Base view size ===
var base_view_w = camera_get_view_width(0);
var base_view_h = camera_get_view_height(0);
var view_w = base_view_w * zoom_factor;
var view_h = base_view_h * zoom_factor;

// === Calculate camera target position ===
var cam_target_x = global.smooth_mid_x - view_w * 0.5;
var cam_target_y = global.smooth_mid_y - view_h * 0.5;


// === Clamp camera to stay in room bounds ===
cam_target_x = clamp(cam_target_x, 0, room_width - view_w);
cam_target_y = clamp(cam_target_y, 0, room_height - view_h);

// === Smooth camera follow ===
if (!variable_global_exists("camera_x")) {
    global.camera_x = cam_target_x;
    global.camera_y = cam_target_y;
}

global.camera_x = lerp(global.camera_x, cam_target_x, 0.1);
global.camera_y = lerp(global.camera_y, cam_target_y, 0.1);

// === Base (clean) position for parallax & shake ===
var base_x = global.camera_x;
var base_y = global.camera_y;

// === Screen Shake ===
var shake_x = random_range(-shake_remain, shake_remain);
var shake_y = random_range(-shake_remain, shake_remain);
shake_remain = max(0, shake_remain - ((1 / shake_length) * shake_magnitude));

// Apply shake to base position
var shaken_x = base_x + shake_x;
var shaken_y = base_y + shake_y;

// Clamp shaken position to room bounds
shaken_x = clamp(shaken_x, 0, room_width - view_w);
shaken_y = clamp(shaken_y, 0, room_height - view_h);

// === Apply Camera ===
var cam = view_camera[0];
camera_set_view_size(cam, view_w, view_h);
camera_set_view_pos(cam, shaken_x, shaken_y);

// === Parallax Backgrounds (use clean base_x/y only) ===
//var z = zoom_factor; // for readability

//if (layer_exists("BG1")) layer_x("BG1", base_x * 0.05);
//if (layer_exists("BG2")) layer_x("BG2", base_x * 0.1);
//if (layer_exists("BG3")) layer_x("BG3", base_x * 0.2);
//if (layer_exists("BG4")) layer_x("BG4", base_x * 0.3);
//if (layer_exists("BG5")) layer_x("BG5", base_x * 0.4);

//var b = 3;
//if (layer_exists("BG1")) layer_y("BG1", 1000 + base_y * 0.5 / b);
//if (layer_exists("BG2")) layer_y("BG2", 750 + base_y * 0.3 / b);
//if (layer_exists("BG3")) layer_y("BG3", 750 + base_y * 0.2 / b);
//if (layer_exists("BG4")) layer_y("BG4", 750 + base_y * 0.1 / b);
//if (layer_exists("BG5")) layer_y("BG5", 750 + base_y * 0.1 / b);
//}else{
	
	
}