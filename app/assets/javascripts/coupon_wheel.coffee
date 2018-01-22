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
  if getCookie('coupon_wheel_app_do_not_show') != 'true'
    domain = document.domain
    $.ajax
      type: 'POST'
      url: "https://665a769a.ngrok.io/clientside"
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
            <button type='button' id='spin'>Spin</button>
          </div>
        ")
        segments = []
        $.each slices, (i) ->
          slice = slices[i]
          if slice.lose
            segments.push({'fillStyle': "#{settings.lose_section_color}", 'text': "#{slice.label}"})
          else
            segments.push({'fillStyle': "#{settings.win_section_color}", 'text': "#{slice.label}", 'code': "#{slice.code}"})
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
                            callbackFinished: 'skra()'
                            callbackAfter : 'drawTriangle()'
                        })
        window.skra = ->
          winningSegment = theWheel.getIndicatedSegment()
          alert("You have won " + winningSegment.text + "!");
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
          stopAt = 140
          theWheel.animation.stopAngle = stopAt;
          theWheel.startAnimation()
      error: (data) ->
        alert('All bad')
    $('body').on 'submit', '#email-form', (e) ->
      e.preventDefault()
      $this = $(this)
      $parent = $(this).parent()
      email = $this.children('.coupon-wheel-email').val()
      $.ajax
        type: 'POST'
        url: "https://665a769a.ngrok.io/collected_emails"
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
