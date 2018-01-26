@calculate_probability = (slices) ->
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
        slices_probability.push({slice_id: slice.id, probability: probability})
  else
    $.each slices, (i) ->
      slice = slices[i]
      if !slice.lose
        probability = 100 / (slices.length / 2)
        probability = Math.round(probability)
        slices_probability.push({slice_id: slice.id, probability: probability})
  $.each slices_probability, (i) ->
    slice = slices_probability[i]
    parent = $('#slice-container').find("[data-slice-id='" + slice.slice_id + "']")
    td = parent.find('.slice-probability')
    td.html("#{slice.probability}%")

@collecting_data_for_probability = ->
  slices = []
  $('.slice').each ->
    type = $(this).find('.slice-type').val()
    if type == 'Losing'
      lose = true
    else
      lose = false
    id = $(this).data('slice-id')
    gravity = parseInt($(this).find('.slice-gravity').val())
    slices.push({id: id, lose: lose, gravity: gravity})
  calculate_probability(slices)

$ ->
  $('.create_slice').on 'click' , ->
    setting_id = $(this).data('setting')
    $.ajax
      type: 'POST'
      url: "/slices"
      data: { slice: { setting_id: setting_id, lose: false, slice_type: 'Coupon', label: 'Coupon Name', code: '000-000-000', gravity: 0, color: '#00ff99' } }
      dataType: "json"
      success: (data) ->
        if $('.slice-index').length != 0
          slice_index = $('.slice-index').last().data('slice-index') + 1
        else
          slice_index = 1
        $('#slice-container').append("
          <tr class='slice' data-slice-id='#{data.slice.id}'>
            <td class='slice-index' data-slice-index=#{slice_index}>#{slice_index}</td>
            <td><select class='slice-type custom-select'>
              <option value='Coupon' selected>Coupon</option>
              <option value='Free Product'>Free Product</option>
            </select></td>
            <td>
              <button type='button' class='slice-choose-product' hidden>Add Product</button>
              <input class='slice-label' type='text' value='#{data.slice.label}' onchange='collecting_data_for_preview();'>
              <input class='slice-product-image' type='text' hidden>
            </td>
            <td><input class='slice-code' type='text' value='#{data.slice.code}'></td>
            <td class='slice-color-td' data-color-id='#{data.slice.id}'><input class='slice-color' type='hidden' value='#{data.slice.color}'></td>
            <td><input class='slice-gravity' type='number' min='0' max='100' value='#{data.slice.gravity}' onchange='collecting_data_for_probability();'></td>
            <td class='slice-probability'></td>
            <td><button type='button' class='slice-save'><button type='button' class='slice-delete'></button></td>
          </tr>
        ")
        $(".slice-color-td[data-color-id='#{data.slice.id}']").children('.slice-color').minicolors theme: 'bootstrap'
        $.ajax
          type: 'POST'
          url: "/slices"
          data: { slice: { setting_id: setting_id, lose: true, slice_type: 'Losing', label: 'Losing Name'} }
          dataType: "json"
          success: (data) ->
            slice_index = $('.slice-index').last().data('slice-index') + 1
            $('#slice-container').append("
              <tr class='slice' data-slice-id='#{data.slice.id}'>
                <td class='slice-index' data-slice-index=#{slice_index}>#{slice_index}</td>
                <td><input class='slice-type' type='text' value='#{data.slice.slice_type}' disabled></td>
                <td><input class='slice-label' type='text' value='#{data.slice.label}' onchange='collecting_data_for_preview();'></td>
                <td></td>
                <td class='slice-color-td'></td>
                <td></td>
                <td></td>
                <td><button type='button' class='slice-save'></button></td>
              </tr>
            ")
            ShopifyApp.flashNotice("Winning and Losing slices are successfully created")
            collecting_data_for_preview()
          error: (data) ->
            ShopifyApp.flashError("Something went wrong with losing slice creation")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with winning slice creation")

  $('#slice-container').on 'click', '.slice-delete', ->
    $parent = $(this).parent().parent()
    slice_id = $parent.data('slice-id')
    $.ajax
      type: 'DELETE'
      url: "/slices/#{slice_id}"
      data: { slice: { id: slice_id } }
      dataType: "json"
      success: (data) ->
        $parent.next().remove()
        $parent.remove()
        ShopifyApp.flashNotice("Slices successfully deleted")
        collecting_data_for_preview()
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with slice deletion")

  $('#slice-container').on 'click', '.slice-save', ->
    $parent = $(this).parent().parent()
    slice_id = $parent.data('slice-id')
    slice_type = $parent.children('td').children('.slice-type').val()
    slice_label = $parent.children('td').children('.slice-label').val()
    slice_code = $parent.children('td').children('.slice-code').val()
    slice_gravity = $parent.children('td').children('.slice-gravity').val()
    slice_color = $parent.children('.slice-color-td').children().children('.slice-color').val()
    if slice_gravity == ''
      slice_gravity = 0
    slice_product_image = $parent.children('td').children('.slice-product-image').val()
    if (slice_type == 'Losing')
      data_slice = { slice: { label: slice_label } }
    else
      data_slice = { slice: { slice_type: slice_type, label: slice_label, code: slice_code, gravity: slice_gravity, product_image: slice_product_image, color: slice_color } }
    $.ajax
      type: 'PUT'
      url: "/slices/#{slice_id}"
      data: data_slice
      dataType: "json"
      success: (data) ->
        ShopifyApp.flashNotice("Slice was successfully updated")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with slice update")

  $('#slice-container').on 'change', '.slice-type', ->
    parent = $(this).parent().parent()
    if $(this).val() == 'Coupon'
      parent.children('td').children('.slice-code').val('000-000-000')
    parent.children('td').children('.slice-product-image').val('')
    parent.children('td').children('.slice-choose-product').toggle()
    parent.children('td').children('.slice-code').toggle()

  $('#slice-container').on 'click', '.slice-choose-product', ->
    $parent = $(this).parent().parent()
    $shop_domain = $('#shop_domain').val()
    singleProductOptions = 'selectMultiple': false
    ShopifyApp.Modal.productPicker singleProductOptions, (success, data) ->
      if success
        product = data.products[0]
        $parent.children('td').children('.slice-code').val($shop_domain + '/products/' + product.handle)
        $parent.children('td').children('.slice-label').val(product.title)
        $parent.children('td').children('.slice-product-image').val(product.image.src)
      if data.errors
        console.error data.errors

  $('.slice-color').minicolors theme: 'bootstrap'
