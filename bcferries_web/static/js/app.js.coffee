FerryTime = angular.module 'FerryTime', ['ngMaterial', 'ngRoute']

FerryTime.controller 'RootCtrl', ['$scope', '$location', ($scope, $location) ->
  $scope.goHome = ->
    $location.path '/'
]

FerryTime.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/terminals',
    templateUrl: '/template/terminals'
    controller: 'TerminalsCtrl'
  .when '/terminal/:terminal',
    templateUrl: '/template/terminal'
    controller: 'TerminalCtrl'
  .when '/terminal/:terminal/route/:route',
    templateUrl: '/template/route'
    controller: 'RouteCtrl'
  .otherwise
    redirectTo: '/terminals'

]
