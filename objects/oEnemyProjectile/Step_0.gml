/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === Constants ===
var acceleration   = 0.2;
var deceleration   = 0.25;
var maxSpeed       = 2;
var pursueDistance = 600;

/// === Local Vars ===
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
    if (place_meeting(x + hsp, y + vsp, closestPlayer)) {
        while (!place_meeting(x + sign(hsp), y + sign(vsp), closestPlayer)) {
            x += sign(hsp);
            y += sign(vsp);
        }
        hsp = -hsp * 2;
        vsp = -vsp * 2;
        closestPlayer.hsp = -hsp;
        closestPlayer.vsp = -vsp;
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

    /// === Determine direction toward closest player ===
    var dirX = 0;
    var dirY = 0;
    if (closestDist <= pursueDistance) {
        if (collision_line(x, y, closestPlayer.x, closestPlayer.y, oWall, true, false) == noone) {
            dirX = (closestPlayer.x > x) ? 1 : -1;
            dirY = (closestPlayer.y > y) ? 1 : -1;
        }
    }

    /// === Horizontal movement ===
    if (dirX != 0) {
        hsp += dirX * acceleration;
    } else {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    /// === Vertical movement ===
    if (dirY != 0) {
        vsp += dirY * acceleration;
    } else {
        var signVsp = sign(vsp);
        vsp -= signVsp * deceleration;
        if (sign(vsp) != signVsp) vsp = 0;
    }

    /// === Clamp speeds ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);
    vsp = clamp(vsp, -maxSpeed, maxSpeed);

    /// === Collision with walls ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) {
            x += sign(hsp);
        }
        hsp = 0;
    }

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
    vsp = 0;
}
