FerryTime.service 'API', [->
  getURL = (arr, prefix = 'api') ->
    "/#{prefix}/#{arr.join('/')}"

  API =
    get: (action, qs = {}) ->
      $.ajax
        type: 'GET'
        url: "#{getURL(action)}?#{$.param(qs)}"
        contentType: 'application/json'
        dataType: 'json'
    post: (action, data, qs = {}) ->
      $.ajax
        type: 'POST'
        url: "#{getURL(action)}?#{$.param(qs)}"
        data: JSON.stringify(data)
        contentType: 'application/json'
        dataType: 'json'
]
