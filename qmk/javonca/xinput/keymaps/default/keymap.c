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
#include "analog.h"

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [0] = LAYOUT(
        TG(1),   KC_LSFT, KC_LCTL, KC_SPC,
        KC_U,    KC_I,    KC_T,    KC_TRNS,
        KC_O,    KC_P,    KC_Y,    KC_TRNS,
        KC_ESC,  KC_F,    KC_G,    KC_SCLN,
        KC_H,    KC_J,    KC_K,    KC_L
    ),

    [1] = LAYOUT(
        KC_TRNS,        KC_TRNS,  KC_TRNS, MS_BTN3,
        MS_BTN1,        MS_BTN2,  KC_ENT,  KC_TRNS,
        LT(2, KC_PGUP), KC_PGDN,  KC_BSPC, KC_TRNS,
        KC_TRNS,        KC_E,     KC_R,    KC_Z,
        KC_X,           KC_C,     KC_V,    KC_B
    ),

    [2] = LAYOUT(
        KC_TRNS, KC_TRNS, KC_TRNS, BL_BRTG,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
        KC_TRNS, MS_WHLU, MS_WHLD, KC_TRNS,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
        KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS
    )
};

void keyboard_pre_init_kb(void) {
    RCC->CFGR &= ~RCC_CFGR_MCO;

    gpio_set_pin_output_push_pull(A15);
    gpio_set_pin_output_push_pull(B4);
    gpio_set_pin_output_push_pull(B15);

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
            gpio_write_pin_high(B4);
            gpio_write_pin_low(B15);
            break;
        case 1:
            cursor_mode = true;
            scrolling_mode = false;
            gpio_write_pin_high(A15);
            gpio_write_pin_low(B4);
            gpio_write_pin_high(B15);
            break;
        case 2:
            cursor_mode = false;
            scrolling_mode = true;
            gpio_write_pin_low(A15);
            gpio_write_pin_high(B4);
            gpio_write_pin_high(B15);
            break;
    }
    return state;
}

// 配置参数
typedef struct {
    uint16_t center;          // ADC中心值
    uint16_t threshold;       // 触发阈值
    uint16_t deadzone;        // 死区大小
    uint8_t debounce;         // 去抖时间
} adc_config_t;

adc_config_t adc_cfg = {
    .center = 512,
    .threshold = 200,
    .deadzone = 50,
    .debounce = 5
};

// 摇杆状态
typedef struct {
    bool up, down, left, right;
    uint8_t up_debounce, down_debounce, left_debounce, right_debounce;
} joystick_state_t;

static joystick_state_t js = {0};

void matrix_scan_user(void) {
    static uint32_t last_scan = 0;
    const uint16_t scan_interval = 10; // 10ms扫描间隔

    if (timer_elapsed32(last_scan) < scan_interval) {
        return;
    }
    
    // 读取ADC
    int16_t x_val = (int16_t)analogReadPin(A1) - adc_cfg.center;
    int16_t y_val = (int16_t)analogReadPin(A2) - adc_cfg.center;
    
    // 应用死区
    if (abs(x_val) < adc_cfg.deadzone) x_val = 0;
    if (abs(y_val) < adc_cfg.deadzone) y_val = 0;
    
    // 检测方向
    bool new_right = (x_val > adc_cfg.threshold);
    bool new_left = (x_val < -adc_cfg.threshold);
    bool new_up = (y_val < -adc_cfg.threshold);
    bool new_down = (y_val > adc_cfg.threshold);
    
    // 去抖处理 - 右
    if (new_right != js.right) {
        if (js.right_debounce < adc_cfg.debounce) {
            js.right_debounce++;
        } else {
            if ((!cursor_mode) && (!scrolling_mode)) {
                if(new_right) register_code(KC_UP);
                else unregister_code(KC_UP);
            }
            js.right = new_right;
            js.right_debounce = 0;
        }
    } else {
        js.right_debounce = 0;
    }
    
    // 去抖处理 - 左
    if (new_left != js.left) {
        if (js.left_debounce < adc_cfg.debounce) {
            js.left_debounce++;
        } else {
            if ((!cursor_mode) && (!scrolling_mode)) {
                if(new_left) register_code(KC_DOWN);
                else unregister_code(KC_DOWN);
            }
            js.left = new_left;
            js.left_debounce = 0;
        }
    } else {
        js.left_debounce = 0;
    }
    
    // 去抖处理 - 上
    if (new_up != js.up) {
        if (js.up_debounce < adc_cfg.debounce) {
            js.up_debounce++;
        } else {
            if ((!cursor_mode) && (!scrolling_mode)) {
                if(new_up) register_code(KC_LEFT);
                else unregister_code(KC_LEFT);
            }
            js.up = new_up;
            js.up_debounce = 0;
        }
    } else {
        js.up_debounce = 0;
    }
    
    // 去抖处理 - 下
    if (new_down != js.down) {
        if (js.down_debounce < adc_cfg.debounce) {
            js.down_debounce++;
        } else {
            if ((!cursor_mode) && (!scrolling_mode)) {
                if (new_down) register_code(KC_RIGHT);
                else unregister_code(KC_RIGHT);
            }
            js.down = new_down;
            js.down_debounce = 0;
        }
    } else {
        js.down_debounce = 0;
    }
    
    last_scan = timer_read32();
}


bool pointing_device_driver_init(void) { 
    return true; 
}

uint16_t pointing_device_driver_get_cpi(void) { 
    return 0; 
}

void pointing_device_driver_set_cpi(uint16_t cpi) {

}

static uint16_t accel_x = 0, accel_y = 0;
report_mouse_t pointing_device_driver_get_report(report_mouse_t mouse_report) {
    static uint32_t last_mouse_update = 0;
    
    if (timer_elapsed32(last_mouse_update) > 10) { // 10ms更新
        // 读取摇杆值
        int8_t x_raw = (int8_t) ((analogReadPin(A1) - adc_cfg.center) / 8);  // X轴
        int8_t y_raw = (int8_t) ((analogReadPin(A2) - adc_cfg.center) / 8);  // Y轴
        
        // 死区过滤
        const int16_t deadzone = 2;
        if (abs(x_raw) < deadzone) x_raw = 0;
        if (abs(y_raw) < deadzone) y_raw = 0;
        
        if (x_raw != 0 || y_raw != 0) {
            // 应用加速度
            if (x_raw != 0) {
                accel_x = (accel_x + abs(x_raw)) > 1000 ? 1000 : accel_x + abs(x_raw);
            } else {
                accel_x = 0;
            }
            
            if (y_raw != 0) {
                accel_y = (accel_y + abs(y_raw)) > 1000 ? 1000 : accel_y + abs(y_raw);
            } else {
                accel_y = 0;
            }
            
            // 计算最终移动值（带加速度）
            int8_t x_move = (x_raw * (100 + accel_x / 10)) / (100 * 16);
            int8_t y_move = (y_raw * (100 + accel_y / 10)) / (100 * 16);
            
            // 限制最大值
            x_move = x_move > 127 ? 127 : (x_move < -127 ? -127 : x_move);
            y_move = y_move > 127 ? 127 : (y_move < -127 ? -127 : y_move);
            
            // 特定层才更新鼠标
            if (cursor_mode | scrolling_mode) {
                if (cursor_mode) {
                    mouse_report.x = y_move;
                    mouse_report.y = - x_move;
                } else if (scrolling_mode) {
                    mouse_report.x = x_move;
                    mouse_report.y = y_move;
                }
                
                pointing_device_set_report(mouse_report);
                pointing_device_send();
            }
        }
        
        last_mouse_update = timer_read32();
    }

    return mouse_report;
}
