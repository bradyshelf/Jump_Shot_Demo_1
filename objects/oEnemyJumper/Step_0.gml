	// === Constants ===
var acceleration = 1;
var deceleration = 0.5;
var maxSpeed = 3;
var pursueDistance = 400;
var jumpSpeed = -7;
var wallJumpSpeed = -10;
var wallJumpOutwardSpeed = 7;
var grv = 0.4;

// === State variables ===
var onGround = place_meeting(x, y + 1, oWall);
var onWallLeft = place_meeting(x - 1, y, oWall);
var onWallRight = place_meeting(x + 1, y, oWall);
var onWall = onWallLeft || onWallRight;
var canJump = onGround || onWall;

// === Pause check ===
if instance_exists(oScreenPause) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

// === Find closest player ===
var closestPlayer = noone;
var minDist = 999999;

with (oPlayer) {
    var d = point_distance(other.x, other.y, x, y);
    if (d < minDist) {
        minDist = d;
        closestPlayer = id;
    }
}

if closestPlayer != noone {

    // --- Collision with the closest player ---
    if (place_meeting(x + hsp, y, closestPlayer)) {
        while (!place_meeting(x + sign(hsp), y, closestPlayer)) {
            x += sign(hsp);
        }
        hsp = -hsp*2;
        screenshake(3,3);

        closestPlayer.hsp = -hsp*2;
        closestPlayer.flash = 4;
        closestPlayer.hp -= 2;
        instance_create_layer(x, y, "Player", oHitstop);

        if !audio_is_playing(sndHurt) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndHurt, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
    }

    if (place_meeting(x, y + vsp, closestPlayer)) {
        while (!place_meeting(x, y + sign(vsp), closestPlayer)) {
            y += sign(vsp);
        }
        vsp = -vsp*1.1;
        screenshake(3,3);

        closestPlayer.flash = 4;
        closestPlayer.hp -= 4;
        instance_create_layer(x, y, "Player", oHitstop);

        if !audio_is_playing(sndHurt) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndHurt, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
    }

    // --- Pursue closest player ---
    var playerX = closestPlayer.x;
    var playerY = closestPlayer.y;
    var distToPlayer = minDist;

    var targetHsp = 0;
    var targetVsp = 0;

    if (distToPlayer <= pursueDistance && collision_line(x, y, playerX, playerY - 20, oWall, true, false) == noone) {
        if (playerX > x) targetHsp = acceleration;
        else if (playerX < x) targetHsp = -acceleration;

        if (playerY > y) targetVsp = acceleration;
        else if (playerY < y) targetVsp = -acceleration;
    }

    // Apply horizontal acceleration/deceleration
    if (targetHsp != 0) hsp += targetHsp;
    else {
        if (hsp > 0) hsp = max(0, hsp - deceleration);
        else if (hsp < 0) hsp = min(0, hsp + deceleration);
    }

    // Jump if able
    if (canJump && collision_line(x, y, playerX, playerY - 20, oWall, true, false) == noone) {
        vsp = jumpSpeed;
    }

    // Wall jump logic
    if (onWall) {
        if (onWallRight) hsp = -wallJumpOutwardSpeed;
        else if (onWallLeft) hsp = wallJumpOutwardSpeed;
        vsp = wallJumpSpeed;
    }
}

// --- Apply gravity ---
vsp += grv;

// --- Clamp horizontal speed ---
hsp = clamp(hsp, -maxSpeed, maxSpeed);

// --- Horizontal collision with walls ---
if (place_meeting(x + hsp, y, oWall)) {
    while (!place_meeting(x + sign(hsp), y, oWall)) x += sign(hsp);
    hsp = -hsp;
}

// --- Vertical collision with walls ---
if (place_meeting(x, y + vsp, oWall)) {
    while (!place_meeting(x, y + sign(vsp), oWall)) y += sign(vsp);
    vsp = 0;
}

// --- Update position ---
x += hsp;
y += vsp;
