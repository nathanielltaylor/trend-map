$(document).ready(function() {
  $(".get-analysis").on("click", function(event) {
    event.preventDefault();
    var currentPath = window.location.href.split('/')[3];
    $.ajax({
      method: 'PUT',
      url: '/' + currentPath,
      success: function(data){
        // if(data[2] === true){
        //   $('.update-rating-' + data[0].id).html(
        //     data[1]
        //   )} else {
        //     alert('Please sign in or create an account to vote!')
        // };
        $.post(
          'https://apiv2.indico.io/sentiment/batch?key=cab99168c35ae5ec855182e7b2a444e9',
          {
            data: JSON.stringify({
              'data': ["indico is so easy to use!", "everything is awesome!"]
            }),
            success: function (data) {
              console.log(data);
            }
          }
        );
      }
    });
  });
});
