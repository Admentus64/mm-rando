;==================================================================================================
; Check Speedups - Sound Check (Actor Cutscene Index 0xC)
;==================================================================================================

.headersize(G_EN_TOTO_VRAM - G_EN_TOTO_FILE)

; Branch to end of function if skipping rest of cutscene.
; This will prevent the function from spawning actors on stage (different Link forms), and prevent
; preparing for the following actor cutscene.
; Replaces:
;   lui     t8, 0x801F
;   lbu     t8, 0xF690 (t8)
;   addiu   s1, s0, 0x0001
;   addu    t9, s5, s0
.org 0x80BA48A0 ; Offset: 0x11E0
    jal     toto_should_skip_formal_replay_hook
    addiu   s1, s0, 0x0001
    bnez    v0, 0x80BA4970
    lbu     t8, 0xF690 (t8)

; Replace function pointer used for advancing actor cutscene when index is 0xC.
; Replaces:
;   .dw 0x80BA407C
.org 0x80BA51A4 ; Offset: 0x1AE4
    .dw toto_prepare_formal_replay

; Remove relocation for function pointer in data section.
; Replaces:
;   .dw 0x820001D4
.org 0x80BA53D4 ; Offset: 0x1D14
    .dw 0x00000000

;==================================================================================================
; Check Speedups - Sound Check (Actor Cutscene Index 0xD)
;==================================================================================================

; Call hook before beginning of function which may advance Toto cutscene state.
; Replaces:
;   sw      s0, 0x0018 (sp)
;   sw      a1, 0x0024 (sp)
.org 0x80BA4A08 ; Offset: 0x1348
    jal     toto_before_advance_formal_replay_hook
    sw      s0, 0x0018 (sp)

; Update behavior when advancing Toto cutscene state (1).
; Replaces:
;   b       0x80BA4B10
;   addiu   v0, r0, 0x0001
.org 0x80BA4AE0 ; Offset: 0x1420
    jal     toto_handle_advance_formal_replay_hook
    addiu   a2, r0, 0x0028

; Update behavior when advancing Toto cutscene state (2).
; Replaces:
;   b       0x80BA4B10
;   addiu   v0, r0, 0x0001
.org 0x80BA4AF4 ; Offset: 0x1434
    jal     toto_handle_advance_formal_replay_hook
    addiu   a2, r0, 0x0014

; Update behavior when advancing Toto cutscene state (3).
; Replaces:
;   b       0x80BA4B10
;   addiu   v0, r0, 0x0001
.org 0x80BA4B04 ; Offset: 0x1444
    jal     toto_handle_advance_formal_replay_hook
    addiu   a2, r0, 0x0004

;==================================================================================================
; Check Speedups - Saving Bomb Shop Lady
;==================================================================================================

.headersize(G_EN_SUTTARI_VRAM - G_EN_SUTTARI_FILE)

; Prevent branching into delay slot due to following patch.
; Replaces:
;   b       0x80BAD554
.org 0x80BAD4C4 ; Offset: 0x2DF4
    b       0x80BAD550

; Call hook function to check if escape sequence should be ended.
; Replaces:
;   lw      t3, 0x01F8 (s0)
;   addiu   at, r0, 0xFF9D
;   addiu   a0, s0, 0x0070
;   bne     t3, at, 0x80BAD5B8
;   lui     a1, 0x4080
.org 0x80BAD550 ; Offset: 0x2E80
    jal     sakon_should_end_thief_escape_hook
    or      a0, s0, r0
    addiu   a0, s0, 0x0070
    beqz    v0, 0x80BAD5B8
    lui     a1, 0x4080

; Prevent setting Sakon velocity to 0 when escape sequence ends.
; Replaces:
;   swc1    f16, 0x0070 (s0)
.org 0x80BAD594 ; Offset: 0x2EC0
    nop

; Remove branch to allow Sakon to continue running after escape sequence ends, and prepare for
; function call to update velocity.
; Replaces:
;   b       0x80BAD5E8
;   lw      ra, 0x0034 (sp)
.org 0x80BAD5B0 ; Offset: 0x2EE0
    addiu   a0, s0, 0x0070
    lui     a1, 0x4080

;==================================================================================================
; Check Speedups - Fisherman's Game
;==================================================================================================

.headersize(G_EN_JGAME_TSN_VRAM - G_EN_JGAME_TSN_FILE)

; Ignore timer check if speedup is enabled.
; Replaces:
;   lw      t1, 0x3E04 (v1)
;   lw      t0, 0x3E00 (v1)
;   bnez    t0, 0x80C13C1C
;   addiu   a0, s0, 0x0190
;   beqz    t1, 0x80C13C48
;   lui     a1, 0x80C1
.org 0x80C13C08 ; Offset: 0x2D8
.area 0x18
    lw      a3, 0x3E04 (v1)
    lw      a2, 0x3E00 (v1)
    jal     fisherman_should_pass_timer_check_hook
    lw      a1, 0x0034 (sp)
    bnez    v0, 0x80C13C48
    lui     a1, 0x80C1 ; Preparing to load: 0x80C15030
.endarea

; Check if Fisherman's Game should end. Used to end the game early if the player has enough points.
; Replaces:
;   lui     t2, 0x801F
;   lw      t2, 0x3470 (t2)
;   lui     t3, 0x801F
;   lw      t3, 0x3474 (t3)
;   bnezl   t2, 0x80C144D4
;   lw      ra, 0x001C (sp)
;   bnez    t3, 0x80C144D0
;   lw      a0, 0x002C (sp)
.org 0x80C14464 ; Offset: 0xB34
.area 0x20
    lui     a2, 0x801F
    lw      a2, 0x3470 (a2)
    lui     a3, 0x801F
    lw      a3, 0x3474 (a3)
    jal     fisherman_should_end_game_hook
    lw      a1, 0x002C (sp)
    beqz    v0, 0x80C144D0
    lw      a0, 0x002C (sp)
.endarea
