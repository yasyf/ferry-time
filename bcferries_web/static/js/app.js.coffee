FerryTime = angular.module 'FerryTime', ['ngMaterial', 'ngRoute']

FerryTime.controller 'RootCtrl', ['$scope', ($scope) ->
]

FerryTime.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/terminals',
    templateUrl: '/template/terminals'
    controller: 'TerminalsCtrl'
  .when '/terminal/:terminal',
    templateUrl: '/template/terminal'
    controller: 'TerminalCtrl'
  .otherwise
    redirectTo: '/terminals'

]
