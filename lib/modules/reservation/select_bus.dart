import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';

class SelectBusScreen extends StatelessWidget {
  const SelectBusScreen({super.key});

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus',
          style: TextStyle(
            color: CustomThemeColors.themeWhite
          )
        ),
        backgroundColor: CustomThemeColors.themeBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<StopsProvider>(builder: (context, stops, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${stops.stopNameDestination}'),
                  const Icon(Icons.chevron_right_sharp),
                  Text('${stops.stopNamePickUp}')
                ],
              ),
            );
          },),
          Consumer<StopsProvider>(builder: (context, stops, child) {
            return FutureBuilder<List<Vehicles>>(
            future: postVehicles(
              context.read<CredentialsProvider>().accessToken as String,
              stops.pickupId,
              stops.destinationId
            ),
            builder: (BuildContext context, AsyncSnapshot<List<Vehicles>> snapshot) {
              if (snapshot.hasData) {
                // return Text('${snapshot.data}');
                return BusCarousel(
                  carouselItems: snapshot.data as List<Vehicles>,
                  itemBuilder: (context, vehicle) {
                    final vehicleImagePath = vehicle.getNestedValue('vehicle_id.vehicle_image');
                    return BusCarouselItem(vehicle: vehicle, vehicleImagePath: vehicleImagePath);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}, ${stops.destinationId}, ${stops.pickupId}');
              }

              return const CircularProgressIndicator();
            });
          })
        ],
      )
    );
  }
}

class BusCarouselItem extends StatelessWidget {
  const BusCarouselItem({
    super.key,
    required this.vehicle, required this.vehicleImagePath,
  });

  final Vehicles vehicle;
  final String vehicleImagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: BusImage(assetId: vehicleImagePath)
    );
  }
}

class BusCarousel extends StatefulWidget {
  const BusCarousel({
    super.key,
    required this.carouselItems,
    required this.itemBuilder,
  });
  final List<Vehicles> carouselItems;
  final Widget Function(BuildContext, Vehicles) itemBuilder;

  @override
  State<BusCarousel> createState() => _BusCarousel();
}

class _BusCarousel extends State<BusCarousel> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.carouselItems.map((vehicle) {
        try {
          return widget.itemBuilder(context, vehicle);
        } catch (e) {
          return Text('Error: ${e.toString()}');
        }
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(milliseconds: 10000),
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        viewportFraction: 0.8,
      ),
    );
  }
}