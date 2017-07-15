window.ClientSideValidations.validators.remote['brazilian_zip_code'] = function(element, options) {
  if ($.ajax({
    url: '/validators/cep',
    data: { id: element.val() },
    // async DEVE estar definido como false
    async: false
  }).status == 404) { return options.message; }
}

