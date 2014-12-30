FerryTime = angular.module 'FerryTime', ['ngMaterial', 'ngRoute']

FerryTime.controller 'RootCtrl', ['$scope', '$location', ($scope, $location) ->
  $scope.goHome = ->
    $location.path '/'
  $scope.ready = ->
    window.prerenderReady = true
]

FerryTime.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/terminals',
    templateUrl: '/template/terminals'
    controller: 'TerminalsCtrl'
  .when '/terminal/:terminal',
    templateUrl: '/template/terminal'
    controller: 'TerminalCtrl'
  .when '/terminal/:terminal/route/:route/departures',
    templateUrl: '/template/route'
    controller: 'RouteCtrl'
    resolve:
      tab: -> 0
  .when '/terminal/:terminal/route/:route/schedule',
    templateUrl: '/template/route'
    controller: 'RouteCtrl'
    resolve:
      tab: -> 1
  .otherwise
    redirectTo: '/terminals'

  $locationProvider
  .html5Mode(true)
  .hashPrefix('!')

]
