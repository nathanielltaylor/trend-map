$(document).ready(function() {
  $("#get-analysis").on("click", function(event) {
    event.preventDefault();
    var currentPath = window.location.href.split('/')[3];
    debugger;
    $.ajax({
      method: 'GET',
      url: '/' + currentPath,
      dataType: 'json'
    })
      .done(function(data){
        debugger;
        $.post(
          'https://apiv2.indico.io/sentiment?key=cab99168c35ae5ec855182e7b2a444e9',
          {
            data: JSON.stringify({
              'data': data[3][0]
            }),
          })
          })
      .done(function(data) {
        debugger;
        $('#get-analysis').html(data);
      })
  })
});
//   });
// });
