// === Get Player Positions ===
if (!instance_exists(oPlayer1) && !instance_exists(oPlayer2)) {
    room_restart();
}
var both_players = instance_exists(oPlayer1) && instance_exists(oPlayer2);
var one_alive = instance_exists(oPlayer1) || instance_exists(oPlayer2);

if (both_players) {
    // === Two Players Alive ===
    var px1 = oPlayer1.x+250;
    var py1 = oPlayer1.y;
    var px2 = oPlayer2.x+250;
    var py2 = oPlayer2.y;

    // === Smoothed Midpoint Between Players ===
    var target_mid_x = (px1 + px2) * 0.5;
    var target_mid_y = (py1 + py2) * 0.5;

} else if (instance_exists(oPlayer1)) {
    // === Only Player 1 Alive ===
    var target_mid_x = oPlayer1.x+250;
    var target_mid_y = oPlayer1.y;

} else if (instance_exists(oPlayer2)) {
    // === Only Player 2 Alive ===
    var target_mid_x = oPlayer2.x+250;
    var target_mid_y = oPlayer2.y;

} else {
    // === No Players Alive ===
    exit;
}

// === Initialize smooth values if needed ===
if (!variable_global_exists("smooth_mid_x")) {
    global.smooth_mid_x = target_mid_x;
    global.smooth_mid_y = target_mid_y;
}

// === Interpolate midpoint (vertical slower) ===
global.smooth_mid_x = lerp(global.smooth_mid_x, target_mid_x, 0.025);
global.smooth_mid_y = lerp(global.smooth_mid_y, target_mid_y, 0.025);

// === Zoom factor based on distance (only if both players exist) ===
if (both_players) {
    var dist = point_distance(px1, py1, px2, py2);
    var zoom_target = clamp(lerp(1.6, 1.9, (dist - 400) / 500), 1.6, 1.9);
} else {
    // Single player: default zoom
    var zoom_target = 1.8;
}

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

// === Clamp camera to room bounds ===
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

// === Parallax Backgrounds ===
var z = zoom_factor;
var zoom_adj = 1 / z;
if (layer_exists("Door")) layer_x("Door", base_x * 0.08 * zoom_adj);
if (layer_exists("BG2")) layer_x("BG2", base_x * 0.08 * zoom_adj);
if (layer_exists("BG3")) layer_x("BG3", base_x * 0.075 * zoom_adj);
if (layer_exists("BG4")) layer_x("BG4", base_x * 0.05 * zoom_adj);
if (layer_exists("BG5")) layer_x("BG5", base_x * 0.025 * zoom_adj);
if (layer_exists("BG6")) layer_x("BG6", base_x * 0.01 * zoom_adj);
if (layer_exists("BG7")) layer_x("BG7", base_x * 0.001 * zoom_adj);
if (layer_exists("BG8")) layer_x("BG8", base_x * 0.001 * zoom_adj);
