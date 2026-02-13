	// Constants for acceleration and deceleration

	var acceleration = 1; // Adjust as needed
	var deceleration = 0.5; // Adjust as needed
	var maxSpeed = 3; // Adjust as needed
	var pursueDistance = 400; // Distance threshold to start pursuing the player
	var jumpSpeed = -7; // Adjusted for higher jump strength
	var wallJumpSpeed = -10; // Adjusted for higher wall jump strength
	var wallJumpOutwardSpeed = 7; // Adjust as needed for wall jump outward strength

	// State variables
	var onGround = place_meeting(x, y + 1, oWall);
	var onWallLeft = place_meeting(x - 1, y, oWall);
	var onWallRight = place_meeting(x + 1, y, oWall);
	var onWall = onWallLeft || onWallRight;
	var canJump = onGround || onWall;

	// Check if the player exists
	if (instance_exists(oPlayer)) {
		        if (place_meeting(x + hsp, y, oPlayer)) {
        while (!place_meeting(x + sign(hsp), y, oPlayer)) {
            x += sign(hsp);
        }
        hsp = -hsp*2;
		oPlayer.flash = 4
		oPlayer.hp -=2;
		instance_create_layer(x,y,"Player",oHitstop);
    }

 if (place_meeting(x , y+ vsp, oPlayer)) {
        while (!place_meeting(x , y+ sign(vsp), oPlayer)) {
            y += sign(vsp);
        }
		vsp = -vsp*1.1;
		oPlayer.flash = 4
		oPlayer.hp -=4;
		instance_create_layer(x,y,"Player",oHitstop);
      
    }

	    // Get the player's position
	    var playerX = oPlayer.x;
	    var playerY = oPlayer.y;

	    // Calculate the distance to the player
	    var distToPlayer = point_distance(x, y, playerX, playerY);

	    // Movement direction
	    var targetHsp = 0;
	    var targetVsp = 0;

	    // Pursue the player if within the pursueDistance
	    if (distToPlayer <= pursueDistance && collision_line(x, y, oPlayer.x, oPlayer.y - 20, oWall, true, false) == noone) {
	        if (playerX > x) {
	            targetHsp = acceleration;
	        } else if (playerX < x) {
	            targetHsp = -acceleration;
	        }

	        if (playerY > y) {
	            targetVsp = acceleration;
	        } else if (playerY < y) {
	            targetVsp = -acceleration;
	        }
	    }

	    // Apply acceleration
	    if (targetHsp != 0) {
	        hsp += targetHsp;
	    } else {
	        // Apply deceleration if not pursuing horizontally
	        if (hsp > 0) {
	            hsp = max(0, hsp - deceleration);
	        } else if (hsp < 0) {
	            hsp = min(0, hsp + deceleration);
	        }
	    }

	    // Always allow jumping if canJump
	    if (canJump && collision_line(x, y, oPlayer.x, oPlayer.y - 20, oWall, true, false) == noone) {
	        vsp = jumpSpeed; // Set vsp to jumpSpeed when canJump
	    }

	    // Handle wall jumping
	    if (onWall) {
	        if (onWallRight) {
	            hsp = -wallJumpOutwardSpeed; // Jumping left
	        } else if (onWallLeft) {
	            hsp = wallJumpOutwardSpeed; // Jumping right
	        }
	        vsp = wallJumpSpeed; // Set vsp to wallJumpSpeed
	    }
	}

	// Apply gravity
	vsp += grv;

	// Apply maximum speed limits
	hsp = clamp(hsp, -maxSpeed, maxSpeed);

	// Horizontal collision
	if (place_meeting(x + hsp, y, oWall)) {
	    while (!place_meeting(x + sign(hsp), y, oWall)) {
	        x += sign(hsp);
	    }
	    hsp = -hsp; // Stop horizontal speed upon collision
	}

	// Vertical collision
	if (place_meeting(x, y + vsp, oWall)) {
	    while (!place_meeting(x, y + sign(vsp), oWall)) {
	        y += sign(vsp);
	    }
	    vsp = 0; // Stop vertical speed upon collision
	}




	// Update position
	x += hsp;
	y += vsp;