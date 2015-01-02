FerryTime.service 'Navigator', ['$window', '$location', '$timeout', ($window, $location, $timeout) ->
  init = false
  $timeout ->
    init = true
  , 1000

  indicatorPresent = ->
    !init or $('#navigator-indicator').css('display') is 'none'

  Navigator =
    go: (path) ->
      path = path.replace(/\s/g, '-')
      if indicatorPresent()
        $window.location.href = path
      else
        $location.path path
]
