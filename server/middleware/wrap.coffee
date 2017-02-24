

module.exports = (controller) ->

  (req, res, next) ->

    try
      result = controller arguments...
      result
        .then (data) ->
          res.send data
        .catch (err) ->
          next err, req, res
    catch err
      next err, req, res
