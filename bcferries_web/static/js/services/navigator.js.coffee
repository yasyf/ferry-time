FerryTime.service 'Navigator', ['$window', '$location', ($window, $location) ->
  indicatorPresent = ->
    $('#navigator-indicator').css('display') is 'none'

  Navigator =
    go: (path) ->
      console.log indicatorPresent()
      if indicatorPresent()
        $window.location.href = path
      else
        $location.path path
]
