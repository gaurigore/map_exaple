import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  String address;

  MapPage({required this.address});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  Set<Marker> markers = {};
  LatLng _coordinates = const LatLng(37.4219999, -122.0840575);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Map View",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
                viewPosition();
              },
              initialCameraPosition: CameraPosition(
                target: _coordinates ?? LatLng(37.4219999, -122.0840575),
                zoom: 14.4746,
              ),
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }

  Future<LatLng> getCoordinates(String address) async {
    // Make a request to the geocoding API
    final response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${dotenv.get('API_KEY')}"));

    // Parse the JSON response
    final json = jsonDecode(response.body);

    // Extract the latitude and longitude from the JSON
    final lat = json['results'][0]['geometry']['location']['lat'];
    final lng = json['results'][0]['geometry']['location']['lng'];

    // Return the coordinates
    return LatLng(lat, lng);
  }

  Future<String> getAddress(LatLng coordinates) async {
    // Make a request to the reverse geocoding API
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=${dotenv.get('API_KEY')}'));

    // Parse the JSON response
    final json = jsonDecode(response.body);

    // Extract the formatted address from the JSON
    final address = json['results'][0]['formatted_address'];

    // Return the address
    return address;
  }

  viewPosition() {
    getCoordinates(widget.address).then((coordinates) {
      setState(() {
        _coordinates = coordinates;
        markers.add(Marker(
            markerId: (MarkerId(widget.address)),
            position: _coordinates,
            onTap: () async {
              String addr = await getAddress(coordinates);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Address'),
                    content: Text(addr),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }));

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _coordinates,
              zoom: 14.4746,
            ),
          ),
        );
      });
    });
  }
}
