$(document).ready(function() {
  $(".vote-trigger-show").on("click", function(event) {
    event.preventDefault();
    var recId = event.currentTarget.attributes[1].value;
    var direction = event.currentTarget.attributes[3].value
    $.ajax({
      method: 'PUT',
      url: '/recommendations/' + recId + '/' + direction,
      success: function(data){
        if(data[2] === true){
          $('.update-rating-' + data[0].id).html(
            data[1]
          )} else {
            alert('Please sign in or create an account to vote!')
        };
      }
    });
  });
});

$(document).ready(function() {
  $(".vote-trigger-index").on("click", function(event) {
    event.preventDefault();
    // debugger;
    // $.ajax({
    //   method: 'GET',
    //   url: '/recommendations',
      // success: function(){
        $("#all-recs").load("/recommendations #all-recs");
        debugger;
    //   }
    // });
  });
});
