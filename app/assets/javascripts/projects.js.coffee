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

  $(document).on "click", ".task_update_button", ->
    update(this, { task: {
      title: $(this).parent().find(".edit_title").val(),
      content: $(this).parent().find(".edit_content").val()
    } })
    location.reload()

  update = (element, data) ->
    task_id = $($(element).parents("tr")[0]).attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}"),
      type: "PATCH",
      dateType: "script",
      data: data

  $(".feed_item_label").on "click", ->
    $(".edit_panel").remove()
    title_label = $("<label>", { text: "件名" })
    title = $("<input>", { type: "text", value: $(this)[0].innerText, class: "form-control edit_title" })
    content_label = $("<label>", { text: "内容" })
    content = $("<textarea>", { rows: 5, text: $(this).parent().find(".feed_item_content").val(), class: "form-control edit_content" })
    button = $("<a>", { class: "btn btn-primary task_update_button" }).append("更新")
    panel_close_button = $("<button>", { type: "button", class: "close", text: "×", id: "edit_panel_close" })
    panel_header = $("<div>", { class: "panel-heading" })
    panel_header.append(panel_close_button)
    panel_body = $("<div>", { class: "panel-body form-group" })
    panel_body.append(title_label, title, content_label, content, button)
    edit_panel = $("<div>", { class: "panel edit_panel" }).append(panel_header, panel_body)
    $(this).after(edit_panel)

  $(document).on "click", "#edit_panel_close", ->
    $('.edit_panel').fadeOut()