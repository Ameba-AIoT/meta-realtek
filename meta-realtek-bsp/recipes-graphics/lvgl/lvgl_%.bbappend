REQUIRED_DISTRO_FEATURES = ""

do_configure:prepend() {
    [ -r "${S}/lv_conf.h" ] \
        || sed -e 's|#if 0 .*Set it to "1" to enable .*|#if 1 // Enabled|g' \
        -e "s|\(#define LV_MEM_CUSTOM .*\)0|\1${LVGL_CONFIG_LV_MEM_CUSTOM}|g" \
        -e "s|#define LV_TICK_CUSTOM 0|#define LV_TICK_CUSTOM 1|g" \
        -e "s|Arduino|stdint|g" \
        -e "s|millis|custom_tick_get|g" \
        -e "s|#define LV_FONT_MONTSERRAT_22 0|#define LV_FONT_MONTSERRAT_22 1|g" \
        -e "s|#define LV_FONT_MONTSERRAT_36 0|#define LV_FONT_MONTSERRAT_36 1|g" \
        -e "s|#define LV_FONT_MONTSERRAT_48 0|#define LV_FONT_MONTSERRAT_48 1|g" \
        -e "s|lv_font_montserrat_14|lv_font_montserrat_22|g" \
            < "${S}/lv_conf_template.h" > "${S}/lv_conf.h"
}
