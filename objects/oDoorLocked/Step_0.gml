/// === Door Open Logic ===
var open_range = 500;

// Check players
var p1_exists = instance_exists(oPlayer1);
var p2_exists = instance_exists(oPlayer2);

// Distance defaults
var dist1 = 999999;
var dist2 = 999999;

// Get distances if players exist
if (p1_exists) dist1 = point_distance(x, y, oPlayer1.x, oPlayer1.y);
if (p2_exists) dist2 = point_distance(x, y, oPlayer2.x, oPlayer2.y);

// === Open Conditions ===
// Door opens if ANY player with hasKey == true is close enough
if (p1_exists && oPlayer1.hasKey && dist1 < open_range) {
    instance_change(oDoorOpened, true);
}
else if (p2_exists && oPlayer2.hasKey && dist2 < open_range) {
    instance_change(oDoorOpened, true);
}
