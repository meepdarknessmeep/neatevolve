---------------------------------------------------------------------------
--  Borrowed from...
--  Git repository: https://github.com/rodamaral/smw-tas
---------------------------------------------------------------------------

local SMW = {}

local luap = require "lib/luap"

SMW.constant = {
  -- Game Modes
  game_mode_overworld = 0x0e,
  game_mode_fade_to_level = 0x0f,
  game_mode_level = 0x14,

  -- Sprites
  sprite_max = 12,
  extended_sprite_max = 10,
  cluster_sprite_max = 20,
  minor_extended_sprite_max = 12,
  bounce_sprite_max = 4,
  null_sprite_id = 0xff,

  -- Blocks
  blank_tile_map16 = 0x25,
}

SMW.WRAM = {
  -- I/O
  ctrl_1_1 = 0x0015,
  ctrl_1_2 = 0x0017,
  firstctrl_1_1 = 0x0016,
  firstctrl_1_2 = 0x0018,

  -- General
  game_mode = 0x0100,
  real_frame = 0x0013,
  effective_frame = 0x0014,
  lag_indicator = 0x01fe,
  timer_frame_counter = 0x0f30,
  RNG = 0x148d,
  current_level = 0x00fe,  -- plus 1
  sprite_memory_header = 0x1692,
  lock_animation_flag = 0x009d, -- Most codes will still run if this is set, but almost nothing will move or animate.
  level_mode_settings = 0x1925,
  star_road_speed = 0x1df7,
  star_road_timer = 0x1df8,
  current_character = 0x0db3, -- #00 = Mario, #01 = Luigi
  exit_counter = 0x1F2E,
  event_flags = 0x1F02, -- 15 bytes (1 bit per exit)
  timer = 0x0F31, -- 3 bytes, one for each digit

  -- Cheats
  frozen = 0x13fb,
  level_paused = 0x13d4,
  level_index = 0x13bf,
  room_index = 0x00ce,
  level_flag_table = 0x1ea2,
  level_exit_type = 0x0dd5,
  midway_point = 0x13ce,

  -- Camera
  layer1_x_mirror = 0x1a,
  layer1_y_mirror = 0x1c,
  layer1_VRAM_left_up = 0x4d,
  layer1_VRAM_right_down = 0x4f,
  camera_x = 0x1462,
  camera_y = 0x1464,
  camera_left_limit = 0x142c,
  camera_right_limit = 0x142e,
  screens_number = 0x005d,
  hscreen_number = 0x005e,
  vscreen_number = 0x005f,
  vertical_scroll_flag_header = 0x1412,  -- #$00 = Disable; #$01 = Enable; #$02 = Enable if flying/climbing/etc.
  vertical_scroll_enabled = 0x13f1,
  camera_scroll_timer = 0x1401,

  -- Sprites
  sprite_status = 0x14c8,
  sprite_number = 0x009e,
  sprite_x_high = 0x14e0,
  sprite_x_low = 0x00e4,
  sprite_y_high = 0x14d4,
  sprite_y_low = 0x00d8,
  sprite_x_sub = 0x14f8,
  sprite_y_sub = 0x14ec,
  sprite_x_speed = 0x00b6,
  sprite_y_speed = 0x00aa,
  sprite_x_offscreen = 0x15a0,
  sprite_y_offscreen = 0x186c,
  sprite_OAM_xoff = 0x0304,
  sprite_OAM_yoff = 0x0305,
  sprite_being_eaten_flag = 0x15d0,
  sprite_OAM_index = 0x15ea,
  sprite_swap_slot = 0x1861,
  sprite_miscellaneous1 = 0x00c2,
  sprite_miscellaneous2 = 0x1504,
  sprite_miscellaneous3 = 0x1510,
  sprite_miscellaneous4 = 0x151c,
  sprite_miscellaneous5 = 0x1528,
  sprite_miscellaneous6 = 0x1534,
  sprite_miscellaneous7 = 0x1540,
  sprite_miscellaneous8 = 0x154c,
  sprite_miscellaneous9 = 0x1558,
  sprite_miscellaneous10 = 0x1564,
  sprite_miscellaneous11 = 0x1570,
  sprite_miscellaneous12 = 0x157c,
  sprite_miscellaneous13 = 0x1594,
  sprite_miscellaneous14 = 0x15ac,
  sprite_miscellaneous15 = 0x1602,
  sprite_miscellaneous16 = 0x160e,
  sprite_miscellaneous17 = 0x1626,
  sprite_miscellaneous18 = 0x163e,
  sprite_miscellaneous19 = 0x187b,
  sprite_underwater = 0x164a,
  sprite_disable_cape = 0x1fe2,
  sprite_1_tweaker = 0x1656,
  sprite_2_tweaker = 0x1662,
  sprite_3_tweaker = 0x166e,
  sprite_4_tweaker = 0x167a,
  sprite_5_tweaker = 0x1686,
  sprite_6_tweaker = 0x190f,
  sprite_tongue_wait = 0x14a3,
  sprite_yoshi_squatting = 0x18af,
  sprite_buoyancy = 0x190e,
  sprite_index_to_level = 0x161A,
  sprite_data_pointer = 0x00CE, -- 3 bytes
  sprite_load_status_table = 0x1938, -- 128 bytes
  bowser_attack_timers = 0x14b0, -- 9 bytes

  -- Extended sprites
  extspr_number = 0x170b,
  extspr_x_high = 0x1733,
  extspr_x_low = 0x171f,
  extspr_y_high = 0x1729,
  extspr_y_low = 0x1715,
  extspr_x_speed = 0x1747,
  extspr_y_speed = 0x173d,
  extspr_suby = 0x1751,
  extspr_subx = 0x175b,
  extspr_table = 0x1765,
  extspr_table2 = 0x176f,

  -- Cluster sprites
  cluspr_flag = 0x18b8,
  cluspr_number = 0x1892,
  cluspr_x_high = 0x1e3e,
  cluspr_x_low = 0x1e16,
  cluspr_y_high = 0x1e2a,
  cluspr_y_low = 0x1e02,
  cluspr_timer = 0x0f9a,
  cluspr_table_1 = 0x0f4a,
  cluspr_table_2 = 0x0f72,
  cluspr_table_3 = 0x0f86,
  reappearing_boo_counter = 0x190a,

  -- Minor extended sprites
  minorspr_number = 0x17f0,
  minorspr_x_high = 0x18ea,
  minorspr_x_low = 0x1808,
  minorspr_y_high = 0x1814,
  minorspr_y_low = 0x17fc,
  minorspr_xspeed = 0x182c,
  minorspr_yspeed = 0x1820,
  minorspr_x_sub = 0x1844,
  minorspr_y_sub = 0x1838,
  minorspr_timer = 0x1850,

  -- Bounce sprites
  bouncespr_number = 0x1699,
  bouncespr_x_high = 0x16ad,
  bouncespr_x_low = 0x16a5,
  bouncespr_y_high = 0x16a9,
  bouncespr_y_low = 0x16a1,
  bouncespr_timer = 0x16c5,
  bouncespr_last_id = 0x18cd,
  turn_block_timer = 0x18ce,

  -- Player
  x = 0x0094,
  y = 0x0096,
  previous_x = 0x00d1,
  previous_y = 0x00d3,
  x_sub = 0x13da,
  y_sub = 0x13dc,
  x_speed = 0x007b,
  x_subspeed = 0x007a,
  y_speed = 0x007d,
  direction = 0x0076,
  is_ducking = 0x0073,
  p_meter = 0x13e4,
  take_off = 0x149f,
  powerup = 0x0019,
  cape_spin = 0x14a6,
  cape_fall = 0x14a5,
  cape_interaction = 0x13e8,
  flight_animation = 0x1407,
  diving_status = 0x1409,
  player_animation_trigger = 0x0071,
  climbing_status = 0x0074,
  spinjump_flag = 0x140d,
  player_blocked_status = 0x0077,
  item_box = 0x0dc2,
  cape_x = 0x13e9,
  cape_y = 0x13eb,
  on_ground = 0x13ef,
  on_ground_delay = 0x008d,
  on_air = 0x0072,
  can_jump_from_water = 0x13fa,
  carrying_item = 0x148f,
  player_pose_turning = 0x1499,
  mario_score = 0x0f34,
  player_coin = 0x0dbf,
  player_looking_up = 0x13de,
  OW_x = 0x1f17,
  OW_y = 0x1f19,

  -- Yoshi
  yoshi_riding_flag = 0x187a,  -- #$00 = No, #$01 = Yes, #$02 = Yes, and turning around.
  yoshi_tile_pos = 0x0d8c,
  yoshi_in_pipe = 0x1419,

  -- Timer
  --keep_mode_active = 0x0db1,
  pipe_entrance_timer = 0x0088,
  score_incrementing = 0x13d6,
  fadeout_radius = 0x1433,
  peace_image_timer = 0x1492,
  end_level_timer = 0x1493,
  multicoin_block_timer = 0x186b,
  gray_pow_timer = 0x14ae,
  blue_pow_timer = 0x14ad,
  dircoin_timer = 0x190c,
  pballoon_timer = 0x1891,
  star_timer = 0x1490,
  animation_timer = 0x1496,
  invisibility_timer = 0x1497,
  fireflower_timer = 0x149b,
  yoshi_timer = 0x18e8,
  swallow_timer = 0x18ac,
  lakitu_timer = 0x18e0,
  spinjump_fireball_timer = 0x13e2,
  game_intro_timer = 0x1df5,
  pause_timer = 0x13d3,
  bonus_timer = 0x14ab,
  disappearing_sprites_timer = 0x18bf,
  message_box_timer = 0x1b89,

  -- Layers
  layer2_x_nextframe = 0x1466,
  layer2_y_nextframe = 0x1468,
}

SMW.DEBUG_REGISTER_ADDRESSES = {
  {"BUS", 0x004016, "JOYSER0"},
  {"BUS", 0x004017, "JOYSER1"},
  {"BUS", 0x004218, "Hardware Controller1 Low"},
  {"BUS", 0x004219, "Hardware Controller1 High"},
  {"BUS", 0x00421a, "Hardware Controller2 Low"},
  {"BUS", 0x00421b, "Hardware Controller2 High"},
  {"BUS", 0x00421c, "Hardware Controller3 Low"},
  {"BUS", 0x00421d, "Hardware Controller3 High"},
  {"BUS", 0x00421e, "Hardware Controller4 Low"},
  {"BUS", 0x00421f, "Hardware Controller4 High"},
  {"BUS", 0x014a13, "Chuck $01:4a13"},
  {"BUS", 0xee4734, "Platform $ee:4734"}, -- this is in no way an extensive list, just common values
  {"BUS", 0xee4cb2, "Platform $ee:4cb2"},
  {"BUS", 0xee4f34, "Platform $ee:4f34"},
  {"WRAM", 0x0015, "RAM Controller Low"},
  {"WRAM", 0x0016, "RAM Controller Low (1st frame)"},
  {"WRAM", 0x0017, "RAM Controller High"},
  {"WRAM", 0x0018, "RAM Controller High (1st frame)"},

  active = {},
}

SMW.PLAYER_HITBOX = {
  {xoff = 2, yoff = 0x14, width = 12, height = 12},
  {xoff = 2, yoff = 0x06, width = 12, height = 26},
  {xoff = 2, yoff = 0x18, width = 12, height = 24},
  {xoff = 2, yoff = 0x10, width = 12, height = 32}
}

SMW.X_INTERACTION_POINTS = {center = 0x8, left_side = 0x2 + 1, left_foot = 0x5, right_side = 0xe - 1, right_foot = 0xb}

SMW.Y_INTERACTION_POINTS = {
  {head = 0x10, center = 0x18, shoulder = 0x16, side = 0x1a, foot = 0x20},
  {head = 0x08, center = 0x12, shoulder = 0x0f, side = 0x1a, foot = 0x20},
  {head = 0x13, center = 0x1d, shoulder = 0x19, side = 0x28, foot = 0x30},
  {head = 0x10, center = 0x1a, shoulder = 0x16, side = 0x28, foot = 0x30}
}

SMW.HITBOX_SPRITE = {  -- sprites' hitbox against player and other sprites
  [0x00] = { xoff = 2, yoff = 3, width = 12, height = 10, oscillation = true },
  [0x01] = { xoff = 2, yoff = 3, width = 12, height = 21, oscillation = true },
  [0x02] = { xoff = 16, yoff = -2, width = 16, height = 18, oscillation = true },
  [0x03] = { xoff = 20, yoff = 8, width = 8, height = 8, oscillation = true },
  [0x04] = { xoff = 0, yoff = -2, width = 48, height = 14, oscillation = true },
  [0x05] = { xoff = 0, yoff = -2, width = 80, height = 14, oscillation = true },
  [0x06] = { xoff = 1, yoff = 2, width = 14, height = 24, oscillation = true },
  [0x07] = { xoff = 8, yoff = 8, width = 40, height = 48, oscillation = true },
  [0x08] = { xoff = -8, yoff = -2, width = 32, height = 16, oscillation = true },
  [0x09] = { xoff = -2, yoff = 8, width = 20, height = 30, oscillation = true },
  [0x0a] = { xoff = 3, yoff = 7, width = 1, height = 2, oscillation = true },
  [0x0b] = { xoff = 6, yoff = 6, width = 3, height = 3, oscillation = true },
  [0x0c] = { xoff = 1, yoff = -2, width = 13, height = 22, oscillation = true },
  [0x0d] = { xoff = 0, yoff = -4, width = 15, height = 16, oscillation = true },
  [0x0e] = { xoff = 6, yoff = 6, width = 20, height = 20, oscillation = true },
  [0x0f] = { xoff = 2, yoff = -2, width = 36, height = 18, oscillation = true },
  [0x10] = { xoff = 0, yoff = -2, width = 15, height = 32, oscillation = true },
  [0x11] = { xoff = -24, yoff = -24, width = 64, height = 64, oscillation = true },
  [0x12] = { xoff = -4, yoff = 16, width = 8, height = 52, oscillation = true },
  [0x13] = { xoff = -4, yoff = 16, width = 8, height = 116, oscillation = true },
  [0x14] = { xoff = 4, yoff = 2, width = 24, height = 12, oscillation = true },
  [0x15] = { xoff = 0, yoff = -2, width = 15, height = 14, oscillation = true },
  [0x16] = { xoff = -4, yoff = -12, width = 24, height = 24, oscillation = true },
  [0x17] = { xoff = 2, yoff = 8, width = 12, height = 69, oscillation = true },
  [0x18] = { xoff = 2, yoff = 19, width = 12, height = 58, oscillation = true },
  [0x19] = { xoff = 2, yoff = 35, width = 12, height = 42, oscillation = true },
  [0x1a] = { xoff = 2, yoff = 51, width = 12, height = 26, oscillation = true },
  [0x1b] = { xoff = 2, yoff = 67, width = 12, height = 10, oscillation = true },
  [0x1c] = { xoff = 0, yoff = 10, width = 10, height = 48, oscillation = true },
  [0x1d] = { xoff = 2, yoff = -3, width = 28, height = 27, oscillation = true },
  [0x1e] = { xoff = 6, yoff = -8, width = 3, height = 32, oscillation = true },  -- default: { xoff = -32, yoff = -8, width = 48, height = 32, oscillation = true },
  [0x1f] = { xoff = -16, yoff = -4, width = 48, height = 18, oscillation = true },
  [0x20] = { xoff = -4, yoff = -24, width = 8, height = 24, oscillation = true },
  [0x21] = { xoff = -4, yoff = 16, width = 8, height = 24, oscillation = true },
  [0x22] = { xoff = 0, yoff = 0, width = 16, height = 16, oscillation = true },
  [0x23] = { xoff = -8, yoff = -24, width = 32, height = 32, oscillation = true },
  [0x24] = { xoff = -12, yoff = 32, width = 56, height = 56, oscillation = true },
  [0x25] = { xoff = -14, yoff = 4, width = 60, height = 20, oscillation = true },
  [0x26] = { xoff = 0, yoff = 88, width = 32, height = 8, oscillation = true },
  [0x27] = { xoff = -4, yoff = -4, width = 24, height = 24, oscillation = true },
  [0x28] = { xoff = -14, yoff = -24, width = 28, height = 40, oscillation = true },
  [0x29] = { xoff = -16, yoff = -4, width = 32, height = 27, oscillation = true },
  [0x2a] = { xoff = 2, yoff = -8, width = 12, height = 19, oscillation = true },
  [0x2b] = { xoff = 0, yoff = 2, width = 16, height = 76, oscillation = true },
  [0x2c] = { xoff = -8, yoff = -8, width = 16, height = 16, oscillation = true },
  [0x2d] = { xoff = 4, yoff = 4, width = 8, height = 4, oscillation = true },
  [0x2e] = { xoff = 2, yoff = -2, width = 28, height = 34, oscillation = true },
  [0x2f] = { xoff = 2, yoff = -2, width = 28, height = 32, oscillation = true },
  [0x30] = { xoff = 8, yoff = -14, width = 16, height = 28, oscillation = true },
  [0x31] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
  [0x32] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
  [0x33] = { xoff = 0, yoff = -2, width = 64, height = 18, oscillation = true },
  [0x34] = { xoff = -4, yoff = -4, width = 8, height = 8, oscillation = true },
  [0x35] = { xoff = 3, yoff = 0, width = 18, height = 32, oscillation = true },
  [0x36] = { xoff = 8, yoff = 8, width = 52, height = 46, oscillation = true },
  [0x37] = { xoff = 0, yoff = -8, width = 15, height = 20, oscillation = true },
  [0x38] = { xoff = 8, yoff = 16, width = 32, height = 40, oscillation = true },
  [0x39] = { xoff = 4, yoff = 3, width = 8, height = 10, oscillation = true },
  [0x3a] = { xoff = -8, yoff = 16, width = 32, height = 16, oscillation = true },
  [0x3b] = { xoff = 0, yoff = 0, width = 16, height = 13, oscillation = true },
  [0x3c] = { xoff = 12, yoff = 10, width = 3, height = 6, oscillation = true },
  [0x3d] = { xoff = 12, yoff = 21, width = 3, height = 20, oscillation = true },
  [0x3e] = { xoff = 16, yoff = 18, width = 254, height = 16, oscillation = true },
  [0x3f] = { xoff = 8, yoff = 8, width = 8, height = 24, oscillation = true }
}

SMW.OBJ_CLIPPING_SPRITE = {  -- sprites' interaction points against objects
  [0x0] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  2},
  [0x1] = {xright = 14, xleft =  2, xdown =  7, xup =  7, yright = 18, yleft = 18, ydown = 32, yup =  2},
  [0x2] = {xright =  7, xleft =  7, xdown =  7, xup =  7, yright =  7, yleft =  7, ydown =  7, yup =  7},
  [0x3] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright = 16, yleft = 16, ydown = 32, yup = 11},
  [0x4] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright = 18, yleft = 18, ydown = 32, yup =  2},
  [0x5] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 24, yleft = 24, ydown = 32, yup = 16},
  [0x6] = {xright =  7, xleft =  0, xdown =  4, xup =  4, yright =  4, yleft =  4, ydown =  8, yup =  0},
  [0x7] = {xright = 31, xleft =  1, xdown = 16, xup = 16, yright = 16, yleft = 16, ydown = 31, yup =  1},
  [0x8] = {xright = 15, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 15, yup =  0},
  [0x9] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
  [0xa] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 72, yleft = 72, ydown = 80, yup = 66},
  [0xb] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  4, yleft =  4, ydown =  8, yup =  0},
  [0xc] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright =  0, yleft =  0, ydown =  0, yup =  0},
  [0xd] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
  [0xe] = {xright = 31, xleft =  0, xdown = 16, xup = 16, yright =  8, yleft =  8, ydown = 16, yup =  0},
  [0xf] = {xright =  8, xleft =  8, xdown =  8, xup = 16, yright =  4, yleft =  1, ydown =  2, yup =  4}
}

SMW.SPRITE_TWEAKERS_INFO = {
  [1] = {"Disappear in cloud of smoke", "Hop in/kick shells", "Dies when jumped on", "Can be jumped on", "Object clipping", "Object clipping", "Object clipping", "Object clipping"},
  [2] = {"Falls straight down when killed", "Use shell as death frame", "Sprite clipping", "Sprite clipping", "Sprite clipping", "Sprite clipping", "Sprite clipping", "Sprite clipping"},
  [3] = {"Don't interact with layer 2 (or layer 3 tides)", "Disable water splash", "Disable cape killing", "Disable fireball killing", "Palette", "Palette", "Palette", "Use second graphics page"},
  [4] = {"Don't use default interaction with player", "Gives power-up when eaten by Yoshi", "Process interaction with player every frame", "Can't be kicked like a shell", "Don't change into a shell when stunned", "Process while off screen", "Invincible to star/cape/fire/bouncing bricks", "Don't disable clipping when killed with star"},
  [5] = {"Don't interact with objects", "Spawns a new sprite", "Don't turn into a coin when goal passed", "Don't change direction if touched", "Don't interact with other sprites", "Weird ground behavior", "Stay in Yoshi's mouth", "Inedible"},
  [6] = {"Don't get stuck in walls (carryable sprites)", "Don't turn into a coin with silver POW", "Death frame 2 tiles high", "Can be jumped on with upward Y speed", "Takes 5 fireballs to kill. Clear means it's killed by one.", "Can't be killed by sliding", "Don't erase when goal passed", "Make platform passable from below"}
}

SMW.HITBOX_EXTENDED_SPRITE = {
  -- To fill the slots...
  --[0] ={ xoff = 3, yoff = 3, width = 64, height = 64},  -- Free slot
  [0x01] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Puff of smoke with various objects
  [0x0e] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Wiggler's flower
  [0x0f] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Trail of smoke
  [0x10] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Spinjump stars
  [0x12] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Water bubble
  -- extracted from ROM:
  [0x02] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Reznor fireball
  [0x03] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Flame left by hopping flame
  [0x04] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Hammer
  [0x05] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Player fireball
  [0x06] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Bone from Dry Bones
  [0x07] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Lava splash
  [0x08] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Torpedo Ted shooter's arm
  [0x09] = { xoff = 0, yoff = 0, width = 15, height = 15},  -- Unknown flickering object
  [0x0a] = { xoff = 4, yoff = 2, width = 8, height = 12},  -- Coin from coin cloud game
  [0x0b] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Piranha Plant fireball
  [0x0c] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Lava Lotus's fiery objects
  [0x0d] = { xoff = 3, yoff = 3, width = 1, height = 1},  -- Baseball
  -- got experimentally:
  [0x11] = { xoff = -0x1, yoff = -0x4, width = 11, height = 19},  -- Yoshi fireballs
}

SMW.HITBOX_CLUSTER_SPRITE = {  -- got experimentally
  --[0] -- Free slot
  [0x01] = { xoff = 2, yoff = 0, width = 17, height = 21, oscillation = 2, phase = 1},  -- 1-Up from bonus game (glitched hitbox area)
  [0x02] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Unused
  [0x03] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Boo from Boo Ceiling
  [0x04] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Boo from Boo Ring
  [0x05] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Castle candle flame (meaningless hitbox)
  [0x06] = { xoff = 2, yoff = 2, width = 12, height = 20, oscillation = 4},  -- Sumo Brother lightning flames
  [0x07] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Reappearing Boo
  [0x08] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Swooper bat from Swooper Death Bat Ceiling (untested)
}

SMW.HITBOX_QUAKE_SPRITE = {
  --[0] -- Free slot
  [0x01] = { xoff = -04, yoff = -4, width = 24, height = 24}, -- Bounce blocks
  [0x02] = { xoff = -32, yoff = -8, width = 80, height = 16}, -- Trail of smoke
}

SMW.YOSHI_TONGUE_X_OFFSETS = {
  [0] = 0xf5, 0xf5, 0xf5, 0xf5, 0xf5, 0xf5, 0xf5, 0xf0,
  0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x18,
  0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x13,
  0xbd, 0x3e, 0x16, 0x05, 0x9d, 0xd0, 0x3e, 0xa0
}

SMW.YOSHI_TONGUE_Y_OFFSETS = {
  [0] = 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x13,
  0xbd, 0x3e, 0x16, 0x05, 0x9d, 0xd0, 0x3e, 0xa0,
  0x0b, 0x8c, 0x95, 0x16, 0x98, 0x45, 0x13, 0x29
}

                    -- 0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f  10 11 12
SMW.SPRITE_MEMORY_MAX = {[0] = 10, 6, 7, 6, 7, 5, 8, 5, 7, 9, 9, 4, 8, 6, 8, 9, 10, 6, 6}  -- the max of sprites in a room

-- from sprite number, returns oscillation flag
-- A sprite must be here iff it processes interaction with player every frame AND this bit is not working in the sprite_4_tweaker WRAM(0x167a)
SMW.OSCILLATION_SPRITES = luap.make_set{0x0e, 0x21, 0x29, 0x35, 0x54, 0x74, 0x75, 0x76, 0x77, 0x78, 0x81, 0x83, 0x87}

-- BUS address of the end of this routine, might be different in ROMhacks
SMW.CHECK_FOR_CONTACT_ROUTINE = 0x03b75b

-- Sprites that have a custom hitbox drawing
SMW.ABNORMAL_HITBOX_SPRITES = luap.make_set{0x62, 0x63, 0x6b, 0x6c}

-- Sprites whose clipping interaction points usually matter
SMW.GOOD_SPRITES_CLIPPING = luap.make_set{
  0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xf, 0x10, 0x11, 0x13, 0x14, 0x18,
  0x1b, 0x1d, 0x1f, 0x20, 0x26, 0x27, 0x29, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31,
  0x32, 0x34, 0x35, 0x3d, 0x3e, 0x3f, 0x40, 0x46, 0x47, 0x48, 0x4d, 0x4e,
  0x51, 0x53, 0x6e, 0x6f, 0x70, 0x80, 0x81, 0x86,
  0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa1, 0xa2, 0xa5, 0xa6, 0xa7, 0xab, 0xb2,
  0xb4, 0xbb, 0xbc, 0xbd, 0xbf, 0xc3, 0xda, 0xdb, 0xdc, 0xdd, 0xdf
}

-- Extended sprites that don't interact with the player
SMW.UNINTERESTING_EXTENDED_SPRITES = luap.make_set{0x01, 0x07, 0x08, 0x0e, 0x10, 0x12}

-- Sprite names, used in Item Box cheat
SMW.SPRITE_NAMES = {
  [0x00] = "Green Koopa Troopa without shell",
  [0x01] = "Red Koopa Troopa without shell",
  [0x02] = "Blue Koopa Troopa without shell",
  [0x03] = "Yellow Koopa Troopa without shell",
  [0x04] = "Green Koopa Troopa",
  [0x05] = "Red Koopa Troopa",
  [0x06] = "Blue Koopa Troopa",
  [0x07] = "Yellow Koopa Troopa",
  [0x08] = "Green Koopa Troopa flying left",
  [0x09] = "Green Koopa Troopa bouncing",
  [0x0A] = "Red Koopa Troopa flying vertically",
  [0x0B] = "Red Koopa Troopa flying horizontally",
  [0x0C] = "Yellow Koopa Troopa with wings",
  [0x0D] = "Bob-Omb",
  [0x0E] = "Keyhole",
  [0x0F] = "Goomba",
  [0x10] = "Bouncing Goomba with wings",
  [0x11] = "Buzzy Beetle",
  [0x12] = "Unused",
  [0x13] = "Spiny",
  [0x14] = "Spiny falling",
  [0x15] = "Cheep Cheep swimming horizontally",
  [0x16] = "Cheep Cheep swimming vertically",
  [0x17] = "Cheep Cheep flying",
  [0x18] = "Cheep Cheep jumping to surface",
  [0x19] = "Display text from level message 1",
  [0x1A] = "Classic Piranha Plant",
  [0x1B] = "Bouncing Football in place",
  [0x1C] = "Bullet Bill",
  [0x1D] = "Hopping flame",
  [0x1E] = "Lakitu",
  [0x1F] = "Magikoopa",
  [0x20] = "Magikoopa's magic",
  [0x21] = "Moving coin",
  [0x22] = "Green vertical net Koopa",
  [0x23] = "Red vertical net Koopa",
  [0x24] = "Green horizontal net Koopa",
  [0x25] = "Red horizontal net Koopa",
  [0x26] = "Thwomp",
  [0x27] = "Thwimp",
  [0x28] = "Big Boo",
  [0x29] = "Koopa Kid",
  [0x2A] = "Upside-down Piranha Plant",
  [0x2B] = "Sumo Brother's lightning",
  [0x2C] = "Yoshi egg",
  [0x2D] = "Baby Yoshi",
  [0x2E] = "Spike Top",
  [0x2F] = "Portable springboard",
  [0x30] = "Dry Bones that throws bones",
  [0x31] = "Bony Beetle",
  [0x32] = "Dry Bones that stays on ledges",
  [0x33] = "Podoboo/vertical fireball",
  [0x34] = "Boss fireball",
  [0x35] = "Yoshi",
  [0x36] = "Unused",
  [0x37] = "Boo",
  [0x38] = "Eerie that moves straight",
  [0x39] = "Eerie that moves in a wave",
  [0x3A] = "Urchin that moves a fixed distance",
  [0x3B] = "Urchin that moves between walls",
  [0x3C] = "Urchin that follows walls",
  [0x3D] = "Rip Van Fish",
  [0x3E] = "P-switch",
  [0x3F] = "Para-Goomba",
  [0x40] = "Para-Bomb",
  [0x41] = "Dolphin that swims and jumps in one direction",
  [0x42] = "Dolphin that swims and jumps back and forth",
  [0x43] = "Dolphin that swims and jumps up and down",
  [0x44] = "Torpedo Ted",
  [0x45] = "Directional coins",
  [0x46] = "Diggin' Chuck",
  [0x47] = "Swimming/jumping fish",
  [0x48] = "Diggin' Chuck's rock",
  [0x49] = "Growing/shrinking pipe",
  [0x4A] = "Goal Point Question Sphere",
  [0x4B] = "Pipe-dwelling Lakitu",
  [0x4C] = "Exploding block",
  [0x4D] = "Monty Mole, ground-dwelling",
  [0x4E] = "Monty Mole, ledge-dwelling",
  [0x4F] = "Jumping Piranha Plant",
  [0x50] = "Jumping Piranha Plant that spits fireballs",
  [0x51] = "Ninji",
  [0x52] = "Moving hole in ghost house ledge",
  [0x53] = "Throw block sprite",
  [0x54] = "Revolving door for climbing net",
  [0x55] = "Checkerboard platform, horizontal",
  [0x56] = "Flying rock platform, horizontal",
  [0x57] = "Checkerboard platform, vertical",
  [0x58] = "Flying rock platform, vertical",
  [0x59] = "Turn block bridge, horizontal and vertical",
  [0x5A] = "Turn block bridge, horizontal",
  [0x5B] = "Floating brown platform",
  [0x5C] = "Floating checkerboard platform",
  [0x5D] = "Small orange floating platform",
  [0x5E] = "Large orange floating platform",
  [0x5F] = "Swinging brown platform",
  [0x60] = "Flat switch palace switch",
  [0x61] = "Floating skulls",
  [0x62] = "Brown line-guided platform",
  [0x63] = "Brown/checkered line-guided platform",
  [0x64] = "Line-guided rope mechanism",
  [0x65] = "Chainsaw (line-guided)",
  [0x66] = "Upside-down chainsaw (line-guided)",
  [0x67] = "Grinder, line-guided",
  [0x68] = "Fuzzy, line-guided",
  [0x69] = "Unused",
  [0x6A] = "Coin game cloud",
  [0x6B] = "Wall springboard (left wall)",
  [0x6C] = "Wall springboard (right wall)",
  [0x6D] = "Invisible solid block",
  [0x6E] = "Dino-Rhino",
  [0x6F] = "Dino-Torch",
  [0x70] = "Pokey",
  [0x71] = "Super Koopa with red cape",
  [0x72] = "Super Koopa with yellow cape",
  [0x73] = "Super Koopa on the ground",
  [0x74] = "Mushroom",
  [0x75] = "Flower",
  [0x76] = "Star",
  [0x77] = "Feather",
  [0x78] = "1-Up mushroom",
  [0x79] = "Growing vine",
  [0x7A] = "Firework",
  [0x7B] = "Goal tape",
  [0x7C] = "Peach (after Bowser fight)",
  [0x7D] = "P-Balloon",
  [0x7E] = "Flying red coin",
  [0x7F] = "Flying golden mushroom",
  [0x80] = "Key",
  [0x81] = "Changing item",
  [0x82] = "Bonus game sprite",
  [0x83] = "Flying question block that flies left",
  [0x84] = "Flying question block that flies back and forth",
  [0x85] = "Unused",
  [0x86] = "Wiggler",
  [0x87] = "Lakitu's cloud",
  [0x88] = "Winged cage (unused)",
  [0x89] = "Layer 3 Smash",
  [0x8A] = "Yoshi's House bird",
  [0x8B] = "Puff of smoke from Yoshi's House",
  [0x8C] = "Side exit enabler",
  [0x8D] = "Ghost house exit sign and door",
  [0x8E] = "Invisible warp hole",
  [0x8F] = "Scale platforms",
  [0x90] = "Large green gas bubble",
  [0x91] = "Chargin' Chuck",
  [0x92] = "Splittin' Chuck",
  [0x93] = "Bouncin' Chuck",
  [0x94] = "Whistlin' Chuck",
  [0x95] = "Chargin' Chuck",
  [0x96] = "Unused",
  [0x97] = "Puntin' Chuck",
  [0x98] = "Pitchin' Chuck",
  [0x99] = "Volcano Lotus",
  [0x9A] = "Sumo Brother",
  [0x9B] = "Amazing Flying Hammer Brother",
  [0x9C] = "Flying gray blocks for Hammer Brother",
  [0x9D] = "Sprite in a bubble",
  [0x9E] = "Ball 'n' Chain",
  [0x9F] = "Banzai Bill",
  [0xA0] = "Bowser battle activator",
  [0xA1] = "Bowser's bowling ball",
  [0xA2] = "Mecha-Koopa",
  [0xA3] = "Rotating gray platform",
  [0xA4] = "Floating spike ball",
  [0xA5] = "Wall-following Sparky/Fuzzy",
  [0xA6] = "Hothead",
  [0xA7] = "Iggy's ball projectile",
  [0xA8] = "Blargg",
  [0xA9] = "Reznor",
  [0xAA] = "Fishbone",
  [0xAB] = "Rex",
  [0xAC] = "Wooden spike pointing down",
  [0xAD] = "Wooden spike pointing up",
  [0xAE] = "Fishin' Boo",
  [0xAF] = "Boo Block",
  [0xB0] = "Reflecting stream of Boo Buddies",
  [0xB1] = "Creating/eating block",
  [0xB2] = "Falling spike",
  [0xB3] = "Bowser statue fireball",
  [0xB4] = "Grinder that moves on the ground",
  [0xB5] = "Unused",
  [0xB6] = "Reflecting fireball",
  [0xB7] = "Carrot Top Lift, upper right",
  [0xB8] = "Carrot Top Lift, upper left",
  [0xB9] = "Info Box",
  [0xBA] = "Timed Lift",
  [0xBB] = "Moving castle block",
  [0xBC] = "Bowser statue",
  [0xBD] = "Sliding Koopa",
  [0xBE] = "Swooper",
  [0xBF] = "Mega Mole",
  [0xC0] = "Sinking gray platform on lava",
  [0xC1] = "Flying gray turn blocks",
  [0xC2] = "Blurp",
  [0xC3] = "Porcu-Puffer",
  [0xC4] = "Gray platform that falls",
  [0xC5] = "Big Boo Boss",
  [0xC6] = "Spotlight/dark room sprite",
  [0xC7] = "Invisible mushroom",
  [0xC8] = "Light switch for dark room",
  [0xC9] = "Bullet Bill shooter",
  [0xCA] = "Torpedo Ted launcher",
  [0xCB] = "Eerie generator",
  [0xCC] = "Para-Goomba generator",
  [0xCD] = "Para-Bomb generator",
  [0xCE] = "Para-Goomba and Para-Bomb generator",
  [0xCF] = "Dolphin generator (left)",
  [0xD0] = "Dolphin generator (right)",
  [0xD1] = "Flying fish generator",
  [0xD2] = "Turn Off Generator 2",
  [0xD3] = "Super Koopa generator",
  [0xD4] = "Bubbled sprite generator",
  [0xD5] = "Bullet Bill generator",
  [0xD6] = "Multidirectional Bullet Bill generator",
  [0xD7] = "Multidirectional diagonal Bullet Bill generator",
  [0xD8] = "Bowser statue fire generator",
  [0xD9] = "Turn Off Generators",
  [0xDA] = "Green Koopa shell",
  [0xDB] = "Red Koopa shell",
  [0xDC] = "Blue Koopa shell",
  [0xDD] = "Yellow Koopa shell",
  [0xDE] = "Group of 5 wave-moving Eeries",
  [0xDF] = "Green Para-Koopa shell",
  [0xE0] = "3 rotating gray platforms",
  [0xE1] = "Boo Ceiling",
  [0xE2] = "Boo Ring moving counterclockwise",
  [0xE3] = "Boo Ring moving clockwise",
  [0xE4] = "Swooper Death Bat Ceiling",
  [0xE5] = "Appearing/disappearing Boos",
  [0xE6] = "Background candle flames",
  [0xE7] = "Unused",
  [0xE8] = "Special auto-scroll command",
  [0xE9] = "Layer 2 Smash",
  [0xEA] = "Layer 2 scrolling command",
  [0xEB] = "Unused",
  [0xEC] = "Unused",
  [0xED] = "Layer 2 Falls",
  [0xEE] = "Unused",
  [0xEF] = "Layer 2 sideways-scrolling command",
  [0xF0] = "Unused",
  [0xF1] = "Unused",
  [0xF2] = "Layer 2 on/off switch controller",
  [0xF3] = "Standard auto-scroll command",
  [0xF4] = "Fast background scroll",
  [0xF5] = "Layer 2 sink command",
  [0xF6] = "Unused",
  [0xF7] = "Unused",
  [0xF8] = "Unused",
  [0xF9] = "Unused",
  [0xFA] = "Unused",
  [0xFB] = "Unused",
  [0xFC] = "Unused",
  [0xFD] = "Unused",
  [0xFE] = "Unused",
  [0xFF] = "Unused",
}

return SMW
