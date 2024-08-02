video:
  type: command
  description: penius
  name: stream
  usage: /stream [args]
  permission: dmc.streamer
  tab complete:
    - definemap completion_tree:
        link: <&lb>Ссылка на стрим<&rb>
    - determine <proc[generateTabCompletion].context[<[completion_tree].escaped>|<context.args.escaped>|<context.raw_args>]>
  script:
    - choose <context.args.get[1]||null>:
      - case link:
        - define link <context.args.get[2]||null>
        - if <[link].equals[null]>:
          - narrate '<&c>Укажите ссылку на видео!'
          - stop
        - ~webget <[link]> save:result
        - if <entry[result].failed>:
          - narrate '<&c>Ссылка неверная!'
          - stop
        - if <[link].advanced_matches[https://www.twitch.tv/*|http://www.twitch.tv/*|https://www.youtube.com/*|http://www.youtube.com/*|https://youtu.be/*|http://youtu.be/*].not||true>:
          - narrate '<&c>Ссылка не ведет на твитч или ютуб!'
          - stop
        - flag <player> stream_link:<[link]>
        - narrate '<&6>✔ <&a>Ссылка на ваш канал была установлена!'
        - flag server is_streaming.<player.name>:!
        - group remove streaming
        - narrate '<&c>⏺ <&6><player.name><&f> запустил стрим — <&color[#c4302b]><player.flag[stream_link].on_hover[<&7>Нажмите, чтобы открыть]>' targets:<server.online_players.exclude[<server.online_players.filter[flag[chatsetting.stream].equals[off]]>].exclude[<player>]>