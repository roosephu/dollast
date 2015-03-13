app = angular.module 'dollast-msg-center', []

app.service 'msgCenter', ["$timeout",
  ($timeout) ->
    return center =
      load: (shared) ~>
        {@messages, @type} = shared
      push: (msg) ~>
        if @messages
          @messages.push msg
          $timeout ->
            center.sidebar msg
            func = -> center.shape 'flip right'
            $timeout func, 500
      shape: (dir) ~>
        console.log "shape", dir
        $ '.text.shape' .shape!
          ..shape dir
      sidebar: ~>
        $ '.sidebar'
          .sidebar 'setting', 'transition', 'overlay'
          .sidebar 'toggle'
]
