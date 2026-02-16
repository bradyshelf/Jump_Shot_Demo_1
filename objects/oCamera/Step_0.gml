/// === CAMERA STEP EVENT ===
if !instance_exists(oPlayer1) && !instance_exists(oPlayer2){
	room_restart();
	
}
// === PLAYER PRESENCE CHECK ===
var both_players = instance_exists(oPlayer1) && instance_exists(oPlayer2);
var one_alive    = instance_exists(oPlayer1) || instance_exists(oPlayer2);

if (!one_alive) exit;

// === GET PLAYER POSITIONS ===
var px1, py1, px2, py2;
if (instance_exists(oPlayer1)) { px1 = oPlayer1.x; py1 = oPlayer1.y; }
if (instance_exists(oPlayer2)) { px2 = oPlayer2.x; py2 = oPlayer2.y; }

// === DETERMINE MIDPOINT ===
var target_mid_x, target_mid_y;

if (both_players) {
    target_mid_x = (px1 + px2) * 0.5 +200;
    target_mid_y = (py1 + py2) * 0.5;
} else if (instance_exists(oPlayer1)) {
    target_mid_x = px1+200;
    target_mid_y = py1;
} else if (instance_exists(oPlayer2)) {
    target_mid_x = px2+300;
    target_mid_y = py2;
}

// === INITIALIZE GLOBALS ===
if (!variable_global_exists("smooth_mid_x")) {
    global.smooth_mid_x = target_mid_x;
    global.smooth_mid_y = target_mid_y;
}
if (!variable_global_exists("camera_x")) {
    global.camera_x = target_mid_x;
    global.camera_y = target_mid_y;
}
if (!variable_global_exists("cam_lead_x")) {
    global.cam_lead_x = 0;
    global.cam_lead_y = 0;
}
if (!variable_global_exists("zoom_factor")) {
    zoom_factor = 1;
}
if (!variable_global_exists("prev_mid_x")) {
    global.prev_mid_x = target_mid_x;
    global.prev_mid_y = target_mid_y;
}

// === CAMERA LEAD SETTINGS ===
var lead_strength = 200; // how far ahead to look
var lead_smooth   = 0.1; // smooth factor for look-ahead

// === CAMERA LEAD LOGIC ===
var dx = target_mid_x - global.prev_mid_x;
var dy = target_mid_y - global.prev_mid_y;

var lead_x = clamp(dx * lead_strength, -lead_strength, lead_strength);
var lead_y = clamp(dy * 0.5, -lead_strength * 0.5, lead_strength * 0.5);

global.cam_lead_x = lerp(global.cam_lead_x, lead_x, lead_smooth);
global.cam_lead_y = lerp(global.cam_lead_y, lead_y, lead_smooth);

target_mid_x += global.cam_lead_x;
target_mid_y += global.cam_lead_y;

// Store for next frame
global.prev_mid_x = target_mid_x - global.cam_lead_x;
global.prev_mid_y = target_mid_y - global.cam_lead_y;

// === SMOOTH CAMERA CENTER ===
global.smooth_mid_x = lerp(global.smooth_mid_x, target_mid_x, 0.025);
global.smooth_mid_y = lerp(global.smooth_mid_y, target_mid_y, 0.025);

// === ZOOM LOGIC ===
if (both_players) {
    var dist = point_distance(px1, py1, px2, py2);
    var zoom_target = clamp(lerp(1, 1.3, (dist - 400) / 500), 1, 1.3);
} else {
    var zoom_target = 1;
}
zoom_factor = lerp(zoom_factor, zoom_target, 0.05);

// === BASE VIEW DIMENSIONS ===
var base_view_w = camera_get_view_width(0);
var base_view_h = camera_get_view_height(0);
var view_w = base_view_w * zoom_factor;
var view_h = base_view_h * zoom_factor;

// === CAMERA TARGET POSITION ===
var cam_target_x = global.smooth_mid_x - view_w * 0.5;
var cam_target_y = global.smooth_mid_y - view_h * 0.5;

// === ROOM CLAMP ===
cam_target_x = clamp(cam_target_x, 0, room_width - view_w);
cam_target_y = clamp(cam_target_y, 0, room_height - view_h);

// === SMOOTH FOLLOW ===
global.camera_x = lerp(global.camera_x, cam_target_x, 0.1);
global.camera_y = lerp(global.camera_y, cam_target_y, 0.1);

// === BASE POSITION ===
var base_x = global.camera_x;
var base_y = global.camera_y;

// === SCREEN SHAKE ===
if (!variable_global_exists("shake_remain")) shake_remain = 0;
if (!variable_global_exists("shake_magnitude")) shake_magnitude = 0;
if (!variable_global_exists("shake_length")) shake_length = 1;

var shake_x = random_range(-shake_remain, shake_remain);
var shake_y = random_range(-shake_remain, shake_remain);
shake_remain = max(0, shake_remain - ((1 / shake_length) * shake_magnitude));

var shaken_x = base_x + shake_x;
var shaken_y = base_y + shake_y;

shaken_x = clamp(shaken_x, 0, room_width - view_w);
shaken_y = clamp(shaken_y, 0, room_height - view_h);

// === APPLY CAMERA ===
var cam = view_camera[0];
camera_set_view_size(cam, view_w, view_h);
camera_set_view_pos(cam, shaken_x, shaken_y);

// === PARALLAX BACKGROUNDS ===
var z = zoom_factor;
var zoom_adj = 1 / z;

if (layer_exists("BG2")) layer_x("BG2", base_x * 0.08 * zoom_adj);
if (layer_exists("BG3")) layer_x("BG3", base_x * 0.075 * zoom_adj);
if (layer_exists("BG4")) layer_x("BG4", base_x * 0.05 * zoom_adj);
if (layer_exists("BG5")) layer_x("BG5", base_x * 0.025 * zoom_adj);
if (layer_exists("BG6")) layer_x("BG6", base_x * 0.01 * zoom_adj);
if (layer_exists("BG7")) layer_x("BG7", base_x * 0.001 * zoom_adj);
if (layer_exists("BG8")) layer_x("BG8", base_x * 0.001 * zoom_adj);
