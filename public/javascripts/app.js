$(document).ready(function(){
  map = new GMap2(document.getElementById("map"));
  lat = $(".latitude").text();
  lng = $(".longitude").text();
  map.setCenter(new GLatLng(lat,lng), 13);    
  map.addControl(new GSmallMapControl());
  $("a.update_location").click(function(){
    if (navigator.geolocation && navigator.vendor != 'Apple Computer, Inc.') {
      navigator.geolocation.getCurrentPosition(function(position) { 
        var user_id = $("a.button.update_location").attr("id");
        lat = position.coords.latitude;
        lng = position.coords.longitude;
        map.panTo(new GLatLng(lat,lng), 13);
        $.ajax({type:"POST", url:('/users/'+user_id+'/set_location.json'), data:{'lat':lat,'lng':lng}, success:function(data){
          $('#location span').text(data.full_address);
          return false;
        }});
      });
    } else {
      $("form#update_location").removeClass("hidden");
    }
  });
  
  $('input[name="location"]').focus(function(){
    if (this.value == "Type your address here") {
      this.value = "";
    }
  });
  
  $('input[name="location"]').blur(function(){
    if (this.value == "") {
      this.value = "Type your address here";
    }
  });
  
  $('form#update_location').submit(function() {
    var user_id = $("a.button.update_location").attr("id");
    $.ajax({type:"POST", url:'/users/'+user_id+'/set_location.json', data:{'location': this.location.value}, success:function(data){
      $('#location span').text(data.full_address);
      lat = data.latitude;
      lng = data.longitude;
      map.panTo(new GLatLng(lat,lng), 13);
      return false;
    }});
    return false;
  });
  
  
    
});

var socket = new Pusher('c9f08e8c50f6f0cfb136', 'thump-development');

socket.bind('userCheckedIn', function(data) {
  addMarker(data);
});

socket.bind('userCheckedOut', function(data) {
  alert(data.login + "has checkout out");
  // addMarker(data);
});


function addMarker(place){
  var marker = new GMarker(new GLatLng(place.latitude, place.longitude));
  map.addOverlay(marker);
  return false;
}
