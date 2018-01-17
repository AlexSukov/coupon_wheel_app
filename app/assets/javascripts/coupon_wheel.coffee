$ ->
  domain = document.domain
  $.ajax
    type: 'POST'
    url: "https://2a75eeec.ngrok.io/clientside"
    data: { shop_domain: domain }
    dataType: "json"
    success: (data) ->
      settings = data.settings
      slices = data.slices
      alert(settings.id)
    error: (data) ->
      alert('All bad')
