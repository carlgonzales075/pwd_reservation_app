import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth_convert.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/modules/employee_screen/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/passengers.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/reservations.dart';
import 'package:pwd_reservation_app/modules/shared/drivers/dialogs.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class UserInfo {
  static Future getTripInfo(BuildContext context) async {
    VehicleRouteInfoProvider vehicleRouteInfoProvider = context.read<VehicleRouteInfoProvider>();
    DispatchInfoProvider dispatchInfoProvider = context.read<DispatchInfoProvider>();
    VehicleInfoExtendedProvider vehicleInfoExtendedProvider = context.read<VehicleInfoExtendedProvider>();
    final vehicleInfoExtended = await getVehicleInfoExtended(
      context,
      vehicleRouteInfoProvider.vehicleId as String,
      vehicleRouteInfoProvider.routeId as String,
      dispatchInfoProvider.dispatchId as String,
    );
    if (context.mounted) {
      vehicleInfoExtendedProvider.initVehicleInfoExtended(
        vehicleInfoExtended.vehicleName,
        vehicleInfoExtended.vehiclePlateNumber,
        vehicleInfoExtended.vehicleImageId,
        vehicleInfoExtended.driverUserId,
        vehicleInfoExtended.conductorUserId,
        vehicleInfoExtended.normalSeatsRemaining,
        vehicleInfoExtended.pwdSeatsRemaining,
        vehicleInfoExtended.tripStops,
      );
      VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
        context,
        context.read<EmployeeProvider>().id as String
      );
      if (context.mounted) {
        context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
          vehicleRouteInfo.routeId,
          vehicleRouteInfo.vehicleId,
          vehicleRouteInfo.driverId,
          vehicleRouteInfo.conductorId,
          vehicleRouteInfo.currentStopId,
          vehicleRouteInfo.goingToBusStopId
        );
      }
    }
  }
  
  static Future<dynamic> getUserInfo(BuildContext context) async {
    try {
      if (context.mounted) {
        String accessToken = context.read<CredentialsProvider>().accessToken as String;
        DirectusUser directusUser = DirectusUser(context);
        User user = await directusUser.getUser(accessToken);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false).updateUser(
            userId: user.userId,
            firstName: user.firstName,
            lastName: user.lastName,
            avatar: user.avatar,
            email: user.email,
            role: user.role
          );
          List<String> validRoles = ['Passenger'];
          if (!validRoles.contains(user.role)) {
            Employee employee = await getEmployeeInfo(
              context,
              user.userId
            );
            if (context.mounted) {
              context.read<EmployeeProvider>().initEmployee(
                employee.id,
                employee.isConductor,
                employee.isDriver,
                employee.assignedVehicle
              );
              Passengers passenger = await Passengers.getPassenger(context);
              if (context.mounted) {
                context.read<PassengerProvider>().initPassenger(
                  id: passenger.id,
                  passengerType: passenger.passengerType,
                  disabilityInfo: passenger.disabilityInfo,
                  seatAssigned: passenger.seatAssigned,
                  isWaiting: passenger.isWaiting,
                  isOnRoute: passenger.isOnRoute
                );
                if (context.mounted) {
                  if (passenger.seatAssigned != null) {
                    ReservationInfo reservationInfo = await getReservationInfo(
                      context, passenger.seatAssigned.toString());
                    if (context.mounted) {
                      context.read<ReservationProvider>().initReservation(
                        reservationInfo.seatName,
                        reservationInfo.routeName,
                        reservationInfo.vehicleName,
                        reservationInfo.busStopName,
                        reservationInfo.distance
                      );
                    }
                  }
                }
                if (context.mounted) {
                  if (employee.assignedVehicle != null) {
                    VehicleRouteInfo vehicleRouteInfo = await getVehicleRouteInfo(
                      context,
                      employee.id
                    );
                    if (context.mounted) {
                      context.read<VehicleRouteInfoProvider>().initVehicleRouteInfo(
                        vehicleRouteInfo.routeId,
                        vehicleRouteInfo.vehicleId,
                        vehicleRouteInfo.driverId,
                        vehicleRouteInfo.conductorId,
                        vehicleRouteInfo.currentStopId,
                        vehicleRouteInfo.goingToBusStopId
                      );
                      DispatchInfo dispatchInfo = await getDispatchInfo(
                        context,
                        vehicleRouteInfo.vehicleId as String,
                        vehicleRouteInfo.routeId as String
                      );
                      if (context.mounted) {
                        context.read<DispatchInfoProvider>().initDispatchInfo(
                          dispatchInfo.dispatchId,
                          dispatchInfo.dateOfDispatch
                        );
                        VehicleInfoExtended vehicleInfoExtended = await getVehicleInfoExtended(
                          context,
                          vehicleRouteInfo.vehicleId as String,
                          vehicleRouteInfo.routeId as String,
                          dispatchInfo.dispatchId as String
                        );
                        if (context.mounted) {
                          // print('how this in');
                          context.read<VehicleInfoExtendedProvider>().initVehicleInfoExtended(
                            vehicleInfoExtended.vehicleName,
                            vehicleInfoExtended.vehiclePlateNumber,
                            vehicleInfoExtended.vehicleImageId,
                            vehicleInfoExtended.driverUserId,
                            vehicleInfoExtended.conductorUserId,
                            vehicleInfoExtended.normalSeatsRemaining,
                            vehicleInfoExtended.pwdSeatsRemaining,
                            vehicleInfoExtended.tripStops
                          );
                          LastUpdate hasUpdates = await checkUpdates(
                            context,
                            context.read<VehicleRouteInfoProvider>().vehicleId as String,
                            DateTime.now(),
                            context.read<UserProvider>().userId as String
                          );
                          if (context.mounted) {
                            context.read<LastUpdateProvider>().initNow(
                              hasUpdates.updates,
                              hasUpdates.updates,
                              hasUpdates.showNotif
                            );
                          }
                        }
                      }
                    }
                  }
                }
              }
              // print('${employee.assignedVehicle}');
            }
            return 'Employee';
          } else {
            Passengers passenger = await Passengers.getPassenger(context);
            if (context.mounted) {
              context.read<PassengerProvider>().initPassenger(
                id: passenger.id,
                passengerType: passenger.passengerType,
                disabilityInfo: passenger.disabilityInfo,
                seatAssigned: passenger.seatAssigned,
                isWaiting: passenger.isWaiting,
                isOnRoute: passenger.isOnRoute
              );
            }
            if (context.mounted) {
              if (passenger.seatAssigned != null) {
                ReservationInfo reservationInfo = await getReservationInfo(
                  context, passenger.seatAssigned.toString());
                if (context.mounted) {
                  context.read<ReservationProvider>().initReservation(
                    reservationInfo.seatName,
                    reservationInfo.routeName,
                    reservationInfo.vehicleName,
                    reservationInfo.busStopName,
                    reservationInfo.distance
                  );
                }
              }
            }
            return 'Passenger';
          }
        }
      }
      return 'Passenger';
    } catch (e) {
      if (context.mounted) {
        CustomDialogs.customFatalError(
          context,
          '$e',
          () {}
        );
      }
    }
  }
}
