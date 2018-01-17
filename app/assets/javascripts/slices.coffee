$ ->
  $('.create_slice').on 'click' , ->
    setting_id = $(this).data('setting')
    $.ajax
      type: 'POST'
      url: "/slices"
      data: { slice: { setting_id: setting_id, lose: false, slice_type: 'Coupon', label: 'Coupon Name', code: '000-000-000', gravity: 0 } }
      dataType: "json"
      success: (data) ->
        $('#slice-container').append("
          <div class='slice' data-slice-id='#{data.slice.id}'>
            <select class='slice-type'>
              <option value='Coupon' selected>Coupon</option>
              <option value='Free Product'>Free Product</option>
            </select>
            <input class='slice-label' type='text' value='#{data.slice.label}'>
            <input class='slice-code' type='text' value='#{data.slice.code}'>
            <button type='button' class='slice-choose-product' hidden>Choose Product</button>
            <input class='slice-gravity' type='number' min='0' max='100' value='#{data.slice.gravity}'>
            <input class='slice-product-image' type='text' hidden>
            <button type='button' class='slice-save'>Save</button>
            <button type='button' class='slice-delete'>Delete</button>
          </div>
        ")
        $.ajax
          type: 'POST'
          url: "/slices"
          data: { slice: { setting_id: setting_id, lose: true, slice_type: 'Losing', label: 'Losing Name' } }
          dataType: "json"
          success: (data) ->
            $('#slice-container').append("
              <div class='slice' data-slice-id='#{data.slice.id}'>
                <input class='slice-type' type='text' value='#{data.slice.slice_type}' disabled>
                <input class='slice-label' type='text' value='#{data.slice.label}'>
                <button type='button' class='slice-save'>Save</button>
              </div>
            ")
          error: (data) ->
            alert('Lose error')
      error: (data) ->
        alert('Win error')

  $('#slice-container').on 'click', '.slice-delete', ->
    $parent = $(this).parent()
    slice_id = $parent.data('slice-id')
    $.ajax
      type: 'DELETE'
      url: "/slices/#{slice_id}"
      data: { slice: { id: slice_id } }
      dataType: "json"
      success: (data) ->
        $parent.next().remove()
        $parent.remove()
      error: (data) ->
        alert('Remove slice error')

  $('#slice-container').on 'click', '.slice-save', ->
    $parent = $(this).parent()
    slice_id = $parent.data('slice-id')
    slice_type = $parent.children('.slice-type').val()
    slice_label = $parent.children('.slice-label').val()
    slice_code = $parent.children('.slice-code').val()
    slice_gravity = $parent.children('.slice-gravity').val()
    slice_product_image = $parent.children('.slice-product-image').val()
    if (slice_type == 'Losing')
      data_slice = { slice: { id: slice_id, label: slice_label } }
    else
      data_slice = { slice: { id: slice_id, slice_type: slice_type, label: slice_label, code: slice_code, gravity: slice_gravity, product_image: slice_product_image } }
    $.ajax
      type: 'PUT'
      url: "/slices/#{slice_id}"
      data: data_slice
      dataType: "json"
      success: (data) ->
        alert('Update slice successfull')
      error: (data) ->
        alert('Update slice error')

  $('#slice-container').on 'change', '.slice-type', ->
    $(this).parent().children('.slice-product-image').val('')
    $(this).parent().children('.slice-choose-product').toggle()
    $(this).parent().children('.slice-code').toggle()

  $('#slice-container').on 'click', '.slice-choose-product', ->
    $parent = $(this).parent()
    $shop_domain = $('#shop_domain').val()
    singleProductOptions = 'selectMultiple': false
    ShopifyApp.Modal.productPicker singleProductOptions, (success, data) ->
      if success
        product = data.products[0]
        $parent.children('.slice-code').val($shop_domain + '/products/' + product.handle)
        $parent.children('.slice-label').val(product.title)
        $parent.children('.slice-product-image').val(product.image.src)
      if data.errors
        console.error data.errors
