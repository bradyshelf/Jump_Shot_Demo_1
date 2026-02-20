/// === PAUSE CHECK ===
if (instance_exists(oScreenPause)) {
    image_speed = 0;
    exit;
} else {
    image_speed = 1;
}

/// === CONSTANTS ===
var acceleration   = 0.2;
var verticalAccel  = 0.1;
var deceleration   = 0.25;
var maxSpeed       = 4;
var pursueDistance = 700;
var verticalOffset = -250;
var hoverAmplitude = 4;
var hoverSpeed     = 0.1;

/// === LOCAL VARS ===
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

if (closestPlayer != noone) {

    // === COLLISION WITH PLAYER ===
    if (place_meeting(x + hsp, y + vsp, closestPlayer)) {

        // Only damage the player if not invincible
        if (closestPlayer.iframes <= 0) {

            // Knockback both entities
            var knock_dir_x = sign(closestPlayer.x - x);
            var knock_dir_y = sign(closestPlayer.y - y);

            hsp = -knock_dir_x * 2;
            vsp = -knock_dir_y * 2;

            closestPlayer.hsp = knock_dir_x * 2;
            closestPlayer.vsp = -2;

            // Damage and feedback
            screenshake(5, 5);
            closestPlayer.flash = 4;
            closestPlayer.hp -= 10;
            closestPlayer.iframes = 20;

            instance_create_layer(x, y, "Player", oHitstop);

            if (!audio_is_playing(sndHurt)) {
                var pitch = random_range(0.8, 1.2);
                var snd_id = audio_play_sound(sndHurt, 1, false);
                audio_sound_pitch(snd_id, pitch);
            }

            // 🔹 Push the bat slightly away to prevent overlap
            x -= knock_dir_x * 6;
            y -= knock_dir_y * 6;
        }
    }

    /// === DETERMINE MOVEMENT DIRECTION ===
    var dirX = 0;
    var dirY = 0;

    if (closestDist <= pursueDistance) {
        if (collision_line(x, y, closestPlayer.x, closestPlayer.y, oWall, true, false) == noone) {
            dirX = sign(closestPlayer.x - x);
            var deltaY = (closestPlayer.y + verticalOffset) - y;
            if (abs(deltaY) > 5) dirY = sign(deltaY);
        }
    }

    /// === MOVEMENT ===
    if (dirX != 0) hsp += dirX * acceleration;
    else hsp = approach(hsp, 0, deceleration);

    if (dirY != 0) vsp += dirY * verticalAccel;
    else vsp = approach(vsp, 0, deceleration);

    hsp = clamp(hsp, -maxSpeed, maxSpeed);
    vsp = clamp(vsp, -maxSpeed, maxSpeed);

    // === WALL COLLISIONS ===
    if (place_meeting(x + hsp, y, oWall)) {
        while (!place_meeting(x + sign(hsp), y, oWall)) x += sign(hsp);
        hsp = -hsp * 0.8;
    }
    if (place_meeting(x, y + vsp, oWall)) {
        while (!place_meeting(x, y + sign(vsp), oWall)) y += sign(vsp);
        vsp = -vsp * 0.8;
    }

    // === APPLY MOVEMENT ===
    x += hsp;
    y += vsp;

    // === ANIMATION ===
    var moveSpeed = point_distance(0, 0, hsp, vsp);
    image_speed = clamp(moveSpeed / maxSpeed, 0.5, 1);

    // === HP LOSS DETECTION ===
    if (hp < hp_previous) {
        sprite_index = sBatHit;
        image_index = 0;
        image_speed = 1;
        hit_timer = hit_duration;
    }

    // === HIT ANIMATION HANDLING ===
    if (sprite_index == sBatHit) {
        if (image_number > 1) {
            if (image_index < image_number - 1) {
                hp_previous = hp;
                exit;
            }
        } else if (hit_timer > 0) {
            hit_timer -= 1;
            hp_previous = hp;
            exit;
        }

        if (instance_exists(oGun) && oGun.countdown <= 0) {
            sprite_index = sBatAttack;
            image_index = 0;
        } else {
            sprite_index = sBatFly;
            image_index = 0;
        }

        hp_previous = hp;
        exit;
    }

    /// === NORMAL STATE HANDLING ===
    if (instance_exists(oGun) && oGun.countdown <= 0) {
        if (sprite_index != sBatAttack) {
            sprite_index = sBatAttack;
            image_index = 0;
        }
    } else {
        if (sprite_index != sBatFly) {
            sprite_index = sBatFly;
            image_index = 0;
        }
    }

    hp_previous = hp;

} else {
    hsp = 0;
    vsp = 0;
}

/// === HOVER EFFECT ===
if (!variable_instance_exists(id, "hoverTime")) hoverTime = irandom(1000);
hoverTime += hoverSpeed;
y += sin(hoverTime) * hoverAmplitude * 0.1;

/// === SMOOTH APPROACH FUNCTION ===
function approach(value, target, amount) {
    if (value < target) return min(value + amount, target);
    if (value > target) return max(value - amount, target);
    return value;
}