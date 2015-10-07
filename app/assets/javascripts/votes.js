$(document).ready(function() {
  $('.upvote-rec').on("click", function(event) {
    event.preventDefault();
    var recId = event.currentTarget.attributes[1].value;
    $.ajax({
      method: 'PUT',
      url: '/recommendations/' + recId + '/like',
      success: function(data){
        if(data[2] === true){
          $('.update-rating-' + data[0].id).html(
            data[1]
          )} else {
            alert('You need to sign in to vote!')
        };
      }
    });
  });

  $('.downvote-rec').on("click", function(event) {
    event.preventDefault();
    var recId = event.currentTarget.attributes[1].value;
    $.ajax({
      method: 'PUT',
      url: '/recommendations/' + recId + '/dislike',
      success: function(data){
        if(data[2] === true){
          $('.update-rating-' + data[0].id).html(
            data[1]
          )} else {
            alert('You need to sign in to vote!')
        };
      }
    });
  });
});
