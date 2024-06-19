import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:pwd_reservation_app/modules/shared/drivers/apis.dart';

class StopsProvider extends ChangeNotifier {
  String? stopNameDestination;
  int? destinationIndex;
  String? destinationId;
  String? stopNamePickUp;
  int? pickUpIndex;
  String? pickUpId;
  String? destinationPointLocation;
  String? pickUpPointLocation;
  List<Map<String, GeoPoint>>? inBetween;

  void updateDestination({
    required String? stopNameDestination,
    required String? destinationId,
    required int? destinationIndex,
    required String? destinationPointLocation
  }) {
    this.stopNameDestination = stopNameDestination;
    this.destinationId = destinationId;
    this.destinationIndex = destinationIndex;
    this.destinationPointLocation = destinationPointLocation;
    notifyListeners();
  }

  List<GeoPoint> getIntersections() {
    List<GeoPoint> geoPointList = [];
    for (int i = 0; i < inBetween!.length; i++) {
      geoPointList.add(inBetween![i].values.first);
    }
    return geoPointList;
  }

  void updatePickUp({
    required String? stopNamePickUp,
    required String? pickUpId,
    required int? pickUpIndex,
    required String? pickUpPointLocation
  }) {
    this.stopNamePickUp = stopNamePickUp;
    this.pickUpId = pickUpId!;
    this.pickUpIndex = pickUpIndex;
    this.pickUpPointLocation = pickUpPointLocation;
    notifyListeners();
  }

  void updateInBetween({
    required List<Map<String, GeoPoint>>? inBetween
  }) {
    this.inBetween = inBetween;
  }

  void resetDestination() {
    stopNameDestination = null;
    destinationIndex = null;
    destinationId = null;
    destinationPointLocation = null;
    inBetween = null;
    notifyListeners();
  }

  void resetPickup() {
    stopNamePickUp = null;
    pickUpIndex = null;
    pickUpId = null;
    pickUpPointLocation = null;
    inBetween = null;
    notifyListeners();
  }

  void resetValues() {
    stopNameDestination = null;
    destinationIndex = null;
    destinationId = null;
    stopNamePickUp = null;
    pickUpIndex = null;
    pickUpId = null;
    destinationPointLocation = null;
    pickUpPointLocation = null;
    inBetween = null;
    notifyListeners();
  }
}

class Stops {
  String? id;
  String? stopName;
  String? stopPointLocation;

  Stops(
    this.id,
    this.stopName,
    this.stopPointLocation
  );

  Stops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stopName = json['stop_name'];
    stopPointLocation = json['stop_point_location'];
  }
}

Future<List<Stops>> getStops(BuildContext context) async {
  final domain = DirectusCalls.getBasics(context)[0];
  final accessToken = DirectusCalls.getBasics(context)[1];

  Future<http.Response> getStopsFunction() async {
    var url = Uri.parse(
      '$domain/items/stops?fields=id,stop_name,'
      'stop_point_location&filter[status][_eq]=published&sort=-sort'
    );
    final response = await http.get(
      url,
      headers: <String, String> {
        "Authorization": "Bearer $accessToken"
      }
    );
    return response;
      // print(responseData['data']);
  }
  final responseBody = await DirectusCalls.apiCall(
    context,
    getStopsFunction(),
    'Get Stops',
    (error) {},
    processingTitle: 'Getting Stops...',
    showModal: false
  );
  final List responseData = json.decode(responseBody)['data'];
  return responseData.map((e) => Stops.fromJson(e)).toList();
}
