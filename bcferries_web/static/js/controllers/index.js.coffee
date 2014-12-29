FerryTime.controller 'IndexCtrl', ['$scope', 'API', '$q', '$timeout', ($scope, API, $q, $timeout) ->
  $scope.terminals = []
  $scope.loadingStages = []

  API.get(['all']).then (response) ->
    terminals = response.all.terminals
    $scope.loadingStages = _.times terminals.length, -> 1
    $scope.terminals = terminals
    _.forEach terminals, (terminal, i) ->
      API.get(['terminal', terminal.name])
      .then (response) ->
        $timeout ->
          $scope.terminals[i] = response.terminal
          $scope.loadingStages[i] = 2

  $scope.joinRoutes = (terminal) ->
    routes = _.pluck terminal.routes, 'name'
    routes.join(' | ')
]
