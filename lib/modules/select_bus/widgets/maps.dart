import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/select_bus/drivers/geopoint_convert.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;

  Future _addMarker(String geoPointString, String stopName) async {
    await mapController.addMarker(
      convertPointToGeoPoint(geoPointString.toString()),
      markerIcon: MarkerIcon(
        iconWidget: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              color: Colors.white,
              child: Text(
                stopName.toString(),
                style: const TextStyle(
                  color: CustomThemeColors.themeBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(
              Icons.place,
              color: Colors.green,
              size: 48,
            ),
          ],
        ),
      ),
    );
  }

  Future _establishZoom(GeoPoint point1, GeoPoint point2) async {
    mapController.zoomToBoundingBox(
      BoundingBox.fromGeoPoints([point1, point2]),
      paddinInPixel: 300
    );
  }

  GeoPoint _calculateCenterPoint(GeoPoint p1, GeoPoint p2) {
    double centerLatitude = (p1.latitude + p2.latitude) / 2;
    double centerLongitude = (p1.longitude + p2.longitude) / 2;
    return GeoPoint(latitude: centerLatitude, longitude: centerLongitude);
  }

  Future<RoadInfo> _drawRoad(GeoPoint start, GeoPoint end) async {
    return await mapController.drawRoad(
      start,
      end,
      roadType: RoadType.car,
      roadOption: const RoadOption(
        roadColor: CustomThemeColors.themeBlue,
        roadWidth: 20
      ),
    );
  }

  Future<void> _setupMarkerAndZoom(StopsProvider stops) async {
    await _addMarker(
      stops.pickUpPointLocation.toString(),
      stops.stopNamePickUp.toString()
    );
    await _addMarker(
      stops.destinationPointLocation.toString(),
      stops.stopNameDestination.toString()
    );
    await _drawRoad(
      convertPointToGeoPoint(stops.destinationPointLocation.toString()),
      convertPointToGeoPoint(stops.pickUpPointLocation.toString()),
    );
    await _establishZoom(
      convertPointToGeoPoint(stops.destinationPointLocation.toString()),
      convertPointToGeoPoint(stops.pickUpPointLocation.toString()),
    );
  }

  @override
  void initState() {
    super.initState();
    StopsProvider stops = context.read<StopsProvider>();
    mapController = MapController(
      initPosition: _calculateCenterPoint(
        convertPointToGeoPoint(stops.pickUpPointLocation.toString()),
        convertPointToGeoPoint(stops.destinationPointLocation.toString())
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<StopsProvider>(
      builder: (context, stops, child) {
        return OSMFlutter(
          controller: mapController,
          osmOption: OSMOption(
            zoomOption: const ZoomOption(initZoom: 16),
            markerOption: MarkerOption(
              defaultMarker: const MarkerIcon(
                icon: Icon(
                  Icons.place,
                  color: Colors.blue,
                  size: 48,
                ),
              ),
            ),
          ),
          onMapIsReady: (bool isReady) async {
            if (isReady) {
              _setupMarkerAndZoom(stops);
            }
          },
        );
      }
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Intramuros, Manila'),
//       ),
//       body: OSMFlutter(
//         controller: MapController(
//           initMapWithUserPosition: const UserTrackingOption(enableTracking: true),
//         ),
//         osmOption: OSMOption(
//           markerOption: MarkerOption(
//             defaultMarker: const MarkerIcon(
//               icon: Icon(
//                 Icons.place,
//                 color: Colors.blue,
//                 size: 48,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
