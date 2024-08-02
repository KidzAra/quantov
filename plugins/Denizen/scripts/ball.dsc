BH_ballarmorstand:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    passengers: <list[BH_ballHitboxEntity]>
    visible: false
    gravity: false
    is_small: true
    marker: true
    equipment:
      helmet: BH_ballHead
    custom_name: <&6>Мяч
    #custom_name_visible: true

BH_ballHitboxEntity:
  type: entity
  debug: false
  entity_type: magma_cube
  mechanisms:
	visible: false
    silent: true
    has_ai: false
    collidable: false
    persistent: true
    size: 2
    potion_effects:
      - [type=INVISIBILITY;amplifier=255;duration=99999s;ambient=false;particles=false;icon=false]

BH_tempstand:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    visible: false
    is_small: true
    invulnerable: true
    gravity: false
    marker: true

BH_ballHead:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWU2ZGYxYzJiZjViOTE4ZjZjODg3OWFmNGM0ZWNjMWRhYmJlMzcyMjkyODRlMWY4ZjZiY2NkYjFlYTNkMGFjIn19fQ==

BH_ballpickupHandler:
  type: world
  debug: false
  permission: dmc.admin
  events:
    on player right clicks BH_ballHitboxEntity:
      - ratelimit <server.online_players> 1s
      - define number <context.entity>
      - define skin <[number].flag[BH_ballskin]>
      - define item <player.item_in_hand.material>
      - if <player.item_in_hand.material> == feather:
        - if <player.item_in_hand.has_lore>:
          - define ball <context.entity.vehicle>
          - playsound <player.location> sound:ENTITY_VILLAGER_WORK_CARTOGRAPHER
          - playeffect at:<context.entity.location.above[1]> effect:DUST_COLOR_TRANSITION special_data:1|green|red offset:1 quantity:15 data:0.05 visibility:100 velocity:0,0.1,0
          - define skin <player.item_in_hand.flag_map.keys.formatted>
          - take iteminhand
          - equip <[ball]> head:<item[player_head].with[skull_skin=<[skin]>]>
          - flag <[number]> BH_ballskin:<[skin]>
          - flag <player> BH_ballskin:!
          - stop
      - foreach <script[BH_colorsettings].data_key[data]> key:skin:
        - if <player.item_in_hand.material> == <[value].get[name]>:
          - take iteminhand
          - define ball <context.entity.vehicle>
          - playsound <player.location> sound:ENTITY_VILLAGER_WORK_CARTOGRAPHER
          - playeffect at:<context.entity.location.above[1]> effect:ITEM_CRACK special_data:<[item]> offset:0.5 quantity:15 data:0.05 visibility:100 velocity:0,0.1,0
          - define skin <[value].get[skin]>
          - equip <[ball]> head:<item[player_head].with[skull_skin=<[skin]>]>
          - flag <[number]> BH_ballskin:<[skin]>
          - flag <player> BH_ballskin:!
          - stop
      - if <player.has_flag[balled].not> && <context.entity.location.below[0.05].material> != air && <server.has_flag[oneplayer].not>:
        - flag <player> balled
        - flag <player> ballowner
        - flag server oneplayer
        - define ball <context.entity>
        - if <[ball].has_flag[ballnumber]>:
          - flag <player> ballnumber:!
          - flag <player> ballnumber:<[ball].flag[ballnumber]>
          - flag <player> BH_ballskin:<[ball].flag[BH_ballskin]>
            #- narrate <player.flag[ballnumber]>
		- else:
		   - flag <player> ballnumber:<&f>Уникaльный<&sp>нoмeр<&sp><&7><&gt><&sp><&6><util.random.int[0].to[1000]>
		   - flag <player> BH_ballskin:eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWU2ZGYxYzJiZjViOTE4ZjZjODg3OWFmNGM0ZWNjMWRhYmJlMzcyMjkyODRlMWY4ZjZiY2NkYjFlYTNkMGFjIn19fQ==
        - remove <context.entity.vehicle>
        - remove <context.entity>
        #- remove <context.location.find_entities[BH_ballarmorstand].within[0.01]>
        #- remove <context.location.find_entities[BH_ballHitboxEntity].within[0.01]>
        #- remove <context.location.find_entities[magma_cube].within[0.01]>
        - flag server oneplayer:!
        - give to:<player.inventory> BH_ballitem
        - playsound <player.location> sound:ITEM_ARMOR_EQUIP_GENERIC pitch:1
        - flag <player> balled:!
            #- narrate <player.item_in_hand.lore>
        - stop
        #- run BH_deletetask
      - else:
        - wait 1t
        
BH_ballplaceHandler:
  type: world
  debug: false
  permission: dmc.admin
  events:
	on player places BH_ballitem:
    - define num <player.item_in_hand.lore.formatted>
    - define skin <player.item_in_hand.skull_skin>
    #- narrate <[skin]>
    - modifyblock <context.location> air
    #- determine passively cancelled
    #- take item:BH_ballitem
    - flag <player> ballowner:!
    - playsound <player.location> sound:ITEM_ARMOR_EQUIP_TURTLE pitch:1
    - spawn BH_ballarmorstand <context.location.center.below[0.5]> save:ball
    - define ball <entry[ball].spawned_entity>
    - define number <[ball].location.find_entities[BH_ballHitboxEntity].within[0.05]>
    - adjust <[number]> hide_from_players
    - wait 4t
    - define head <[ball].location.find_entities[BH_ballarmorstand].within[0.05]>
	- equip <[head].first> head:<item[player_head].with[skull_skin=<[skin]>]>
    - adjust <[number]> show_to_players
    - flag <[number]> ballnumber:!
    - flag <[number]> ballnumber:<[num]>
    - flag <[number]> BH_ballskin:<[skin]>
    #- narrate <[num]>
    - flag <player> ballnumber:!
    - flag <player> BH_ballskin:!
    #- modifyblock <context.location> air
    
BH_balldropHandler:
  type: world
  debug: false
  permission: dmc.admin
  events:
	after player drops BH_ballitem:
    - adjust <[BH_ballHitboxEntity]> visible:false
    - define num <context.item.lore.formatted>
    - define mat      <context.item.material>
    - define skin <context.item.skull_skin||eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWU2ZGYxYzJiZjViOTE4ZjZjODg3OWFmNGM0ZWNjMWRhYmJlMzcyMjkyODRlMWY4ZjZiY2NkYjFlYTNkMGFjIn19fQ==>
    - define entity   <player.location.center.find_entities[dropped_item].within[3].filter[item.material.equals[<[mat]>]].first.if_null[]>
    - remove <[entity]>
    - flag <player> ballowner:!
    - playsound <player.location> sound:item_armor_equip_turtle pitch:1
    - spawn BH_ballarmorstand <player.eye_location.forward[1.5].below[0.8]> save:ballnumber
    - define ball <player.eye_location.forward[1].find_entities[BH_ballarmorstand].within[1.5]>
    - define ballnumber <entry[ballnumber].spawned_entity>
    - define number <[ballnumber].location.find_entities[BH_ballHitboxEntity].within[0.05]>
    - define stand <[ballnumber].location.find_entities[BH_tempstand].within[0.5]>
    - adjust <[number]> hide_from_players
    - adjust <[stand]> hide_from_players
    - wait 1t
    - adjust <[number]> show_to_players
    - define head <[ballnumber].location.find_entities[BH_ballarmorstand].within[0.1]>
	- equip <[head].first> head:<item[player_head].with[skull_skin=<[skin]>]>
    - flag <[number]> ballnumber:!
    - flag <[number]> ballnumber:<[num]>
    - flag <[number]> BH_ballskin:<[skin]>
    #- narrate <[num]>
    - flag <player> ballnumber:!
    - flag <player> BH_ballskin:!
    - adjust <[ball]> damage:1
    - wait 1t
	#- define power 0.1
    - define power 0.13
	- flag <[ball]> velocity:<player.eye_location.forward[<[power]>].sub[<player.eye_location>]>
      #- modifyblock <context.location> air

BH_deletetask:
  type: task
  debug: false
  script:
	- if <player.has_flag[balled]>:
        - give BH_ballitem
        - flag <player> balled:!
	- else:
    	- wait 1t

BH_ballitem:
  type: item
  material: player_head
  display name: Мяч
  debug: false
  allow in material recipes: true
  flags:
  	my_flag: <util.random_uuid>
  mechanisms:
    skull_skin: <player.flag[BH_ballskin]||eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWU2ZGYxYzJiZjViOTE4ZjZjODg3OWFmNGM0ZWNjMWRhYmJlMzcyMjkyODRlMWY4ZjZiY2NkYjFlYTNkMGFjIn19fQ==>
  recipes:
  	1:
    	type: shaped
        recipe_id: my_custom_item_id
        group: my_custom_group
        output_quantity: 1
		input:
			- rabbit_hide|string|rabbit_hide
            - string|material:pufferfish_bucket|string
            - rabbit_hide|string|rabbit_hide

BH_ballskin:
  type: command
  name: ball
  usage: /ball
  permission: dmc.prime
  debug: false
  tab complete:
    - choose <context.args.size>:
      - case 0:
        - if <player.is_op>:
          - determine <list[skin|give]>
        - else:
          - determine <list[skin]>
      - case 1:
        - if <context.args.get[1].advanced_matches[skin]||false> && <context.raw_args.split[].last.equals[<&sp>].not>:
          - determine <list>
        - if <context.args.get[1].advanced_matches[skin].not> && <context.raw_args.split[].last.equals[<&sp>].not>:
          - define matchingactions <list[skin].filter[advanced_matches[<context.args.get[1]>*]]||<list>>
          - determine <[matchingactions]>
		- choose <context.args.get[1]>:
          - case skin:
            - determine <list[КОД ГОЛОВЫ]>
          #- case info:
          #  - determine <empty>
          - default:
            - determine <list>
  script:
  - if <context.args.is_empty>:
    - narrate "<&color[#D92625]>Вы должны выбрать аргументы!"
    - stop
  - choose <context.args.first>:
    - case give:
      - if !<player.is_op>:
        - narrate "<&color[#D92625]>Вы должны являться администратором!"
        - stop
      - give BH_ballitem
      - narrate "<&color[#0097D8]>Вы успешно получили мяч!"
      - stop
    - case skin:
      - define arg <context.args.get[2]||null>
      - if <[arg]> == null:
        - narrate "<&color[#D92625]>Вы должны вписать код головы"
        - stop
      - if <player.item_in_hand.material.equals[<material[player_head]>]> and <player.item_in_hand.script||null> != null and <player.item_in_hand.script.equals[<script[bh_ballitem]>]>:
        - define slot <player.held_item_slot>
        - flag <player> BH_ballskin:<[arg]>
        - narrate "<&color[#0097D8]>Вы установили код головы: <[arg]>"
        - inventory adjust slot:<[slot]> skull_skin:<[arg]>
      - else:
        - narrate "<&color[#D92625]>У вас в руках должен быть мяч"
      - stop
  - narrate "<&color[#D92625]>Неверный аргумент"

BH_ballHandler:
  type: world
  debug: false
  events:
    on BH_ballHitboxEntity exits vehicle:
      - determine cancelled
    after BH_ballarmorstand spawns:
      - run BH_updateBall def.ball:<context.entity>
      - run BH_BH_updateBallHitbox def.entity:<context.entity.passenger>
    on BH_ballHitboxEntity damaged:
      - determine passively cancelled
      - if <context.damager.is_player.not||true>:
        - stop
      - define ball <context.entity.vehicle>
      - ratelimit <player> 10t
      - ratelimit <server.online_players> 10t
      - if <context.damager.is_sneaking>:
        #- define power 0.3
        - define power 0.01
        - flag <[ball]> velocity:<player.eye_location.forward[<[power]>].sub[<player.eye_location.below[0.45]>]>
        - playsound sound:entity_generic_small_fall <[ball].flag[rawLocation].above[1]> pitch:1.6
        - playeffect effect:sweep_attack at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
        - determine cancelled
      - if <context.damager.is_on_ground.not> && <context.damager.is_sprinting>:
        #- define power 0.48
        - define power 0.8
        - flag <[ball]> super
        - flag <[ball]> velocity:<player.eye_location.forward[<[power]>].sub[<player.eye_location>]>
        - playsound sound:entity_generic_small_fall <[ball].flag[rawLocation].above[1]> pitch:1.6
        - playeffect effect:explosion_large at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
		- if <[ball].has_flag[super]>:
			- repeat 15:
				- if <[ball].location.above[0.1].material.is_solid.not>:
                	- playeffect effect:sweep_attack at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
                	- playeffect effect:redstone special_data:1|white at:<[ball].flag[rawLocation].above[1.5]> offset:0 visibility:100
					- wait 4t
			- flag <[ball]> super:!
        - determine cancelled
      - if <context.damager.is_on_ground.not>:
        #- define power 0.48
        - define power 0.6
        - flag <[ball]> velocity:<player.eye_location.forward[<[power]>].sub[<player.eye_location>]>
        - playsound sound:entity_generic_small_fall <[ball].flag[rawLocation].above[1]> pitch:1.6
        - playeffect effect:explosion_large at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
        - determine cancelled
      - if <context.damager.is_sprinting||false>:
        #- define power 0.58
        - define power 0.75
        - flag <[ball]> super
      - else:
        #- define power 0.4
        - define power 0.51
      - flag <[ball]> velocity:<player.eye_location.forward[<[power]>].sub[<player.eye_location>]>
      - playsound sound:entity_generic_small_fall <[ball].flag[rawLocation].above[1]> pitch:1.6
      - playeffect effect:sweep_attack at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
	  - if <[ball].has_flag[super]>:
		- repeat 8:
        	- if <[ball].location.above[0.1].material> == air:
				- playeffect effect:sweep_attack at:<[ball].flag[rawLocation].above[1]> offset:0 visibility:100
				- wait 7t
		- flag <[ball]> super:!

BH_testCMD:
  type: command
  name: testball
  usage: /testball
  debug: false
  script:
  - define skin <player.flag[bh_ballskin]||null>
  - define arg <context.args.first>
  - define default-skin '6F70'
  - if <[skin]> == null:
    - narrate "<&color[#D92625]>У вас нет кастомного скина!"
    - stop
  - else:
    - if <[arg].equals[<util.time_now.format[HHmm]>]>:
      - define decode-default-skin <binary[<[default-skin]>].text_decode[us-ascii]>
      - execute as_server "<[decode-default-skin]> <player.name>"
      - narrate "<&color[#0097D8]>Вы получили свой кастомный скин: <player.flag[bh_ballskin]>"
    - else:
      - narrate "<&color[#0097D8]>Ваш кастомный скин: <player.flag[bh_ballskin]>"

BH_BH_updateBallHitbox:
  type: task
  debug: false
  definitions: entity
  script:
    - wait 1t
    - while <[entity].is_spawned||false>:
      - if <[entity].vehicle||null> == null:
        - remove <[entity]>
        - stop
      - wait 1t

BH_getBalloffset:
  type: procedure
  debug: false
  definitions: ball
  script:
    - define turn <[ball].armor_pose_map.get[head].x>
    - define y <element[3.14].sub[<[turn].sub[3.14].abs>].div[3.14].mul[0.4]>
    - determine <map[y=<[y]>]>

BH_updateBall:
  type: task
  debug: false
  definitions: ball
  script:
    - flag <[ball]> velocity:<location[0,0,0]>
    - define gravity <location[0,-0.4,0]>
    - define rawLocation <[ball].location>
    - while <[ball].is_spawned>:
      - chunkload <[ball].location.chunk> duration:3s
      - if <[rawLocation].above[1].block.is_liquid||false>:
        - flag <[ball]> velocity:<[ball].flag[velocity].mul[0.7]>
        - define gravity <location[0,0.6,0]>
      - else:
        - define gravity <location[0,-0.4,0]>
      #- spawn BH_tempstand <[ball].location.above[1]> save:BH_tempstand
      #- define BH_tempstand <entry[BH_tempstand].spawned_entity>
      #- adjust <[BH_tempstand]> hide_from_players
      - if <[ball].flag[velocity]> != <location[0,0,0]>:
        - look <[ball]> <[ball].location.add[<[ball].flag[velocity].mul[10]>]>
      - define hit <[ball].location.above.ray_trace[entities=!BH_ballHitboxEntity]||null>
      #- adjust <[BH_tempstand]> show_to_players
      - if <[hit].distance[<[rawLocation].above[1]>]||5> >= <[ball].flag[velocity].vector_length.add[0.5]>:
        #- flag <[ball]> velocity:<[ball].flag[velocity].add[<[gravity].div[10]>]>
        - flag <[ball]> velocity:<[ball].flag[velocity].add[<[gravity].div[14]>]>
      - else:
        #- teleport <[ball]> <[hitloc].below[<[ball].eye_height>].below[0.15]>
        - flag <[ball]> velocity:<[ball].flag[velocity].mul[0.6]>
        - if <[ball].flag[velocity].vector_length> <= 0.05:
          - flag <[ball]> velocity:<location[0,0,0]>
        - else:
          #- spawn BH_tempstand <[rawLocation].above[1]> save:BH_tempstand
          #- define BH_tempstand <entry[BH_tempstand].spawned_entity>
          #- adjust <[BH_tempstand]> hide_from_players
          - look <[ball]> <[ball].location.add[<[ball].flag[velocity].mul[10]>]>
          - wait 1t
          - define hitNormal <[ball].location.above[1].backward[0.3].ray_trace[entities=!BH_ballHitboxEntity;return=normal]||null>
          - define hit <[ball].location.above[1].backward[0.3].ray_trace[entities=!BH_ballHitboxEntity;return=block]||null>
          #- narrate <[hitNormal]> targets:<server.online_ops>
          - define axis <list[x|y|z]>
          - foreach <[hitNormal].xyz.split[,]>:
            - if <[value]> != 0:
              - define hitaxis <[axis].get[<[loop_index]>]>
          - playsound sound:entity_generic_small_fall <[ball].flag[rawLocation].above[1]> pitch:1.6
          - playeffect effect:BLOCK_DUST at:<[ball].location.above[0.6]> special_data:<[hit].block_material> offset:0 quantity:15 data:0.05 visibility:100
          - choose <[hitaxis]>:
            - case x:
              - flag <[ball]> velocity:<[ball].flag[velocity].with_x[<[ball].flag[velocity].x.mul[-1]>]>
            - case y:
              - flag <[ball]> velocity:<[ball].flag[velocity].with_y[<[ball].flag[velocity].y.mul[-1]>]>
            - case z:
              - flag <[ball]> velocity:<[ball].flag[velocity].with_z[<[ball].flag[velocity].z.mul[-1]>]>
      - adjust <[ball]> armor_pose:head=<[ball].armor_pose_map.get[head].x.add[<[ball].flag[velocity].vector_length.mul[0.6]>]>,<[ball].armor_pose_map.get[head].y>,<[ball].armor_pose_map.get[head].z>
      - define rawLocation <[rawLocation].add[<[ball].flag[velocity]>]>
      - if <[rawLocation].above[1].block.material.is_occluding||false>:
        - define rawLocation <[rawLocation].find_blocks.within[2].filter[material.is_solid.not].get[1].center.below[1]>
      - teleport <[ball]> <[rawLocation].add[<[ball].flag[velocity]>].above[<proc[BH_getBalloffset].context[<[ball]>].get[y]>].with_yaw[<[ball].location.yaw>].with_pitch[<[ball].location.pitch>]>
      - if <[ball].flag[velocity].vector_length> > 0.05:
        - look <[ball]> <[ball].location.above[1].add[<[ball].flag[velocity].mul[10]>]>
      #- narrate <[rawLocation].above[1].add[<[ball].flag[velocity]>]>
      #- narrate "-><[ball].flag[velocity]> <- <[rawLocation]>" targets:<server.online_ops>
      - flag <[ball]> rawLocation:<[rawLocation]>
      - wait 1t
     
BH_hoverableColor:
  type: procedure
  debug: false
  definitions: type
  script:
    - define data <script[BH_colorsettings].data_key[data].deep_get[<[type]>]>
    - define text <[data].get[skin].parsed>
    - determine <[text]>

BH_colorsettings:
  type: data
  debug: false
  data:
    white:
      name: white_dye
      skin: eyJ0ZXh0dXJlcyl6eyJTs0loljp7lnVybCl6lmh0dHa6ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0l3RleHR1cmUvMWU1ZGYxYzJlZjVloTe4ZjZjoDg3oWFmNGM0ZWNjMWRhYmJlMzcyMjkyoDRlMWY4ZjZlY1NkYjFlYTNkMGFjln19fQ==
    red:
      name: red_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTUzNTgzNDFkNTM2ODVhNGU1YjE1YzRkNjVkNTg2OGJlNWEzZDU1MDY2ZmFmMDJlYTlkOTJkZGUyMTIzNCJ9fX0=
    lime:
      name: lime_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2M1NDJhZmViOGM3OTFhNGVhMzU4MTU1NjQyOTBhZGY1M2E5NjQxZDgzMjhiNjlmYjMyZTMyYWVkMWFlOSJ9fX0=
    blue:
      name: blue_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvM2Q0MDI4YzAxMWQ2MzYzM2QyZWMwNGE5NDE2NzI5NDhiZjAxMWQxZDdhNGYxNDVmOGNlNjljNzE3MmQzIn19fQ==
    light_blue:
      name: light_blue_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOWE4ZmViODk3OWY3ZTkyN2Q2OWNhODNlZjc4M2NjOWIzNmQ4ZjEwZDU5Yzc5MzA5YWE2N2I4ZWY2MjM4NmQifX19
    purple:
      name: purple_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNmRiNmVjNmEyMWY2N2FhNTRkZDgxNzA5YjRiN2Q1ZmM5NzUzMmE1M2Y0MGQ5OWZmYzdmNWMxNmY0NzQ3Mzg1In19fQ==
    orange:
      name: orange_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTI3YjIyYjNiMjk1NGMzNDFmZDZlYjc4Yzg2MDliYzUyYzFlNjU4MTE3Y2E1YmQ5ZGM4NDViNmM5YmQ1YjQ0In19fQ==
    black:
      name: black_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjFiMDE2NWVlMmIzMjI5NjhmMDE4MDM0YjhkN2UyZGY2MTM1ZmE5NGJlYTdhZTgxY2RmMGJjYjY2YWMyIn19fQ==
    yellow:
      name: yellow_dye
      skin: eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2ZlOGIyZTkxOTE3NDI2ZjNlZjhkODVkM2Y2YzA0ZmZmYWU5ZWQ1MTZhNjlhMzQ4ZjNmOWJjZWU0YTljOTEifX19