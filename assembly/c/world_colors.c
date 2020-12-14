#include "actor_ext.h"
#include "color.h"
#include "types.h"
#include "world_colors.h"

struct world_color_config WORLD_COLOR_CONFIG = {
    .magic = WORLD_COLOR_CONFIG_MAGIC,
    .version = 0,
    .goron_punch = { 0xFF, 0x00, 0x00 },
    .goron_rolling = { 0x9B, 0x00, 0x00, },
    .sword_blue_pri = { 0xAA, 0xFF, 0xFF, },
    .sword_blue_env = { 0x00, 0x64, 0xFF, },
    .blue_bubble = { 0x00, 0x00, 0xFF, },
};

u32 world_colors_get_blue_bubble_color(z2_actor_t *actor, z2_game_t *game) {
    rgbs_t color = WORLD_COLOR_CONFIG.blue_bubble;
    if ((color.s & COLOR_SPECIAL_INSTANCE) != 0) {
        bool created = false;
        struct actor_ext *ext = actor_ext_setup(actor, &created);
        if (ext != NULL) {
            if (created) {
                ext->color = color_randomize_hue(color.rgb);
            }
            return color_rgb2int(ext->color, 0);
        }
    }

    return color_rgb2int(color.rgb, 0);
}

void WorldColors_Init(void) {
    // Set alpha values for specific colors.
    WORLD_COLOR_CONFIG.sword_blue_env.s = 0x80;
}
