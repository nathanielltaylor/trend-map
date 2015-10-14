function searchMap() {
  // get the current URL from the page
  var currentPath = window.location.href.split('/')[3];
  // debugger;
  $.ajax({
    url: "/" + currentPath,
    method: 'GET',
    dataType: "json"
  })
  .done(function(data){

    var tweets = data[0];
    var lat = data[1][0];
    var lng = data[1][1];

    var map = new google.maps.Map(document.getElementById('search-map'), {
      center: {lat: lat, lng: lng},
      zoom: 13,
      minZoom: 4,
      styles: [
      {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
              {
                  "visibility": "on"
              },
              {
                  "color": "#aee2e0"
              }
          ]
      },
      {
          "featureType": "landscape",
          "elementType": "geometry.fill",
          "stylers": [
              {
                  "color": "#abce83"
              }
          ]
      },
      {
          "featureType": "poi",
          "elementType": "geometry.fill",
          "stylers": [
              {
                  "color": "#769E72"
              }
          ]
      },
      {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [
              {
                  "color": "#7B8758"
              }
          ]
      },
      {
          "featureType": "poi",
          "elementType": "labels.text.stroke",
          "stylers": [
              {
                  "color": "#EBF4A4"
              }
          ]
      },
      {
          "featureType": "poi.park",
          "elementType": "geometry",
          "stylers": [
              {
                  "visibility": "simplified"
              },
              {
                  "color": "#8dab68"
              }
          ]
      },
      {
          "featureType": "road",
          "elementType": "geometry.fill",
          "stylers": [
              {
                  "visibility": "simplified"
              }
          ]
      },
      {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [
              {
                  "color": "#5B5B3F"
              }
          ]
      },
      {
          "featureType": "road",
          "elementType": "labels.text.stroke",
          "stylers": [
              {
                  "color": "#ABCE83"
              }
          ]
      },
      {
          "featureType": "road",
          "elementType": "labels.icon",
          "stylers": [
              {
                  "visibility": "off"
              }
          ]
      },
      {
          "featureType": "road.local",
          "elementType": "geometry",
          "stylers": [
              {
                  "color": "#A4C67D"
              }
          ]
      },
      {
          "featureType": "road.arterial",
          "elementType": "geometry",
          "stylers": [
              {
                  "color": "#9BBF72"
              }
          ]
      },
      {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [
              {
                  "color": "#EBF4A4"
              }
          ]
      },
      {
          "featureType": "transit",
          "stylers": [
              {
                  "visibility": "off"
              }
          ]
      },
      {
          "featureType": "administrative",
          "elementType": "geometry.stroke",
          "stylers": [
              {
                  "visibility": "on"
              },
              {
                  "color": "#87ae79"
              }
          ]
      },
      {
          "featureType": "administrative",
          "elementType": "geometry.fill",
          "stylers": [
              {
                  "color": "#7f2200"
              },
              {
                  "visibility": "off"
              }
          ]
      },
      {
          "featureType": "administrative",
          "elementType": "labels.text.stroke",
          "stylers": [
              {
                  "color": "#ffffff"
              },
              {
                  "visibility": "on"
              },
              {
                  "weight": 4.1
              }
          ]
      },
      {
          "featureType": "administrative",
          "elementType": "labels.text.fill",
          "stylers": [
              {
                  "color": "#495421"
              }
          ]
      },
      {
          "featureType": "administrative.neighborhood",
          "elementType": "labels",
          "stylers": [
              {
                  "visibility": "off"
              }
          ]
      }
      ]
    });

    tweets.forEach(function(tweet){
        var lat = parseFloat(tweet.geo["coordinates"][0]);
        var lng = parseFloat(tweet.geo["coordinates"][1]);

        var marker = new google.maps.Marker({
          position: {lat: lat, lng: lng},
          map: map,
          title: 'Tweet',
          icon: '/assets/tweets_maps.png'
        })
        marker.addListener('click', function() {
          infowindow.open(map, marker);
        });
        var infowindow = new google.maps.InfoWindow({
          content: tweet.text
        });
    });
  });
}
