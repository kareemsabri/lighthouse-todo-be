

module.exports = (promise) ->
  return promise.catch (err) ->
    console.log err
