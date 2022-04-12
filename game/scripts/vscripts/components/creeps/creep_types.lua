-- These values are starting and minimum values for neutral creeps when 5vs5; values increase over time (check creep_power.lua)
-- "creep name", Health, Mana, Damage, Armor, Gold Bounty, Exp Bounty
CreepTypes = {
  -- 1 "easy camp" (CreepMax is 10 for all easy camps)
  {
    {                                              --HP   MANA  DMG   ARM   GOLD  EXP  -- expected gold is 70 and XP is 90
      {"npc_dota_neutral_custom_big_wolf",          480,  200,  35,   1.5,   30,  40},
      {"npc_dota_neutral_custom_small_wolf",        320,  200,  15,   0.5,   20,  25},
      {"npc_dota_neutral_custom_small_wolf",        320,  200,  15,   0.5,   20,  25}
    },
    {
      {"npc_dota_neutral_custom_kobold_foreman",    450,  150,  30,    1,    30,  35},
      {"npc_dota_neutral_custom_kobold_soldier",    380,    0,  20,    1,    25,  30},
      {"npc_dota_neutral_custom_kobold",            250,    0,  10,   0.5,   15,  25}
    },
	{
      {"npc_dota_neutral_dark_troll",               450,  200,  70,    1,    30,  35}, -- has Piercing
      {"npc_dota_neutral_forest_troll_berserker",   400,    0,  40,    1,    25,  30}, -- has Piercing
      {"npc_dota_neutral_forest_troll_high_priest", 320,  500,  20,   0.5,   15,  25}  -- has Piercing
    },
  },
    -- 2 "medium camp" (CreepMax is 8 for all medium camps)
  {
    {                                              --HP   MANA  DMG   ARM   GOLD  EXP  -- expected gold is 60 and XP is 143
      {"npc_dota_neutral_custom_harpy_storm",       650,  300,  60,   1.3,   35,  82}, -- has Piercing
      {"npc_dota_neutral_custom_harpy_scout",       400,  200,  50,     1,   25,  61}  -- has Piercing
    },
    {
      {"npc_dota_neutral_custom_mud_golem",         525,    0,  35,    1,    15,  29}, -- multiply gold value by 2 and xp value by 2.5 because they split
      {"npc_dota_neutral_custom_mud_golem",         525,    0,  35,    1,    15,  29}
    },
    {
      {"npc_dota_neutral_custom_blue_tomato",       650,  300,  40,   1.3,   35,  82},
      {"npc_dota_neutral_custom_blue_potato",       400,    0,  35,   1.3,   25,  61}
    }
  },
    -- 3 "hard camp" (CreepMax is 10 for all hard camps)
  {
    {                                              --HP   MANA  DMG   ARM   GOLD  EXP  -- expected gold is 100 and XP 100
      {"npc_dota_neutral_custom_ghost",             800,    0,  40,   1.5,   50,  50}, -- has Piercing
      {"npc_dota_neutral_fel_beast",                400,  200,  30,    1,    25,  25},
      {"npc_dota_neutral_fel_beast",                400,  200,  30,    1,    25,  25}
    },
    {
      {"npc_dota_neutral_custom_centaur_khan",      800,  300,  50,   1.5,   50,  50},
      {"npc_dota_neutral_custom_small_centaur",     400,    0,  30,    1,    25,  25},
      {"npc_dota_neutral_custom_small_centaur",     400,    0,  30,    1,    25,  25}
    },
    {
      {"npc_dota_neutral_satyr_hellcaller",         800,  400,  50,   1.5,   50,  50},
      {"npc_dota_neutral_satyr_soulstealer",        500,  600,  30,    1,    30,  30},
      {"npc_dota_neutral_satyr_trickster",          300,  500,  10,    1,    20,  25}
    }
  },
   -- 4 "ancient camp" (CreepMax is 8 for ancient camps)
  {
    {                                               --HP  MANA  DMG   ARM   GOLD  EXP  -- expected gold is 120 and XP is 120
      {"npc_dota_neutral_granite_golem",           1275,    0,  50,    2,   120,  120}
    },
    {
      {"npc_dota_neutral_rock_golem",              1200,    0,  40,    1,    50,  120}
    },
    {
      {"npc_dota_neutral_black_dragon",            1275,  500,  80,    3,   120,  120}
    }
  },
   -- 5 "solo ancient corner camp" (CreepMax is 1)
  {
    {
      {"npc_dota_neutral_custom_black_dragon",     1500,  300,  80,    3,   100, 150}
    }
  },
   -- 6 "solo ancient mid camp" (CreepMax is 1)
  {
    {
      {"npc_dota_mini_roshan",                     1500,    0,  80,    3,   125, 25}
    },
    {
      {"npc_dota_neutral_custom_dark_troll_lord",  1500,  300,  80,    8,   125, 25}
    },
    {
      {"npc_dota_neutral_custom_pine_cone",        1500,  300,  80,    8,   125, 25}
    },
    {
      {"npc_dota_neutral_custom_ogre_mauler",      1500,  400,  80,    8,   125, 25}
    },
    {
      {"npc_dota_neutral_custom_wildkin",          1500,  400,  80,    5,   125, 25}
    },
    {
      {"npc_dota_neutral_custom_ice_shaman",       1500,  400,  80,    8,   125, 25}
    },
  },
   -- 7 "solo prowler - part of the ancient camp" (CreepMax is 1)
  {
    {
      {"npc_dota_neutral_prowler_shaman",          1275,  400,  80,    3,   100, 120}
    }
  }
}
