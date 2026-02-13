// === Position Sync ===

if instance_exists(oScreenPause){

exit;
}else{



x = owner.x;
y = owner.y;

image_xscale = abs(owner.image_xscale);
image_yscale = abs(owner.image_yscale);

// === Recoil Decay ===
recoil = max(0, recoil - 1);

// === Player Detection ===
if (instance_exists(oPlayer)) {
    var dist = point_distance(x, y, oPlayer.x, oPlayer.y);

    if (dist < 1000) {
        countdown--;

        // === When countdown finishes, start the firing sequence ===
        if (countdown <= 0) {

            // Wait for the burst delay between volleys
            if (burstTimer <= 0) {

                // === Fire full 360° spread ===
                var bullet_total = 12;       // bullets per circle
                var angle_step   = 360 / bullet_total;

                // Alternate rotation direction each volley
                var direction_flip = (burstCount mod 2 == 0) ? 1 : -1;

                // Add slight spin offset that alternates direction
                var base_angle = (burstCount * 10 * direction_flip) mod 360;

                for (var i = 0; i < bullet_total; i++) {
                    var dir = base_angle + i * angle_step;

                    var b = instance_create_layer(x, y, "bullets", oBossBullet);
                    if (b != noone) {
                        b.direction = dir;
                        b.speed = 5;
                        b.image_angle = dir;
                    }
                }

                // === Burst Management ===
                burstCount++;
                burstTimer = burstDelay; // wait before next ring

                // === End of Burst Cycle ===
                if (burstCount >= burstTotal) {
                    countdown = countdownrate; // reset for next firing round
                    burstCount = 0;
                }

                recoil = 5;

            } else {
                burstTimer--;
            }
        }
    }
}

// === Apply Recoil ===
x -= lengthdir_x(recoil, image_angle);
y -= lengthdir_y(recoil, image_angle);
}