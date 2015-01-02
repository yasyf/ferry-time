FerryTime.controller 'RouteCtrl', ['$scope', 'API', '$q', '$timeout',
 'Navigator', '$routeParams', '$rootScope', 'tab', '$mdDialog',
 ($scope, API, $q, $timeout, Navigator, $routeParams, $rootScope, tab, $mdDialog) ->

  $scope.terminal =
    name: $routeParams.terminal.replace(/-/g, ' ')
  $scope.route =
    name: $routeParams.route.replace(/-/g, ' ')
  $rootScope.title = $scope.route.name
  $scope.crossings = []
  $scope.schedule = []
  $scope.crossingloadingStages = []
  $scope.scheduledloadingStages = []
  $scope.selected = tab

  API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name]).then (response) ->
    crossings = response.route.crossings
    schedule = response.route.schedule
    $timeout ->
      $scope.route = response.route
      $scope.crossingloadingStages = _.times Math.max(1, crossings.length), -> 1
      $scope.scheduledloadingStages = _.times Math.max(1, schedule.length), -> 1
      $scope.crossings = crossings
      $scope.schedule = schedule
    crossingPromises = _.map crossings, (crossing, i) ->
      API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name, 'crossing', crossing.name])
      .then (response) ->
        $timeout ->
          $scope.crossings[i] = response.crossing
          $scope.crossingloadingStages[i] = 2
    schedulePromises = _.map schedule, (scheduled, i) ->
      API.get(['terminal', $scope.terminal.name, 'route', $scope.route.name, 'scheduled', scheduled.name])
      .then (response) ->
        $timeout ->
          $scope.schedule[i] = response.scheduled
          $scope.scheduledloadingStages[i] = 2

    $q.all(crossingPromises.concat schedulePromises).then -> $scope.ready()

  $scope.toggleLink = (tab) ->
    if tab is 0
      "/terminal/#{$scope.terminal.name}/route/#{$scope.route.name}/departures"
    else
      "/terminal/#{$scope.terminal.name}/route/#{$scope.route.name}/schedule"

  $scope.toggle = ->
    Navigator.go $scope.toggleLink($scope.selected^0)

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
    $scope.diffMinutes(scheduled) > 0

  $scope.isEarly = (scheduled) ->
    moment(scheduled.actual_departure) < moment(scheduled.scheduled_departure)

  $scope.isDeparted = (sailing) ->
    time = sailing.time or sailing.actual_departure or sailing.scheduled_departure
    moment(time).add(20, 'minutes') < moment()

  $scope.diffMinutes = (scheduled) ->
    if $scope.isEarly(scheduled)
      moment(scheduled.scheduled_departure).diff(moment(scheduled.actual_departure), 'minutes')
    else
      moment(scheduled.actual_departure).diff(moment(scheduled.scheduled_departure), 'minutes')

  $scope.subscribeSMS = (ev, sailing) ->
    $mdDialog.show
      templateUrl: '/template/sms'
      targetEvent: ev
      controller: 'SMSCtrl'
      locals:
        terminal: $scope.terminal
        route: $scope.route
        sailing: sailing
]
