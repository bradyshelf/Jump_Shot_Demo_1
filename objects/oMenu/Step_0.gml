//if (gamepad_is_connected(0)|| gamepad_is_connected(4)) && (gamepad_is_connected(1)|| gamepad_is_connected(5)) {


// Center of GUI
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

// Sounds
var hover_sound = sndSelect;
var select_sound = sndPush;

// Menu vertical layout values
var spacing = menu_itemheight * .8;
var total_menu_height = spacing * menu_items;
var start_y = gui_height / 2 - (total_menu_height / 2) + 40;

// Easing menu x position
menu_x += (menu_x_target - menu_x) / menu_speed;

// --- KEYBOARD / GAMEPAD CONTROLS ---
if (menu_control)
{
    if (keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(4, gp_padu))
    {
        menu_cursor--;
        if (menu_cursor < 0) menu_cursor = menu_items - 1;

        if (menu_cursor != last_hovered)
        {
            var pitch = random_range(0.7, 1);
            var snd_id = audio_play_sound(hover_sound, 1, false);
            audio_sound_pitch(snd_id, pitch);
            last_hovered = menu_cursor;
        }
    }

    if (keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(4, gp_padd))
    {
        menu_cursor++;
        if (menu_cursor >= menu_items) menu_cursor = 0;

        if (menu_cursor != last_hovered)
        {
            var pitch = random_range(0.7, 1);
            var snd_id = audio_play_sound(hover_sound, 1, false);
            audio_sound_pitch(snd_id, pitch);
            last_hovered = menu_cursor;
        }
    }

    if (keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(4, gp_face1))
    {
        menu_x_target = gui_width + 300;
        menu_committed = menu_cursor;
        menu_control = false;
        audio_play_sound(select_sound, 1, false);
    }

    // --- MOUSE CONTROLS ---
    var mouse_y_gui = device_mouse_y_to_gui(0);

    for (var i = 0; i < menu_items; i++)
    {
        var item_y = start_y + (spacing * i);

        if (abs(mouse_y_gui - item_y) < spacing / 2)
        {
            if (menu_cursor != i)
            {
                menu_cursor = i;
                var pitch = random_range(0.7, 1);
                var snd_id = audio_play_sound(hover_sound, 1, false);
                audio_sound_pitch(snd_id, pitch);
                last_hovered = i;
            }

            if (mouse_check_button_pressed(mb_left))
            {
                menu_x_target = gui_width + 300;
                menu_committed = i;
                menu_control = false;
            }

            break; // Don't check other items once match is found
        }
    }
}


if ((menu_x > gui_width + 60) && (menu_committed != -1))
{
    switch (menu_committed)
    {
        case 0:
            if (!audio_is_playing(sndPush))
            {
                audio_play_sound(sndPush, 1, false);
            }
            SlideTransition(TRANS_MODE.GOTO, Room1);
            break;

        case 1:

	 audio_stop_all()
game_end();
    }
}
//}