# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#task_table').tablefix {
    width: 800
    height: 500
    fixRows: 1
    fixCols: 3
  }