@discount_code_verification = (input) ->
  value = input.val()
  parent = input.parent()
  flag = undefined
  $('#suggested_discounts').children().each ->
    if $(this).val() == value
      flag = false
    else
      flag = true
  if flag
    input.addClass('wrong_discount_code')
    parent.parent().children('td').children('.slice-save').addClass('disabled').attr("disabled", true);
    parent.children('.home-info').remove()
    parent.append("<p class='home-info'><br/>This code does not exist</p>")
  else
    input.removeClass('wrong_discount_code')
    parent.parent().children('td').children('.slice-save').removeClass('disabled').attr("disabled", false);
    parent.children('.home-info').remove()
$ ->
  $('.add_discount_code_form').on 'click' ,->
    $(this).prop('disabled', true)
    $('#discount-container').append("
    <table id='discount-form'>
      <caption>
        To create new discount code enter desired values below and press 'Create discount code'. Avoid non-alphanumeric characters like % or ! or $ any other weird stuff ( @ # & – [ { } ] : ; ', ? / * ` ~ ^ + = < >) in the discount code name. Especially if your discount code name has multiple words with spaces.
      </caption>
      <tr>
        <th>Code</th>
        <th>Type</th>
        <th>Value</th>
        <th>Actions</th>
      </tr>
      <tr>
        <td>
          <input type='text' id='discount_code_title' placeholder='Enter desired discount name'>
        </td>
        <td>
          <select id='discount_code_type' class='custom-select'>
            <option value='fixed_amount'>Fixed amount</option>
            <option value='percentage'>Percentage</option>
          </select>
        </td>
        <td>
          <input type='number' id='discount_code_value' step='1' min='-100' max='100' value='0'>
        </td>
        <td>
          <button type='button' id='create_discount_code' class='create_discount_code'></button>
          <button type='button' id='cancel_discount_code' class='cancel_discount_code'></button>
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
        if discount.value_type == 'fixed_amount'
          value_type_final = 'Fixed Amount'
        else if discount.value_type == 'percentage'
          value_type_final = 'Percentage'
        else
          value_type_final = discount.value_type
        $('#discount-form').remove()
        $('.add_discount_code_form').prop('disabled', false)
        $('#discount-codes tr:first-child').after("
          <tr>
            <td>
              #{discount.title}
            </td>
            <td>
              #{value_type_final}
            </td>
            <td>
              #{discount.value}
            </td>
            <td>
              <button type='button' class='destroy_discount_code' data-id='#{discount.id}'></button>
            </td>
          </tr>
        ")
        $('#suggested_discounts').prepend("
          <option data-discount-id='#{discount.id}' value='#{discount.title}'></option>
        ")
        ShopifyApp.flashNotice("Discount code successfully created")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with discount code creation")

  $('#discount-codes').on 'click', '.destroy_discount_code', ->
    $tr = $(this).parent().parent()
    id = $(this).data('id')
    $suggested_discount_option = $("option[data-discount-id=#{id}]")
    $.ajax
      type: 'DELETE'
      url: "/destroy_discount_code/#{id}"
      dataType: "json"
      success: (data) ->
        $tr.remove()
        $suggested_discount_option.remove()
        $('.slice-code').each ->
          discount_code_verification($(this))
        ShopifyApp.flashNotice("Discount successfully deleted")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with discount code deletion")

  $('body').on 'change', '.slice-code', ->
    discount_code_verification($(this))
