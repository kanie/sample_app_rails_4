# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#task_table").tablefix {
    height: 740
    width: 1200
    fixRows: 1
  }

  $("input.planed_time").on "change", ->
    task_id = $($(this).parent().parent()[0]).attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}"),
      type: "PATCH",
      dateType: "script",
      data: {
        task: {
          planed_time: $(this)[0].value
        }
      }

  $(".sortable").sortable update: (event, ui) ->
    $.ajax (document.URL + "/task/sort"),
      type: "POST",
      dateType: "script",
      data: {
        "task_id": $(ui.item[0]).attr("data-task-id")
        "order": ui.item[0].sectionRowIndex
      }

  $(".sortable").disableSelection();