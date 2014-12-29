FerryTime.controller 'TerminalCtrl', ['$scope', 'API', '$q', '$timeout', '$location', '$routeParams', '$rootScope',
 ($scope, API, $q, $timeout, $location, $routeParams, $rootScope) ->

  $rootScope.title = $routeParams.terminal

  $scope.terminal =
    name: $routeParams.terminal
  $scope.routes = []
  $scope.loadingStages = []

  API.get(['terminal', $scope.terminal.name]).then (response) ->
    routes = response.terminal.routes
    $timeout ->
      $scope.terminal = response.terminal
      $scope.loadingStages = _.times routes.length, -> 1
      $scope.routes = routes
    _.forEach routes, (route, i) ->
      API.get(['terminal', $scope.terminal.name, 'route', route.name])
      .then (response) ->
        $timeout ->
          $scope.routes[i] = response.route
          $scope.loadingStages[i] = 2

  $scope.earliestCrossingTime = (route) ->
    crossingTimes = _.map route.crossings, (crossing) -> moment(crossing.name, "h:mma")
    crossing = _.min crossingTimes
    crossing.format('h:mm A')

  $scope.sailingsLeftToday = (route) ->
    sailings = _.filter route.schedule, (scheduled) -> moment(scheduled.name, "h:mma") > moment()
    sailings.length

  $scope.goTo = (route) ->
    $location.path "/terminal/#{$scope.terminal.name}/route/#{route.name}"
]
