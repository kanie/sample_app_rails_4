# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#task_table').tablefix {
    height: 740
    width: 1200
    fixRows: 1
  }

  $('input.planed_time').on "change", ->
    alert "!"

  $('.sortable').sortable();
  $('.sortable').disableSelection();