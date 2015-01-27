# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


@readImage = (input) ->
  if input.files and input.files[0]
    FR = new FileReader()
    FR.onload = (e) ->
      $("#img").attr "src", e.target.result
      $("#offer_thumb").val e.target.result
      return
    FR.readAsDataURL input.files[0]
  return

@ready = ->
	$("#asd").change ->
	  readImage this
	  return

$(document).ready(ready)
$(document).on('page:load', ready)