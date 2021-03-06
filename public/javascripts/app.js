$(document).ready(function(){
  
  map = new GMap2(document.getElementById("map"));
  lat = $(".latitude").text();
  lng = $(".longitude").text();
  map.setCenter(new GLatLng(lat,lng), 13);    
  map.addControl(new GSmallMapControl());
  markers = [];
  $.ajax({type:"GET", url:"/users/with_locations", success:function(data) {
    $.each(data, function(i,v){
      addMarker(v);
    });
  }});
  $("a.update_location").click(function(){
    if (1==0){//(navigator.geolocation && navigator.vendor != 'Apple Computer, Inc.') {
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
      $("form#update_location").fadeIn("slow");
    }
  });
  
  $('#location span').click(function(){
    map.panTo(new GLatLng(lat, lng), 13);
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
      $('form#update_location').fadeOut("slow");
      map.panTo(new GLatLng(lat,lng), 13);
      return false;
    }});
    return false;
  });
  
  $('.user-info-window a.close').live('click', function(){
    var uid = $(this).attr("id");
    $('.user-info-window#'+uid).fadeOut('fast');
  });

  $('.msg').live('click', function(){
    $(this).fadeOut('fast');
  });

  
  $('form#message').live('submit', function(){
    var user_id = $("a.button.update_location").attr("id");
    if (this.to_user_id == undefined){
      var window_user_id = user_id;
      var formData = {'message': this.message.value};
    } else {
      var window_user_id = this.to_user_id.value;
      var formData = {'message': this.message.value, 'to_user_id': this.to_user_id.value};
    }
    $.ajax({type:"POST", url:'/users/'+user_id+'/message', data:formData, success:function(data){
      $('.user-info-window#user_' + window_user_id + ' input[type="text"]').value = '';
      $('.user-info-window#user_'+window_user_id).fadeOut('fast');
    }});
    return false;    
  });
    
});

jsEnvironments = {
  'thump.local': 'development',
  'thump.heroku.com': 'production'  
};
jsEnv = jsEnvironments[document.location.host];

var socket = new Pusher('c9f08e8c50f6f0cfb136', 'thump-'+jsEnv);

socket.bind('userCheckedIn', function(data) {
  addMarker(data);
});

socket.bind('userCheckedOut', function(data) {
  removeMarker(data);
});

socket.bind('messageBroadcast', function(data) {
  console.log(data);
  $.each(markers, function(index, value){
    if (data.user_id == value.user_id){
      if (data.to_user_id == undefined){
        var message = data.message;
      } else {
        var message = "@" + data.to_user_login + " " + data.message;
      }
      text = '<div class="msg" id="user_' + data.user_id + '">'+ message+'</div>';
      $("#main").append(text);
      $('.user-info-window#user_'+data.user_id + ' .current_message').text(message);
      $('.msg#user_'+data.user_id).css('top', map.fromLatLngToContainerPixel(value.marker.getLatLng()).y - 40);
      $('.msg#user_'+data.user_id).css('left', map.fromLatLngToContainerPixel(value.marker.getLatLng()).x + 20);
      $('.msg#user_'+data.user_id).delay(4000).fadeOut('slow');
    }
  }); 
});

function addMarker(data){
  removeMarker(data);
  baseIcon = new GIcon(G_DEFAULT_ICON);
  baseIcon.image  = data.gravatar_url;
  baseIcon.iconSize = new GSize(36, 36);
  baseIcon.iconAnchor = new GPoint(18, 36); 
  var latlng  = new GLatLng(data.latitude, data.longitude);
  var marker = new GMarker(latlng, {icon:baseIcon});
  markers.push({'marker':marker, 'user_id':data.user_id})
  map.addOverlay(marker);
  GEvent.addListener(marker, "click", function() {
    if ($(".user-info-window#user_"+data.user_id).length == 0){
      $.ajax({type:"GET", url:('/users/'+data.user_id), success:function(htmldata){
        $("#main").append(htmldata);
        myMarker = marker;
        $('.user-info-window#user_'+data.user_id).css('top', map.fromLatLngToContainerPixel(marker.getLatLng()).y - 50);
        $('.user-info-window#user_'+data.user_id).css('left', map.fromLatLngToContainerPixel(marker.getLatLng()).x - 30);
        return false;
      }});
    } else {
      $('.user-info-window#user_'+data.user_id).css('top', map.fromLatLngToContainerPixel(marker.getLatLng()).y - 50);
      $('.user-info-window#user_'+data.user_id).css('left', map.fromLatLngToContainerPixel(marker.getLatLng()).x - 30);      
      $('.user-info-window#user_'+data.user_id).fadeIn('fast');
    }
  });
  return false;
}

function removeMarker(data){
  $.each(markers, function(index, value){
    if (data.user_id == value.user_id){
      var i = markers.indexOf(value.marker);
      markers.splice(i, 1);
      map.removeOverlay(value.marker);
    }
  });
}