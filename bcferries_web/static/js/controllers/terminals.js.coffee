FerryTime.controller 'TerminalsCtrl', ['$scope', 'API', '$q', '$timeout', '$location',
 ($scope, API, $q, $timeout, $location) ->

  $scope.terminals = []
  $scope.loadingStages = []

  API.get(['all']).then (response) ->
    terminals = response.all.terminals
    $timeout ->
      $scope.loadingStages = _.times terminals.length, -> 1
      $scope.terminals = terminals
    _.forEach terminals, (terminal, i) ->
      API.get(['terminal', terminal.name])
      .then (response) ->
        $timeout ->
          $scope.terminals[i] = response.terminal
          $scope.loadingStages[i] = 2

  navigator.geolocation.getCurrentPosition (position) ->
    latLon = "#{position.coords.latitude}, #{position.coords.longitude}"
    API.get ['nearest_terminal'],
      location: latLon
    .then (response) ->
      $timeout ->
        $scope.nearestTerminal = response.nearest_terminal.name

  $scope.joinRoutes = (terminal) ->
    routes = _.pluck terminal.routes, 'name'
    routes.join(' | ')

  $scope.goTo = (terminal) ->
    $location.path "/terminal/#{terminal.name}"
]
