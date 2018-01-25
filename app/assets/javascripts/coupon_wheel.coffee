$ ->
  setCookie = (cname, cvalue, exdays) ->
    d = new Date
    d.setTime d.getTime() + exdays * 24 * 60 * 60 * 1000
    expires = 'expires=' + d.toUTCString()
    document.cookie = cname + '=' + cvalue + ';' + expires + ';path=/'

  getCookie = (cname) ->
    name = cname + '='
    ca = document.cookie.split(';')
    i = 0
    while i < ca.length
      c = ca[i]
      while c.charAt(0) == ' '
        c = c.substring(1)
      if c.indexOf(name) == 0
        return c.substring(name.length, c.length)
      i++
    ''
  copyToClipboard = (element) ->
    $temp = $('<input>')
    $('body').append $temp
    $temp.val($(element).text()).select()
    document.execCommand 'copy'
    $temp.remove()

  random_item = (items) ->
    items[Math.floor(Math.random() * items.length)]

  calculate_prob_and_get_slice_id = (slices) ->
    gravity_sum = 0
    prob = 0
    window.slice_id = undefined
    $.each slices, (i) ->
      slice = slices[i]
      if !slice.lose
        gravity_sum += slice.gravity
    slices_probability = []
    if gravity_sum != 0
      $.each slices, (i) ->
        slice = slices[i]
        if !slice.lose
          probability = slice.gravity / gravity_sum * 100
          probability = Math.round(probability)
          i = 0
          while i < probability
            slices_probability.push(slice.id)
            i++
      slice_id = random_item(slices_probability)
    else
      $.each slices, (i) ->
        slice = slices[i]
        if !slice.lose
          probability = 100 / (slices.length / 2)
          probability = Math.round(probability)
          slices_probability.push({slice_id: slice.id, probability: probability})
      random_slice = random_item(slices_probability)
      slice_id = random_slice.slice_id
    return slice_id

  if getCookie('coupon_wheel_app_do_not_show') != 'true'
    domain = document.domain
    $.ajax
      type: 'POST'
      url: "https://f8a8ec82.ngrok.io/clientside"
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
            <canvas id='coupon_wheel' width='800' height='500'>
                Canvas not supported, use another browser.
            </canvas>
            <button type='button btn' id='spin'>Spin</button>
          </div>
        ")
        segments = []
        $.each slices, (i) ->
          slice = slices[i]
          if slice.lose
            segments.push({fillStyle: settings.lose_section_color, text: slice.label})
          else
            segments.push({fillStyle: settings.win_section_color, text: slice.label,
            code: slice.code, product_image: slice.product_image, slice_type: slice.slice_type})
        theWheel = new Winwheel(
          canvasId: 'coupon_wheel'
          numSegments: segments.length
          segments: segments
          textAlignment : 'center'
          innerRadius   : 32
          outerRadius   : 212
          pins : {
              number     : segments.length,
              outerRadius : 10,
              margin      : -10,
              fillStyle   : '#7734c3',
              strokeStyle : '#ffffff'
          }
          pointerGuide : {
                              display     : true
                              strokeStyle : 'red'
                              lineWidth   : 3
                          }
          animation : {
                            type: 'spinToStop'
                            duration : 5
                            spins    : 8
                            callbackFinished: 'showWinner()'
                            callbackAfter : 'drawTriangle()'
                        })
        window.showWinner = ->
          winningSegment = theWheel.getIndicatedSegment()
          if winningSegment.slice_type == 'Coupon'
            $('.coupon-wheel-modal').append("
              <div class='winning_title'>#{settings.winning_title}</div>
              <div class='winning_text'>#{settings.winning_text}</div>
              <div class='discount_code_title'>#{settings.discount_code_title}
                <span class='code'>#{winningSegment.code}</span>
              </div>
              <button class='btn continue_button'>#{settings.continue_button}</button>
              <button class='btn reject_discount_button'>#{settings.reject_discount_button}</button>
            ")
          else
            $('.coupon-wheel-modal').append("
              <div class='winning_title'>#{settings.winning_title}</div>
              <div class='winning_text'>#{settings.winning_text}</div>
              <img src='#{winningSegment.product_image}' class='product_image'>
              <div class='free_product_description'>#{settings.free_product_description}</div>
              <a type='button' href='#{winningSegment.code}'class='btn free_product_button'>#{settings.free_product_button}</a>
              <button class='btn free_product_reject'>#{settings.reject_discount_button}</button>
            ")
        window.drawTriangle = ->
          # Get the canvas context the wheel uses.
          ctx = theWheel.ctx
          ctx.strokeStyle = 'navy'
          # Set line colour.
          ctx.fillStyle = 'aqua'
          # Set fill colour.
          ctx.lineWidth = 2
          ctx.beginPath()
          # Begin path.
          ctx.moveTo 370, 5
          # Move to initial position.
          ctx.lineTo 430, 5
          # Draw lines to make the shape.
          ctx.lineTo 400, 40
          ctx.lineTo 371, 5
          ctx.stroke()
          # Complete the path by stroking (draw lines).
          ctx.fill()
          # Then fill.

        drawTriangle()
        $('body').on 'click', '#spin', (e)->
          slice_id = calculate_prob_and_get_slice_id(slices)
          slice_index = slices.map((o) ->
            o.id
          ).indexOf(slice_id) + 1
          stopAt = theWheel.getRandomForSegment(slice_index)
          theWheel.animation.stopAngle = stopAt;
          theWheel.startAnimation()
          $(this).remove()
        $('body').on 'click', '.continue_button', (e)->
          copyToClipboard('.code')
          $(this).text("#{settings.copied_message}")
          if settings.discount_coupon_auto_apply
            code = $('.code').text()
            exp_time = settings.discount_code_bar_countdown_time / 1440
            setCookie('coupon_wheel_app_code',code, exp_time)
      error: (data) ->
        alert('All bad')
    $('body').on 'submit', '#email-form', (e) ->
      e.preventDefault()
      $this = $(this)
      $parent = $(this).parent()
      email = $this.children('.coupon-wheel-email').val()
      $.ajax
        type: 'POST'
        url: "https://f8a8ec82.ngrok.io/collected_emails"
        data: { collected_email: email, shop_domain: domain }
        dataType: "json"
        success: (data) ->
          $this.remove()
          $parent.append('
            <p>Thank you for subscription!</p>
          ')
          setCookie('coupon_wheel_app_do_not_show', 'true', data.settings.do_not_show_app)
        error: (data) ->
          alert('Email not saved')

  if getCookie('coupon_wheel_app_code') != ''
    code = getCookie('coupon_wheel_app_code')
    $("form[action='/cart']").attr('action','/cart?discount=' + code)
