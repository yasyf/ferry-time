FerryTime.controller 'IndexCtrl', ['$scope', 'API', ($scope, API) ->
  $scope.items = [
    heading: 'Hello World!'
    subheading: 'This is a test'
    content: 'Lorem ipsum...'
  ]
  API.get(['terminal', 'Horseshoe Bay', 'route', 'Horseshoe Bay to Departure Bay', 'scheduled', '6:30 PM'])
  .then (response) ->
    console.log response
]
