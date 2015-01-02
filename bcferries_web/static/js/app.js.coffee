FerryTime = angular.module 'FerryTime', ['ngMaterial', 'ngRoute', 'ui.mask']

FerryTime.controller 'RootCtrl', ['$scope', 'Navigator', '$window', '$timeout',
 ($scope, Navigator, $window, $timeout) ->
  $scope.goHome = ->
    Navigator.go '/'
  $scope.ready = ->
    $timeout ->
      $window.prerenderReady = true
      $window.onCaptureReady() if $window.onCaptureReady
    , 1000
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
