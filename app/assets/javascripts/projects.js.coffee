# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#task_table").tablefix {
    height: 740
    width: 1200
    fixRows: 1
  }

  $(".sortable").sortable update: (event, ui) ->
    $.ajax (document.URL + "/task/sort"),
      type: "POST",
      dateType: "script",
      data: {
        task_id: $(ui.item[0]).attr("data-task-id")
        order: ui.item[0].sectionRowIndex
      }

  $(".sortable").disableSelection();

  $("input.planed_time_field").on "change", ->
    update(this, { task: { planed_time: $(this)[0].value } })

  $(".select_user_field").on "change", ->
    update(this, { task: { user_id: $(this).val() } })

  update = (element, data) ->
    task_id = $($(element).parent().parent()[0]).attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}"),
      type: "PATCH",
      dateType: "script",
      data: data

  $(".feed_item_content").on "click", (event) ->
    $(".edit_panel").remove()
    $(this).after("<div class=\"panel edit_panel\" style=\"top: #{event.pageY - 180}px; left: #{event.pageX - 60}px;\">
<div class=\"panel-body\">
パネルの内容
パネルの内容
パネルの内容
パネルの内容
パネルの内容
パネルの内容
</div>
</div>
")
