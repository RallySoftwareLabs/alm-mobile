$.fn.spin = function(opts) {
  this.each(function() {
    var $this = $(this),
        data = $this.data('spinner');

    if (data && data.spinner) {
      data.spinner.stop();
      delete data.spinner;
    }
    if (opts !== false) {
      $this.data('spinner', new Spinner($.extend({color: $this.css('color')}, opts)).spin(this));
    }
  });
  return this;
};