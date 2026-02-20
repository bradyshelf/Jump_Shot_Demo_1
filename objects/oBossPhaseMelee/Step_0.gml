/// === BOSS TIMER / PROJECTILE SWITCH ===
if (iframes > 0) {
    iframes -= 1;
}

instance_destroy(oBossGun);
timer--;
if (timer <= 0) {
    instance_change(oBossPhaseProjectile, true);
}

/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === CONSTANTS ===
var acceleration   = 0.5;
var deceleration   = 0.25;
var maxSpeed       = 8.5;
var pursueDistance = 1000;
var grv            = 0.4;

/// === LOCAL VARS ===
vsp += grv; // gravity
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

/// === IF A PLAYER EXISTS ===
if (closestPlayer != noone) {

    // === COLLISION WITH PLAYER (HORIZONTAL) ===
    if (place_meeting(x + hsp, y, closestPlayer)) {

        // Snap to edge
        while (!place_meeting(x + sign(hsp), y, closestPlayer)) {
            x += sign(hsp);
        }

        // Knockback
        hsp = -hsp * 2;
        closestPlayer.hsp = -hsp;
        screenshake(5, 5);

        // Player damage only if not invincible
        if (closestPlayer.iframes <= 0) {
            closestPlayer.hp -= 15;
            closestPlayer.flash = 4;
            closestPlayer.iframes = 20; // short invincibility
            instance_create_layer(x, y, "Player", oHitstop);
        }

        // Hurt sound
        if (!audio_is_playing(sndHurt)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndHurt, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
    }

    // === COLLISION WITH PLAYER (VERTICAL) ===
    if (place_meeting(x, y + vsp, closestPlayer)) {

        while (!place_meeting(x, y + sign(vsp), closestPlayer)) {
            y += sign(vsp);
        }

        // Bounce
        vsp = -vsp * 1.1;
        hsp = -hsp * 2;
        closestPlayer.hsp = -hsp;
        screenshake(5, 5);

        if (closestPlayer.iframes <= 0) {
            closestPlayer.hp -= 50;
            closestPlayer.flash = 4;
            closestPlayer.iframes = 20;
            instance_create_layer(x, y, "Player", oHitstop);
        }

        if (!audio_is_playing(sndHurt)) {
            var pitch = random_range(0.8, 1.2);
            var snd_id = audio_play_sound(sndHurt, 1, false);
            audio_sound_pitch(snd_id, pitch);
        }
    }

    /// === DETERMINE DIRECTION TOWARD PLAYER ===
    var horizontal = 0;
    if (closestDist <= pursueDistance && place_meeting(x, y + 1, oWall)) {
        if (collision_line(x, y, closestPlayer.x, closestPlayer.y - 20, oWall, true, false) == noone) {
            horizontal = (closestPlayer.x > x) ? 1 : -1;
        }
    }

    /// === HORIZONTAL ACCELERATION/DECELERATION ===
    if (horizontal != 0) {
        hsp += horizontal * acceleration;
    } else {
        var signHsp = sign(hsp);
        hsp -= signHsp * deceleration;
        if (sign(hsp) != signHsp) hsp = 0;
    }

    /// === CLAMP HORIZONTAL SPEED ===
    hsp = clamp(hsp, -maxSpeed, maxSpeed);

    /// === COLLISION WITH WALLS ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) {
            x += sign(hsp);
        }
        hsp = -hsp;
    }

    if (place_meeting(x, y + vsp, oWall)) {
        while (!place_meeting(x, y + sign(vsp), oWall)) {
            y += sign(vsp);
        }
        vsp = 0;
    }

    /// === APPLY MOVEMENT ===
    x += hsp;
    y += vsp;

    /// === ANIMATION SELECTION ===
    if (vsp != 0) {
        sprite_index = sBossPhase1Fall;
    } else if (hsp != 0) {
        sprite_index = sBossAttack_2;
        image_xscale = sign(hsp) * 3;
        image_speed = abs(hsp) / 8;
    } else {
        sprite_index = sBossPhase1Idle;
    }

    /// === VICTORY STATE (NO PLAYERS) ===
    if (!instance_exists(oPlayer1) && !instance_exists(oPlayer2)) {
        sprite_index = sVictory;
    }

} else {
    // No players exist
    hsp = 0;
}