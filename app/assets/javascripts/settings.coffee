@displayList = (api_key, list_id) ->
  $.ajax
    type: 'POST'
    url: "/mailchimp_api_key_verification"
    data: { api_key: api_key }
    dataType: "json"
    success: (data) ->
      mailchimp_lists = data.mailchimp_lists.body.lists
      $('#mailchimp').append("
        <div class='form-group' id='mailchimp-select-form'>
          <label for='mailchimp-select'>Mailchimp List</label>
          <select id='mailchimp-select'></select>
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

$ ->
  $('#setting_background_color').minicolors theme: 'bootstrap'
  $('#setting_font_color').minicolors theme: 'bootstrap'
  $('#setting_bold_text_and_button_color').minicolors theme: 'bootstrap'
  $('#setting_win_section_color').minicolors theme: 'bootstrap'
  $('#setting_lose_section_color').minicolors theme: 'bootstrap'
  $('#setting_progress_bar_color').minicolors theme: 'bootstrap'

  $('.add_url').on 'click' , ->
    $('#url_filters').append("
      <div class='new-url-form'>
        <input type='text' class='new-url' placeholder='Enter url' value=''>
        <button type='button' class='add-new-url'>Save Url</button>
        <button type='button' class='remove-new-url-form'>Remove Form</button>
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
            <button type='button' class='url_delete' data-url='#{data.url}'>Delete URL</button>
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
        $('#mailchimp').append("
          <div class='form-group' id='mailchimp-select-form'>
            <label for='mailchimp-select'>Mailchimp List</label>
            <select id='mailchimp-select'>
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

  $('body').on 'change','#mailchimp-select', ->
    list_id = $(this).val()
    $('#setting_mailchimp_list_id').val(list_id)
