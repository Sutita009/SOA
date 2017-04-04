

function initAutocomplete() {
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {
			//ตั้งค่าไว้ที่ phuket
            lat: 7.89059,
            lng: 98.398102
        },
        zoom: 10,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    // สร้าง search box
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

    // แสดงผลลัพธ์ของ searchbox
    map.addListener('bounds_changed', function () {
        searchBox.setBounds(map.getBounds());
    });

    var markers = [];
  
    searchBox.addListener('places_changed', function () {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // Clear out the old markers
        markers.forEach(function (marker) {
            marker.setMap(null);
        });
        markers = [];

        // For each place, get the icon, name and location
        var bounds = new google.maps.LatLngBounds();
        places.forEach(function (place) {
            var icon = {
                url: place.icon,
                size: new google.maps.Size(50, 50),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(25, 25)
            };
            // Create a marker for each place
            markers.push(new google.maps.Marker({
                map: map,
                icon: icon,
                title: place.name,
                position: place.geometry.location
            }));

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
            makeWeatherRequest(place.name);
            makeYoutubeRequest(place.geometry.location);
        });


        map.fitBounds(bounds);
    });
    // [END region_getplaces]

}

function onLoadCallback() {
    gapi.client.setApiKey("AIzaSyCmkV7mh-Q4f7xOlhJsSDCjqNnDBzhyeis");
    
}

function httpGetAsync(theUrl, callback) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
            callback(xmlHttp.responseText);
    }
    xmlHttp.open("GET", theUrl, true); // true for asynchronous 
    xmlHttp.send(null);
}

function makeWeatherRequest(city) {
    var url = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=b2f0443c1e0a7024b0b5f08e8535792c&units=metric";
    httpGetAsync(url, function (res) {
		//get value of weather
        var json = JSON.parse(res);
        document.querySelector('.name').innerHTML = json.name;
        document.querySelector('.weatherMain').innerHTML = json.weather[0].main;
        document.querySelector('.temp').innerHTML = 'temperature ' + json.main.temp + ' Celsius';
        document.querySelector('.pressure').innerHTML = 'pressure ' + json.main.pressure + ' hPa';
        document.querySelector('.humidity').innerHTML = 'Humidity ' + json.main.humidity + '%';
		
		
    });
}


f