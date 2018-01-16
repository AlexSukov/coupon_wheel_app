$ ->
  domain = document.domain
  $.ajax
    type: 'POST'
    url: "https://f8ed6190.ngrok.io/clientside"
    data: { shop_domain: domain }
    dataType: "json"
    success: (data) ->
      alert(data.shop.shopify_domain)
    error: (data) ->
      alert('All bad')
