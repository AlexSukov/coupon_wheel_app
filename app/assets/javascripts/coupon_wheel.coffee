$ ->
  domain = document.domain
  $.ajax
    type: 'POST'
    url: "https://744f6c09.ngrok.io/clientside"
    data: { shop_domain: domain }
    dataType: "json"
    success: (data) ->
      settings = data.settings
      slices = data.slices
      $('body').prepend("
        <div class='coupon-wheel-modal'>
          <form id='email-form'>
            <input type='email' class='coupon-wheel-email' placeholder='Enter your email' required>
            <button type='submit' id='coupon-wheel-send'> Send </button>
          </form>
        </div>
      ")
    error: (data) ->
      alert('All bad')

  $('body').on 'submit', '#email-form', (e) ->
    e.preventDefault()
    $this = $(this)
    $parent = $(this).parent()
    email = $this.children('.coupon-wheel-email').val()
    $.ajax
      type: 'POST'
      url: "https://744f6c09.ngrok.io/collected_emails"
      data: { collected_email: email, shop_domain: domain }
      dataType: "json"
      success: (data) ->
        $this.remove()
        $parent.append('
          <p>Thank you for subscription!</p>
        ')
      error: (data) ->
        alert('Email not saved')
