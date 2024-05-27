import 'package:flutter/material.dart';

import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/images.dart';
import 'package:pwd_reservation_app/modules/shared/widgets/widgets_module.dart';

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
                  Text('${stops.stopNamePickUp}'),
                  const Icon(Icons.chevron_right_sharp),
                  Text('${stops.stopNameDestination}')
                ],
              ),
            );
          }),
          Consumer<StopsProvider>(builder: (context, stops, child) {
            // print(context.read<PassengerProvider>().passengerType);
            return FutureBuilder<List<Vehicles>>(
            future: postVehicles(
              context.read<CredentialsProvider>().accessToken as String,
              stops.pickupId as String,
              stops.destinationId as String,
              context.read<DomainProvider>().url as String,
              context.read<PassengerProvider>().passengerType != 'Normal'
            ),
            builder: (BuildContext context, AsyncSnapshot<List<Vehicles>> snapshot) {
              if (snapshot.hasData) {
                // return Text('${snapshot.data}');
                if (snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      RichText(text: TextSpan(
                        text: 'Nice! We found ',
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${snapshot.data!.length} ',
                            style: const TextStyle(color: CustomThemeColors.themeBlue,
                              fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                            text: '${snapshot.data!.length == 1 ? 'bus': 'buses'} along your way!',
                            style: const TextStyle(color: Colors.black),
                          )
                        ])
                      ),
                      BusCarouselSliderGroup(snapshot: snapshot),
                    ],
                  );
                } else {
                  return Flexible(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset('assets/images/1791330.png'),
                          const Text(
                            'We are very sorry!!!',
                            style: TextStyle(
                              fontSize: 24,
                              color: CustomThemeColors.themeBlue,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const Text(
                            'We currently have no buses along this route :(((',
                            style: TextStyle(
                              fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
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

class BusCarouselSliderGroup extends StatefulWidget {
  const BusCarouselSliderGroup({
    super.key,
    required this.snapshot
  });

  final AsyncSnapshot snapshot;

  @override
  State<BusCarouselSliderGroup> createState() => _BusCarouselSliderGroupState();
}

class _BusCarouselSliderGroupState extends State<BusCarouselSliderGroup> {
  final CarouselController _controller1 = CarouselController();
  final CarouselController _controller2 = CarouselController();
  bool isNextVisible = true;
  bool isPrevVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BusCarousel(
          carouselItems: widget.snapshot.data as List<Vehicles>,
          itemBuilder: (context, vehicle) {
            final vehicleImagePath = vehicle.getNestedValue('vehicle_id.vehicle_image');
            return BusCarouselItem(vehicleImagePath: vehicleImagePath);
          },
          carouselController: _controller1,
        ),
        BusCarouselDesc(
          carouselItems: widget.snapshot.data as List<Vehicles>,
          itemBuilder: (context, vehicle) {
            return BusCarouselItemDesc(vehicle: vehicle);
          },
          carouselController: _controller2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isNextVisible,
            child: ElevatedButton(
              onPressed: () {
                _controller1.nextPage();
                _controller2.nextPage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomThemeColors.themeLightBlue,
                foregroundColor: CustomThemeColors.themeWhite,
                minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                )
              ),
              child: const Text('Next Bus'),
            ),
          ),
        )
      ],
    );
  }
}

class BusCarouselItem extends StatelessWidget {
  const BusCarouselItem({
    super.key,
    required this.vehicleImagePath,
  });

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
    required this.carouselController
  });
  final List<Vehicles> carouselItems;
  final Widget Function(BuildContext, Vehicles) itemBuilder;
  final CarouselController carouselController;

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
        autoPlay: false,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enlargeFactor: 1.4
      ),
      carouselController: widget.carouselController,
    );
  }
}

class BusCarouselItemDesc extends StatelessWidget {
  const BusCarouselItemDesc({
    super.key,
    required this.vehicle
  });

  final Vehicles vehicle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BasicElevatedButton(
              buttonText: 'Select ${vehicle.getNestedValue('vehicle_id.vehicle_name')}',
              onPressed: () async {
                try {
                  // print('asd dsf');
                  PassengerSeatAssignment seatAssignment = await postSeatReservation(
                    context,
                    context.read<CredentialsProvider>().accessToken as String,
                    vehicle.getNestedValue('vehicle_id.id'),
                    context.read<StopsProvider>().pickupId as String,
                    context.read<StopsProvider>().destinationId as String,
                    context.read<DomainProvider>().url as String
                  );
                  
                  if (context.mounted) {
                    print(seatAssignment.seatAssigned);
                    if (seatAssignment.seatAssigned == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('No Available Seats'),
                            content: const Text(
                              'No available seats for your passenger type. Please select another bus.'
                            ),
                            alignment: Alignment.center,
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: CustomThemeColors.themeBlue,
                                  foregroundColor: CustomThemeColors.themeWhite
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK')
                              )
                            ],
                          );
                        }
                      );
                    } else {
                      ReservationInfo reservationInfo = await getReservationInfo(
                        context.read<CredentialsProvider>().accessToken as String,
                        seatAssignment.seatAssigned as String,
                        context.read<DomainProvider>().url as String
                      );

                      if (context.mounted) {
                        // print('asd dsf');
                        context.read<ReservationProvider>().initReservation(
                          reservationInfo.seatName,
                          reservationInfo.routeName,
                          reservationInfo.vehicleName,
                          reservationInfo.busStopName,
                          reservationInfo.distance
                        );
                        context.read<PassengerProvider>().assignSeat(
                          seatAssigned: seatAssignment.seatAssigned as String, 
                          isWaiting: seatAssignment.isWaiting as bool
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Booking Successful!'),
                              content: const Text('You are now booked for a ride!'),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.pushNamed(context, '/home');
                                  },
                                ),
                              ],
                            );
                          }
                        );
                      }
                    }
                    
                  }
                } catch (e) {
                  // Handle any errors that occurred during the seat reservation
                  throw Exception('Error: $e');
                }
              }
            ),
          ),
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
            desc: 'PHP ${vehicle.getNestedValue('amounts.fare_amount')}',
            color:vehicle.getNestedValue('amounts.discount') == 0 ? CustomThemeColors.themeBlue : Colors.green,
            visible: true,
          ),
          RowDesc(
            title: 'PWD/SC Discount',
            desc: 'PHP ${vehicle.getNestedValue('amounts.discount')}',
            color:Colors.green,
            visible: vehicle.getNestedValue('amounts.discount') > 0,
          )
        ],
      )
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('$title :'),
          Text(desc, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color
          ))
        ],
      ),
    );
  }
}

class BusCarouselDesc extends StatefulWidget {
  const BusCarouselDesc({
    super.key,
    required this.carouselItems,
    required this.itemBuilder,
    required this.carouselController
  });
  final List<Vehicles> carouselItems;
  final Widget Function(BuildContext, Vehicles) itemBuilder;
  final CarouselController carouselController;

  @override
  State<BusCarouselDesc> createState() => _BusCarouselDesc();
}

class _BusCarouselDesc extends State<BusCarouselDesc> {
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
        autoPlay: false,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enlargeFactor: 1.4,
        height: 260
      ),
      carouselController: widget.carouselController,
    );
  }
}