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
        alert('Url filter creation error')

  $('#url_filters').on 'click', '.url_delete', ->
    $parent = $(this).parent()
    url_value = $(this).data('url')
    setting_id = $('#url_filters').data('setting-id')
    $.ajax
      type: 'POST'
      url: "/remove_url_filter/#{setting_id}"
      data: { url_filters: url_value }
      dataType: "json"
      success: (data) ->
        $parent.remove()
      error: (data) ->
        alert('Url filter creation error')
