#ifndef FPS_H
#define FPS_H

#include <z64.h>
#include <z64extended.h>
#include "Input.h"

void Handle_L_Button(GlobalContext* ctxt);
void Toggle_Minimap(GlobalContext* ctxt);
void Handle_Hud(GlobalContext* ctxt);
void Hide_Hud(GlobalContext* ctxt);
void Handle_FPS(GlobalContext* ctxt);

#define map_select_active			(*(uint32_t*)			0x8022A174) // 8024A484, 803E6C44
#define opening_door				(*(uint32_t*)			0x80400820)
#define time_modifier				(*(uint32_t*)			0x801EF684)
#define deku_hovering				(*(uint16_t*)			0x8040081C)
#define playable_state				(*(uint16_t*)			0x803FFE66)
#define use_hookshot				(*(uint16_t*)			0x803FFE00)
#define jump_state					(*(uint16_t*)			0x80400897)
#define deku_stick_timer			(*(uint16_t*)			0x804008D8)
#define jump_height					(*(uint16_t*)			0x803FFE20)
#define jump_gravity				(*(uint16_t*)			0x803FFE24)
#define link_action					(*(uint16_t*)			0x80400004)
#define text_state					(*(uint8_t*)			0x803FFDB6)
#define link_animation_speed		(*(uint8_t*)			0x803825E1)
#define opening_chest				(*(uint8_t*)			0x803FFF68)

#define var_8040000C				(*(uint32_t*)			0x8040000C)
#define var_801160AE				(*(uint16_t*)			0x801160AE)
#define var_80116702				(*(uint16_t*)			0x80116702)
#define var_803FFE64				(*(uint16_t*)			0x803FFE64)
#define var_801D7B44				(*(uint8_t*)			0x801D7B44)

#endif
