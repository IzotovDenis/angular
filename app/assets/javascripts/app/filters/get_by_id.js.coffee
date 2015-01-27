app.filter "getById", ->
  (input, kod) ->
    i = 0
    len = input.length
    while i < len
      return input[i]  if +input[i].kod is +kod
      i++
    null