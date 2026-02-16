// === PAUSE SCREEN STEP EVENT ===

// === GUI SETUP ===
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// === SOUND ASSIGNMENTS ===
var snd_hover  = sndSelect;
var snd_select = sndPush;

// === MENU LAYOUT ===
var spacing = menu_itemheight * 1.1; // vertical distance between options
var total_height = spacing * menu_items;
var start_y = (gui_h / 2) - (total_height / 2) + 40;

// === SMOOTH MENU MOVEMENT ===
menu_x += (menu_x_target - menu_x) / menu_speed;

// === INPUT CONTROL ===
if (menu_control)
{
    // === KEYBOARD / GAMEPAD NAVIGATION ===
    if (keyboard_check_pressed(vk_up) || gamepad_button_check_pressed(0, gp_padu))
    {
        menu_cursor--;
        if (menu_cursor < 0) menu_cursor = menu_items - 1;

        var pitch = random_range(0.8, 1);
        var s = audio_play_sound(snd_hover, 1, false);
        audio_sound_pitch(s, pitch);
    }

    if (keyboard_check_pressed(vk_down) || gamepad_button_check_pressed(0, gp_padd))
    {
        menu_cursor++;
        if (menu_cursor >= menu_items) menu_cursor = 0;

        var pitch = random_range(0.8, 1);
        var s = audio_play_sound(snd_hover, 1, false);
        audio_sound_pitch(s, pitch);
    }

    // === CONFIRM (ENTER / A BUTTON) ===
    if (keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_face1))
    {
        menu_x_target = gui_w + 300;
        menu_committed = menu_cursor;
        menu_control = false;
        audio_play_sound(snd_select, 1, false);
    }

    // === MOUSE INPUT ===
    var mouse_y_gui = device_mouse_y_to_gui(0);

    // --- Hover detection ---
    for (var i = 0; i < menu_items; i++)
    {
        var item_y = start_y + (spacing * i);
        var top = item_y - (menu_itemheight * 0.7);
        var bottom = item_y + (menu_itemheight * 0.7);

        if (mouse_y_gui >= top && mouse_y_gui <= bottom)
        {
            if (menu_cursor != i)
            {
                menu_cursor = i;
                var pitch = random_range(0.8, 1);
                var s = audio_play_sound(snd_hover, 1, false);
                audio_sound_pitch(s, pitch);
            }
            break;
        }
    }

    // --- Click detection (on currently highlighted item) ---
    if (mouse_check_button_pressed(mb_left))
    {
        menu_x_target = gui_w + 300;
        menu_committed = menu_cursor;
        menu_control = false;
        audio_play_sound(snd_select, 1, false);
    }
}

// === HANDLE SELECTION AFTER TRANSITION ===
if ((menu_x > gui_w + 60) && (menu_committed != -1))
{
    switch (menu_committed)
    {
        // === 0: RESUME GAME ===
        case 0:
            if (!audio_is_playing(snd_select))
                audio_play_sound(snd_select, 1, false);
            instance_destroy(oPauseScreen);
            break;

        // === 1: RESTART AT CHECKPOINT ===
        case 1:
            if (!audio_is_playing(snd_select))
                audio_play_sound(snd_select, 1, false);

            //if (variable_global_exists("checkpoint_room"))
            //{
            //    if (room != global.checkpoint_room)
            //        SlideTransition(TRANS_MODE.GOTO, global.checkpoint_room);
            //    else
            //        room_restart();
            //}
            //else
            //{
            //    room_restart();
            //}
			room_restart();
            instance_destroy(oPauseScreen);
            break;

        // === 2: RETURN TO LOBBY ===
        case 2:
            if (!audio_is_playing(snd_select))
                audio_play_sound(snd_select, 1, false);

            SlideTransition(TRANS_MODE.GOTO, Menu);
            instance_destroy(oPauseScreen);
            break;
    }
}
