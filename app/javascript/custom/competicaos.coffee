# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
# https://kernelgarden.wordpress.com/2014/02/26/dynamic-select-boxes-in-rails-4/
$ ->
  $(document).on 'change', '#competicao_est_id', (evt) ->
    $.ajax '/competicaos/atualiza_combo_clube',
      type: 'GET'
      dataType: 'script'
      data: {
        estado_id: $("#competicao_est_id option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")
        