/* Copyright 2022 schwarzer-geiger
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT(
        TG(1), KC_DEL, KC_9, KC_0,
        KC_1,  KC_2,   KC_3, KC_4,
        KC_5,  KC_6,   KC_7, KC_8,
        KC_U,  KC_I,   KC_O, KC_P,
        KC_J,  KC_K,   KC_L, KC_SCLN
    ),

    [1] = LAYOUT(
        KC_TRNS,        KC_TRNS,  KC_ESC,  MS_BTN3,
        MS_BTN1,        MS_BTN2,  KC_ENT,  LCTL(KC_C),
        LT(2, KC_PGUP), KC_PGDN,  KC_BSPC, LCTL(KC_V),
        KC_Q,           KC_E,     KC_R,    KC_T,
        KC_Y,           KC_F,     KC_G,    KC_H
    ),

    [2] = LAYOUT(
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
        KC_TRNS, MS_WHLD, KC_TRNS, KC_TRNS,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    )
};

joystick_config_t joystick_axes[JOYSTICK_AXIS_COUNT] = {
    [0] = JOYSTICK_AXIS_IN(A3, 1023, 512, 0),
    [1] = JOYSTICK_AXIS_IN(A4, 0, 512, 1023),
    [2] = JOYSTICK_AXIS_IN(A1, 1023, 512, 0),
    [3] = JOYSTICK_AXIS_IN(A2, 0, 512, 1023)
};

void keyboard_pre_init_kb(void) {

    gpio_set_pin_output_push_pull(A15);
    gpio_set_pin_output_push_pull(B10);
    gpio_set_pin_output_push_pull(B11);

    keyboard_pre_init_user();
}

bool cursor_mode = false;
bool scrolling_mode = false;

layer_state_t layer_state_set_user(layer_state_t state) {
    switch (get_highest_layer(state)) {
        case 0:
            cursor_mode = false;
            scrolling_mode = false;
            gpio_write_pin_high(A15);
            gpio_write_pin_high(B10);
            gpio_write_pin_low(B11);
            break;
        case 1:
            cursor_mode = true;
            scrolling_mode = false;
            gpio_write_pin_high(A15);
            gpio_write_pin_low(B10);
            gpio_write_pin_high(B11);
            break;
        case 2:
            cursor_mode = false;
            scrolling_mode = true;
            gpio_write_pin_low(A15);
            gpio_write_pin_high(B10);
            gpio_write_pin_high(B11);
            break;
    }
    return state;
}

bool pointing_device_driver_init(void) { 
    return true; 
}

uint16_t pointing_device_driver_get_cpi(void) { 
    return 0; 
}

void pointing_device_driver_set_cpi(uint16_t cpi) {

}

report_mouse_t pointing_device_driver_get_report(report_mouse_t mouse_report) {
    // 读取摇杆轴值 (-127 到 127)
    int8_t x_axis = (joystick_read_axis(0)) / 8;  // X轴
    int8_t y_axis = (joystick_read_axis(1)) / 8;  // Y轴
    
    // 应用死区过滤
    const int8_t deadzone = 10;
    if (abs(x_axis) < deadzone) x_axis = 0;
    if (abs(y_axis) < deadzone) y_axis = 0;
    
    // 只有值发生变化时才更新鼠标
    if (cursor_mode | scrolling_mode) {
        if (cursor_mode) {
            mouse_report.x = x_axis / 16;
            mouse_report.y = y_axis / 16;
        } else if (scrolling_mode) {
            mouse_report.x = y_axis / 16;
            mouse_report.y = x_axis / 16;
        }
        
        pointing_device_set_report(mouse_report);
        pointing_device_send();
    }

    return mouse_report;
}
