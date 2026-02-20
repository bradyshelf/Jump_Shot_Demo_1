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
var pursueDistance = 600;
var grv            = 0.4;
var bite_duration  = 15;
var hit_duration   = 20;

/// === LOCAL VARS ===
vsp += grv;
var closestPlayer = noone;
var closestDist   = 999999;

/// === STATE SYSTEM ===
if (!variable_instance_exists(id, "state")) state = "idle";
if (!variable_instance_exists(id, "state_timer")) state_timer = 0;

/// === FIND CLOSEST PLAYER ===
with (oPlayer) {
    var dist = point_distance(x, y, other.x, other.y);
    if (dist < closestDist) {
        closestDist = dist;
        closestPlayer = id;
    }
}

if (closestPlayer != noone) {

    // === COLLISION WITH PLAYER (HORIZONTAL ATTACK) ===
    if (place_meeting(x + hsp, y, closestPlayer) && state != "hit") {

        // Only damage the player if they are NOT invincible
        if (closestPlayer.iframes <= 0) {

            // Snap to edge of collision
            while (!place_meeting(x + sign(hsp), y, closestPlayer)) {
                x += sign(hsp);
            }

            // Knockback both sides
            hsp = -hsp * 2;
            closestPlayer.hsp = -hsp * 0.5;

            screenshake(5, 5);

            // Player damage + feedback
            closestPlayer.flash = 4;
            closestPlayer.hp -= 25;
            closestPlayer.iframes = 20; // Give player invulnerability after being hit

            instance_create_layer(x, y, "Player", oHitstop);

            if (!audio_is_playing(sndHurt)) {
                var pitch = random_range(0.8, 1.2);
                var snd_id = audio_play_sound(sndHurt, 1, false);
                audio_sound_pitch(snd_id, pitch);
            }

            // Enter bite state
            state = "bite";
            state_timer = bite_duration;
            sprite_index = sZombieBite;
            image_index = 0;
            image_speed = 0.25;
        }
    }

    // === COLLISION WITH PLAYER (VERTICAL) ===
    if (place_meeting(x, y + vsp, closestPlayer)) {
        while (!place_meeting(x, y + sign(vsp), closestPlayer)) {
            y += sign(vsp);
        }
        vsp = -hsp * 1.1;
    }

    // === ENEMY TAKING DAMAGE ===
    if (hp < hp_previous && state != "hit") {
        state = "hit";
        state_timer = hit_duration;
        sprite_index = sZombieHit;
        image_index = 0;
        image_speed = 0.2;
    }

    // === STATE TIMER HANDLING ===
    if (state_timer > 0) {
        state_timer -= 1;
        if (state_timer <= 0) {
            state = "idle";
        }
    }

    // === MOVEMENT & AI ===
    if (state != "bite" && state != "hit") {

        var horizontal = 0;

        // Follow player if in range and line of sight
        if (closestDist <= pursueDistance && place_meeting(x, y + 1, oWall)) {
            if (collision_line(x, y, closestPlayer.x, closestPlayer.y - 20, oWall, true, false) == noone) {
                horizontal = (closestPlayer.x > x) ? 1 : -1;
            }
        }

        // Acceleration / deceleration
        if (horizontal != 0) {
            hsp += horizontal * acceleration;
        } else {
            var signHsp = sign(hsp);
            hsp -= signHsp * deceleration;
            if (sign(hsp) != signHsp) hsp = 0;
        }

        // Clamp speed
        hsp = clamp(hsp, -maxSpeed, maxSpeed);

        // Collisions with walls
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

        // Apply movement
        x += hsp;
        y += vsp;

        // Animation logic
        if (vsp != 0) {
            sprite_index = ZombieFalling;
            image_speed = 1;
        } else if (hsp >= 1) {
            sprite_index = ZombieRun;
            image_xscale = -3;
            image_speed = abs(hsp) / 8;
        } else if (hsp <= -1) {
            sprite_index = ZombieRun;
            image_xscale = 3;
            image_speed = abs(hsp) / 8;
        } else {
            sprite_index = ZombieIdle;
            image_speed = 0.2;
        }
    }

} else {
    hsp = 0;
}

/// === UPDATE PREVIOUS HP ===
hp_previous = hp;