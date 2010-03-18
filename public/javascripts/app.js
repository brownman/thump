$(document).ready(function(){
  var map = new GMap2(document.getElementById("map"));
  var lat = 51.5001524;
  var lng = -0.1262362;
  map.setCenter(new GLatLng(lat,lng), 13);    
  map.addControl(new GSmallMapControl());  
});
