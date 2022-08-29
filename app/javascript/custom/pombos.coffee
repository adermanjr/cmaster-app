# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# https://css-tricks.com/jquery-coffeescript/

#$("#btn_filtro").click ->
#  $(".collapse").collapse('show')

#$ ->
#  if window.location.search.substring(1).includes("&")
#    $("#filtro").collapse('show')

#$ ->
#  alert($('input[name="pombo[vivo]"]').val())
#  #alert($(':hidden[name="pombo[vivo]"]'))

$ ->
 $('#pesquisa').autocomplete
   minLength: 2
   source: (request, response) ->
     $.ajax
       url: '/pombos/autocomplete'
       dataType: "json"
       data: 
        pesquisa: request.term
       success: (data) ->
         response $.map(data, (pombo) ->
           {
             label: pombo.anilha + ' ' + pombo.nome
             code: pombo.anilha
           }
         )
    select: (event, ui) ->
      $('#anilha_filter').val(ui.item.code)
 
