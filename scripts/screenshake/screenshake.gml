

function screenshake(argument0, argument1) {

	    with (oCamera) {
        if (argument0 > shake_remain) {
            shake_magnitude = argument0;
            shake_remain = argument0;
            shake_length = argument1;
            shake_frame_count = 0; // Reset frame count when starting a new shake
        }
    }

	
}
