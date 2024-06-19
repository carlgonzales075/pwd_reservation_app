import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/vehicles.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({
    super.key,
    required this.vehicle
  });

  final Vehicles vehicle;

  @override
  Widget build (BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BusImage(assetId: vehicle.getNestedValue('vehicle_id.vehicle_image')),
          RowDesc(
              title: 'Plate Number',
              desc: vehicle.getNestedValue('vehicle_id.vehicle_plate_number'),
              color: CustomThemeColors.themeBlue,
              visible: true,
            ),
            RowDesc(
              title: 'Route',
              desc: vehicle.getNestedValue('route_id.route_name'),
              color: CustomThemeColors.themeBlue,
              visible: true,
            ),
            RowDesc(
              title: 'Current Stop',
              desc: vehicle.getNestedValue('current_stop.stop_name') ?? 'In Transit to ${
                vehicle.getNestedValue('going_to_bus_stop.stop_name')}',
              color: vehicle.getNestedValue('current_stop.stop_name') == null ?
                Colors.green : CustomThemeColors.themeBlue,
              visible: true,
            ),
            RowDesc(
              title: 'Remaining PWD Seats',
              desc: '${vehicle.getNestedValue('vehicle_id.remaining_pwd_seats')}',
              color: vehicle.getNestedValue('vehicle_id.remaining_pwd_seats') > 0 ? 
                CustomThemeColors.themeBlue : Colors.red,
              visible: true,
            ),
            RowDesc(
              title: 'Remaining Normal Seats',
              desc: '${vehicle.getNestedValue('vehicle_id.remaining_normal_seats')}',
              color: vehicle.getNestedValue('vehicle_id.remaining_normal_seats') > 0 ? 
                CustomThemeColors.themeBlue : Colors.red,
              visible: true,
            ),
            RowDesc(
              title: 'Arriving After',
              desc: '${vehicle.getNestedValue('distance')} Bus Stops',
              color:CustomThemeColors.themeBlue,
              visible: true,
            ),
            RowDesc(
              title: 'Fare Amount',
              desc: 'PHP ${double.parse(
                vehicle.getNestedValue('amounts.fare_amount').toString()
              ).toStringAsFixed(2)}',
              color: vehicle.getNestedValue('amounts.discount') == 0 ? CustomThemeColors.themeBlue : Colors.green,
              visible: true,
            ),
            RowDesc(
              title: 'PWD/SC Discount',
              desc: 'PHP ${double.parse(
                vehicle.getNestedValue('amounts.discount').toString()
              ).toStringAsFixed(2)}',
              color:Colors.green,
              visible: vehicle.getNestedValue('amounts.discount') > 0,
            )
        ],
      ),
    );
  }
}

class RowDesc extends StatelessWidget {
  const RowDesc({
    super.key,
    required this.title,
    required this.desc,
    required this.color,
    required this.visible
  });

  final String title;
  final String desc;
  final Color color;
  final bool visible;

  @override
  Widget build (BuildContext context) {
    return Visibility(
      visible: visible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('$title :'),
          Text(desc, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color
          )),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}