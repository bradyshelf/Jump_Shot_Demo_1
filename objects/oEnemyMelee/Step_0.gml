/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === Constants ===
var acceleration   = 0.5;
var deceleration   = 0.25;
var maxSpeed       = 8.5;
var pursueDistance = 600;
var grv            = 0.4;

/// === Local Vars ===
vsp += grv; // Apply gravity always
var closestPlayer = noone;
var closestDist = 999999;

/// Find closest player
with (oPlayer) {
    var dist = point_distance(x, y, other.x, other.y);
    if (dist < closestDist) {
        closestDist = dist;
        closestPlayer = id;
    }
}

// If there is a player
if (closestPlayer != noone) {

    /// === COLLISION WITH PLAYER ===
    if (place_meeting(x + hsp, y, closestPlayer)) {
        while (!place_meeting(x + sign(hsp), y, closestPlayer)) {
            x += sign(hsp);
        }
        hsp = -hsp * 2;
        closestPlayer.hsp = -hsp;
        screenshake(5,5);
        closestPlayer.flash = 4;
        closestPlayer.hp -= 10;
        instance_create_layer(x, y, "Player", oHitstop);

        if (!audio_is_playing(sndHurt)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndHurt, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
    }

    if (place_meeting(x, y + vsp, closestPlayer)) {
        while (!place_meeting(x, y + sign(vsp), closestPlayer)) {
            y += sign(vsp);
        }
        vsp = -vsp * 1.1;
    }

    /// === Determine direction toward closest player ===
    var horizontal = 0;
    if (closestDist <= pursueDistance && place_meeting(x, y + 1, oWall)) {
        if (collision_line(x, y, closestPlayer.x, closestPlayer.y - 20, oWall, true, false) == noone) {
            horizontal = (closestPlayer.x > x) ? 1 : -1;
        }
    }

    /// === Horizontal acceleration/deceleration ===
    if (horizontal != 0) {
        hsp += horizontal * acceleration;
    } else {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    /// === Clamp horizontal speed ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);

    /// === Horizontal collision with walls ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }

    /// === Vertical collision with walls ===
    if (place_meeting(x, y + vsp, oWall)) {
        while (!place_meeting(x, y + sign(vsp), oWall)) {
            y += sign(vsp);
        }
        vsp = 0;
    }

    /// === Apply movement ===
    x += hsp;
    y += vsp;

} else {
    // No players exist
    hsp = 0;
}
