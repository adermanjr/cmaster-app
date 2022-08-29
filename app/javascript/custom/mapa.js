function getCoords(tela) {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      
      document.getElementById(tela + '_lat').value = pos.lat;
      document.getElementById(tela + '_lng').value = pos.lng;
      
      convertDecimalParaGraus(pos.lat, 'lat', tela);
      convertDecimalParaGraus(pos.lng, 'lng', tela);
      
      if (tela == 'modal') {
        document.getElementById('lat').value = pos.lat.toFixed(6);
        document.getElementById('lng').value = pos.lng.toFixed(6);
      }
      
    }, function() {
      alert('Error: The Geolocation service failed.');
    });
  }
}

var rad = function(x) {
  return x * Math.PI / 180;
};


var getDistance = function(p1, p2) {
  var R = 6378137; // Earth’s mean radius in meter (SIRGAS2000 a )
  var dLat = rad(p2.lat() - p1.lat());
  var dLong = rad(p2.lng() - p1.lng());
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(rad(p1.lat())) * Math.cos(rad(p2.lat())) *
    Math.sin(dLong / 2) * Math.sin(dLong / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;
  return d; // returns the distance in meter
};


//http://maps.marnoto.com/en/coordinate-converter/#
function convertGrauParaDecimal(days, minutes, seconds, direction) {
  
  var dd = parseInt(days) + parseInt(minutes)/60 + parseFloat(seconds)/(60*60);
  
  if (direction == "S" || direction == "W") {
      dd = dd*-1;
  } // Don't do anything for N or E
  
  return dd;
}

function dms_to_degrees(d, m, s) {
  
  let dg = d; 
  let fract = m / 60 + s / 3600; 
  let total = 0;
  
  if (d > 0) {
    total = dg + fract;
  }
  else {
    total = dg - fract;
  }
  return total;
}


function convertDecimalParaGraus(val, tipo, tela = 'modal') {

  var valAbs = Math.abs(val);
  var coordDeg = Math.floor(valAbs);
  var coordMin = Math.floor((valAbs - coordDeg) * 60);
  var coordSeg = Math.round((valAbs - coordDeg - coordMin / 60) * 3600 * 1000) / 1000; 
  
  if (tipo == 'lat')
    var coordCardinal = ((val > 0) ? "N" : "S");
  else 
    var coordCardinal = ((val > 0) ? "E" : "W");
    
  
  let descDeg = tipo +'dd';
  let descMin = tipo +'dm';
  let descSeg = tipo +'ds';
  let descCard = tipo +'direction';
  
  if (tela != 'modal') {
    descDeg = tela + '_' + tipo + '_deg';
    descMin = tela + '_' + tipo + '_min';
    descSeg = tela + '_' + tipo + '_seg';
    descCard = tela + '_' + tipo + '_card';
  }
    
  document.getElementById(descDeg).value = coordDeg;
  document.getElementById(descMin).value = coordMin;
  document.getElementById(descSeg).value = coordSeg.toFixed(2);
  document.getElementById(descCard).value = coordCardinal;
  
}

function converterCoordParaGraus() {
  convertDecimalParaGraus(document.getElementById('lat').value, 'lat');
  convertDecimalParaGraus(document.getElementById('lng').value, 'lng');
}

function converterCoordParaDecimal(tela, zoom) {
  var lat = convertGrauParaDecimal(document.getElementById(tela + '_lat_deg').value,
                                   document.getElementById(tela + '_lat_min').value,
                                   document.getElementById(tela + '_lat_seg').value,
                                   document.getElementById(tela + '_lat_card').value);
  document.getElementById('lat').value = lat.toFixed(6);
  
  var lng = convertGrauParaDecimal(document.getElementById(tela + '_lng_deg').value,
                                   document.getElementById(tela + '_lng_min').value,
                                   document.getElementById(tela + '_lng_seg').value,
                                   document.getElementById(tela + '_lng_card').value);
  document.getElementById('lng').value = lng.toFixed(6);
  
  preencheValoresCoordenadas(tela, 'lat');
  preencheValoresCoordenadas(tela, 'lng');
  
  initMapLL(lat.toFixed(6), lng.toFixed(6), zoom);
  
}

function preencheValoresCoordenadas(tela, tipo) {
  document.getElementById(tipo +'dd').value = document.getElementById(tela + '_' + tipo + '_deg').value;
  document.getElementById(tipo +'dm').value = document.getElementById(tela + '_' + tipo + '_min').value;
  document.getElementById(tipo +'ds').value = document.getElementById(tela + '_' + tipo + '_seg').value;
  document.getElementById(tipo +'direction').value = document.getElementById(tela + '_' + tipo + '_card').value;
}

function setar_lat_lng(modal) {
  if (modal =='MPO') return;
  
  let tela_nome = 'usuario';
  if (modal == "MPC"){
    tela_nome = 'prova';
  }
  document.getElementById(tela_nome + '_lat').value = document.getElementById('lat').value;
  document.getElementById(tela_nome + '_lng').value = document.getElementById('lng').value;
}

function apagar_lat_lng(campo_lat, campo_lng) {
  document.getElementById(campo_lat).value = "";
  document.getElementById(campo_lng).value = "";
}

function valida_coordenadas(tela, l) {
  var valid = true;
  
  var card = document.getElementById(tela +  l + '_card').value;
  var deg = document.getElementById(tela +  l + '_deg').value;
  var min = document.getElementById(tela +  l + '_min').value;
  var seg = document.getElementById(tela +  l + '_seg').value;
  
  
  if (card == '') valid = false;
  if (deg == '') valid = false;
  if (min == '') valid = false;
  if (seg == '') valid = false;
  
  
  return valid;
}

function valida_coodenadas_diretor(tela) {
  var lat = valida_coordenadas(tela, '_lat');
  var lng = valida_coordenadas(tela, '_lng');
  
  return lat & lng;
}

function initMapLL(lat, lng, zoom_tela) {
  document.getElementById('lat').value = lat;
  document.getElementById('lng').value = lng;
    
  var myCoords = new google.maps.LatLng(lat, lng);
  var mapOptions = {
    center: myCoords,
    zoom: zoom_tela,
    mapTypeId: 'roadmap',
  };
  
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);
  var marker = new google.maps.Marker({
    position: myCoords,
    animation: google.maps.Animation.DROP,
    map: map,
    draggable: false
  });

/*
*** por endereço ***

    var geocoder = new google.maps.Geocoder();
    var marker = new google.maps.Marker();
    
    geocoder.geocode({'address': endereco}, function(results, status) {
      if (status === 'OK') {
        map.setCenter(results[0].geometry.location);
        marker.constructor({
          animation: google.maps.Animation.DROP,
          map: map,
          position: results[0].geometry.location,
          draggable: true
        });
        document.getElementById('lat').value = marker.getPosition().lat().toFixed(6);
        document.getElementById('lng').value = marker.getPosition().lng().toFixed(6);
      } else {
        alert('Geocode was not successful for the following reason: ' + status);
      }
    });
*/  
//// refresh marker position and recenter map on marker
//function refreshMarker(){
//  var lat = document.getElementById('lat').value;
//  var lng = document.getElementById('lng').value;
//  var myCoords = new google.maps.LatLng(lat, lng);
//  marker.setPosition(myCoords);
//  map.setCenter(marker.getPosition());   
//}
//
//// when input values change call refreshMarker
//document.getElementById('lat').onchange = refreshMarker;
//document.getElementById('lng').onchange = refreshMarker;
//
//// when marker is dragged update input values
//marker.addListener('drag', function() {
//  latlng = marker.getPosition();
//  newlat=(Math.round(latlng.lat()*1000000))/1000000;
//  newlng=(Math.round(latlng.lng()*1000000))/1000000;
//  document.getElementById('lat').value = newlat;
//  document.getElementById('lng').value = newlng;
//});
//
//// When drag ends, center (pan) the map on the marker position
//marker.addListener('dragend', function() {
//  map.panTo(marker.getPosition());   
//});
}

function initMapRota(p1lat, p1lng, p2lat, p2lng, nome_pombal, nome_cidade, zoom_tela) {
  var coordsUsu = new google.maps.LatLng(p1lat, p1lng);
  var coordsPrv = new google.maps.LatLng(p2lat, p2lng);
  var coordsCnt = new google.maps.LatLng((p1lat + p2lat)/2, (p1lng + p2lng)/2);
  
  var mapOptions = {
    center: coordsCnt,
    zoom: zoom_tela,
    mapTypeId: 'roadmap',
    /* mapTypeId: 'terrain' */
  };
  
  var map = new google.maps.Map(document.getElementById('map'), mapOptions);
  
  var iconA = 'https://chart.googleapis.com/chart?' +
            'chst=d_map_pin_letter&chld=A|00FF00|000000';
  var iconB = 'https://chart.googleapis.com/chart?' +
            'chst=d_map_pin_letter&chld=B|1E90FF|000000';
            
  var marker = new google.maps.Marker({
    position: coordsUsu,
    map: map,
    title: nome_pombal,
    icon: iconA
  });
  
  var marker2 = new google.maps.Marker({
    position: coordsPrv,
    map: map,
    title: nome_cidade,
    icon: iconB
  });

  var flightPlanCoordinates = [
    {lat: p1lat, lng: p1lng},
    {lat: p2lat, lng: p2lng},
  ];
  
  var flightPath = new google.maps.Polyline({
    path: flightPlanCoordinates,
    geodesic: true,
    strokeColor: '#FF0000',
    strokeOpacity: 1.0,
    strokeWeight: 2
  });

  flightPath.setMap(map);
}