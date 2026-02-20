// === Advance Animation on Button Press ===
if (keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(4, gp_face1)) {
    image_index += 1;

    // If reached the last frame, move to next room
    if (image_index >= image_number) {
        // Optional: clamp to last frame so it doesn’t go out of range
        image_index = image_number - 1;

  SlideTransition(TRANS_MODE.NEXT, 0);
    }
}