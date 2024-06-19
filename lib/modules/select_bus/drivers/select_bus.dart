import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/seat_assignment.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/stops.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/vehicles.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';

Future<void> selectBus(BuildContext context, Vehicles vehicle) async {
  try {
    // print('asd dsf');
    PassengerSeatAssignment seatAssignment = await postSeatReservation(
      context,
      vehicle.getNestedValue('vehicle_id.id'),
      context.read<StopsProvider>().pickUpId as String,
      context.read<StopsProvider>().destinationId as String,
      context.read<PassengerProvider>().disabilityInfo
    );
    
    if (context.mounted) {
      // print(seatAssignment.seatAssigned);
      if (seatAssignment.seatAssigned == null) {
        if (context.read<PassengerProvider>().disabilityInfo != null) {
          CustomDialogs.customDecisionDialog(
            context,
            'Sit on Non-Priority Seat?',
            'No PWD Seats are Available on this bus. Would you like to be seated on a non-priority seat instead?',
            () async {
              await selectBusSecond(context, vehicle);
            }
          );
        } else {
          CustomDialogs.customErrorDialog(
            context,
            'No Available Seats',
            'No available seats for your passenger type. Please select another bus.'
          );
        }
      } else {
        ReservationInfo reservationInfo = await getReservationInfo(
          context,
          seatAssignment.seatAssigned as String,
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
          CustomDialogs.customInfoDialog(
            context,
            'Booking Successful!',
            'You are now booked for a ride!',
            () {
              Navigator.pushReplacementNamed(context, '/home');
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

Future<void> selectBusSecond(BuildContext context, Vehicles vehicle) async {
  try {
    // print('asd dsf');
    PassengerSeatAssignment seatAssignment = await postSeatReservation(
      context,
      vehicle.getNestedValue('vehicle_id.id'),
      context.read<StopsProvider>().pickUpId as String,
      context.read<StopsProvider>().destinationId as String,
      null
    );
    
    if (context.mounted) {
      // print(seatAssignment.seatAssigned);
      if (seatAssignment.seatAssigned == null) {
        if (context.read<PassengerProvider>().disabilityInfo != null) {
          CustomDialogs.customErrorDialog(
            context,
            'No Available Seats',
            'No available seats for your passenger type. Please select another bus.'
          );
        }
      } else {
        ReservationInfo reservationInfo = await getReservationInfo(
          context,
          seatAssignment.seatAssigned as String,
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
          CustomDialogs.customInfoDialog(
            context,
            'Booking Successful!',
            'You are now booked for a ride!',
            () {
              Navigator.pushReplacementNamed(context, '/home');
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