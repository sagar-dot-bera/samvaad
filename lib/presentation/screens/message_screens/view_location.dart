import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:samvaad/core/services/location_service.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/router.dart';

@RoutePage()
class LocationViewScreen extends StatefulWidget {
  const LocationViewScreen({super.key, required this.lat, required this.log});
  final double lat;
  final double log;

  @override
  State<LocationViewScreen> createState() => _LocationViewScreenState();
}

class _LocationViewScreenState extends State<LocationViewScreen> {
  late LatLng awayUser;
  late LatLng user;
  List<LatLng> routePoints = [];
  LocationHandler locationHandler = LocationHandler();
  bool isLoading = false;

  Future<void> fetchRoute() async {
    setState(() {
      isLoading = true;
    });
    awayUser = LatLng(widget.lat, widget.log);
    final currenUserLocation =
        await locationHandler.getCurrentLocation().catchError((error) {
      getIt<AppRouter>().maybePop();
      log("on catch fired");
      if (error.toString().contains("service not")) {
        log("location service is off");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Enable location"),
                content: Text(
                    "Enable location service to share location from you phone"),
              );
            });
      } else if (error.toString().contains("permission denied")) {
        log("permission denied");
      } else if (error.toString().contains(" we cannot request permissions")) {
        log(" we cannot request permissions");
      }
      return null;
    });
    if (currenUserLocation != null) {
      user = LatLng(currenUserLocation.latitude, currenUserLocation.longitude);
      final url = Uri.parse(
          "https://router.project-osrm.org/route/v1/driving/${awayUser.longitude},${awayUser.latitude};${user.longitude},${user.latitude}?geometries=geojson");

      final response = await http.get(url);
      log(" ${awayUser.latitude} ${user.latitude}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        log("${jsonData}");
        final coordinates = jsonData["routes"][0]["geometry"]["coordinates"];

        if (jsonData["routes"].isEmpty ||
            jsonData["routes"][0]["geometry"]["coordinates"].isEmpty) {
          log("No route found!");

          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("No Route Found"),
                content:
                    Text("Cannot generate a route for the given locations."),
              );
            },
          );
          return;
        }
        log("${coordinates}");
        setState(() {
          isLoading = false;
          routePoints = coordinates
              .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          isLoading ? LinearProgressIndicator() : SizedBox(),
          Expanded(
            child: FlutterMap(
                options: MapOptions(
                    initialCenter: LatLng(widget.lat, widget.log),
                    initialZoom: 13),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(widget.lat, widget.log),
                        width: 80,
                        height: 80,
                        child: Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      )
                    ],
                  ),
                  routePoints.isNotEmpty
                      ? PolylineLayer(
                          polylines: [
                            Polyline(
                              points: routePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
                        )
                      : SizedBox()
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await fetchRoute();
          },
          label: Text("Find route")),
    );
  }
}
