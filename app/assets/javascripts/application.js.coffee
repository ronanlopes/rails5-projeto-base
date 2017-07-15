//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
//= require twitter/bootstrap
//= require twitter/bootstrap/rails/confirm
//= require chosen-jquery
//= require app_control
//= require datatable
//= require meiomask
//= require rails.validations
//= require rails.validations.simple_form
//= require rails.validations.customValidators


app_control.init_before()
# roda funções de inicialização
@$ ->
  ready()

# inicialização
@ready = () ->
  # enable chosen js
  window.initialize_objects()

  $('.modal').on 'shown.bs.modal', ->
    window.initialize_objects()

  $('.btn-new').click ->
    url = $(this).data("url")
    callback = $(this).data("callback")
    modal_form({ url: url, callback: callback})  
  
  $.fn.twitter_bootstrap_confirmbox.defaults = {
    fade: true,
    title: "Confirmação",
    cancel: "Cancelar",
    cancel_class: "btn cancel",
    proceed: "Confirmar",
    proceed_class: "btn proceed btn-primary"
  };


  $(".alterar-senha").click ->
    url = "/alterar_senha"
    modal_form({ url: url })  