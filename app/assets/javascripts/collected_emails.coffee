$ ->
  $('.remove-email').on 'click', ->
    $parent = $(this).parent()
    email_id = $(this).data('email-id')
    $.ajax
      type: 'DELETE'
      url: "collected_emails/#{email_id}"
      data: { collected_email: { id: email_id } }
      dataType: "json"
      success: (data) ->
        $parent.remove()
        ShopifyApp.flashNotice("Email successfully deleted")
      error: (data) ->
        ShopifyApp.flashError("Something went wrong with email deletion")
