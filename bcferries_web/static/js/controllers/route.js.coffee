FerryTime.controller 'RouteCtrl', ['$scope', 'API', '$q', '$timeout', '$location', '$routeParams', '$rootScope'
 ($scope, API, $q, $timeout, $location, $routeParams, $rootScope) ->

  $rootScope.title = $routeParams.route

  $scope.terminal =
    name: $routeParams.terminal
  $scope.route =
    name: $routeParams.route
  $scope.crossings = []
  $scope.schedule = []
  $scope.crossingloadingStages = []
  $scope.scheduledloadingStages = []
  $scope.selected = 0

  API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name]).then (response) ->
    crossings = response.route.crossings
    schedule = response.route.schedule
    $timeout ->
      $scope.route = response.route
      $scope.crossingloadingStages = _.times crossings.length, -> 1
      $scope.scheduledloadingStages = _.times schedule.length, -> 1
      $scope.crossings = crossings
      $scope.schedule = schedule
    _.forEach crossings, (crossing, i) ->
      API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name, 'crossing', crossing.name])
      .then (response) ->
        $timeout ->
          $scope.crossings[i] = response.crossing
          $scope.crossingloadingStages[i] = 2
    _.forEach schedule, (scheduled, i) ->
      API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name, 'scheduled', scheduled.name])
      .then (response) ->
        $timeout ->
          $scope.schedule[i] = response.scheduled
          $scope.scheduledloadingStages[i] = 2

  $scope.toggle = ->
    $scope.selected ^= 1

  $scope.formatTime = (timeString) ->
    moment(timeString).format('h:mm A')

  $scope.arrivalTime = (scheduled) ->
    if $scope.isOffTime(scheduled)
      $scope.formatTime(scheduled.arrival)
    else
      arrival = moment(scheduled.scheduled_departure).add(scheduled.sailing_time, 'seconds')
      $scope.formatTime(arrival)

  $scope.isOffTime = (scheduled) ->
    return false unless scheduled.actual_departure?
    moment(scheduled.actual_departure) != moment(scheduled.scheduled_departure)

  $scope.isEarly = (scheduled) ->
    moment(scheduled.actual_departure) < moment(scheduled.scheduled_departure)

  $scope.diffMinutes = (scheduled) ->
    if $scope.isEarly(scheduled)
      moment(scheduled.scheduled_departure).diff(moment(scheduled.actual_departure), 'minutes')
    else
      moment(scheduled.actual_departure).diff(moment(scheduled.scheduled_departure), 'minutes')
]
