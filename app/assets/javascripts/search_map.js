function initSearchMap() {
  $.ajax({
    url: "/",
    method: 'GET',
    dataType: "json"
  })
  .done(function(data){
    // var userLocation = {lat: data[0], lng: data[1]};

    var map = new google.maps.Map(document.getElementById('map'), {
      center: {lat: 39.5, lng: -98.35},
      zoom: 4,
      minZoom: 2,
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

    var tweets = data;
    // var trends = data[3];

    tweets.forEach(function(tweet){
        var lat = parseFloat(tweet.latitude);
        var lng = parseFloat(tweet.longitude);

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

    // trends.forEach(function(trend){
    //   var trendLat = parseFloat(trend.latitude);
    //   var trendLng = parseFloat(trend.longitude);
    //
    //   var trendMarker = new google.maps.Marker({
    //     position: { lat: trendLat, lng: trendLng},
    //     map: map,
    //     title: 'Trend',
    //     icon: '/assets/trends_maps.png'
    //   })
    //
    //   trendMarker.addListener('click', function() {
    //     trendInfowindow.open(map, trendMarker);
    //   });
    //   var trendInfowindow = new google.maps.InfoWindow({
    //     content: trend.name
    //   });
    // });
    //
    // var marker = new google.maps.Marker({
    //   position: userLocation,
    //   map: map,
    //   title: 'You are here'
    // });
    // marker.addListener('click', function() {
    //   infowindow.open(map, marker);
    // });
    //
    // var infowindow = new google.maps.InfoWindow({
    //   content: 'You are here!'
    // });
  });
}
