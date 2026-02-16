/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === CONSTANTS ===
var acceleration   = 0.2;     // Horizontal acceleration
var verticalAccel  = 0.1;     // Vertical acceleration (slower for smooth float)
var deceleration   = 0.25;
var maxSpeed       = 4;
var pursueDistance = 700;
var verticalOffset = -250;    // Stay above player
var hoverAmplitude = 4;       // Vertical bobbing height
var hoverSpeed     = 0.1;    // Hover motion speed

/// === LOCAL VARIABLES ===
var closestPlayer = noone;
var closestDist   = 999999;

/// === FIND CLOSEST PLAYER ===
with (oPlayer) {
    var dist = point_distance(x, y, other.x, other.y);
    if (dist < closestDist) {
        closestDist = dist;
        closestPlayer = id;
    }
}

/// === IF PLAYER EXISTS ===
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

    /// === DETERMINE MOVEMENT DIRECTION ===
    var dirX = 0;
    var dirY = 0;

    if (closestDist <= pursueDistance) {
        if (collision_line(x, y, closestPlayer.x, closestPlayer.y, oWall, true, false) == noone) {
            // Horizontal: chase player
            dirX = (closestPlayer.x > x) ? 1 : -1;

            // Vertical: maintain offset above player
            var deltaY = (closestPlayer.y + verticalOffset) - y;
            if (abs(deltaY) > 5) dirY = (deltaY > 0) ? 1 : -1;
        }
    }

    /// === HORIZONTAL MOVEMENT ===
    if (dirX != 0) {
        hsp += dirX * acceleration;
    } else {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    /// === VERTICAL MOVEMENT ===
    if (dirY != 0) {
        vsp += dirY * verticalAccel;
    } else {
        var signVsp = sign(vsp);
        vsp -= signVsp * deceleration;
        if (sign(vsp) != signVsp) vsp = 0;
    }

    /// === CLAMP SPEEDS ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);
    vsp = clamp(vsp, -maxSpeed, maxSpeed);

    /// === WALL COLLISION ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) x += sign(hsp);
        hsp = 0;
    }
    if (place_meeting(x, y + vsp, oWall)) {
        while (!place_meeting(x, y + sign(vsp), oWall)) y += sign(vsp);
        vsp = 0;
    }

    /// === APPLY MOVEMENT ===
    x += hsp;
    y += vsp;

} else {
    // No players exist
    hsp = 0;
    vsp = 0;
}

/// === HOVER EFFECT ===
if (!variable_instance_exists(id, "hoverTime")) hoverTime = irandom(1000);
hoverTime += hoverSpeed;
y += sin(hoverTime) * hoverAmplitude * 0.1;
