/*global I18n*/

$(document).ready(function(){
  $('#micropost_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert(I18n.t('more_than_5_warn'));
    }
  });
});