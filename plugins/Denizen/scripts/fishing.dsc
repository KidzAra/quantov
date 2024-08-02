fishy_game_task:
  type: task
  debug: false
  script:
    - if <player.has_flag[is_fishy_game].not> && ( <player.item_in_hand.material.name.equals[fishing_rod]> || <player.item_in_offhand.material.name.equals[fishing_rod]> ):
      - define fishy_place <player.fish_hook.flag[pFishing.fishy_place]||null>
      - define place_data <server.flag[pFishing.fishy_places.<[fishy_place]>]>
      - define category <[place_data].get[category]>
      - choose <[category]>:
        - case epic:
          - define random_fishy_progress 2.5
          - define random_progress <util.random.int[13].to[19]>
          - define broke_mul <util.random.decimal[3.1].to[4]>
          - flag <player> tension:0.8
        - case rare:
          - define random_fishy_progress 4
          - define random_progress <util.random.int[9].to[14]>
          - define broke_mul <util.random.decimal[2.7].to[3.5]>
          - flag <player> tension:0.65
        - case legendary:
          - define random_fishy_progress 2.9
          - define random_progress <util.random.int[15].to[19]>
          - define broke_mul <util.random.decimal[3.9].to[5]>
          - flag <player> tension:1
        - case common:
          - define random_fishy_progress 4.5
          - define random_progress <util.random.int[8].to[13]>
          - define broke_mul <util.random.decimal[1.5].to[2.2]>
          - flag <player> tension:0.5
        - case book:
          - define random_fishy_progress 3.5
          - define random_progress <util.random.int[10].to[16]>
          - define broke_mul <util.random.decimal[1.9].to[3]>
          - flag <player> tension:0.7
        - case mending:
          - define random_fishy_progress 3
          - define random_progress <util.random.int[12].to[18]>
          - define broke_mul <util.random.decimal[3.1].to[4]>
          - flag <player> tension:0.8
      - flag <player> is_fishy_game expire:10s
      - flag <player> fishing.progress:<[random_progress]>
      - flag <player> fishing.tension:0
      - flag <player> fishing.broke_start:!
      - flag <player> random_fishy_progress:!
      - define settings <script[pFishing_data_settings].data_key[data]>
      - define catch_radius <[settings].deep_get[place_radius]>
      - define fishy_place <server.flag[pFishing.fishy_places].filter_tag[<[filter_value].deep_get[location].center.distance[<player.fish_hook.location>].horizontal.is_less_than_or_equal_to[<[catch_radius]>]>].keys.first||null>
      - define place_location <server.flag[pFishing.fishy_places.<[fishy_place]>].deep_get[location].center>
      - define list <list[1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20]>
      - define fishing_progress:0
      - actionbar 'Кажется, здесь что-то есть'
      - wait 1s
      - while <player.has_flag[is_fishy_game]> && ( <player.item_in_hand.material.name.equals[fishing_rod]> || <player.item_in_offhand.material.name.equals[fishing_rod]> ) && <player.fish_hook.name.equals[FISHING_HOOK]||false>:
        - define hook_animation_x <util.random.decimal[-1.9].to[1.9]>
        - define hook_animation_z <util.random.decimal[-1.9].to[1.9]>
        - define fishing_progress:+:0.05
        - if <player.has_flag[random_fishy_progress].not>:
          - flag <player> random_fishy_progress:<util.random.decimal[1].to[<[random_fishy_progress]>]>
          - define random_fishy_progress <player.flag[random_fishy_progress]>
          - flag <player> random_broke_start_progress:<util.random.decimal[<[random_fishy_progress]>].to[<[random_fishy_progress].add[<[broke_mul]>]>]>
          - define random_broke_start_progress <player.flag[random_broke_start_progress]>
          - flag <player> random_fishy_progress expire:20s
        - if <player.flag[fishing.progress].is_more_than[20]>:
          - actionbar '<&c>Ты упустил улов!'
          - flag <player> is_fishy_game:!
          - while stop
        - if <player.flag[fishing.progress].is_less_than[0.2]>:
          - actionbar 'Ты что-то поймал, тяни!'
          - playsound sound:ENTITY_PLAYER_SPLASH pitch:1 volume:0.5 <player.fish_hook.location>
          - flag <player> is_fishy_game:!
          - stop
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[0.5]>:
          - define color <&color[#C0FF6F]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[1]>:
          - define color <&color[#E9FF6F]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[1.5]>:
          - define color <&color[#FED635]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[2]>:
          - define color <&color[#FEAC35]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[2.5]>:
          - define color <&color[#FF8512]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[3]>:
          - define color <&color[#FF5012]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[3.5]>:
          - define color <&color[#FF4900]>
        - if <player.flag[fishing.tension].is_more_than_or_equal_to[4]>:
          - define color <&color[#FF0000]>
        - if <[fishing_progress].is_less_than[<[random_fishy_progress]>]> && <player.flag[fishing.tension].is_less_than_or_equal_to[0.9]>:
          - define color <&gradient[from=<&a>;to=<&color[#9CD677]>]>
        - if <player.has_flag[fishing.broke_start].not>:
          - define loot_color <&b>
        - foreach <[list]>:
          - if <[value].equals[<player.flag[fishing.progress].round_up>]>:
            - define slot '<[loot_color]>⏴'
          - else:
            - if <[value].is_less_than_or_equal_to[<player.flag[fishing.progress]>]>:
              - define slot '▌'
            - else:
              - define slot '<&7>▌'
          - define game_list:->:<[slot]>
        - define actionbar '🎣 <[color]><[game_list].separated_by[]><&c> ✘'
        - define game_list <list>
        - actionbar <[actionbar]>
        - wait 2t
        - if <[fishing_progress].is_more_than_or_equal_to[<[random_fishy_progress]>]>:
          - flag <player> fishing.broke_start expire:8s
          - flag <player> fishing.progress:+:0.2
          - if <player.has_flag[sounds_cooldown].not>:
            - playsound <player.location> sound:ITEM_SPYGLASS_USE pitch:0
            - flag <player> sounds_cooldown expire:8t
          - adjust <player.fish_hook> velocity:<[place_location].sub[<element[<player.fish_hook.location.x.add[<[hook_animation_x]>]>,<player.fish_hook.location.y>,<player.fish_hook.location.z.add[<[hook_animation_z]>]>].as[location]>].normalize.mul[0.03]>
          - playeffect <player.fish_hook.location.below[0.5]> effect:water_splash offset:0 quantity:2
          - playsound sound:ENTITY_GENERIC_SWIM at:<player.fish_hook.location> pitch:1.4 volume:0.05
          - if <player.flag[fishing.tension].is_less_than_or_equal_to[1]>:
            - define color <&gradient[from=<&a>;to=<&color[#9CD677]>]>
            - define loot_color <&c>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[0.5]>:
            - define color <&color[#C0FF6F]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[1]>:
            - define color <&color[#E9FF6F]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[1.5]>:
            - define color <&color[#FED635]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[2]>:
            - define color <&color[#FEAC35]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[2.5]>:
            - define color <&color[#FF8512]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[3]>:
            - define color <&color[#FF5012]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[3.5]>:
            - define color <&color[#FF4900]>
          - if <player.flag[fishing.tension].is_more_than_or_equal_to[4]>:
            - define color <&color[#FF0000]>
            - flag <player> is_fishy_game:!
            - actionbar '<&c>Черт! Леска оборвалась!'
            - define durability <player.item_in_hand.durability>
            - define durability:+:4
            - inventory adjust slot:hand durability:<[durability]>
            - if <[durability]> > 64:
              - take iteminhand
            - remove <player.fish_hook>
            - playsound <player.location> sound:entity_item_break pitch:2
            - flag <player> random_fishy_progress:!
          - if <[fishing_progress].is_more_than_or_equal_to[<[random_broke_start_progress]>]>:
            - define fishing_progress:0
            - flag <player> random_fishy_progress:!
            - flag <player> fishing.broke_start:!
        - if <player.flag[fishing.tension]> != 0:
          - flag <player> fishing.tension:-:0.1
      - flag <player> is_fishy_game:!
      - stop



pFishing_world_main:
  type: world
  debug: false
  events:
    after server start:
      - run pFishing_task_fishyPlaceLooper
      - run pFishing_task_playerLooper
    on player fishes:
      - define settings <script[pFishing_data_settings].data_key[data]>
      - choose <context.state>:
        - case FISHING:
          - run pFishing_task_initiateFishEvent def.hook:<context.hook>
        - case BITE:
          - define settings <script[pFishing_data_settings].data_key[data]>
          - define catch_radius <[settings].deep_get[place_radius]>
          - define fishy_place <server.flag[pFishing.fishy_places].filter_tag[<[filter_value].deep_get[location].center.distance[<context.hook.location>].horizontal.is_less_than_or_equal_to[<[catch_radius]>]>].keys.first||null>
          - if <player.has_flag[is_fishy_game].not> && <[fishy_place]> != null:
            - run fishy_game_task
          - wait 3s
          - if <context.hook.location||null> != null:
            - run pFishing_task_initiateFishEvent def.hook:<context.hook>
        - case REEL_IN:
          - if <player.has_flag[fishing.broke_start].not> && <player.has_flag[is_fishy_game]>:
            - adjust <player.fish_hook> velocity:<player.location.sub[<player.fish_hook.location>].normalize.mul[0.05]>
            - if <player.flag[fishing.progress].is_more_than[1]>:
              - determine passively cancelled
            - if <player.flag[fishing.progress].is_less_than_or_equal_to[1]>:
              - determine passively cancelled
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - if <player.flag[fishing.progress].is_less_than[1]>:
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - ratelimit <player> 7t
            - flag <player> fishing.progress:--
            - playsound at:<player.location> sound:ITEM_SPYGLASS_USE pitch:2
            - stop
          - if <player.has_flag[fishing.broke_start]> && <player.has_flag[is_fishy_game]>:
            - adjust <player.fish_hook> velocity:<player.location.sub[<player.fish_hook.location>].normalize.mul[0.05]>
            - if <player.flag[fishing.progress].is_more_than[1]>:
              - determine passively cancelled
            - if <player.flag[fishing.progress].is_less_than_or_equal_to[1]>:
              - determine passively cancelled
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - if <player.flag[fishing.progress].is_less_than[1]>:
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - ratelimit <player> 5t
            - playsound at:<player.location> sound:ITEM_SPYGLASS_USE pitch:1
            - flag <player> fishing.tension:+:<player.flag[tension]>
            - flag <player> fishing.progress:--
            - stop
        - case CAUGHT_FISH:
          - if <player.flag[fishing.progress].is_more_than[1]>:
            - adjust <context.hook> fish_hook_bite_time:1t
            - adjust <player.fish_hook> velocity:<player.location.sub[<player.fish_hook.location>].normalize.mul[0.05]>
          - if <player.has_flag[fishing.broke_start].not> && <player.has_flag[is_fishy_game]>:
            - adjust <player.fish_hook> velocity:<player.location.sub[<player.fish_hook.location>].normalize.mul[0.05]>
            - if <player.flag[fishing.progress].is_more_than[1]>:
              - determine passively cancelled
            - if <player.flag[fishing.progress].is_less_than_or_equal_to[1]>:
              - determine passively cancelled
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - if <player.flag[fishing.progress].is_less_than[1]>:
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - ratelimit <player> 7t
            - flag <player> fishing.progress:--
            - playsound at:<player.location> sound:ITEM_SPYGLASS_USE pitch:2
            - stop
          - else if <player.has_flag[fishing.broke_start]> && <player.has_flag[is_fishy_game]>:
            - adjust <player.fish_hook> velocity:<player.location.sub[<player.fish_hook.location>].normalize.mul[0.05]>
            - if <player.flag[fishing.progress].is_more_than[1]>:
              - determine passively cancelled
            - if <player.flag[fishing.progress].is_less_than_or_equal_to[1]>:
              - determine passively cancelled
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - if <player.flag[fishing.progress].is_less_than[1]>:
              - adjust <context.hook> fish_hook_bite_time:1t
              - adjust <context.hook> fish_hook_nibble_time:3s
            - ratelimit <player> 5t
            - playsound at:<player.location> sound:ITEM_SPYGLASS_USE pitch:1
            - flag <player> fishing.tension:+:<player.flag[tension]>
            - flag <player> fishing.progress:--
            - stop
          - define fishy_place <context.hook.flag[pFishing.fishy_place]||null>
          - if <[fishy_place]> == null:
            - remove <context.hook>
            - stop
          - define place_data <server.flag[pFishing.fishy_places.<[fishy_place]>]>
          - define catch <[place_data].deep_get[contents].first>
          - flag server pFishing.fishy_places.<[fishy_place]>.contents:<[place_data].deep_get[contents].remove[1]>
          - if <server.flag[pFishing.fishy_places.<[fishy_place]>.contents].size||0> == 0:
            - flag server pFishing.fishy_places.<[fishy_place]>:!
          - if <[catch].material.name.equals[enchanted_book]>:
            - define book '<[catch].material.name.replace_text[_].with[<&sp>]> | <[catch].enchantments.formatted.replace_text[_].with[<&sp>]> <[catch].enchantment_map.values.formatted>'
            - flag server telemetry.fishing.server.drops.<[book]>:++
            - flag server telemetry.fishing.player.<player.name>.drops.<[book]>:++
          - else:
            - flag server telemetry.fishing.server.drops.<[catch].material.name.replace_text[_].with[<&sp>]>:++
            - flag server telemetry.fishing.player.<player.name>.drops.<[catch].material.name.replace_text[_].with[<&sp>]>:++
          - flag <player> is_fishy_game:!
          - determine CAUGHT:<[catch]>

pFishing_task_initiateFishEvent:
  type: task
  debug: false
  definitions: hook
  script:
    - define settings <script[pFishing_data_settings].data_key[data]>
    - waituntil <[hook].location.material.name.equals[water].and[<[hook].velocity.vector_length.round_to[2].equals[0]||false>].and[<[hook].location.y.round.equals[63]||false>]||false> max:5s
    - define is_stable <[hook].location.material.name.equals[water].and[<[hook].velocity.vector_length.round_to[2].equals[0]||false>].and[<[hook].location.y.round.equals[63]||false>]||false>
    - if <[is_stable].not||true>:
      - stop
    - define catch_radius <[settings].deep_get[place_radius]>
    - define fishy_place <server.flag[pFishing.fishy_places].filter_tag[<[filter_value].deep_get[location].center.distance[<[hook].location>].horizontal.is_less_than_or_equal_to[<[catch_radius]>]>].keys.first||null>
    - if <[fishy_place]> == null:
      - stop
    - adjust <[hook]> fish_hook_max_lure_time:24h
    - adjust <[hook]> fish_hook_min_lure_time:23h
    - adjust <[hook]> fish_hook_lure_time:24h
    - define wait_time <duration[<util.random.int[20].to[100]>t]>
    - wait <[wait_time]>

    - if <[hook].location||null> == null:
      - stop
    - flag <[hook]> pFishing.fishy_place:<[fishy_place]>
    - adjust <[hook]> fish_hook_bite_time:1t

pFishing_procedure_randomCategoryItem:
  type: procedure
  debug: false
  definitions: category
  script:
    - if <[category]||null> == null:
      - determine stick
    - define settings <script[pFishing_data_settings].data_key[data]>
    - define items <[settings].deep_get[categories.<[category]>.prizes]>
    - define item <[items].random.parsed.as[item]>
    - determine <[item]>

pFishing_data_settings:
  type: data
  debug: false
  data:
    update_radius: 30
    river_height: 62
    per_server_limit: 600
    per_player_limit: 10
    fishy_place_min_distance: 25
    creation_chance: 15
    player_looper_rate: 10s
    dead_radius: 10
    place_radius: 1.5
    category_colors:
      common:    <&ns>BBBBBB
      uncommon:  <&ns>94FF8C
      rare:      <&ns>8CB6FF
      epic:      <&ns>DB8CFF
      legendary: <&ns>FFF28C
    categories:

      common:
        chance: 32
        prize_count:
          min: 1
          max: 4
        prizes:
          - stick
          - string
          - coal
          - flint
          - bone
          - seagrass
          - gold_nugget
          - iron_nugget
          - bowl
          - bucket
          - iron_horse_armor
          - bow[durability=<util.random.int[70].to[380]>]
          - diamond
          - emerald
          - prismarine_shard
          - prismarine_crystals
          - nether_brick
          - leather
          - lily_pad
          - spider_eye
          - rotten_flesh
          - LEATHER_CHESTPLATE[durability=<util.random.int[15].to[65]>]
          - LEATHER_BOOTS[durability=<util.random.int[15].to[54]>]
          - LEATHER_LEGGINGS[durability=<util.random.int[15].to[64]>]
          - LEATHER_HELMET[durability=<util.random.int[15].to[54]>]
          - raw_copper
          - crossbow[durability=<util.random.int[70].to[460]>]
          - wooden_pickaxe[durability=<util.random.int[30].to[58]>]
      rare:
        chance: 100
        prize_count:
          min: 1
          max: 3
        prizes:
          - carrot
          - diamond
          - pufferfish_bucket
          - golden_horse_armor
          - emerald
          - raw_gold
          - raw_iron
          - saddle
          - quartz
          - brick
          - nautilus_shell
          - writable_book
          - rabbit_hide
          - ink_sac
          - bamboo
          - ender_pearl
          - arrow
          - clock
          - compass
          - iron_shovel[durability=<util.random.int[105].to[241]>]
          - iron_axe[durability=<util.random.int[105].to[241]>]
          - iron_pickaxe[durability=<util.random.int[105].to[241]>]
      epic:
        chance: 18
        prize_count:
          min: 1
          max: 2
        prizes:
          - experience_bottle
          - scute
          - golden_apple
          - lead
          - goat_horn[raw_nbt=<map[instrument=string:minecraft:<list[admire|sing|ponder|seek|feel|call|yearn|dream].random>_goat_horn]>]
          - frogspawn
          - name_tag
          - spyglass
          - ballitem
          - recovery_compass
          - creeper_banner_pattern
          - skull_banner_pattern
          - turtle_egg
          - netherite_scrap
          - totem_of_undying
          - diamond_boots[durability=<util.random.int[105].to[420]>]
          - diamond_helmet[durability=<util.random.int[105].to[360]>]
          - diamond_chestplate[durability=<util.random.int[205].to[520]>]
          - diamond_leggings[durability=<util.random.int[155].to[490]>]
          - diamond_pickaxe[durability=<util.random.int[205].to[520]>]
          - diamond_shovel[durability=<util.random.int[155].to[490]>]
          - diamond_axe[durability=<util.random.int[155].to[490]>]
      legendary:
        prize_count:
          min: 1
          max: 1
        chance: 5
        prizes:
          - netherite_scrap
          - netherite_ingot
          - shulker_shell
          - heart_of_the_sea
          - phantom_membrane
          - totem_of_undying
          - trident[durability=<util.random.int[70].to[245]>]
          - mojang_banner_pattern
      book:
        chance: 15
        prize_count:
          min: 1
          max: 2
        prizes:
          - ENCHANTED_BOOK[enchantments=<map[PROTECTION=<util.random.int[1].to[4]>]>]
          - ENCHANTED_BOOK[enchantments=<map[FEATHER_FALLING=<util.random.int[1].to[4]>]>]
          - ENCHANTED_BOOK[enchantments=<map[BLAST_PROTECTION=<util.random.int[1].to[4]>]>]
          - ENCHANTED_BOOK[enchantments=<map[PROJECTILE_PROTECTION=<util.random.int[1].to[4]>]>]
          - ENCHANTED_BOOK[enchantments=<map[RESPIRATION=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[THORNS=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[DEPTH_STRIDER=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[FROST_WALKER=<util.random.int[1].to[2]>]>]
          - ENCHANTED_BOOK[enchantments=<map[SMITE=<util.random.int[1].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[PIERCING=<util.random.int[1].to[4]>]>]
          - ENCHANTED_BOOK[enchantments=<map[QUICK_CHARGE=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[RIPTIDE=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[IMPALING=<util.random.int[1].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[LOYALTY=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[PUNCH=<util.random.int[1].to[2]>]>]
          - ENCHANTED_BOOK[enchantments=<map[POWER=<util.random.int[1].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[SWEEPING_EDGE=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[LOOTING=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[FIRE_ASPECT=<util.random.int[1].to[2]>]>]
          - ENCHANTED_BOOK[enchantments=<map[KNOCKBACK=<util.random.int[1].to[2]>]>]
          - ENCHANTED_BOOK[enchantments=<map[BANE_OF_ARTHROPODS=<util.random.int[1].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[LUCK_OF_THE_SEA=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[LURE=<util.random.int[1].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[CURSE_OF_VANISHING=1]>]
          - ENCHANTED_BOOK[enchantments=<map[CURSE_OF_BINDING=1]>]
          - ENCHANTED_BOOK[enchantments=<map[INFINITY=1]>]
          - ENCHANTED_BOOK[enchantments=<map[FLAME=1]>]
          - ENCHANTED_BOOK[enchantments=<map[INFINITY=1]>]
          - ENCHANTED_BOOK[enchantments=<map[MULTISHOT=1]>]
          - ENCHANTED_BOOK[enchantments=<map[AQUA_AFFINITY=1]>]
          - ENCHANTED_BOOK[enchantments=<map[CHANNELING=1]>]
      mending:
        chance: 10
        prize_count:
          min: 1
          max: 1
        prizes:
          - ENCHANTED_BOOK[enchantments=<map[MENDING=1]>]
          - ENCHANTED_BOOK[enchantments=<map[UNBREAKING=<util.random.int[2].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[EFFICIENCY=<util.random.int[3].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[FORTUNE=<util.random.int[2].to[3]>]>]
          - ENCHANTED_BOOK[enchantments=<map[SHARPNESS=<util.random.int[3].to[5]>]>]
          - ENCHANTED_BOOK[enchantments=<map[SILK_TOUCH=1]>]

pFishing_command_main:
  type: command
  debug: false
  name: pfishing
  permission: pfishing.admin
  usage: /pfishing
  description: Pfishing
  aliases:
    - pfish
    - pf
    - fishing
    - fish
  script:
    - choose <context.args.get[1]||null>:
      - case enable:
        - define current_state <server.flag[pFishing.enabled]||true>
        - if <[current_state]>:
          - narrate "<&c>pFishing is already enabled! If you wish to reload it, use /pf restart."
          - stop
        - flag server pFishing.enabled:true

        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - if <util.queues.parse[id].contains[<[queue_id]>]>:
            - queue <queue[<[queue_id]>]> stop
        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - run <[queue_id]> id:<[queue_id]>

        - narrate "<&a>Successfully enabled verdex pFishing!"
      - case disable:
        - define current_state <server.flag[pFishing.enabled]||true>
        - if <[current_state].not>:
          - narrate "<&c>pFishing is already disabled! If you wish to reload it, use /pf restart."
          - stop
        - flag server pFishing.enabled:false

        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - if <util.queues.parse[id].contains[<[queue_id]>]>:
            - queue <queue[<[queue_id]>]> stop
        - narrate "<&a>Successfully disabled verdex pFishing!"
      - case restart:
        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - if <util.queues.parse[id].contains[<[queue_id]>]>:
            - queue <queue[<[queue_id]>]> stop
        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - run <[queue_id]> id:<[queue_id]>

        - narrate "<&a>Successfully restarted verdex pFishing!"
      - case clear:
        - define count <server.flag[pFishing.fishy_places].keys.size>
        - flag server pFishing.fishy_places:!
        - narrate "<&a>Successfully removed all fishy places (<[count]>)!"

      - case toggle:
        - define current_state <server.flag[pFishing.enabled]||true>
        - flag server pFishing.enabled:<[current_state].not>
        - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
          - if <util.queues.parse[id].contains[<[queue_id]>]>:
            - queue <queue[<[queue_id]>]> stop
        - choose <[current_state].not>:
          - case true:
            - foreach <list[pFishing_task_fishyPlaceLooper|pFishing_task_playerLooper]> as:queue_id:
              - run <[queue_id]> id:<[queue_id]>
            - narrate "<&a>Successfully enabled pFishing!"
          - case false:
            - narrate "<&a>Successfully disabled pFishing!"
      - case telemetry:
        - choose <context.args.get[2]||null>:
            - default:
                - narrate "<&c>Unrecognised command!"
            - case player:
                - define player_name <context.args.get[3]||null>
                - define player_data <server.flag[telemetry.fishing.player.<[player_name]>.drops]||null>
                - if <[player_data]> == null:
                    - narrate "<&c>Wrong player or empty telemetry!"
                    - stop
                - narrate "<&7><[player_name]> fishing telemetry:"
                - narrate " <&7>Drops:"
                - define 911 <server.flag[telemetry.fishing.player.<[player_name]>.drops].sort_by_value.reverse||<map>>
                - narrate <[911].parse_value_tag[<&sp><&sp><&7><[parse_key].to_titlecase><&co><&sp><[parse_value]>].values.separated_by[<n>]>
            - case server:
                - narrate "<&7>Server fishing telemetry:"
                - narrate " <&7>Drops:"
                - define 911 <server.flag[telemetry.fishing.server.drops].sort_by_value.reverse||<map>>
                - narrate <[911].parse_value_tag[<&sp><&sp><&7><[parse_key].to_titlecase><&co><&sp><[parse_value]>].values.separated_by[<n>]>
      - default:
        - narrate '<&c>Unrecognised command!'
  tab complete:
    - definemap completion_tree:
        enable: <list>
        disable: <list>
        toggle: <list>
        restart: <list>
        clear: <list>
        telemetry: <list[player|server]>
    - determine <proc[generateTabCompletion].context[<[completion_tree].escaped>|<context.args.escaped>|<context.raw_args>]>

pFishing_task_createFishyPlace:
  type: task
  debug: false
  definitions: location|player
  script:
    - define settings <script[pFishing_data_settings].data_key[data]>
    - define location <[location].as[location].block||null>
    - if <[location]> == null:
      - debug error "Location not specified!"
      - stop
    - narrate '<[location]> | <[player].name>' targets:<server.online_ops>
    - define category_chances <[settings].get[categories].parse_value_tag[<[parse_value].get[chance]>]>
    - define category <proc[advancedRandomProcedure].context[<[category_chances].escaped>]>
    - foreach <list[min|max]>:
      - define item_count_<[value]> <[settings].deep_get[categories.<[category]>.prize_count.<[value]>]>
    - define contents <list>
    - define item_count <util.random.int[<[item_count_min]>].to[<[item_count_max]>]>
    - repeat <[item_count]>:
      - define contents:->:<proc[pFishing_procedure_randomCategoryItem].context[<[category]>]>
    - definemap data:
        created_on: <util.time_now>
        location: <[location]>
        player: <[player]>
        category: <[category]>
        contents: <[contents]>
    - define id <server.flag[pFishing.fishy_places].keys.highest.add[1]||1>
    - flag server pFishing.fishy_places.<[id]>:<[data]>

ripples_task:
  type: task
  name: ripples_task
  definitions: location|id|color
  debug: true
  script:
    - define radius:0
    - define count:50
    - define size:0.2
    - if <server.has_flag[ripple_cooldown.<[id]>].not>:
      - flag server ripple_cooldown.<[id]> expire:25t
      - repeat 15:
        - define radius:+:0.6
        - define count:-:1
        - define size:+:0.065
        - playeffect effect:REDSTONE special_data:<[size]>|<[color]> at:<[location].center.above[0.39].points_around_y[radius=<[radius].div[5]>;points=<[count]>]> quantity:1 offset:0 visibility:100
        - wait 3t

pFishing_task_fishyPlaceLooper:
  type: task
  debug: false
  definitions: id
  script:
    - define settings <script[pFishing_data_settings].data_key[data]>
    - while <server.flag[pFishing.enabled]||false>:
      - foreach <server.flag[pFishing.fishy_places]||<map>> key:id as:place_data:
        - if <[place_data].deep_get[location].chunk.is_loaded||false>:
          - define effect_radius <[settings].deep_get[place_radius].div[2]>
          - define density_coefficient <[settings].deep_get[place_radius].power[2]>
          - if <[place_data].deep_get[location].center.biome.name.equals[river]||false>:
            - playeffect effect:bubble_column_up at:<[place_data].deep_get[location].center>            quantity:<util.random.int[0].to[2].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - playeffect effect:bubble_pop       at:<[place_data].deep_get[location].center.above[0.5]> quantity:<util.random.int[0].to[4].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - run ripples_task def.location:<[place_data].deep_get[location]> def.id:<[id]> def.color:<&color[#FFFFFF]>
          - else if <[place_data].deep_get[location].center.biome.name.equals[beach]||false>:
            - playeffect effect:bubble_column_up at:<[place_data].deep_get[location].center>            quantity:<util.random.int[0].to[2].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - playeffect effect:bubble_pop       at:<[place_data].deep_get[location].center.above[0.5]> quantity:<util.random.int[0].to[4].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - run ripples_task def.location:<[place_data].deep_get[location]> def.id:<[id]> def.color:<&color[#FFFFFF]>
          - else if <[place_data].deep_get[location].center.biome.name.equals[jungle]||false>:
            - playeffect effect:bubble_column_up at:<[place_data].deep_get[location].center>            quantity:<util.random.int[0].to[2].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - playeffect effect:bubble_pop       at:<[place_data].deep_get[location].center.above[0.5]> quantity:<util.random.int[0].to[4].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - run ripples_task def.location:<[place_data].deep_get[location]> def.id:<[id]> def.color:<&color[#FFFFFF]>
          - else if <[place_data].deep_get[location].center.biome.name.equals[swamp]||false>:
            - playeffect effect:bubble_column_up at:<[place_data].deep_get[location].center>            quantity:<util.random.int[1].to[2].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - playeffect effect:sculk_charge_pop at:<[place_data].deep_get[location].center.above[0.5]>            quantity:<util.random.int[0].to[3].mul[<[density_coefficient]>]> offset:2,0,2 data:0.01 visibility:100 velocity:0,0.04,0
            - run ripples_task def.location:<[place_data].deep_get[location]> def.id:<[id]> def.color:<&color[#E4FFB5]>
          - else if <[place_data].deep_get[location].center.biome.name.equals[mangrove_swamp]||false>:
            - playeffect effect:bubble_column_up at:<[place_data].deep_get[location].center>            quantity:<util.random.int[1].to[2].mul[<[density_coefficient]>]> offset:<[effect_radius]>,0,<[effect_radius]> data:0.01 visibility:100
            - playeffect effect:sculk_charge_pop at:<[place_data].deep_get[location].center.above[0.5]>            quantity:<util.random.int[0].to[3].mul[<[density_coefficient]>]> offset:2,0,2 data:0.01 visibility:100 velocity:0,0.04,0
            - run ripples_task def.location:<[place_data].deep_get[location]> def.id:<[id]> def.color:<&color[#E4FFB5]>
          - define category <[place_data].deep_get[category]>
          - define category_color <[settings].deep_get[category_colors.<[category]>].parsed.as[color]||<color[#FFFFFF]>>
          - choose <[category]>:
            - case epic:
              - if <util.random_chance[20]>:
                - define offset <util.random.decimal[0].to[1].mul[<[effect_radius].mul[2]>]>
                - define angle <util.random.int[1].to[360]>
                - playeffect effect:witch_magic      at:<[place_data].deep_get[location].center.above[0.25].with_yaw[<[angle]>].forward_flat[<[offset]>]> quantity:1 offset:0 visibility:100 velocity:<location[0,5,0]>
            - case rare:
              - if <util.random_chance[20]>:
                - define offset <util.random.decimal[0].to[1].mul[<[effect_radius].mul[2]>]>
                - define angle <util.random.int[1].to[360]>
                - playeffect effect:villager_happy      at:<[place_data].deep_get[location].center.above[0.45].with_yaw[<[angle]>].forward_flat[<[offset]>]> quantity:1
            - case legendary:
              - if <util.random_chance[20]>:
                - define offset <util.random.decimal[0].to[1].mul[<[effect_radius].mul[2]>]>
                - define angle <util.random.int[1].to[360]>
                - playeffect effect:wax_on      at:<[place_data].deep_get[location].center.above[0.25].with_yaw[<[angle]>].forward_flat[<[offset]>]> quantity:1 offset:0 visibility:100 velocity:<location[0,5,0]>

        - else:
          - flag server pFishing.fishy_places.<[id]>:!
      - wait 3t

pFishing_task_removeFishyPlace:
  type: task
  debug: false
  definitions: id
  script:
    - define id <[id]||null>
    - if <[id]> == null:
      - debug error "ID not specified!"
      - stop
    - flag server pFishing.fishy_places.<[id]>:!


pFishing_task_playerLooper:
  type: task
  debug: false
  script:
    - define settings <script[pFishing_data_settings].data_key[data]>
    - while <server.flag[pFishing.enabled]||false>:
      - define player <world[world].players.random||null>
      - define formula <element[125].div[<server.online_players.size>]>
      - if <[player]> != null && <[player].in_group[afk].not>:
        - if <[player].location.y.sub[<[settings].deep_get[river_height]>].abs.is_less_than_or_equal_to[<[settings].deep_get[update_radius]>]>:
          - if <server.flag[pFishing.fishy_places].filter_tag[<[filter_value].deep_get[player].equals[<[player]>]>].keys.size||0> < <[settings].deep_get[per_player_limit]>:
            - if <server.flag[pFishing.fishy_places].keys.size||0> < <[settings].deep_get[per_server_limit]>:
              - if <world[world].has_storm>:
                - define chance 25
              - else:
                - define chance <[settings].deep_get[creation_chance]>
              - if <util.random_chance[<[chance]||15>]>:
                - define anchor_location <[player].location.with_y[<[settings].deep_get[river_height]>]||<location[0,0,0]>>
                - define cuboid <[anchor_location].add[<location[<[settings].deep_get[update_radius].mul[-1]>,0,<[settings].deep_get[update_radius].mul[-1]>]>].to_cuboid[<[anchor_location].add[<location[<[settings].deep_get[update_radius]>,0,<[settings].deep_get[update_radius]>]>]>]||null>
                - define blocks <[cuboid].blocks.filter_tag[<element[<[filter_value].material.name.equals[water].and[<[filter_value].material.level.equals[0]||false>].or[<[filter_value].material.waterlogged||false>]>].or[<[filter_value].material.name.advanced_matches[seagrass|tall_seagrass|kelp]>]>]||<list>>
                - define blocks <[blocks].filter[biome.name.advanced_matches[river|swamp|mangrove_swamp|beach|jungle]]>
                - define blocks <[blocks].filter[distance[<[player].location>].horizontal.is_more_than[<[settings].deep_get[dead_radius]>]]>
                - define blocks <[blocks].filter_tag[<server.flag[pFishing.fishy_places].values.parse[get[location].distance[<[filter_value]>].horizontal].lowest.is_more_than[<[settings].deep_get[fishy_place_min_distance]>]||true>]>
                - define create_location <[blocks].random||null>
                - if <[create_location]> != null:
                  - run pFishing_task_createFishyPlace def.location:<[create_location]> def.player:<[player]>
      - wait <[formula].as[duration]||1t>