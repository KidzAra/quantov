item_display_editor_entity:
    type: entity
    debug: false
    entity_type: item_display
    mechanisms:
        item: air
block_display_editor_entity:
    type: entity
    debug: false
    entity_type: block_display
    mechanisms:
        material: air
item_display_editor_gui:
    type: inventory
    debug: false
    inventory: CHEST
    title: Редактор обьектов
    size: 36
    gui: true
    definitions:
        display: armor_stand[flag=item_display_editor.type:display;display=<&color[#edf2f4]>СПОСОБ ОТОБРАЖЕНИЯ]
        pivot: map[flag=item_display_editor.type:pivot;display=<&color[#edf2f4]>БИЛЛБОРД]
        left-x: torch[flag=item_display_editor.type:left-x;display=<&color[#edf2f4]>ПОВОРОТ ВЛЕВО ПО X]
        right-x: soul_torch[flag=item_display_editor.type:right-x;display=<&color[#edf2f4]>ПОВОРОТ ВПРАВО ПО X]
        glowing: glowstone[flag=item_display_editor.type:glowing;display=<&color[#edf2f4]>СВЕЧЕНИЕ]
        glow_color: glow_berries[flag=item_display_editor.type:glow_color;display=<&color[#edf2f4]>ЦВЕТ СВЕЧЕНИЯ]
        left-y: lantern[flag=item_display_editor.type:left-y;display=<&color[#edf2f4]>ПОВОРОТ ВЛЕВО ПО Y]
        right-y: soul_lantern[flag=item_display_editor.type:right-y;display=<&color[#edf2f4]>ПОВОРОТ ВПРАВО ПО Y]
        scale-east-west: copper_block[flag=item_display_editor.type:scale-east-west;display=<&color[#edf2f4]>УВЕЛИЧИТЬ ВОСТОК/ЗАПАД]
        scale-up-down: iron_block[flag=item_display_editor.type:scale-up-down;display=<&color[#edf2f4]>УВЕЛИЧИТЬ ВВЕРХ/ВНИЗ]
        scale-north-south: gold_block[flag=item_display_editor.type:scale-north-south;display=<&color[#edf2f4]>УВЕЛИЧИТЬ СЕВЕР/ЮГ]
        scale-all: gold_block[flag=item_display_editor.type:scale-all;display=<&color[#edf2f4]>УВЕЛЕЧИТЬ ВСЁ]
        remove: barrier[flag=item_display_editor.type:remove;display=<&color[#d64933]>УДАЛИТЬ]
        left-z: campfire[flag=item_display_editor.type:left-z;display=<&color[#edf2f4]>ПОВОРОТ ВЛЕВО Z]
        right-z: soul_campfire[flag=item_display_editor.type:right-z;display=<&color[#edf2f4]>ПОВОРОТ ВПРАВО ПО Z]
        reset: brush[flag=item_display_editor.type:reset;display=<&color[#02A9EA]>СБРОСИТЬ НАСТРОЙКИ ТРАНСФОРМАЦИИ]
        y: iron_ingot[flag=item_display_editor.type:up-down;display=<&color[#edf2f4]>ВВЕРХ/ВНИЗ]
        x: copper_ingot[flag=item_display_editor.type:east-west;display=<&color[#edf2f4]>ВОСТОК/ЗАПАД]
        z: gold_ingot[flag=item_display_editor.type:north-south;display=<&color[#edf2f4]>СЕВЕР/ЮГ]
        lock: STRUCTURE_VOID[flag=item_display_editor.type:lock;display=<&color[#edf2f4]>Заблокировать редактирование другим игрокам]
        debug: debug_stick[flag=item_display_editor.config:debug;display=<&color[#edf2f4]>NBT обьекта]
        # Player configuration
        size: slime_ball[flag=item_display_editor.config:size;display=<&color[#edf2f4]>Размер поиска обьекта]
        type: minecart[flag=item_display_editor.config:type;display=<&color[#edf2f4]>Режим перемещения колесом мыши (Ввер/вниз | поворот влево/вправо | размер)]
        target: target[flag=item_display_editor.config:target;display=<&color[#edf2f4]>Убрать выделение энтити (переключиться на дебаг стик)]
        blocks: glass[flag=item_display_editor.config:blocks;display=<&color[#edf2f4]>Игнорировать блоки]
        light: shroomlight[flag=item_display_editor.type:light;display=<&color[#edf2f4]>Уровень света от окружения]
        sky_light: ice[flag=item_display_editor.type:sky_light;display=<&color[#edf2f4]>Уровень света от неба]
        light_reset: light[block_material=light[level=5];flag=item_display_editor.type:light_reset;display=<&color[#02A9EA]>СБРОСИТЬ НАСТРОЙКИ СВЕТА]
    slots:
    - [display] [pivot] [left-x] [right-x] [] [] [light_reset] [sky_light] [light]
    - [target] [] [left-y] [right-y] [] [scale-all] [scale-east-west] [scale-up-down] [scale-north-south]
    - [remove] [] [left-z] [right-z] [reset] [] [x] [y] [z]
    - [size] [blocks] [debug] [] [] [] [type] [] [lock]
blueprintPlaceTask:
    type: task
    definitions: entities
    debug: false
    script:
        - flag <player> blueprint:<[entities]> expire:1m
        - flag <player> blueprint_yaw <player.location.yaw>
        # - foreach <[entities]>:
        #     - if <[value].vehicle.equals[null]>:
        #         - define anchor_entity <[value]>
        - while <player.has_flag[blueprint]> && <player.is_online>:
            - foreach <[entities]>:
                - adjust <[value]> glowing:true
                - adjust <[value]> glow_color:#63ADF2
                - adjust <[value]> brightness:<map[block=15]>
                #- adjust <[value]> scale:<[value].scale.mul[<player.flag[blueprint_size].mul[20]>]>
                # - if <player.is_op>:
                #     - narrate <[value].scale>
                - flag <player> blueprint_size_raw:<[value].scale>
                - flag <player> blueprint_size:!
                - teleport <[value]> <player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]||<player.location.yaw>>]>
                - teleport <[value]> <[value].location.add[0,<player.flag[blueprint_y]>,0]>
                #- debugblock <[value].location> color:0,191,255,64 d:2t
            - wait 1t
        - remove <[entities]>
        - flag <player> blueprint:!
        - flag <player> entities:!
        - flag <player> items:!
        - wait 2t
        - flag <player> blueprint_yaw:!
        - flag <player> blueprint_size_raw:!
        - flag <player> blueprint_size:!
        - flag <player> blueprint_y:!

item_display_editor_nbt:
    type: inventory
    debug: false
    inventory: CHEST
    title: Редактор NBT
    size: 36
    gui: true
    definitions:
        EAST: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTNmYzUyMjY0ZDhhZDllNjU0ZjQxNWJlZjAxYTIzOTQ3ZWRiY2NjY2Y2NDkzNzMyODliZWE0ZDE0OTU0MWY3MCJ9fX0=;flag=item_display_editor.config:east;display=<&color[#edf2f4]>Восточное направление]
        WEST: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWYxMzNlOTE5MTlkYjBhY2VmZGMyNzJkNjdmZDg3YjRiZTg4ZGM0NGE5NTg5NTg4MjQ0NzRlMjFlMDZkNTNlNiJ9fX0=;flag=item_display_editor.config:west;display=<&color[#edf2f4]>Западное направление]
        NORTH: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTk5YWFmMjQ1NmE2MTIyZGU4ZjZiNjI2ODNmMmJjMmVlZDlhYmI4MWZkNWJlYTFiNGMyM2E1ODE1NmI2NjkifX19;flag=item_display_editor.config:north;display=<&color[#edf2f4]>Северное направление]
        SOUTH: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzkxMmQ0NWIxYzc4Y2MyMjQ1MjcyM2VlNjZiYTJkMTU3NzdjYzI4ODU2OGQ2YzFiNjJhNTQ1YjI5YzcxODcifX19;flag=item_display_editor.config:south;display=<&color[#edf2f4]>Южное направление]
        VERTICAL: player_head[skull_skin=eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWQ2YjEyOTNkYjcyOWQwMTBmNTM0Y2UxMzYxYmJjNTVhZTVhOGM4ZjgzYTE5NDdhZmU3YTg2NzMyZWZjMiJ9fX0=;flag=item_display_editor.config:VERTICAL;display=<&color[#edf2f4]>Вертикальное направление]
        POWER: redstone[flag=item_display_editor.config:power;display=<&color[#edf2f4]>Активация]
        HALF: oak_door[flag=item_display_editor.config:half;display=<&color[#edf2f4]>Часть]
        SHAPE: oak_stairs[flag=item_display_editor.config:shape;display=<&color[#edf2f4]>Форма]
        LEAF_SIZE: oak_leaves[flag=item_display_editor.config:leaf_size;display=<&color[#edf2f4]>Размер листвы]
        age: bamboo[flag=item_display_editor.config:age;display=<&color[#edf2f4]>Возраст/размер]
        attached: tripwire_hook[flag=item_display_editor.config:attached;display=<&color[#edf2f4]>Прикреплено]
    slots:
    - [] [NORTH] [] [] [] [] [] [] []
    - [WEST] [VERTICAL] [EAST] [] [power] [] [half] [] [shape]
    - [] [SOUTH] [] [] [leaf_size] [] [age] [] [attached]
    - [] [] [] [] [] [] [] [] []


getheights:
    type: procedure
    debug: false
    definitions: item_display|direction
    script:
    - if <[item_display].material.advanced_matches[*wall].not>:
        - define new_list <[item_display].material.faces>
        - if <[item_display].material.faces.contains[<[direction]>].not>:
            - define new_list:->:<[direction]>
        - else:
            - define new_list:<-:<[direction]>
        #- adjust <[item_display]> material:<[item_display].material.name>[faces=<[list]>]
    - else:
        - choose <[direction]>:
            - case east:
                - define num 2
            - case north:
                - define num 1
            - case South:
                - define num 3
            - case west:
                - define num 4
            - case vertical:
                - define num 5
        - define list <[item_display].material.sides>
        - if <[num]> != 5:
            - if <[item_display].material.sides.get[<[num]>].equals[NONE]>:
                - foreach <[list]>:
                    - if <[loop_index].equals[<[num]>].not>:
                        - define new_list:->:<[value]>
                    - else:
                        - define new_list:->:low
            - else if <[item_display].material.sides.get[<[num]>].equals[low]>:
                - foreach <[list]>:
                    - if <[loop_index].equals[<[num]>].not>:
                        - define new_list:->:<[value]>
                    - else:
                        - define new_list:->:tall
            - else if <[item_display].material.sides.get[<[num]>].equals[tall]>:
                - foreach <[list]>:
                    - if <[loop_index].equals[<[num]>].not>:
                        - define new_list:->:<[value]>
                    - else:
                        - define new_list:->:none
        - else:
            - if <[item_display].material.sides.get[<[num]>].equals[NONE]>:
                - foreach <[list]>:
                    - if <[loop_index].equals[<[num]>].not>:
                        - define new_list:->:<[value]>
                    - else:
                        - define new_list:->:tall
            - else if <[item_display].material.sides.get[<[num]>].equals[tall]>:
                - foreach <[list]>:
                    - if <[loop_index].equals[<[num]>].not>:
                        - define new_list:->:<[value]>
                    - else:
                        - define new_list:->:none
        #- adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]

    - determine <[new_list]>


item_display_editor_gui_handler:
    type: world
    debug: false
    events:
        on player right clicks block with:item_display_editor_item using:off_hand:
            - determine passively cancelled
        on player right clicks *slab with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *portal with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks snow with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks observer with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks target with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks tripwire_hook with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks pink_petals with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks cave_vines with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *crop with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks cocoa with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks nether_wart with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *campfire with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks cake with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks iron_door with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks suspicious* with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks lightning_rod with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *plate with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *sculk_sensor with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks wheat with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks carrots with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks potatoes with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks pumpkin_stem with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks melon_stem with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks snow with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks end_portal_frame with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks farmland with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *candle with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks beehive with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks bee_nest with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks sweet_berry_bush with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks sea_pickle with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks composter with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks respawn_anchor with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks sculk_shrieker with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *egg with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks cactus with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks tnt with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks sugar_cane with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks redstone* with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks repeater with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks *leaves with:item_display_editor_item:
            - determine passively cancelled
        on player right clicks block with:glowstone_dust:
            - if <player.is_sneaking> && <context.location.has_flag[waxed].not> && <context.location.block.material.name.equals[air].not||false>:
                # - if <player.has_permission[prime].not>:
                #     - determine cancelled
                - determine passively cancelled
                - animate <player> animation:ARM_SWING
                - flag <context.location> waxed expire:1d
                - take iteminhand
                - playeffect at:<context.location.center> offset:0.6 effect:wax_on quantity:10
                - playsound at:<context.location.center> volume:0.4 sound:entity_illusioner_cast_spell
        on player right clicks block with:*_axe:
            - if <player.is_sneaking> && <context.location.has_flag[waxed]> && <context.location.block.material.name.equals[air].not||false>:
                # - if <player.has_permission[prime].not>:
                #     - determine cancelled
                - determine passively cancelled
                - animate <player> animation:ARM_SWING
                - flag <context.location> waxed:!
                - playeffect at:<context.location.center> offset:0.4 effect:wax_off quantity:10
                - playsound at:<context.location.center> volume:0.4 sound:item_axe_wax_off
                - define durability <player.item_in_hand.durability>
                - define durability:+:1
                - inventory adjust slot:hand durability:<[durability]>
                - if <[durability]> > <player.item_in_hand.max_durability>:
                    - take iteminhand
                    - playsound <player> sound:ENTITY_ITEM_BREAK
        on player right clicks block with:item_display_editor_item bukkit_priority:lowest:
            # - if <player.has_permission[prime].not>:
            #     - determine cancelled
            - if <player.has_flag[blueprint]> && <player.item_in_offhand.script.name.equals[blue_print]||false>:
                - determine passively cancelled
                - if <player.has_flag[blueprint_cooldown]>:
                    - inventory close
                    - narrate "<&color[#d64933]>Вы уверены что можете так часто использовать чертеж?"
                    - stop
                - flag <player> items:!
                - foreach <player.flag[entities]>:

                    - if <[value].describe.contains_text[block_display]>:
                        - flag <player> items.<[value].describe.after[m@].before[;].before[<&lb>]>:++ expire:10s
                    #- flag <player> items.<[value].describe.after[m@].before[<&lb>]>:++ expire:10s
                    #- narrate <[value].describe.after[i@].before[;]>
                    - if <[value].describe.contains_text[item_display]>:
                        #- narrate <[value].describe>
                        - flag <player> items.<[value].describe.after[i@].before[;].before[<&lb>]>:++ expire:10s
                - foreach <player.inventory.list_contents>:
                    #- narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>'
                    #- narrate '<[value].material.name.equals[<empty>].not>'

                    - define sum <player.inventory.slot[<player.inventory.find_all_items[<[value].material.name>]>].parse[quantity]>
                    - define new_sum:0
                    - foreach <[sum]>:
                        - define new_sum:+:<[value]>

                    #- if <player.flag[items].get[<[value].material.name>]||null> != null && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>:
                    #- if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>:
                    #- if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>:
                    - if <player.flag[items].get[<[value].material.name>]||null> != null && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>:
                        - define i:++
                        - define inventory_items.<[value].material.name>:<[new_sum]>

                    # - if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>:
                    #     - define i:++
                    # - else if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>:
                    #     - foreach next

                    # - if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>:
                    #     - define i:++
                    # - narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[new_sum]> >= <player.flag[items].get[<[value].material.name>]>'



                    # - narrate '<player.flag[items].get[<[value].material.name>]> > 64 && <[value].material.name.advanced_matches[<player.flag[items].keys>]>'
                    # - if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>:
                    #     - define i:++
                    # - else if <player.flag[items].get[<[value].material.name>]> > 64 && <[value].material.name.advanced_matches[<player.flag[items].keys>]>:
                    #     - define i:++

                - if <[i]||null> == null:
                    - narrate "<&color[#d64933]>Ошибка в чертеже либо у вас нет таких ресурсов!"
                    - narrate '<&color[#adb5bd]>Требуется:'


                    # - foreach <player.inventory.list_contents>:
                    #     #- narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>'
                    #     - if <[value].material.name.advanced_matches[<player.flag[items].keys>].not>:
                    #         - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[value].material.name>].translated_name> — <player.flag[items].get[<[value].material.name>]>'

                    - foreach <player.flag[items]> key:key:
                        - foreach <player.inventory.list_contents> as:raw:
                            - if <[key].advanced_matches[<player.inventory.list_contents.parse[material.name]>].not> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1:
                                - flag <player> <[key]>.size:++ expire:4t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> == 1:
                                - flag <player> <[key]>.size:++ expire:4t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value].sub[<[raw].quantity>]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> != 1:
                                - foreach <player.inventory.find_all_items[<[key]>]>:
                                    - define amount:+:<player.inventory.slot[<[value]>].quantity>
                                    #- narrate <player.inventory.slot[<[value]>].quantity>
                                - flag <player> <[key]>.size:++ expire:4t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[amount]>'
                    - flag <player> entities:!
                    - flag <player> blueprint:!
                    - flag <player> items:!
                    - inventory close
                    - stop
                - if <player.is_op>:
                    - narrate '<[inventory_items].keys.size> != <player.flag[items].keys.size>'
                - if <[inventory_items].keys.size> != <player.flag[items].keys.size>:
                    - inventory close
                    - narrate "<&color[#d64933]>У вас не хватает ресурсов для размещения чертежа!"
                    - narrate '<&color[#adb5bd]>Требуется:'


                    # - foreach <player.inventory.list_contents>:
                    #     #- narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>'
                    #     - if <[value].material.name.advanced_matches[<player.flag[items].keys>].not>:
                    #         - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[value].material.name>].translated_name> — <player.flag[items].get[<[value].material.name>]>'

                    - foreach <player.flag[items]> key:key:
                        - foreach <player.inventory.list_contents> as:raw:
                            - if <[key].advanced_matches[<player.inventory.list_contents.parse[material.name]>].not> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1:
                                - flag <player> <[key]>.size:++ expire:2s
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> == 1:
                                - flag <player> <[key]>.size:++ expire:2s
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value].sub[<[raw].quantity>]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> != 1:
                                - foreach <player.inventory.find_all_items[<[key]>]>:
                                    - define amount:+:<player.inventory.slot[<[value]>].quantity>
                                - flag <player> <[key]>.size:++ expire:2s
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[amount]>'

                    - flag <player> items:!
                    - flag <player> blueprint:!
                    - stop
                - foreach <player.flag[entities]>:
                    - spawn <[value]> <player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]>]> save:entity
                    - mount <entry[entity].spawned_entity> cancel

                    - define item_display <entry[entity].spawned_entity>
                    - flag <[item_display]> custom_model
                    #- narrate <player.flag[blueprint_size_raw]>
                    #- adjust <[item_display]> scale:<player.flag[blueprint_size_raw]||<[item_display].scale>>
                    #- narrate '<[item_display]> <[item_display].location.add[0,<player.flag[blueprint_y]>,0]>'
                    #- narrate <[item_display]>
                    - if <[item_display].scale.x> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер X больше 2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled
                    - if <[item_display].scale.y> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер Y больше 2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled
                    - if <[item_display].scale.z> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер Z больше 2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled

                    - if <[item_display].scale.x.replace_text[-].with[]> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер X больше -2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled
                    - if <[item_display].scale.y.replace_text[-].with[]> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер Y больше -2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled
                    - if <[item_display].scale.z.replace_text[-].with[]> > 3:
                        - narrate "<&color[#d64933]>Нельзя сделать размер Z больше -2.5."
                        - remove <entry[entity].spawned_entity>
                        - inventory close
                        - determine cancelled
                    - if <[value].describe.contains_text[block_display]>:
                        - take item:<[value].describe.after[m@].before[;].before[<&lb>]> quantity:1
                    - else if <[value].describe.contains_text[item_display]>:
                        - take item:<[value].describe.after[i@].before[;].before[<&lb>]> quantity:1

                    - flag <player> blueprint_cooldown expire:20s
                    - flag <entry[entity].spawned_entity> owner:<player>
                    - teleport <entry[entity].spawned_entity> <player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]>]>
                    - teleport <[item_display]> <[item_display].location.add[0,<player.flag[blueprint_y]>,0]>
                    - flag <entry[entity].spawned_entity> locked
                - playsound sound:item_armor_equip_leather <player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]>]> volume:0.4
                - playsound sound:entity_illusioner_cast_spell <player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]>]> volume:0.4
                - playeffect effect:cloud offset:0.3,0.5,0.3 quantity:15 at:<player.eye_location.ray_trace[range=4].if_null[<player.eye_location.forward[4]>].with_pitch[0].with_yaw[<player.flag[blueprint_yaw]>]>
                - inventory flag slot:41 cooldown expire:<util.random.int[100].to[600]>s
                - inventory close
                - determine passively cancelled
                - flag <player> blueprint:!
                - flag <player> items:!
                - flag <player> entities:!
                - flag <player> blueprint_yaw:!
                - stop



            # - if <player.has_flag[blueprint]>:
            #     - stop
            - if <context.location.has_flag[waxed].not> && <player.has_flag[item_display_editor.selected_display].not>:
                - determine passively cancelled
                - stop
            - if <context.location.has_flag[waxed].not> && <player.has_flag[item_display_editor.selected_display]> && <player.item_in_hand.has_flag[item_display_editor].not>:
                - determine passively cancelled
                - stop
            - wait 1t
            - adjustblock <context.location> waterlogged:false
        on player breaks block:
            - flag <context.location> waxed:!

        on player left clicks block with:*editor_item:
            - if <player.has_flag[blueprint]> && <player.has_flag[blueprint_bypass].not>:
                - determine passively cancelled
                - flag <player> blueprint:!
        # on player swaps items:
        #     - if <player.has_flag[blueprint]>:
        #         - determine cancelled
        on player clicks item in inventory:
            # - if <player.is_op>:
            #     - inventory set slot:<context.slot> d:<context.inventory> o:grass_block
            - if <player.has_flag[blueprint]> && <context.raw_slot.equals[34].not>:
                - determine cancelled
        on player drops item:
            - if <player.has_flag[blueprint]>:
                - determine cancelled
        on player dies:
            - if <player.has_flag[blueprint]>:
                - flag <player> blueprint:!
        on player right clicks block with:*blue_print using:off_hand:
            - if <player.item_in_offhand.has_flag[code]>:
                - if <player.item_in_offhand.flag[code].split[].get[2].equals[s].not>:
                    - narrate "<&color[#d64933]>Ошибка в чертеже!"
                    - playsound <player> sound:block_note_block_didgeridoo volume:0.7 pitch:0
                    - determine cancelled
                - if <player.item_in_offhand.flag[code].contains[/summon block_display ~-0.5 ~-0.5 ~-0.5].not>:
                    - narrate "<&color[#d64933]>Ошибка в чертеже!"
                    - playsound <player> sound:block_note_block_didgeridoo volume:0.7 pitch:0
                    - stop
                - if <player.item_in_offhand.flag[code].contains[Items:<&lb>{Slot:]>:
                    - inventory close
                    - narrate "<&color[#d64933]>Шо ты там дюпнуть собираешься, клоун?"
                    - stop
                - ratelimit <player> 2t
                - if <player.is_sneaking> && <player.has_flag[blueprint].not> && <player.item_in_hand.script.name.equals[item_display_editor_item]||false>:
                    - if <player.item_in_offhand.has_flag[cooldown]>:
                        - narrate "<&color[#d64933]>Этот чертеж временно недоступен! Подождите еще <player.item_in_offhand.flag_expiration[cooldown].add[1t].duration_since[<util.time_now>].formatted.replace_text[s].with[с].replace_text[m].with[м].replace_text[h].with[ч].replace_text[d].with[д]>"
                        - determine cancelled

                    - flag <player> blueprint_bypass expire:1t
                    - determine passively cancelled
                    - inventory close
                    - execute as_op '<player.item_in_offhand.flag[code].after[/]>' silent
                    - define entity <player.location.find_entities[item_display|block_display|text_display].within[1]>
                    - foreach <[entity]>:
                        - if <[value].vehicle.equals[null]>:
                            - define anchor_entity <[value]>

                    - foreach <[anchor_entity].passengers.parse[describe]>:
                        - fakespawn <[value]> <player.location> players:<player> d:1h
                    - flag <player> entities:<[anchor_entity].passengers.parse[describe]>
                    - playsound sound:entity_villager_work_librarian volume:0.5 <player.location>
                    - define entityes <player.fake_entities>
                    - flag <player.fake_entities> anchor:<[anchor_entity]>
                    - run blueprintPlaceTask def.entities:<[entityes]>
                    - remove <[entity]>

                    - foreach <player.flag[entities]>:
                        - if <[value].describe.contains_text[block_display]>:
                            - flag <player> items.<[value].describe.after[m@].before[;].before[<&lb>]>:++ expire:10s
                        - if <[value].describe.contains_text[item_display]>:
                            - flag <player> items.<[value].describe.after[i@].before[;]>:++ expire:10s
                    - foreach <player.inventory.list_contents>:
                        - if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>:
                            - define i:++
                    - if <[i]||null> == null:
                        - narrate "<&color[#d64933]>Ошибка в чертеже либо у вас нет таких ресурсов!"
                        - narrate '<&color[#adb5bd]>Требуется:'
                        - foreach <player.flag[items]> key:key:
                            - foreach <player.inventory.list_contents> as:raw:
                                - if <[key].advanced_matches[<player.inventory.list_contents.parse[material.name]>].not> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1:
                                    - flag <player> <[key]>.size:++ expire:5t
                                    - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value]>'
                                - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> == 1:
                                    - flag <player> <[key]>.size:++ expire:5t
                                    - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value].sub[<[raw].quantity>]>'
                                - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> != 1:
                                    - foreach <player.inventory.find_all_items[<[key]>]>:
                                        - define amount:+:<player.inventory.slot[<[value]>].quantity>
                                    - flag <player> <[key]>.size:++ expire:5t
                                    - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[amount]>'
                    - stop
                - else:
                    - stop


            - if <player.item_in_offhand.book_pages.first.split[].get[2].equals[s].not>:
                - narrate "<&color[#d64933]>Ошибка в чертеже!"
                - playsound <player> sound:block_note_block_didgeridoo volume:0.7 pitch:0
                - determine cancelled
            - if <player.item_in_offhand.book_pages.separated_by[].contains[/summon block_display ~-0.5 ~-0.5 ~-0.5].not>:
                - narrate "<&color[#d64933]>Ошибка в чертеже!"
                - playsound <player> sound:block_note_block_didgeridoo volume:0.7 pitch:0
                - stop
            - if <player.item_in_offhand.book_pages.separated_by[].contains[Items:<&lb>{Slot:]>:
                - inventory close
                - narrate "<&color[#d64933]>Шо ты там дюпнуть собираешься, клоун?"
                - stop
            - ratelimit <player> 2t
            - if <player.is_sneaking> && <player.has_flag[blueprint].not> && <player.item_in_hand.script.name.equals[item_display_editor_item]||false>:
                - if <player.item_in_offhand.has_flag[cooldown]>:
                    - narrate "<&color[#d64933]>Этот чертеж временно недоступен! Подождите еще <player.item_in_offhand.flag_expiration[cooldown].add[1t].duration_since[<util.time_now>].formatted.replace_text[s].with[с].replace_text[m].with[м].replace_text[h].with[ч].replace_text[d].with[д]>"
                    - determine cancelled

                - flag <player> blueprint_bypass expire:1t
                - determine passively cancelled
                - inventory close
                - execute as_op '<player.item_in_offhand.book_pages.separated_by[].after[/]>' silent
                - define entity <player.location.find_entities[item_display|block_display|text_display].within[3].filter[has_flag[custom_model].not]>
                - foreach <[entity]>:
                    - if <[value].vehicle.equals[null]>:
                        - define anchor_entity <[value]>
                #- wait 1s
                #- narrate <[anchor_entity].passengers.parse[describe]>

            # - if <[item].material.name.advanced_matches[cake|*candle|*torch|chain|*bed|*dripstone|*bud|amethyst*|*coral*|*lantern*|flower_pot].not>:
            #     - spawn item_display_editor_entity[item=<[item].with[quantity=1]>] <[location]> save:entity
            # - else:
            #     - spawn block_display_editor_entity[material=<[item].with[quantity=1].material.name>] <[location]> save:entity

                - foreach <[anchor_entity].passengers.parse[describe]>:
                #     - if <[value].describe.after[m@].before[<&lb>].advanced_matches[cake|*candle|*torch|chain|*bed|*dripstone|*bud|amethyst*|*coral*|*lantern*|flower_pot|bamboo|barrier].not>:
                #         - fakespawn e@item_display<&lb><[value].after[<&lb>].replace_text[material].with[item].replace_text[m@].with[i@]> <player.location> players:<player> d:1h
                #     - else:
                    - fakespawn <[value]> <player.location> players:<player> d:1h
                - flag <player> entities:<[anchor_entity].passengers.parse[describe]>
                - playsound sound:entity_villager_work_librarian volume:0.5 <player.location>
                - define entityes <player.fake_entities>
                - flag <player.fake_entities> anchor:<[anchor_entity]>
                - run blueprintPlaceTask def.entities:<[entityes]>
                - remove <[entity]>

                - foreach <player.flag[entities]>:
                    - if <[value].describe.contains_text[block_display]>:
                        - flag <player> items.<[value].describe.after[m@].before[;].before[<&lb>]>:++ expire:10s
                    #- narrate <[value].describe.after[i@].before[;]>
                    - if <[value].describe.contains_text[item_display]>:
                        #- narrate <[value].describe>
                        - flag <player> items.<[value].describe.after[i@].before[;]>:++ expire:10s
                - foreach <player.inventory.list_contents>:
                    #- narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>'
                    - if <[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>:
                        - define i:++
                - if <[i]||null> == null:
                    - narrate "<&color[#d64933]>Ошибка в чертеже либо у вас нет таких ресурсов!"
                    - narrate '<&color[#adb5bd]>Требуется:'


                    # - foreach <player.inventory.list_contents>:
                    #     #- narrate '<[value].material.name.advanced_matches[<player.flag[items].keys>]> && <[value].quantity> >= <player.flag[items].get[<[value].material.name>]>'
                    #     - if <[value].material.name.advanced_matches[<player.flag[items].keys>].not>:
                    #         - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[value].material.name>].translated_name> — <player.flag[items].get[<[value].material.name>]>'

                    - foreach <player.flag[items]> key:key:
                        - foreach <player.inventory.list_contents> as:raw:
                            - if <[key].advanced_matches[<player.inventory.list_contents.parse[material.name]>].not> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1:
                                - flag <player> <[key]>.size:++ expire:5t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> == 1:
                                - flag <player> <[key]>.size:++ expire:5t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[value].sub[<[raw].quantity>]>'
                            - else if <[key]> == <[raw].material.name> && <[value]> >= <[raw].quantity> && <player.flag[<[key]>.size]||0> != 1 && <player.inventory.find_all_items[<[key]>].size> != 1:
                                - foreach <player.inventory.find_all_items[<[key]>]>:
                                    - define amount:+:<player.inventory.slot[<[value]>].quantity>
                                - flag <player> <[key]>.size:++ expire:5t
                                - narrate ' <&color[#adb5bd]>• <&color[#d64933]><material[<[key]>].translated_name> — <[amount]>'
                    #- flag <player> entities:!
                    #- flag <player> blueprint:!
                    #- flag <player> items:!
                    - stop


        # on player left|right clicks item_flagged:item_display_editor.config in item_display_editor_nbt:
        #     - define config <context.item.flag[item_display_editor.config]>
        #     - define player_config <proc[IDE_get_player_config]>
        #     - define item_display <player.flag[item_display_editor.selected_display].if_null[null]>
        #     - choose <[config]>:
        #         - case east:
        #             # - define size:|:0.1|0.5|1|2|5
        #             # - if <context.click> == LEFT:
        #             #     - define add 1
        #             # - else:
        #             #     - define add -1
        #             # - define index <[size].find[<[player_config.size]>].add[<[add]>]>
        #             # - if <[index]> == 0:
        #             #     - define index 5
        #             # - if <[index]> == 6:
        #             #     - define index 1
        #             # - define size <[size].get[<[index]>]>
        #             - flag <player> item_display_editor.config.face:east

        on player left|right clicks item_flagged:item_display_editor.config in item_display_editor_gui:
        # - if <player.has_permission[prime].not>:
        #     - determine cancelled
        - define config <context.item.flag[item_display_editor.config]>
        - define player_config <proc[IDE_get_player_config]>
        - define item_display <player.flag[item_display_editor.selected_display].if_null[null]>
        - choose <[config]>:

            - case debug:
                - inventory open d:item_display_editor_nbt
                #- inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[size]>"
            - case target:
                - inventory flag slot:hand item_display_editor:!
            - case type:

                #- narrate <[player_config.type]>
                # - if <[player_config.type].equals[поворот]||true>:
                #     - flag <player> item_display_editor.config.type:вверх/вниз
                #     - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]>вверх/вниз"
                # - else if <[player_config.type].equals[вверх/вниз]||true>:
                #     - flag <player> item_display_editor.config.type:размер
                #     - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]>размер"
                # - else if <[player_config.type].equals[размер]||true>:
                #     - flag <player> item_display_editor.config.type:поворот
                #     - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]>поворот"

                - if <[player_config.type].equals[поворот]||false>:
                    - flag <player> item_display_editor.config.type:вверх/вниз
                    - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]>вверх/вниз"
                - else:
                    - flag <player> item_display_editor.config.type:поворот
                    - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]>поворот"

                # - define size:|:0.1|0.5|1|2|5
                # - if <context.click> == LEFT:
                #     - define add 1
                # - else:
                #     - define add -1
                # - define index <[size].find[<[player_config.size]>].add[<[add]>]>
                # - if <[index]> == 0:
                #     - define index 5
                # - if <[index]> == 6:
                #     - define index 1
                # - define size <[size].get[<[index]>]>
                # - flag <player> item_display_editor.config.size:<[size]>
                # - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[size]>"
            - case size:
                - define size:|:0.1|0.5|1|2|5
                - if <context.click> == LEFT:
                    - define add 1
                - else:
                    - define add -1
                - define index <[size].find[<[player_config.size]>].add[<[add]>]>
                - if <[index]> == 0:
                    - define index 5
                - if <[index]> == 6:
                    - define index 1
                - define size <[size].get[<[index]>]>
                - flag <player> item_display_editor.config.size:<[size]>
                - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[size]>"
            - case blocks:
                - if <[player_config.blocks]>:
                    - flag <player> item_display_editor.config.blocks:false
                    - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Игнорировать блоки<&co> <&color[#02A9EA]>нет"
                - else:
                    - flag <player> item_display_editor.config.blocks:true
                    - inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Игнорировать блоки<&co> <&color[#02A9EA]>да"
            - default:
                - debug <&color[#d64933]> "<&color[#d64933]>Event misfired or flag value did not match. Value was: '<&color[#02A9EA]><context.item.flag[item_display_editor.config]><&color[#d64933]>'"
        on player left clicks item_flagged:item_display_editor.config in item_display_editor_nbt:
        - define type <context.item.flag[item_display_editor.config]>
        - if <player.item_in_hand> not matches item_display_editor_item:
            - narrate "<&color[#d64933]>Вы должны держать в руках инструмент для редактирования."
            - stop
        - inventory flag slot:hand item_display_editor.type:<[type]>
        - inventory flag slot:hand item_display_editor.glow_color:!
        on player left clicks item_flagged:item_display_editor.type in item_display_editor_gui:
        - define type <context.item.flag[item_display_editor.type]>
        - if <player.item_in_hand> not matches item_display_editor_item:
            - narrate "<&color[#d64933]>Вы должны держать в руках инструмент для редактирования."
            - stop
        - inventory flag slot:hand item_display_editor.type:<[type]>
        - inventory flag slot:hand item_display_editor.glow_color:!
        on player swaps items offhand:item_display_editor_item:
        # - if <player.has_permission[prime].not>:
        #     - determine cancelled
        - determine passively cancelled
        - inject IDE_open_inventory
        on player clicks block with:item_flagged:item_display_editor.type:
        # - if <player.has_permission[prime].not>:
        #     - determine cancelled
        - determine passively cancelled
        - if <player.has_flag[blueprint]>:
            - stop
        - define item_display <player.flag[item_display_editor.selected_display].if_null[null]>
        - if <[item_display].has_flag[locked]||false> && <player> != <[item_display].flag[owner]>:
            - if <player.in_group[admin].not>:
                - narrate "<&color[#d64933]>Владец этого обьекта запретил его редактирование (<[item_display].flag[owner].name>)"
                - stop
        - if <[item_display]> == null:
            #- inventory flag slot:hand item_display_editor:!
            - narrate "<&color[#d64933]>У вас нет выбранного обьекта."
            - inventory close
            - stop
        - define data <[item_display].proc[IDE_get_data]>
        - if <player.is_sneaking>:
            - define value 0.03125
        - else:
            - define value 0.0625
        - define click_type <context.click_type.before[_]>
        - if <[click_type]> == RIGHT:
            - define value <[value].mul[-1]>
        - choose <context.item.flag[item_display_editor.type]>:

                # - if <[click_type]> == LEFT && <player.is_sneaking.not>:
                #     - define add 1
                # - else if <player.is_sneaking> && <[click_type]> == LEFT:
                #     - define add -1

                # - define ENUM_LIST:|:EAST|WEST|SOUTH|NORTH
                # - define item_transform <[item_display].material.faces>
                # - narrate <[item_transform]>
                # - define index <[ENUM_LIST].find[<[item_transform]>].add[<[add]>]>

                # - if <[index]> == 0:
                #     - define index 4
                # - if <[index]> == 5:
                #     - define index 1
                # - define transform <[ENUM_LIST].get[<[index]>]>
                # - narrate <[transform]>
                # - if <[click_type]> == RIGHT:
                #     - if <[item_display].material.faces.contains[<[transform]>]>:
                #         - define action false
                #     - else:
                #         - define action true


                # - adjust <[item_display]> material:<[item_display].material>[faces=<list[<[transform]>]>]
                # - narrate "<&color[#63c132]>Трансформация была установлена на <&color[#02A9EA]><[transform]>"

            - case east:
                - define new_list <proc[getheights].context[<[item_display]>|east]>

                - if <[item_display].material.advanced_matches[*wall]>:
                    - adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]
                    - define old_action <[item_display].material.sides>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[sides=<[old_action]>].with[sides=<[new_list]>]>
                - else:
                    - adjust <[item_display]> material:<[item_display].material.name>[faces=<[new_list]>]
                    - define old_action <[item_display].material.faces>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[faces=<[old_action]>].with[faces=<[new_list]>]>
            - case west:
                - define new_list <proc[getheights].context[<[item_display]>|west]>

                - if <[item_display].material.advanced_matches[*wall]>:
                    - adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]
                    - define old_action <[item_display].material.sides>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[sides=<[old_action]>].with[sides=<[new_list]>]>
                - else:
                    - adjust <[item_display]> material:<[item_display].material.name>[faces=<[new_list]>]
                    - define old_action <[item_display].material.faces>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[faces=<[old_action]>].with[faces=<[new_list]>]>
            - case south:
                - define new_list <proc[getheights].context[<[item_display]>|south]>


                - if <[item_display].material.advanced_matches[*wall]>:
                    - adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]
                    - define old_action <[item_display].material.sides>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[sides=<[old_action]>].with[sides=<[new_list]>]>
                - else:
                    - adjust <[item_display]> material:<[item_display].material.name>[faces=<[new_list]>]
                    - define old_action <[item_display].material.faces>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[faces=<[old_action]>].with[faces=<[new_list]>]>
            - case north:
                - define new_list <proc[getheights].context[<[item_display]>|north]>

                - if <[item_display].material.advanced_matches[*wall]>:
                    - adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]
                    - define old_action <[item_display].material.sides>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[sides=<[old_action]>].with[sides=<[new_list]>]>
                - else:
                    - adjust <[item_display]> material:<[item_display].material.name>[faces=<[new_list]>]
                    - define old_action <[item_display].material.faces>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[faces=<[old_action]>].with[faces=<[new_list]>]>
            - case vertical:
                - define new_list <proc[getheights].context[<[item_display]>|vertical]>

                - adjust <[item_display]> material:<[item_display].material.name>[sides=<[new_list]>]

                - define old_action <[item_display].material.sides>
                - adjust <[item_display]> material:<[item_display].material.replace_text[sides=<[old_action]>].with[sides=<[new_list]>]>
            - case power:
                - if <[item_display].material.switched.equals[true]>:
                    - define action false
                - else:
                    - define action true
                - define old_action <[item_display].material.switched>
                - adjust <[item_display]> material:<[item_display].material.replace_text[switched=<[old_action]>].with[switched=<[action]>]>
            - case half:
                - if <[item_display].material.half.equals[BOTTOM]>:
                    - define action TOP
                - else:
                    - define action BOTTOM
                - define old_action <[item_display].material.half>
                - adjust <[item_display]> material:<[item_display].material.replace_text[half=<[old_action]>].with[half=<[action]>]>
            - case age:
                - define max_age <[item_display].material.maximum_age||null>
                - define max_level <[item_display].material.maximum_level||null>
                - if <[max_age].equals[null].not>:
                    - if <[item_display].material.maximum_age> != <[item_display].material.age>:
                        - define age <[item_display].material.age>
                        - define age:++
                    - else:
                        - define age 0
                    - define old_action <[item_display].material.age>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[age=<[old_action]>].with[age=<[age]>]>
                - else:
                    - if <[item_display].material.maximum_level> != <[item_display].material.level>:
                        - define age <[item_display].material.level>
                        - define age:++
                    - else:
                        - define age 0
                    - define old_action <[item_display].material.level>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[level=<[old_action]>].with[level=<[age]>]>
            - case attached:
                - if <[item_display].material.name.advanced_matches[bell|grindstone].not>:
                    - if <[item_display].material.attached.equals[true]>:
                        - define action false
                    - else:
                        - define action true
                    - define old_action <[item_display].material.attached>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[attached=<[old_action]>].with[attached=<[action]>]>

                - else:
                    - if <[item_display].material.attachment_face.equals[FLOOR]>:
                        - define action CEILING
                    - else if <[item_display].material.attachment_face.equals[CEILING]>:
                        - define action SINGLE_WALL
                    - else if <[item_display].material.attachment_face.equals[SINGLE_WALL]>:
                        - define action DOUBLE_WALL
                    - else:
                        - define action FLOOR
                    - define old_action <[item_display].material.attachment_face>
                    - adjust <[item_display]> material:<[item_display].material.replace_text[attachment_face=<[old_action]>].with[attachment_face=<[action]>]>


            - case leaf_size:
                - if <[item_display].material.leaf_size.equals[none]>:
                    - define action SMALL
                - else if <[item_display].material.leaf_size.equals[SMALL]>:
                    - define action LARGE
                - else:
                    - define action none

                - define old_action <[item_display].material.leaf_size>
                - adjust <[item_display]> material:<[item_display].material.replace_text[leaf_size=<[old_action]>].with[leaf_size=<[action]>]>
            - case shape:
                - if <[item_display].material.shape.equals[straight]>:
                    - define action INNER_LEFT
                - else if <[item_display].material.shape.equals[INNER_LEFT]>:
                    - define action INNER_RIGHT
                - else if <[item_display].material.shape.equals[INNER_RIGHT]>:
                    - define action OUTER_LEFT
                - else if <[item_display].material.shape.equals[OUTER_LEFT]>:
                    - define action OUTER_RIGHT
                - else:
                    - define action straight
                - define old_action <[item_display].material.shape>
                - adjust <[item_display]> material:<[item_display].material.replace_text[shape=<[old_action]>].with[shape=<[action]>]>


            # Move Y
            - case up-down:
                - define vector 0,<[value]>,0
                - inject IDE_set_location
            # Move X
            - case east-west:
                - define vector <[value]>,0,0
                - inject IDE_set_location
            # Move Z
            - case north-south:
                - define vector 0,0,<[value]>
                - inject IDE_set_location
            # Scale Y
            - case scale-up-down:
                - define vector <location[0,<[value]>,0]>
                - inject IDE_set_transformation_scale
            # Scale X
            - case scale-east-west:
                - define vector <location[<[value]>,0,0]>
                - inject IDE_set_transformation_scale
            # Scale Z
            - case scale-north-south:
                - define vector <location[0,0,<[value]>]>
                - inject IDE_set_transformation_scale
            - case scale-all:
                - define vector <location[<[value]>,<[value]>,<[value]>]>
                - inject IDE_set_transformation_scale
            # item_transform

            - case light_reset:
                - adjust <[item_display]> brightness
                - flag <player> item_display_editor.config.sky_light:!
                - flag <player> item_display_editor.config.light:!
            - case lock:
                - if <[item_display].has_flag[locked].not||true> && <[item_display].flag[owner]> == <player>:
                    - flag <[item_display]> locked
                    - narrate "<&color[#d64933]>Возможность редактирования обьекта другими игрокам была заблокирована"
                    - playsound sound:item_lodestone_compass_lock <player>
                - else if <[item_display].flag[owner]> == <player>:
                    - flag <[item_display]> locked:!
                    - narrate "<&color[#63c132]>Возможность редактирования обьекта другими игрокам была разблокирована"
                    - playsound sound:entity_item_break <player>
            - case sky_light:
                - if <[click_type]> == LEFT && <player.flag[item_display_editor.config.sky_light]||0> < 15:
                    - define add 1
                - else if <player.flag[item_display_editor.config.sky_light]||0> > 0 && <[click_type]> == right:
                    - define add -1
                - define size <player.flag[item_display_editor.config.sky_light]||1>
                - define size:+:<[add]||0>
                - flag <player> item_display_editor.config.sky_light:<[size]>
                - adjust <[item_display]> brightness:<map[sky=<[size]>]>
                #- inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Размер<&co> <[size].custom_color[emphasis]>"
            - case light:
                - if <[click_type]> == LEFT && <player.flag[item_display_editor.config.light]||0> < 15:
                    - define add 1
                - else if <player.flag[item_display_editor.config.light]||0> > 0 && <[click_type]> == right:
                    - define add -1
                - define size <player.flag[item_display_editor.config.light]||1>
                - define size:+:<[add]||0>
                - flag <player> item_display_editor.config.light:<[size]>
                - adjust <[item_display]> brightness:<map[block=<[size]>]>
                #- inventory adjust destination:<player.open_inventory> slot:<context.slot> "lore:<&color[#adb5bd]>Размер<&co> <[size].custom_color[emphasis]>"


            - case display:
                - if <[click_type]> == LEFT:
                    - define add 1
                - else:
                    - define add -1
                - define ENUM_LIST:|:NONE|THIRDPERSON_LEFTHAND|THIRDPERSON_RIGHTHAND|FIRSTPERSON_LEFTHAND|FIRSTPERSON_RIGHTHAND|HEAD|GUI|GROUND|FIXED
                - define item_transform <[data.display]>
                - define index <[ENUM_LIST].find[<[item_transform]>].add[<[add]>]>
                - if <[index]> == 0:
                    - define index 9
                - if <[index]> == 10:
                    - define index 1
                - define transform <[ENUM_LIST].get[<[index]>]>
                - adjust <[item_display]> display:<[transform]>
                - narrate "<&color[#63c132]>Трансформация была установлена на <&color[#02A9EA]><[transform]>"

            - case pivot:
                - if <[click_type]> == LEFT:
                    - define add 1
                - else:
                    - define add -1
                - define ENUM_LIST:|:FIXED|VERTICAL|HORIZONTAL|CENTER
                - define pivot <[data.pivot]>
                - define index <[ENUM_LIST].find[<[pivot]>].add[<[add]>]>
                - if <[index]> == 0:
                    - define index 4
                - if <[index]> == 5:
                    - define index 1
                - define transform <[ENUM_LIST].get[<[index]>]>
                - adjust <[item_display]> pivot:<[transform]>
                - narrate "<&color[#63c132]>Биллборд был установлен на <&color[#02A9EA]><[transform]>"
            # remove
            - case remove:
                - ratelimit <player> 2t
                # - if <[item_display].flag[owner].if_null[null]> != <player>:
                #     - if <player.is_op>:
                #         - goto beb
                #     - narrate "<&color[#d64933]>Этот обьект не пренадлежит вам."
                #     - stop
                # - mark beb
                # - if <player.is_op.not>:
                #     - inventory flag slot:hand item_display_editor:!
                # - else:
                - flag <player> item_display_editor.selected_display:!
                #- remove <[item_display]>
                #- flag <player> item_display_editor
                #- if <player.is_op>:
                - give <[item_display].item||<[item_display].material.after[@].as[item]>>
                #- narrate <[item_display].item||<[item_display].material.after[@].as[item]>>
                - remove <[item_display]>
            - case right-x:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[1|0|0]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case right-y:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|1|0]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case right-z:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|0|1]> def.type:transformation_right_rotation def.click_type:<[click_type]>
            - case left-x:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[1|0|0]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case left-y:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|1|0]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case left-z:
                - run IDE_set_transformation_rotation def.item_display:<[item_display]> def.data:<[data]> def.axis:<list[0|0|1]> def.type:transformation_left_rotation def.click_type:<[click_type]>
            - case reset:
                - adjust <[item_display]> left_rotation:0,0,0,1
                - adjust <[item_display]> right_rotation:0,0,0,1
                - flag <[item_display]> item_display_editor.transformation_left_rotation:!
                - flag <[item_display]> item_display_editor.transformation_right_rotation:!
            - case glowing:
                - if <[item_display].has_flag[item_display_editor.glowing]>:
                    - adjust <[item_display]> glowing:false
                    - flag <[item_display]> item_display_editor.glowing:!
                    - narrate "<&color[#63c132]>Обьект больше не светится."
                - else:
                    - adjust <[item_display]> glowing:true
                    - flag <[item_display]> item_display_editor.glowing
                    - narrate "<&color[#63c132]>Обьект теперь светится."
            - case glow_color:
                - if <player.item_in_hand.has_flag[item_display_editor.glow_color]>:
                    - adjust <[item_display]> glow_color:<player.item_in_hand.flag[item_display_editor.glow_color]>
                    - stop
                - flag <player> item_display_editor.chat_input expire:30s
                - narrate "<&color[#63c132]>Напишите RGB или HEX значение в чат чтобы применить цвет. Пример: 255,255,255 or #ffff00."
            - default:
                - debug <&color[#d64933]> "<&color[#d64933]>Event misfired or flag value did not match. Value was: '<context.item.flag[item_display_editor.type].custom_color[emphasis]>'"
        on player chats flagged:item_display_editor.chat_input ignorecancelled:true priority:-100:
        - determine passively cancelled
        - if <player.item_in_hand> not matches item_display_editor_item:
            - narrate "<&color[#d64933]>Вы должны держать в руках инструмент для редактирования."
            - flag <player> item_display_editor.chat_input:!
            - stop
        - define color <color[<context.message>].if_null[null]>
        - if <[color]> == null:
            - narrate "<&color[#d64933]>Это неверный код <&color[#02A9EA]><context.message>"
            - flag <player> item_display_editor.chat_input:!
            - stop
        - flag <player> item_display_editor.chat_input:!
        - inventory flag slot:hand item_display_editor.glow_color:<[color]>
        - narrate "<&color[#63c132]>Цвет установлен. Взмахните инструментом чтобы применить!"
        on player walks flagged:item_display_editor.in_selection:
        # - if <player.has_permission[prime].not>:
        #     - stop
        - ratelimit <player> 2t
        - if <player.item_in_hand> not matches item_display_editor_item:
            - stop
        - define player_config <proc[IDE_get_player_config]>
        - define item_display <player.eye_location.ray_trace_target[entities=item_display|block_display|text_display;blocks=<[player_config.blocks]>;range=10;raysize=<[player_config.size]>].if_null[null]>
        # - if <[item_display].has_flag[locked]||false> && <player> != <[item_display].flag[owner]>:
        #     - stop
        # If no display item is in range. Remove the glowing and the flag.
        - define display_item <player.flag[item_display_editor.selected_display].if_null[<player>]>
        - if <[item_display]> == null:
            - if <player.has_flag[item_display_editor.selected_display]>:
                - if !<[display_item].has_flag[item_display_editor.glowing]>:
                    - adjust <[display_item]> glowing:false
                - flag <player> item_display_editor.selected_display:!
            - stop
        # If the player selected item is not equal the new item, remove the glowing from the old one and add it to the new one.
        - if <[display_item]> != <[item_display]> && !<[display_item].has_flag[item_display_editor.glowing]>:
            - adjust <[display_item]> glowing:false
            - flag <player> item_display_editor.selected_display:<[item_display]>
        #- define entity <[item_display].location.find_entities[item_display|block_display].within[2]>
        # #- narrate <[item_display].vehicle||null>
        # - foreach <[entity]>:
        #     - if <[value].vehicle.equals[null]>:
        #         - define anchor_entity <[value]>
        #- narrate <[anchor_entity].passengers>
        # - if <[item_display].vehicle||null> == null:

        #     - flag <player> item_display_editor.selected_display:<[anchor_entity]>
        # - else:
        - flag <player> item_display_editor.selected_display:<[item_display]>
        - adjust <[item_display]> glowing:true
        on player scrolls their hotbar item:item_display_editor_item:
        - flag <player> item_display_editor.in_selection
        on player scrolls their hotbar:
            - if <player.flag[item_display_editor.config.type].equals[поворот]||true>:
                - if <player.has_flag[blueprint]> && <player.is_sneaking>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_yaw:--
                        - else:
                            - flag <Player> blueprint_yaw:++
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_yaw:--
                - else if <player.has_flag[blueprint]>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_yaw:-:5
                        - else:
                            - flag <Player> blueprint_yaw:+:5
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_yaw:-:5

            - else if <player.flag[item_display_editor.config.type].equals[размер]||true>:
                - if <player.has_flag[blueprint]> && <player.is_sneaking>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_size:0.05
                        - else:
                            - flag <Player> blueprint_size:0.05
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_size:-:0.05
                - else if <player.has_flag[blueprint]>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_size:-:0.1
                        - else:
                            - flag <Player> blueprint_size:+:0.1
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_size:-:0.1

            - else:
                - if <player.has_flag[blueprint]> && <player.is_sneaking>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_y:-:0.05
                        - else:
                            - flag <Player> blueprint_y:+:0.05
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_y:-:0.05
                - else if <player.has_flag[blueprint]>:
                    - determine passively cancelled
                    - if <context.new_slot> >= <context.previous_slot>:
                        - if <context.new_slot.equals[9]> && <context.previous_slot.equals[1]>:
                            - flag <Player> blueprint_y:-:0.1
                        - else:
                            - flag <Player> blueprint_y:+:0.1
                    - else if <context.new_slot> < <context.previous_slot>:
                        - flag <Player> blueprint_y:-:0.1
        on player scrolls their hotbar item:!item_display_editor_item flagged:item_display_editor.in_selection:
        - inject IDE_disable_selection
        on player quits flagged:item_display_editor.in_selection:
        - inject IDE_disable_selection
        on player drops item_display_editor_item:
        - if <player.item_in_offhand.material.name.equals[air].not>:
            # - if <player.has_permission[prime].not>:
            #     - stop
            - determine passively cancelled
            - define item <player.item_in_offhand>
            - if <[item]> matches *air:
                - stop
            - define location <player.eye_location.ray_trace[range=5].if_null[null]>
            - if <[location].find_entities[item_display|block_display|text_display].within[20].size> > 95:
                - narrate "<&color[#d64933]>Слишком много обьектов в радиусе 20 блоков (95 обьектов)"
                - determine cancelled
            - if <[location]> == null:
                - narrate "<&color[#d64933]>Вы не можете разместить обьект здесь."
                - determine cancelled
            - if <player.is_sneaking.not>:
                - spawn item_display_editor_entity[item=<[item].with[quantity=1]>] <[location]> save:entity
            - else:
                - spawn block_display_editor_entity[material=<[item].with[quantity=1].material.name>;translation=-0.5,-0.5,-0.5] <[location]> save:entity
                #- narrate <entry[entity].spawned_entity.material||null> == null
                - if <entry[entity].spawned_entity.item||null> == null && <entry[entity].spawned_entity.material||null> == null:
                    #- if <entry[entity].spawned_entity.material||null> == null:
                    - remove <entry[entity].spawned_entity>
                    - determine cancelled
            - if <player.gamemode> != creative:
                - take slot:41

            # - if <[item].material.name.advanced_matches[cake|*candle|*torch|chain|*bed|*dripstone|*bud|amethyst*|*coral*|*lantern*|flower_pot|bamboo|*fence|*gate|*button|*plate|*door|*wall|*bars|*pane].not>:
            #     - spawn item_display_editor_entity[item=<[item].with[quantity=1]>] <[location]> save:entity
            # - else:
            #     - spawn block_display_editor_entity[material=<[item].with[quantity=1].material.name>] <[location]> save:entity
            #- flag <entry[entity].spawned_entity> locked
            - flag <entry[entity].spawned_entity> owner:<player>
        - else:
            - inject IDE_disable_selection
blue_print:
    type: item
    material: writable_book
    debug: false
    mechanisms:
        custom_model_data: 1
    display name: <&color[#edf2f4]>Чертеж
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
                - glow_ink_sac|glowstone_dust|blue_dye
                - paper|material:writable_book|paper
                - air|diamond|air

item_display_editor_item:
    type: item
    material: debug_stick
    debug: false
    mechanisms:
        custom_model_data: 1
    display name: <&color[#edf2f4]>Разводной ключ
    lore:
    - <&6>(F)<&7> — <&a>Открыть окно редактирования
    - <&6>Левый клик<&7> — <&a>Применить эффект
    - <&6>Правый клик<&7> — <&a>Отменить эффект
    - <&6>(SHIFT + Q)<&7> — <&a>Разместить как БЛОК
    - <&6>(Q)<&7> — <&a>Разместить как ПРЕДМЕТ
    - <&6>Присед<&7> — <&a>Удваивает значение
    recipes:
        1:
            type: shaped
            output_quantity: 1
            input:
                - air|netherite_scrap|iron_ingot
                - copper_ingot|enchanted_book[enchantments=<map[SILK_TOUCH=1]>]|netherite_scrap
                - stick|copper_ingot|air

## Helper methods
IDE_open_inventory:
    type: task
    debug: false
    script:
    - define config <proc[IDE_get_player_config]>
    - define inventory <inventory[item_display_editor_gui]>
    - inventory adjust slot:28 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[config.size]>"

    - inventory adjust slot:34 destination:<[inventory]> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]><[config.type]>"

    - inventory adjust slot:9 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[config.light]>"
    - inventory adjust slot:8 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер<&co> <&color[#02A9EA]><[config.sky_light]>"
    - inventory adjust slot:29 destination:<[inventory]> "lore:<&color[#adb5bd]>Игнорировать блоки<&co> <&color[#02A9EA]><[config.blocks]>"
    - if <player.has_flag[item_display_editor.selected_display]>:
        - define display_item <player.flag[item_display_editor.selected_display]>
        - define data <[display_item].proc[IDE_get_data]>
        - inventory adjust slot:1 destination:<[inventory]> "lore:<&color[#adb5bd]>Трансформация<&co> <&color[#02A9EA]><[data.display]>"
        - inventory adjust slot:2 destination:<[inventory]> "lore:<&color[#adb5bd]>Биллборд<&co> <&color[#02A9EA]><[data.pivot]>"
        - inventory adjust slot:3 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по XL<&co> <&color[#02A9EA]><[data.transformation_left_rotation].x>"
        - inventory adjust slot:4 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по XR<&co> <&color[#02A9EA]><[data.transformation_right_rotation].x>"
        # - inventory adjust slot:8 destination:<[inventory]> "lore:<&color[#adb5bd]>Свечение<&co> <&color[#02A9EA]><[display_item].has_flag[item_display_editor.glowing]>"
        # - inventory adjust slot:9 destination:<[inventory]> "lore:<&color[#adb5bd]>Цвет свечения<&co> <&color[<[data.glow_color].if_null[white]>]>COLOR"
        - inventory adjust slot:12 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по YL<&co> <&color[#02A9EA]><[data.transformation_left_rotation].y>"
        - inventory adjust slot:13 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по YR<&co> <&color[#02A9EA]><[data.transformation_right_rotation].y>"
        - inventory adjust slot:16 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер по EW<&co> <&color[#02A9EA]><[data.scale].x>"
        - inventory adjust slot:17 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер по UD<&co> <&color[#02A9EA]><[data.scale].y>"
        - inventory adjust slot:18 destination:<[inventory]> "lore:<&color[#adb5bd]>Размер по NS<&co> <&color[#02A9EA]><[data.scale].z>"
        - inventory adjust slot:21 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по ZL<&co> <&color[#02A9EA]><[data.transformation_left_rotation].z>"
        - inventory adjust slot:22 destination:<[inventory]> "lore:<&color[#adb5bd]>Поворот по ZR<&co> <&color[#02A9EA]><[data.transformation_right_rotation].z>"
        - inventory adjust slot:25 destination:<[inventory]> "lore:<&color[#adb5bd]>Локация X<&co> <&color[#02A9EA]><[display_item].location.x.round_to[4]>"
        - inventory adjust slot:26 destination:<[inventory]> "lore:<&color[#adb5bd]>Локация Y<&co> <&color[#02A9EA]><[display_item].location.y.round_to[4]>"
        - inventory adjust slot:27 destination:<[inventory]> "lore:<&color[#adb5bd]>Локация Z<&co> <&color[#02A9EA]><[display_item].location.z.round_to[4]>"
        - inventory adjust slot:36 destination:<[inventory]> "lore:<&color[#adb5bd]>Заблокировано<&co> <&color[#02A9EA]><[display_item].has_flag[locked]>"
    - inventory open destination:<[inventory]>
IDE_disable_selection:
    type: task
    debug: false
    script:
    - if <player.has_flag[item_display_editor.selected_display]>:
        - if !<player.flag[item_display_editor.selected_display].has_flag[item_display_editor.glowing]>:
            - adjust <player.flag[item_display_editor.selected_display]> glowing:false
    - flag <player> item_display_editor.selected_display:!
    - flag <player> item_display_editor.in_selection:!
IDE_set_transformation_scale:
    type: task
    debug: false
    script:
    - define transformation_scale <[data.scale]>
    - if <[item_display].scale.x> > 2.52 && <[click_type]> == LEFT:
        - narrate "<&color[#d64933]>Нельзя сделать размер X больше 2.5."
        - determine cancelled
    - if <[item_display].scale.y> > 2.52 && <[click_type]> == LEFT:
        - narrate "<&color[#d64933]>Нельзя сделать размер Y больше 2.5."
        - determine cancelled
    - if <[item_display].scale.z> > 2.52 && <[click_type]> == LEFT:
        - narrate "<&color[#d64933]>Нельзя сделать размер Z больше 2.5."
        - determine cancelled

    - if <[item_display].scale.x.replace_text[-].with[]> > 2.6 && <[click_type]> == RIGHT:
        - narrate "<&color[#d64933]>Нельзя сделать размер X больше -2.5."
        - determine cancelled
    - if <[item_display].scale.y.replace_text[-].with[]> > 2.6 && <[click_type]> == RIGHT:
        - narrate "<&color[#d64933]>Нельзя сделать размер Y больше -2.5."
        - determine cancelled
    - if <[item_display].scale.z.replace_text[-].with[]> > 2.6 && <[click_type]> == RIGHT:
        - narrate "<&color[#d64933]>Нельзя сделать размер Z больше -2.5."
        - determine cancelled

    - adjust <[item_display]> scale:<[transformation_scale].add[<[vector]>]>
    - narrate "<&color[#63c132]>Размер трансформации был установлен: <&color[#02A9EA]><[item_display].scale>"
IDE_set_transformation_rotation:
    type: task
    debug: false
    definitions: item_display|data|axis|type|click_type
    script:
    - if <player.is_sneaking.not>:
        - if <[click_type]> == LEFT:
            - flag <[item_display]> item_display_editor.<[type]>.angle:+:5
        - else:
            - flag <[item_display]> item_display_editor.<[type]>.angle:-:5
    - else:
        - if <[click_type]> == LEFT:
            - flag <[item_display]> item_display_editor.<[type]>.angle:+:2.5
        - else:
            - flag <[item_display]> item_display_editor.<[type]>.angle:-:2.5
    #- narrate <[type]>
    - if <[type]> == transformation_left_rotation:
        - adjust <[item_display]> left_rotation:<[axis].proc[IDE_quaternion].context[<[item_display].flag[item_display_editor.<[type]>.angle]>]>
    - else:
        - adjust <[item_display]> right_rotation:<[axis].proc[IDE_quaternion].context[<[item_display].flag[item_display_editor.<[type]>.angle]>]>
IDE_set_location:
    type: task
    debug: false
    script:
    - teleport <[item_display]> <[item_display].location.add[<[vector]>].round_to_precision[0.03125]>
    - narrate "<&color[#63c132]>Локация обьекта была установлена на <&color[#02A9EA]><[item_display].location.format[sx sy sz world]>"
IDE_get_player_config:
    type: procedure
    debug: false
    script:
    - definemap config:
        size: 1
        light: 1
        sky_light: 1
        blocks: true
        type: поворот
    - foreach <[config]> key:key as:value:
        - define flag <player.flag[item_display_editor.config.<[key]>].if_null[null]>
        - if <[flag]> != null:
            - define config.<[key]> <[flag]>
    - determine <[config]>
IDE_get_data:
    type: procedure
    debug: false
    definitions: entity
    data:
        display: <[entity].display>
        pivot: <[entity].pivot>
        scale: <[entity].scale>
        glow_color: <[entity].glow_color.if_null[WHITE]>
        transformation_left_rotation: <[entity].left_rotation>
        transformation_right_rotation: <[entity].right_rotation>
    script:
    - determine <script.parsed_key[data]>
## Quaternion math.
IDE_quaternion:
    type: procedure
    debug: false
    definitions: axis|angle
    script:
    - define angle <[angle].to_radians>
    - define angle_div <[angle].div[2].sin>
    - define x <[axis].get[1].mul[<[angle_div]>]>
    - define y <[axis].get[2].mul[<[angle_div]>]>
    - define z <[axis].get[3].mul[<[angle_div]>]>
    - define w <[angle].div[2].cos>
    - define axis <[x]>,<[y]>,<[z]>,<[w]>
    - determine <[axis]>