if (location.href.includes('checkout') || location.href.includes('password'))
  console.log('It is a password or checkout page.')
else 
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
          <span id='winning_code' class='code'>#{winningSegment.code}</span>
        </p>
        <button data-clipboard-target='#winning_code' class='continue_button'>#{settings.continue_button}</button>
        <button class='reject_discount_button'>#{settings.reject_discount_button}</button>
      ")
      code = getCookie('coupon_wheel_app_code')
      if code != ''
        $("<p>Your prize from previous spin is: '#{code}'. Be aware that you can use only one discount code at checkout!</p>").insertAfter('.discount_code_title')
      new ClipboardJS('.continue_button');
    else
      $('.coupon-wheel-text-container').append("
        <h2 class='winning_title'>#{settings.winning_title}</h2>
        <p class='free_product_description'>#{settings.free_product_description}</p>
        <img src='#{winningSegment.product_image}' class='product_image'>
        <div>
          <a href='https://#{winningSegment.code}' class='free_product_link'><button type='button' class='free_product_button'>#{settings.free_product_button}</button></a>
          <button class='free_product_reject'>#{settings.free_product_reject}</button>
        </div>
      ")
  @body_prepend = (settings, link) ->
    $('body').prepend("
      <div class='coupon-wheel-modal'>
        <div class='coupon-wheel-modal-wrapper-blur'></div>
        <div class='coupon-wheel-modal-wrapper'>
          <div class='canvas-container'>
            <div class='canvas-back'>
              <img src='#{link}/assets/Back-2.png'>
            </div>
            <div class='canvas-centerpiece'>
              <img src='#{link}/assets/Center.png'>
            </div>
            <div class='canvas-marker'>
              <img src='#{link}/assets/Marker.png'>
            </div>
            <canvas id='coupon_wheel'>
              Canvas not supported, use another browser.
              </canvas>
          </div>
          <div class='coupon-wheel-text-container'>
            <h2 class='title-text'>#{settings.title_text}</h2>
            <p class='disclaimer-text'>#{settings.disclaimer_text}</p>
            <p class='guiding-text'>#{settings.guiding_text}</p>
            <form id='email-form'>
              <input type='email' class='coupon-wheel-email' placeholder='#{settings.enter_email}' required>
              <button type='submit' id='coupon-wheel-send' class='coupon-wheel-send'> #{settings.spin_button} </button>
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
          left: 110vw;
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
          max-width: 768px;
        }
        .coupon-wheel-text-container{
          padding-top: 10%;
          color: #{settings.font_color};
          width: 40%;
          margin-right: 10%;
          height: 100%;
          overflow: auto;
        }
        .disclaimer-text, .guiding-text, .winning_text, .discount_code_title, .free_product_description{
          color: #{settings.font_color};
        }
        .canvas-back{
          position: absolute;
          top: 52.9%;
          left: 50%;
          transform: translate(-50%, -50%);
          width: 70%;
          z-index: 1;
        }
        .canvas-centerpiece{
          position: absolute;
          top: 50%;
          left: 50%;
          width: 52%;
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
          width: 100%;
          text-align: right;
          color: #{settings.font_color};
        }
        .coupon-wheel-send{
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
          padding: 10px 10px;
          margin: 20px 0;
        }
        .free_product_link{
          display: block;
        }
        .free_product_link:hover, .free_product_link:focus{
          opacity: 1;
        }
        .coupon-wheel-modal-showing{
          left: 0;
        }
        .big-logo{
          max-width: 300px;
          max-height: 168px;
        }
        @media only screen and (max-width: 1600px){
          .coupon-wheel-modal-wrapper-blur{
            filter: blur(5px);
          }
          .coupon-wheel-modal-wrapper{
            height: 95%;
            width: 95%;
          }
          .canvas-back {
            top: 54%;
            width: 80%;
          }
          .canvas-centerpiece {
            width: 59.5%;
            top: 50.5%;
          }
          .coupon-wheel-text-container{
            margin-right: 5%;
            margin-left: 5%;
            padding-top: 1%;
          }
          .canvas-marker{
            top: 20%;
          }
        }
        @media only screen and (max-width: 1400px){
          .canvas-centerpiece {
            width: 65%;
            top: 50%;
          }
          .canvas-marker {
            top: 15%;
          }
        }
        @media only screen and (max-width: 1300px){
          .canvas-back {
            top: 53%;
            width: 85%;
          }
          .canvas-centerpiece {
            width: 66%;
            top: 50.5%;
          }
          .coupon-wheel-text-container {
            padding-top: 10%;
          }
          .canvas-marker{
            top:27%;
          }
        }
        @media only screen and (max-width: 1100px){
          .canvas-marker {
            top: 35%;
          }
          .canvas-back {
            top: 52%;
            width: 100%;
          }
          .coupon-wheel-text-container {
            padding-top: 40%;
          }
          .canvas-centerpiece {
            width: 83%;
          }
        }
        @media only screen and (max-width: 1023px){
          .coupon-wheel-modal-wrapper{
            display: flex;
            flex-wrap: wrap;
          }
          .canvas-container, .coupon-wheel-text-container{
            width: 100%;
          }
          .canvas-container{
            height: 55%;
          }
          .coupon-wheel-text-container{
            margin: 0;
            height: 45%;
            padding: 10% 10% 0 10%;
            overflow: auto;
          }
          .big-logo{
            display: none;
          }
          .canvas-centerpiece {
            width: 55%;
          }
          .canvas-back {
            top: 54.5%;
            width: 70%;
          }
          .canvas-marker {
            top: 8%;
          }
        }
        @media only screen and (max-width: 767px){
          .canvas-container, .coupon-wheel-text-container{
            width: 100%;
          }
          .canvas-container{
            position: absolute;
            top: 97%;
            transform: translateY(-50%);
          }
          .big-logo{
            display: none;
          }
          .coupon-wheel-text-container{
            padding: 0;
            margin: 0;
            overflow: auto;
            height: 70%;
          }
          .canvas-centerpiece{
            width: 76%;
            top: 53%;
          }
          .coupon-wheel-modal-wrapper{
            height: 95%;
            width: 95%;
            display: flex;
            position: relative;
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
            top: 57%;
            width: 92%;
          }
          .coupon-wheel-text-container p{
            margin-bottom: 10px;
          }
          .coupon-wheel-send{
            padding: 5px 5px;
            display: block;
            margin: 15px auto;
          }
          .coupon-wheel-email {
            padding: 7px 7px;
          }
          .continue_button, .free_product_button{
            width: 100%;
            margin: 20px auto;
          }
        }
        @media only screen and (device-width: 414px){
          .canvas-back {
            top: 57%;
            width: 87%;
          }
        }
        @media only screen and (device-width: 375px){
          .canvas-back {
            top: 59%;
            width: 92%;
          }
        }
        @media only screen and (device-width: 320px){
          .canvas-back {
            top: 61%;
            width: 89%;
          }
          .coupon-wheel-text-container {
            height: 40%;
          }
        }
      </style>
    ")
    if settings.big_logo.url != null
      $('.coupon-wheel-text-container').prepend("<img class='big-logo' src='#{settings.big_logo.url}'>")
    if settings.small_logo.url != null
      $('.canvas-centerpiece').append("
        <div class='canvas-logo'>
          <img class='canvas-logo-img' src='#{settings.small_logo.url}'>
        </div>")
    if settings.show_pull_out_tab
      if settings.default_tab_icon == 'Custom'
        image = settings.tab_icon.url
      else
        image = settings.default_tab_icon
      $('body').prepend("
        <button type='button' class='pull-out-tab'><img class='tab-icon' src='#{image}'></button>
        <style>
          .pull-out-tab{
            position: fixed;
            top: 50%;
            right: 0;
            transform: translateY(-50%);
            background-color: transparent;
            border: none;
            outline: none;
            z-index: 5;
            width: 64px;
            padding: 0;
            height: 64px;
          }
          .tab-icon{
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
          }
        </style>
      ")
    if settings.enable_progress_bar
      progress_bar_position = ''
      switch (settings.progress_bar_position)
        when 'Under Top Title'
          progress_bar_position = '.coupon-wheel-text-container .title-text'
        when 'Under Main Text'
          progress_bar_position = '.coupon-wheel-text-container .disclaimer-text'
        when 'Under Spin Button'
          progress_bar_position = '#email-form'
      $( "
      <div id='coupon-wheel-progress-bar-container'>
        <p id='coupon-wheel-progress-bar-text'>#{settings.progress_bar_text}</p>
        <div id='coupon-wheel-progress'>
          <div id='coupon-wheel-bar'></div>
        </div>
      </div>
      <style>
        #coupon-wheel-progress-bar-text{
          color: #{settings.font_color};
        }
        #coupon-wheel-progress{
          width: 100%;
          background-color: #ddd;
          border-radius: 5px;
        }
        #coupon-wheel-bar{
          width: 0%;
          height: 15px;
          background-color: #{settings.progress_bar_color};
          border-radius: 5px;
        }
      </style>" ).insertAfter(progress_bar_position)
    $('body').on 'click', '.pull-out-tab', ->
      show_coupon_wheel_modal(settings)
    $('body').on 'click', '.coupon-wheel-close, .free_product_reject, .reject_discount_button', ->
      close_coupon_wheel_modal()
      window.coupon = true
      setCookie('coupon_wheel_app_do_not_show', 'true', settings.do_not_show_app)
    $('body').on 'click', '.continue_button', (e)->
      $(this).text("#{settings.copied_message}")
      close_coupon_wheel_modal()
      if settings.enable_discount_code_bar && getCookie('coupon_wheel_app_facebook') == ''
        countdown = new Date
        countdown.setTime countdown.getTime() + settings.discount_code_bar_countdown_time * 60 * 1000
        exp_time = settings.discount_code_bar_countdown_time / 1440
        setCookie('coupon_wheel_app_countdown', countdown, exp_time )
        discount_code_bar(settings, countdown)
      if settings.discount_coupon_auto_apply
        code = $('.code').text()
        exp_time = settings.discount_code_bar_countdown_time / 1440
        setCookie('coupon_wheel_app_code', code, exp_time)
  @animate_progress_bar = (percentage) ->
    elem = $('#coupon-wheel-bar')
    width = 0
    frame = ->
      if width >= percentage
        clearInterval id
      else
        width++
        elem.css('width', width + '%')
    id = setInterval(frame, 20)
  @discount_code_bar = (settings, countdown) ->
    $('body').append("
    <div id='discount-code-bar'>
    <p id='countdown-text'>#{settings.discount_coupon_code_bar} <span id='countdown'></span></p>
    <button type='button' id='close-discount-code-bar'>#{settings.close_button_in_bar}</button>
    </div>
    <style>
      #discount-code-bar{
        width: 100%;
        background-color: #{settings.background_color};
      }
      #countdown-text{
        text-align: center;
        color: #{settings.font_color};
        padding: 5px;
        margin: 10px;
      }
      #close-discount-code-bar{
        position: absolute;
        top: 50%;
        right: 10%;
        transform: translateY(-50%);
        background-color: #{settings.bold_text_and_button_color};
        border-color: #{settings.bold_text_and_button_color};
        border-radius: 5px;
        color: #{settings.font_color};
        outline: none;
      }
      .relative{
        position: relative;
      }
      @media only screen and (max-width: 767px){
        #close-discount-code-bar{
          position: relative;
          display: block;
          margin: 0 auto;
          right: 0;
        }
      }
    </style>
    ")
    styles = {}
    switch (settings.discount_code_bar_position)
      when 'Screen Top'
        styles =
          position: 'fixed'
          top: 0
      when 'Screen Bottom'
        styles =
          position: 'fixed'
          bottom: 0
      when 'Page Top'
        styles =
          position: 'absolute'
          top: 0
        $('body').addClass('relative')
      when 'Page Bottom'
        styles =
          position: 'absolute'
          bottom: 0
        $('body').addClass('relative')
    $('#discount-code-bar').css(styles)
    $('#countdown').countdown countdown, (event) ->
      $(this).text(event.strftime('%M:%S'))
      if event.type == 'finish'
        $('#countdown-text').html('Your discount code is no longer available')
    $('body').on 'click', '#close-discount-code-bar', ->
      $('#discount-code-bar').remove()
      setCookie('coupon_wheel_app_countdown', 0, 0 )
  @close_coupon_wheel_modal = ->
    $('.coupon-wheel-modal').removeClass('coupon-wheel-modal-showing')
  @show_coupon_wheel_modal = (settings) ->
    $('.coupon-wheel-modal').addClass('coupon-wheel-modal-showing')
    if settings.enable_progress_bar
      if !$('.coupon-wheel-modal').hasClass('coupon-wheel-progress-finished')
        animate_progress_bar(settings.progress_bar_percentage)
        $('.coupon-wheel-modal').addClass('coupon-wheel-progress-finished')
  @show_facebook_sharer = (settings, link) ->
    if settings.facebook_enable
      url = encodeURIComponent($("meta[property='og:url']").attr('content'))
      $('body').prepend("
        <div class='facebook-modal'>
          <div class='facebook-modal-wrapper'></div>
          <div class='facebook-modal-container'>
            <div class='facebook-modal-container-wrapper'>
              <span class='close-facebook-modal'>x</span>
              <div class='facebook-text-container'>
                <h2 class='facebook-title'>#{settings.facebook_title}</h2>
                <p class='facebook-desc'>#{settings.facebook_desc}</p>
                <a href='https://www.facebook.com/sharer/sharer.php?u=#{url}' target='_blank' class='facebook-link'>
                <svg version='1.1' id='Capa_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px'
                	 width='20px' height='20px' viewBox='0 0 612 612' style='fill: #{settings.facebook_button_text_color}; vertical-align: middle;' xml:space='preserve'>
                	<g>
                		<path d='M612,306C612,137.004,474.995,0,306,0C137.004,0,0,137.004,0,306c0,168.995,137.004,306,306,306
                			C474.995,612,612,474.995,612,306z M27.818,306C27.818,152.36,152.36,27.818,306,27.818S584.182,152.36,584.182,306
                			S459.64,584.182,306,584.182S27.818,459.64,27.818,306z'/>
                		<path d='M317.739,482.617V306h58.279l9.208-58.529h-67.487v-29.348c0-15.272,5.007-29.849,26.928-29.849h43.813v-58.418h-62.201
                			c-52.298,0-66.569,34.438-66.569,82.175v35.413h-35.885V306h35.885v176.617H317.739L317.739,482.617z'/>
                	</g>
                </svg>
                #{settings.facebook_button}
                </a>
              </div>
            </div>
          </div>
        </div>
        <style>
          .facebook-modal{
            position: fixed;
            height: 100vh;
            width: 100vw;
            z-index: 1000;
          }
          .facebook-modal-wrapper{
            height: 100vh;
            width: 100vw;
            filter: blur(5px);
            background-color: rgba(255,255,255,0.9);
          }
          .facebook-modal-container{
            background-image: url(#{settings.facebook_image.url});
            background-size: cover;
            background-repeat: no-repeat;
            width: 50%;
            height: 50%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%,-50%);
          }
          .facebook-modal-container-wrapper{
            width: 100%;
            height: 100%;
            position:relative;
          }
          .facebook-text-container{
            width: 30%;
            text-align: center;
            position: absolute;
            top: 50%;
            left: 70%;
            min-width: 210px;
            transform: translate(-50%,-50%);
          }
          .facebook-title{
            border-bottom: 1px solid;
            padding-bottom: 10px;
          }
          .facebook-title, .facebook-desc{
            color: #{settings.facebook_text_color};
          }
          .facebook-link{
            color: #{settings.facebook_button_text_color};
            background-color: #{settings.facebook_button_color};
            border-color: #{settings.facebook_button_color};
            border-radius: 5px;
            padding: 5px 10px;
          }
          .facebook-link:hover{
            opacity: 1;
          }
          .close-facebook-modal{
            cursor: pointer;
            color: #{settings.facebook_text_color};
            position: absolute;
            right: 10px;
            top: 10px;
            font-size: 24px;
          }
          @media only screen and (max-width: 767px){
            .facebook-modal-container{
              width: 95%;
              height: 95%;
              background-image: url(#{settings.facebook_image_mobile.url});
            }
            .facebook-text-container{
              top: 75%;
              left: 50%;
            }
          }
        </style>
      ")
  @draw_wheel = (settings, slices) ->
    height = $('.canvas-container').height()
    width = $('.canvas-container').width()
    if $(window).width() < 767
      $('.coupon-wheel-modal-wrapper').css('height', $(window).height())
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
    return theWheel

  @second_spin = (settings, slices)->
    body_prepend(settings, 'https://exitwheel.zoomifi.com')
    $('#email-form').remove()
    $("
      <button type='button' class='spin coupon-wheel-send'>#{settings.spin_button}</button>
    ").insertAfter('.guiding-text')
    theWheel = draw_wheel(settings, slices)
    slice_id = calculate_prob_and_get_slice_id(slices)
    slice_index = slices.map((o) ->
      o.id
    ).indexOf(slice_id) + 1
    stopAt = theWheel.getRandomForSegment(slice_index)
    theWheel.animation.stopAngle = stopAt;
    show_coupon_wheel_modal(settings)
    $('body').on 'click', '.spin', ->
      $('.coupon-wheel-text-container').html('')
      theWheel.startAnimation()

  $ ->
      domain = Shopify.shop
      $.ajax
        type: 'POST'
        url: "https://exitwheel.zoomifi.com/clientside"
        data: { shop_domain: domain }
        dataType: "json"
        success: (data) ->
          settings = data.settings
          slices = data.slices
          window.coupon = false
          countdown = getCookie('coupon_wheel_app_countdown')
          url_filters = settings.url_filters
          permitted_url = true
          $.each url_filters, (i) ->
            if url_filters[i] == document.location.href
              permitted_url = false
          if countdown != ''
            countdown = new Date(countdown)
            discount_code_bar(settings, countdown)
          if getCookie('coupon_wheel_app_facebook') == '' && settings.facebook_enable
            $("form[action*='/cart'] [name='checkout']").one 'click', (e) ->
              $this = $(this)
              e.preventDefault()
              show_facebook_sharer(settings, 'https://exitwheel.zoomifi.com')
              $('body').on 'click', '.close-facebook-modal', ->
                $('.facebook-modal').fadeOut()
                setCookie('coupon_wheel_app_facebook', true, settings.do_not_show_app)
                $this.click()
              $('body').on 'click', '.facebook-link', ->
                setCookie('coupon_wheel_app_facebook', true, settings.do_not_show_app)
                $('.facebook-modal').fadeOut()
                second_spin(settings, slices)
          if getCookie('coupon_wheel_app_do_not_show') != 'true'
            if settings.enable
              if permitted_url
                if $(window).width() > 800 && settings.show_on_desktop
                  body_prepend(settings, 'https://exitwheel.zoomifi.com')
                  if settings.show_on_desktop_leave_intent
                    $(document).mouseleave ->
                      if $('#discount-code-bar').length == 0 && window.coupon == false
                        show_coupon_wheel_modal(settings)
                  if settings.show_on_desktop_after
                    setTimeout (->
                      show_coupon_wheel_modal(settings)
                    ), settings.show_on_desktop_seconds * 1000
                if $(window).width() < 800 && settings.show_on_mobile
                  body_prepend(settings, 'https://exitwheel.zoomifi.com')
                  if settings.show_on_mobile_leave_intent
                    scroll = $(window).scrollTop()
                    $(window).scroll ->

                      if $(this).scrollTop() < scroll-30
                        if $('#discount-code-bar').length == 0 && window.coupon == false
                          show_coupon_wheel_modal(settings)
                      else
                        scroll = $(this).scrollTop()
                  if settings.show_on_mobile_after
                    setTimeout (->
                      show_coupon_wheel_modal(settings)
                    ), settings.show_on_mobile_seconds * 1000
                theWheel = draw_wheel(settings, slices)
                $('body').on 'submit', '#email-form', (e) ->
                  e.preventDefault()
                  $this = $(this)
                  $parent = $(this).parent()
                  email = $this.children('.coupon-wheel-email').val()
                  $.ajax
                    type: 'POST'
                    url: "https://exitwheel.zoomifi.com/collected_emails"
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
                      setCookie('coupon_wheel_app_do_not_show', 'true', data.settings.do_not_show_app)
                    error: (data) ->
                      console.log('Email already exist')
        error: (data) ->
          console.log('All bad');

    code = getCookie('coupon_wheel_app_code')
    if code != ''
      attribute = $("form[action*='/cart']").attr('action')
      if attribute == '/cart'
        attribute = attribute + '?discount=' + code
      else if attribute == '/cart?'
        attribute = attribute + '&discount=' + code
      $("form[action*='/cart']").attr('action', attribute)
