$ ->
  $('.add_discount_code_form').on 'click' ,->
    $(this).prop('disabled', true)
    $('#discount-container').append("
    <table id='discount-form'>
      <caption>
        To create new discount code enter desired values below and press 'Create discount code'
      </caption>
      <tr>
        <th>Code</th>
        <th>Type</th>
        <th>Value</th>
        <th>Actions</th>
      </tr>
      <tr>
        <td>
          <input type='text' id='discount_code_title' placeholder='Enter desired discount code'>
        </td>
        <td>
          <select id='discount_code_type'>
            <option value='fixed_amount'>Fixed amount</option>
            <option value='percentage'>Percentage</option>
          </select>
        </td>
        <td>
          <input type='number' id='discount_code_value' step='1' min='-100' max='100' value='0'>
        </td>
        <td>
          <button type='button' id='create_discount_code'>Create discount code</button>
          <button type='button' id='cancel_discount_code'>Cancel</button>
        </td>
      </tr>
    </table>
    ")

  $('#discount-container').on 'click', '#cancel_discount_code', ->
    $('.add_discount_code_form').prop('disabled', false)
    $('#discount-form').remove()

  $('#discount-container').on 'click', '#create_discount_code', ->
    title = $('#discount_code_title').val()
    value_type = $('#discount_code_type').val()
    value = $('#discount_code_value').val()
    date_now = new Date
    starts_at = date_now.toISOString()
    if value > 0
      value = value * -1
    $.ajax
      type: 'POST'
      url: "/create_discount_code"
      data: { title: title, value_type: value_type, value: value, starts_at: starts_at }
      dataType: "json"
      success: (data) ->
        discount = data.discount
        $('#discount-form').remove()
        $('.add_discount_code_form').prop('disabled', false)
        $('#discount-codes tr:first-child').after("
          <tr>
            <td>
              #{discount.title}
            </td>
            <td>
              #{discount.value_type}
            </td>
            <td>
              #{discount.value}
            </td>
            <td>
              <button type='button' class='destroy_discount_code' data-id='#{discount.id}'>Delete discount code</button>
            </td>
          </tr>
        ")
        ShopifyApp.flashNotice("Discount code successfully created")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with discount code creation")

  $('#discount-codes').on 'click', '.destroy_discount_code', ->
    $tr = $(this).parent().parent()
    id = $(this).data('id')
    $.ajax
      type: 'DELETE'
      url: "/destroy_discount_code/#{id}"
      dataType: "json"
      success: (data) ->
        $tr.remove()
        ShopifyApp.flashNotice("Discount successfully deleted")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with discount code deletion")
