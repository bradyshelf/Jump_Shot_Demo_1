// How close players need to be to open the door
var open_range = 500;

// Count how many players exist
var p1_exists = instance_exists(oPlayer1);
var p2_exists = instance_exists(oPlayer2);

// Distance variables
var dist1 = 999999;
var dist2 = 999999;

// Calculate distances if players exist
if (p1_exists) dist1 = point_distance(x, y, oPlayer1.x, oPlayer1.y);
if (p2_exists) dist2 = point_distance(x, y, oPlayer2.x, oPlayer2.y);

// === Door logic ===
if (p1_exists && p2_exists) {
    // Both alive → BOTH must be near
    if (dist1 < open_range && dist2 < open_range) {
        instance_change(oDoorOpened, true);
    }
} else if (p1_exists) {
    // Only player 1 alive → just player 1
    if (dist1 < open_range) {
        instance_change(oDoorOpened, true);
    }
} else if (p2_exists) {
    // Only player 2 alive → just player 2
    if (dist2 < open_range) {
        instance_change(oDoorOpened, true);
    }
}
