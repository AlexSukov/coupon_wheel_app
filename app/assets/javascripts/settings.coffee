@scroll_to_preview = ->
  $('html, body').animate({
    scrollTop: $(".canvas-container").offset().top
  }, 2000);

@displayMailchimpList = (api_key, list_id) ->
  $.ajax
    type: 'POST'
    url: "/mailchimp_api_key_verification"
    data: { api_key: api_key }
    dataType: "json"
    success: (data) ->
      mailchimp_lists = data.mailchimp_lists.body.lists
      $('#mailchimp-container').append("
        <div class='form-group left-intent' id='mailchimp-select-form'>
          <label for='mailchimp-select'>Mailchimp List</label>
          <select id='mailchimp-select' class='custom-select one-quarter'></select>
        </div>
      ")
      $.each mailchimp_lists, (i) ->
        if mailchimp_lists[i].id == list_id
          $('#mailchimp-select').append("
            <option selected value='#{mailchimp_lists[i].id}'>#{mailchimp_lists[i].name}</option>
          ")
        else
          $('#mailchimp-select').append("
            <option value='#{mailchimp_lists[i].id}'>#{mailchimp_lists[i].name}</option>
          ")
    error: (data) ->
      ShopifyApp.flashError('Something wrong with your API key')

@displayKlaviyoList = (api_key, list_id) ->
  $.ajax
    type: 'POST'
    url: "/klaviyo_api_key_verification"
    data: { api_key: api_key }
    dataType: "json"
    success: (data) ->
      klaviyo_lists = $.parseJSON(data.klaviyo_lists)
      klaviyo_lists = klaviyo_lists.data
      $('#klaviyo-container').append("
        <div class='form-group left-intent' id='klaviyo-select-form'>
          <label for='klaviyo-select'>Klaviyo List</label>
          <select id='klaviyo-select' class='custom-select one-quarter'></select>
        </div>
      ")
      $.each klaviyo_lists, (i) ->
        if klaviyo_lists[i].id == list_id
          $('#klaviyo-select').append("
            <option selected value='#{klaviyo_lists[i].id}'>#{klaviyo_lists[i].name}</option>
          ")
        else
          $('#klaviyo-select').append("
            <option value='#{klaviyo_lists[i].id}'>#{klaviyo_lists[i].name}</option>
          ")
    error: (data) ->
      ShopifyApp.flashError('Something wrong with your API key')
@readURL = (input, elem, cl) ->
  $elem = elem
  $class = cl
  if input.files and input.files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $($elem).html("
        <img src='#{e.target.result}' class='#{$class}'>
      ")
    reader.readAsDataURL input.files[0]
@wheel_preview = (settings, slices) ->
  height = $('.canvas-container').height()
  width = $('.canvas-container').width()
  $('#wheel_preview').attr('width', width)
  $('#wheel_preview').attr('height', height)
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
    segments.push({ fillStyle: fillStyle, text: slice.label})
  if $(window).width() > 1400
    outerRadius = 200
    innerRadius = 40
    textFontSize = 14
  else if $(window).width() > 767
    outerRadius = 160
    innerRadius = 30
    textFontSize = 14
  else if $(window).width() > 340
    outerRadius = 115
    innerRadius = 20
    textFontSize = 12
  else
    outerRadius = 100
    innerRadius = 15
    textFontSize = 10
  Wheel = new Winwheel(
    canvasId: 'wheel_preview'
    numSegments: segments.length
    segments: segments
    textAlignment : 'center'
    textFontSize : textFontSize
    innerRadius   : innerRadius
    outerRadius   : outerRadius
    textFillStyle : settings.font_color
    pins : {
        number     : segments.length,
        outerRadius : 5,
        margin      : -5,
        fillStyle   : '#3f3f3f',
        strokeStyle : '#3f3f3f'
    })
  $('.canvas-container').css('background-color', settings.background_color)
@collecting_data_for_preview = ->
  settings = {}
  slices = []
  settings['background_color'] = $('#setting_background_color').val()
  settings['font_color'] = $('#setting_font_color').val()
  settings['win_section_color'] = $('#setting_win_section_color').val()
  settings['lose_section_color'] = $('#setting_lose_section_color').val()
  settings['duo_color'] = $('#setting_duo_color').is(':checked')
  $('.slice').each ->
    type = $(this).find('.slice-type').val()
    if type == 'Losing'
      lose = true
    else
      lose = false
    label = $(this).find('.slice-label').val()
    color = $(this).find('.slice-color').val()
    slices.push({label: label, lose: lose, color: color})
  wheel_preview(settings, slices)

$ ->
  $('#setting_background_color').minicolors theme: 'bootstrap'
  $('#setting_font_color').minicolors theme: 'bootstrap'
  $('#setting_bold_text_and_button_color').minicolors theme: 'bootstrap'
  $('#setting_win_section_color').minicolors theme: 'bootstrap'
  $('#setting_lose_section_color').minicolors theme: 'bootstrap'
  $('#setting_progress_bar_color').minicolors theme: 'bootstrap'
  $('#setting_facebook_text_color, #setting_facebook_button_text_color, #setting_facebook_button_color').minicolors theme: 'bootstrap'

  $('.add_url').on 'click' , ->
    $('#url_filters').append("
      <div class='new-url-form'>
        <input type='text' class='new-url' placeholder='Enter url' value=''>
        <button type='button' class='add-new-url'></button>
        <button type='button' class='remove-new-url-form'></button>
      </div>")
    $(this).prop('disabled', true)

  $('#url_filters').on 'click', '.remove-new-url-form', ->
    $(this).parent().remove()
    $('.add_url').prop('disabled', false)

  $('#url_filters').on 'click', '.add-new-url', ->
    url_value = $('.new-url').val()
    setting_id = $('#url_filters').data('setting-id')
    $.ajax
      type: 'POST'
      url: "/add_url_filter/#{setting_id}"
      data: { url_filters: url_value }
      dataType: "json"
      success: (data) ->
        $('.new-url-form').remove()
        $('#url_filters').append("
          <div class='url'>
            #{data.url}
            <button type='button' class='url_delete' data-url='#{data.url}'></button>
          </div>")
        $('.add_url').prop('disabled', false)
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with URL filter creation")

  $('#url_filters').on 'click', '.url_delete', ->
    $parent = $(this).parent()
    url_value = $(this).data('url')
    setting_id = $('#url_filters').data('setting-id')
    $.ajax
      type: 'DELETE'
      url: "/remove_url_filter/#{setting_id}"
      data: { url_filters: url_value }
      dataType: "json"
      success: (data) ->
        $parent.remove()
        ShopifyApp.flashNotice("URL filter successfully deleted")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with URL filter deletion")

  $('#setting_mailchimp_api_key').on 'change', ->
    mailchimp_api_key = $(this).val()
    $.ajax
      type: 'POST'
      url: "/mailchimp_api_key_verification"
      data: { api_key: mailchimp_api_key }
      dataType: "json"
      success: (data) ->
        $('#mailchimp-select-form').remove()
        $('#mailchimp-container').append("
          <div class='form-group left-intent' id='mailchimp-select-form'>
            <label for='mailchimp-select'>Mailchimp List</label>
            <select id='mailchimp-select' class='custom-select one-quarter'>
              <option disabled selected> -- select a list -- </option>
            </select>
          </div>
        ")
        mailchimp_lists = data.mailchimp_lists.body.lists
        $.each mailchimp_lists, (i) ->
          $('#mailchimp-select').append("
            <option value='#{mailchimp_lists[i].id}'>#{mailchimp_lists[i].name}</option>
          ")
      error: (data) ->
        ShopifyApp.flashError('Wrong API key. Try again')

  $('#setting_klaviyo_api_key').on 'change', ->
    klaviyo_api_key = $(this).val()
    $.ajax
      type: 'POST'
      url: "/klaviyo_api_key_verification"
      data: { api_key: klaviyo_api_key }
      dataType: "json"
      success: (data) ->
        $('#klaviyo-select-form').remove()
        $('#klaviyo-container').append("
          <div class='form-group left-intent' id='klaviyo-select-form'>
            <label for='klaviyo-select'>Klaviyo List</label>
            <select id='klaviyo-select' class='custom-select one-quarter'>
              <option disabled selected> -- select a list -- </option>
            </select>
          </div>
        ")
        klaviyo_lists = $.parseJSON(data.klaviyo_lists)
        klaviyo_lists = klaviyo_lists.data
        $.each klaviyo_lists, (i) ->
          $('#klaviyo-select').append("
            <option value='#{klaviyo_lists[i].id}'>#{klaviyo_lists[i].name}</option>
          ")
      error: (data) ->
        ShopifyApp.flashError('Wrong API key. Try again')


  $('body').on 'change','#mailchimp-select', ->
    list_id = $(this).val()
    $('#setting_mailchimp_list_id').val(list_id)

  $('body').on 'change','#klaviyo-select', ->
    list_id = $(this).val()
    $('#setting_klaviyo_list_id').val(list_id)

  $('#setting_duo_color').on 'change', ->
    $('#duo-color-settings').toggle();
    $('#each-slice-color-note').toggle();
    if $('#duo-color-settings')[0].style.display == 'block'
      $('.slice-color-td').hide()
    else
      $('.slice-color-td').show()
      $('.slice-color').minicolors theme: 'bootstrap'

  $('#setting_enable_discount_code_bar').on 'change', ->
    $('#discount-code-bar-container').fadeToggle('fast');

  $('#setting_enable_progress_bar').on 'change', ->
    $('#progress-bar-container').fadeToggle('fast');

  $('#setting_show_on_desktop').on 'change', ->
    $('#desktop-container').fadeToggle('fast');

  $('#setting_show_on_mobile').on 'change', ->
    $('#mobile-container').fadeToggle('fast');

  $('#setting_show_pull_out_tab').on 'change', ->
    $('#pull-out-tab-container').fadeToggle('fast');

  $('#setting_mailchimp_enable').on 'change', ->
    $('#mailchimp-container').fadeToggle('fast');

  $('#setting_klaviyo_enable').on 'change', ->
    $('#klaviyo-container').fadeToggle('fast');

  $('#setting_facebook_enable').on 'change', ->
    $('#facebook-container').fadeToggle('fast');

  $('.show-advanced').on 'click', ->
    $('#advanced-settings').fadeIn();
    $(this).hide()

  $('.close-advanced').on 'click', ->
    $('#advanced-settings').fadeOut();
    $('.show-advanced').show();

  $('#setting_default_tab_icon').on 'change', ->
    image = $(this).val()
    if image == 'Custom'
      $('#custom-tab-icon').fadeIn()
      if $('#setting_tab_icon').val() != ''
        $('#setting_tab_icon').trigger('change')
    else
      $('#custom-tab-icon').fadeOut()
      $('.tab-icon-wrapper').html("
        <img src='#{image}' class='tab-icon'>
      ")
  $(window).resize ->
    collecting_data_for_preview()

  $('#show-example').on 'click', ->
    $(this).next().fadeToggle()
    if $(this).attr('data-show') == 'show'
      $(this).attr('data-show','hide')
      $(this).html('Close example of text positioning')
    else
      $(this).attr('data-show','show')
      $(this).html('Show me example of text positioning')
