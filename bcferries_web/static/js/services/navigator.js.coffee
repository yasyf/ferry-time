FerryTime.service 'Navigator', ['$window', '$location', ($window, $location) ->
  indicatorPresent = ->
    $('#navigator-indicator').css('display') is 'none'

  Navigator =
    go: (path) ->
      path = path.replace(/\s/g, '-')
      if indicatorPresent()
        $window.location.href = path
      else
        $location.path path
]
