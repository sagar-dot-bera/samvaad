import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:samvaad/core/services/location_service.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';
import 'package:http/http.dart' as http;

class LocationLoader extends StatefulWidget {
  const LocationLoader({super.key, required this.message});
  final Message message;

  @override
  State<LocationLoader> createState() => _LocationLoaderState();
}

class _LocationLoaderState extends State<LocationLoader> {
  LatLng getLatng(String data) {
    Map<String, dynamic> latLong = jsonDecode(data);
    log("location loader lat ${latLong['lat']} ${latLong["lng"]}");

    double latData = double.tryParse(latLong['lat']!)!;
    double longData = double.tryParse(latLong['lng']!)!;
    return LatLng(latData, longData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: SizeOf.intance.getHight(context, 0.50),
          height: SizeOf.intance.getHight(context, 0.20),
          child: FlutterMap(
            options: MapOptions(
                initialCenter: getLatng(widget.message.content!),
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
                    point: getLatng(widget.message.content!),
                    width: 26,
                    height: 26,
                    child:
                        Icon(Icons.location_pin, color: Colors.red, size: 26),
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        OutlinedButton(
          onPressed: () {
            final latLng = getLatng(widget.message.content!);
            getIt<AppRouter>().push(
                LocationViewRoute(lat: latLng.latitude, log: latLng.longitude));
          },
          child: Text("View Map"),
        )
      ],
    );
  }
}
