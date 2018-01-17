(function() {
  $(function() {
    var domain;
    domain = document.domain;
    return $.ajax({
      type: 'POST',
      url: "https://2a75eeec.ngrok.io/clientside",
      data: {
        shop_domain: domain
      },
      dataType: "json",
      success: function(data) {
        var settings, slices;
        settings = data.settings;
        slices = data.slices;
        return alert(settings.id);
      },
      error: function(data) {
        return alert('All bad');
      }
    });
  });

}).call(this);
