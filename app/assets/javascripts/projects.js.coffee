# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".task_table").tablefix {
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

  $(".time .time_field").on "change", ->
    update_task(this, { task: { planed_time: $(this)[0].value } })

  $(".select_user_field").on "change", ->
    update_task(this, { task: { user_id: $(this).val() } })

  $(document).on "click", ".task_update_button", ->
    title = $(this).parent().find(".edit_title").val()
    update_task(this, { task: {
      title: title,
      content: $(this).parent().find(".edit_content").val()
    } })
    tasks_row(this).find(".feed_item_label")[0].innerHTML = title
    $('.edit_panel').fadeOut()

  $(".day .time_field.planed").on "change", ->
    update_daily(this, { daily: { planed_time: $(this)[0].value } })

  $(".day .time_field.actual").on "change", ->
    update_daily(this, { daily: { actual_time: $(this)[0].value } })

  update_task = (element, data) ->
    task_id = tasks_row(element).attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}"),
      type: "PATCH",
      dateType: "script",
      data: data

  tasks_row = (element) ->
    $($(element).parents(".task_row")[0])

  update_daily = (element, data) ->
    task_id = tasks_row(element).attr("data-task-id")
    daily_id = $($(element).parents(".day")[0]).attr("data-daily-id")
    $.ajax (document.URL + "/tasks/#{task_id}/dailies/#{daily_id}"),
      type: "PATCH",
      dateType: "script",
      data: data


  $(".feed_item_label").on "click", ->
    task_id = tasks_row(this).attr("data-task-id")
    $.ajax (document.URL + "/tasks/#{task_id}.json"),
      type: "GET",
      dateType: "script",
      data: {task_id: task_id },
      context: this
      success: (task) ->
        $(".edit_panel").remove()
        title_label = $("<label>", { text: "件名" })
        title = $("<input>", { type: "text", value: task.title, class: "form-control edit_title" })
        content_label = $("<label>", { text: "内容" })
        content = $("<textarea>", { rows: 5, text: task.content, class: "form-control edit_content" })
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

  $(".planed_tab").on "click", ->
    $(".planed").show()
    $(".actual").hide()
    $(".diff").hide()

  $(".actual_tab").on "click", ->
    $(".planed").hide()
    $(".actual").show()
    $(".diff").hide()

  $(".diff_tab").on "click", ->
    $(".planed").hide()
    $(".actual").hide()
    $(".diff").show()