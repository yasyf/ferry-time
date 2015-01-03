FerryTime.controller 'SMSCtrl', ['$scope', '$mdDialog', '$timeout', 'terminal', 'route', 'sailing', 'API',
 ($scope, $mdDialog, $timeout, terminal, route, sailing, API) ->

  $scope.terminal = terminal
  $scope.route = route
  $scope.time = moment(sailing.time or sailing.scheduled_departure).format('h:mm A')
  $scope.template = 'form.html'
  $scope.data =
    number: localStorage.getItem('number')

  $scope.submit = ->
    $scope.template = 'pending.html'
    localStorage.setItem('number', $scope.data.number)
    API.post ['terminal', terminal.name, 'route', route.name, 'subscribe', $scope.time],
      number: $scope.data.number
    .then (response) ->
      $timeout -> $scope.template = 'success.html'
      $timeout ->
        $mdDialog.hide response.inserted
      , 1000
]
