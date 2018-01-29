@setCookie = (cname, cvalue, exdays) ->
  d = new Date
  d.setTime d.getTime() + exdays * 24 * 60 * 60 * 1000
  expires = 'expires=' + d.toUTCString()
  document.cookie = cname + '=' + cvalue + ';' + expires + ';path=/'

@getCookie = (cname) ->
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
@copyToClipboard = (element) ->
  $temp = $('<input>')
  $('body').append $temp
  $temp.val($(element).text()).select()
  document.execCommand 'copy'
  $temp.remove()

@random_item = (items) ->
  items[Math.floor(Math.random() * items.length)]

@shuffle = (a) ->
  j = undefined
  x = undefined
  i = undefined
  i = a.length - 1
  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    x = a[i]
    a[i] = a[j]
    a[j] = x
    i--
  return

@calculate_prob_and_get_slice_id = (slices) ->
  gravity_sum = 0
  slice_id = undefined
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
    shuffle(slices_probability)
    slice_id = random_item(slices_probability)
  else
    $.each slices, (i) ->
      slice = slices[i]
      if !slice.lose
        probability = 100 / (slices.length / 2)
        probability = Math.round(probability)
        slices_probability.push({slice_id: slice.id, probability: probability})
    shuffle(slices_probability)
    random_slice = random_item(slices_probability)
    slice_id = random_slice.slice_id
  return slice_id

@showWinner = (winningSegment, settings) ->
  if winningSegment.slice_type == 'Coupon'
    $('.coupon-wheel-text-container').append("
      <h2 class='winning_title'>#{settings.winning_title}</h2>
      <p class='winning_text'>#{settings.winning_text}</p>
      <p class='discount_code_title'>#{settings.discount_code_title}
        <span class='code'>#{winningSegment.code}</span>
      </p>
      <button class='continue_button'>#{settings.continue_button}</button>
      <button class='reject_discount_button'>#{settings.reject_discount_button}</button>
    ")
  else
    $('.coupon-wheel-text-container').append("
      <h2 class='winning_title'>#{settings.winning_title}</h2>
      <p class='free_product_description'>#{settings.free_product_description}</p>
      <img src='#{winningSegment.product_image}' class='product_image'>
      <div>
        <a href='#{winningSegment.code}' class='free_product_link'><button type='button' class='free_product_button'>#{settings.free_product_button}</button></a>
        <button class='free_product_reject'>#{settings.free_product_reject}</button>
      </div>
    ")
$ ->
  if getCookie('coupon_wheel_app_do_not_show') != 'true'
    domain = document.domain
    $.ajax
      type: 'POST'
      url: "https://fb2c91df.ngrok.io/clientside"
      data: { shop_domain: domain }
      dataType: "json"
      success: (data) ->
        settings = data.settings
        slices = data.slices
        $('body').prepend("
          <div class='coupon-wheel-modal'>
            <div class='coupon-wheel-modal-wrapper-blur'></div>
            <div class='coupon-wheel-modal-wrapper'>
              <div class='canvas-container'>
                <div class='canvas-back'>
                  <img src='https://fb2c91df.ngrok.io/assets/Back-2.png'>
                </div>
                <div class='canvas-centerpiece'>
                  <img src='https://fb2c91df.ngrok.io/assets/Center.png'>
                  <div class='canvas-logo'>
                    <img class='canvas-logo-img' src='https://fb2c91df.ngrok.io/#{settings.small_logo.url}'>
                  </div>
                </div>
                <div class='canvas-marker'>
                  <img src='https://fb2c91df.ngrok.io/assets/Marker.png'>
                </div>
                <canvas id='coupon_wheel'>
                  Canvas not supported, use another browser.
                  </canvas>
              </div>
              <div class='coupon-wheel-text-container'>
                <img class='big-logo' src='https://fb2c91df.ngrok.io/#{settings.big_logo.url}'>
                <h2 class='title-text'>#{settings.title_text}</h2>
                <p class='disclaimer-text'>#{settings.disclaimer_text}</p>
                <p class='guiding-text'>#{settings.guiding_text}</p>
                <form id='email-form'>
                  <input type='email' class='coupon-wheel-email' placeholder='#{settings.enter_email}' required>
                  <button type='submit' id='coupon-wheel-send'> #{settings.spin_button} </button>
                </form>
                <button type='button' class='coupon-wheel-close'>#{settings.close_button} x</button>
              </div>
            </div>
          </div>
          <style>
            .coupon-wheel-modal{
              background-color: rgba(1,1,1,0.7);
              position: fixed;
              top: 0;
              left: 0;
              width: 100vw;
              height: 100vh;
              transition: all 0.3s ease-out;
              z-index: 999;
            }
            .coupon-wheel-modal-wrapper{
              background-color: #{settings.background_color};
              width: 80%;
              height: 80%;
              position: absolute;
              top: 50%;
              left: 50%;
              transform: translate(-50%,-50%);
            }
            .coupon-wheel-modal-wrapper-blur{
              background-color: #{settings.background_color};
              width: 100%;
              height: 100%;
              position: absolute;
              top: 0;
              left: 0;
              filter: blur(50px);
            }
            .canvas-container, .coupon-wheel-text-container{
              position: relative;
              width: 50%;
              height: 100%;
              float: left;
            }
            .coupon-wheel-text-container{
              padding-top: 10%;
              color: #{settings.font_color};
              width: 40%;
              margin-right: 10%;
              height:100%
            }
            .disclaimer-text, .guiding-text, .winning_text, .discount_code_title, .free_product_description{
              color: #{settings.font_color};
            }
            .canvas-back{
              position: absolute;
              top: 54%;
              left: 50%;
              transform: translate(-50%, -50%);
              width: 70%;
              z-index: 1;
            }
            .canvas-centerpiece{
              position: absolute;
              top: 50%;
              left: 50%;
              transform: translate(-50%, -50%);
              z-index: 3;
            }
            .canvas-logo{
              position: absolute;
              top: 50%;
              left: 50%;
              transform: translate(-50%,-50%);
              z-index: 4;
            }
            .canvas-marker{
              position: absolute;
              top: 19%;
              left: 50%;
              transform: translate(-50%,-50%);
              z-index: 3;
            }
            #coupon_wheel{
              position: absolute;
              z-index: 2;
              top: 0;
              left: 0;
            }
            .canvas-back img, .canvas-centerpiece img, .canvas-marker img{
              width: 100%;
            }
            img.canvas-logo-img{
              width: 70px;
              object-fit: cover;
              height: 70px;
              border-radius: 50%;
            }
            .coupon-wheel-email{
              width: 100%;
              padding: 15px 10px;
              border-radius: 5px;
            }
            .coupon-wheel-close, .reject_discount_button, .free_product_reject{
              background-color: transparent;
              border: none;
              float: right;
              color: #{settings.font_color};
            }
            #coupon-wheel-send{
              background-color: #{settings.bold_text_and_button_color};
              border-color: #{settings.bold_text_and_button_color};
              border-radius: 5px;
              text-transform: uppercase;
              color: #{settings.font_color};
              width: 50%;
              padding: 10px 10px;
              margin: 20px 0;
            }
            .continue_button, .free_product_button {
              color: #{settings.font_color};
              background-color: #{settings.bold_text_and_button_color};
              border-color: #{settings.bold_text_and_button_color};
              border-radius: 5px;
              width: 30%;
              padding: 10px 10px;
              margin: 20px 0;
            }
            .free_product_link{
              display: block;
            }
            .free_product_link:hover, .free_product_link:focus{
              opacity: 1;
            }
            @media only screen and (max-width: 1400px){
              .canvas-back {
                top: 53%;
                width: 98%;
              }
              .canvas-centerpiece{
                width: 80%;

              }
              .coupon-wheel-text-container{
                margin-right: 0;
                margin-left:10%;
              }
              .canvas-marker{
                top:22%;
              }
            }
            @media only screen and (max-width: 767px){
              .canvas-container, .coupon-wheel-text-container{
                width: 100%;
              }
              .canvas-container{
                height: 60%;
              }
              .big-logo{
                display: none;
              }
              .coupon-wheel-text-container{
                padding: 0;
                margin: 0;
                overflow: auto;
                height: 35%;
              }
              .canvas-centerpiece{
                width: 70%;
              }
              .coupon-wheel-modal-wrapper{
                height: 95%;
                width: 95%;
                display: flex;
                flex-wrap: wrap-reverse;
              }
              .coupon-wheel-modal-wrapper-blur{
                filter: blur(5px);
              }
              img.canvas-logo-img{
                width: 45px;
                height: 45px;
              }
              .canvas-marker {
                width: 12%;
                top: 13%;
              }
              .canvas-back {
                top: 55%;
                width: 88%;
              }
              .coupon-wheel-text-container p{
                margin-bottom: 10px;
              }
              #coupon-wheel-send{
                padding: 5px 5px;
                display: block;
                margin: 15px auto;
              }
              .coupon-wheel-email {
                padding: 7px 7px;
              }
            }
          </style>
        ")
        height = $('.canvas-container').height()
        width = $('.canvas-container').width()
        $('.coupon-wheel-modal').css('height', $(window).height())
        $('#coupon_wheel').attr('width', width)
        $('#coupon_wheel').attr('height', height)
        segments = []
        $.each slices, (i) ->
          slice = slices[i]
          if settings.duo_color
              fillStyle = slice.color
          else
            if slice.lose
              fillStyle = settings.lose_section_color
            else
              fillStyle = settings.win_section_color
          segments.push({fillStyle: fillStyle, text: slice.label,
          code: slice.code, product_image: slice.product_image, slice_type: slice.slice_type})
        if $(window).width() > 767
          outerRadius = 200
          innerRadius = 40
          textFontSize = 14
        else if $(window).width() > 340
          outerRadius = 125
          innerRadius = 20
          textFontSize = 12
        else
          outerRadius = 100
          innerRadius = 15
          textFontSize = 10
        theWheel = new Winwheel(
          canvasId: 'coupon_wheel'
          numSegments: segments.length
          segments: segments
          textAlignment : 'center'
          innerRadius   : innerRadius
          outerRadius   : outerRadius
          textFontSize  : textFontSize
          textFillStyle : settings.font_color
          special_settings: settings
          pins : {
              number     : segments.length,
              outerRadius : 5,
              margin      : -5,
              fillStyle   : '#3f3f3f',
              strokeStyle : '#3f3f3f'
          }
          animation : {
                            type: 'spinToStop'
                            duration : 5
                            spins    : 8
                            callbackFinished: 'showWinner(winwheelToDrawDuringAnimation.getIndicatedSegment(), winwheelToDrawDuringAnimation.special_settings)'
                        })

        $('body').on 'submit', '#email-form', (e) ->
          e.preventDefault()
          $this = $(this)
          $parent = $(this).parent()
          email = $this.children('.coupon-wheel-email').val()
          $.ajax
            type: 'POST'
            url: "https://fb2c91df.ngrok.io/collected_emails"
            data: { collected_email: email, shop_domain: domain }
            dataType: "json"
            success: (data) ->
              $('.coupon-wheel-text-container').html('')
              slice_id = calculate_prob_and_get_slice_id(slices)
              slice_index = slices.map((o) ->
                o.id
              ).indexOf(slice_id) + 1
              stopAt = theWheel.getRandomForSegment(slice_index)
              theWheel.animation.stopAngle = stopAt;
              theWheel.startAnimation()
              #setCookie('coupon_wheel_app_do_not_show', 'true', data.settings.do_not_show_app)
            error: (data) ->
              alert('Email not saved')
        $('body').on 'click', '.coupon-wheel-close, .free_product_reject, .reject_discount_button', ->
          $('.coupon-wheel-modal').css('left', '110vw')
        $('body').on 'click', '.continue_button', (e)->
          copyToClipboard('.code')
          $(this).text("#{settings.copied_message}")
          if settings.discount_coupon_auto_apply
            code = $('.code').text()
            exp_time = settings.discount_code_bar_countdown_time / 1440
            setCookie('coupon_wheel_app_code',code, exp_time)
      error: (data) ->
        alert('All bad')

  if getCookie('coupon_wheel_app_code') != ''
    code = getCookie('coupon_wheel_app_code')
    $("form[action='/cart']").attr('action','/cart?discount=' + code)
