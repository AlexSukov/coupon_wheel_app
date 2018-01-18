$ ->
  $('.create_slice').on 'click' , ->
    setting_id = $(this).data('setting')
    $.ajax
      type: 'POST'
      url: "/slices"
      data: { slice: { setting_id: setting_id, lose: false, slice_type: 'Coupon', label: 'Coupon Name', code: '000-000-000', gravity: 0 } }
      dataType: "json"
      success: (data) ->
        slice_index = $('.slice-index').last().data('slice-index') + 1
        $('#slice-container').append("
          <div class='slice' data-slice-id='#{data.slice.id}'>
            <span class='slice-index' data-slice-index=#{slice_index}>#{slice_index}</span>
            <select class='slice-type'>
              <option value='Coupon' selected>Coupon</option>
              <option value='Free Product'>Free Product</option>
            </select>
            <button type='button' class='slice-choose-product' hidden>Choose Product</button>
            <input class='slice-label' type='text' value='#{data.slice.label}'>
            <input class='slice-code' type='text' value='#{data.slice.code}'>
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
            slice_index = $('.slice-index').last().data('slice-index') + 1
            $('#slice-container').append("
              <div class='slice' data-slice-id='#{data.slice.id}'>
                <span class='slice-index' data-slice-index=#{slice_index}>#{slice_index}</span>
                <input class='slice-type' type='text' value='#{data.slice.slice_type}' disabled>
                <input class='slice-label' type='text' value='#{data.slice.label}'>
                <button type='button' class='slice-save'>Save</button>
              </div>
            ")
            ShopifyApp.flashNotice("Winning and Losing slices are successfully created")
          error: (data) ->
            ShopifyApp.flashError("Something went wrong with losing slice creation")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with winning slice creation")

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
        ShopifyApp.flashNotice("Slices successfully deleted")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with slice deletion")

  $('#slice-container').on 'click', '.slice-save', ->
    $parent = $(this).parent()
    slice_id = $parent.data('slice-id')
    slice_type = $parent.children('.slice-type').val()
    slice_label = $parent.children('.slice-label').val()
    slice_code = $parent.children('.slice-code').val()
    slice_gravity = $parent.children('.slice-gravity').val()
    slice_product_image = $parent.children('.slice-product-image').val()
    if (slice_type == 'Losing')
      data_slice = { slice: { label: slice_label } }
    else
      data_slice = { slice: { slice_type: slice_type, label: slice_label, code: slice_code, gravity: slice_gravity, product_image: slice_product_image } }
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
    parent = $(this).parent()
    if $(this).val() == 'Coupon'
      parent.children('.slice-code').val('000-000-000')
    parent.children('.slice-product-image').val('')
    parent.children('.slice-choose-product').toggle()
    parent.children('.slice-code').toggle()

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
