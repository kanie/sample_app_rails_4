# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".img_dropzone").on "dragover", (e) ->
    e.preventDefault()

  $(".img_dropzone").on "drop", (_e) ->
    e = select_event(_e)
    e.preventDefault()

    files = e.dataTransfer.files
    if(0 < files.length)
      file_upload(files[0])

  select_event = (_e) ->
    if(_e.originalEvent)
      e = _e.originalEvent
    else
      e = _e

  file_upload = (f) ->
    formData = new FormData
    formData.append("file", f)
    $.ajax "upload_image",
      type: "POST"
      dataType: "text"
      contentType: false
      processData: false
      data: formData
      success: (data) ->
        location.reload()