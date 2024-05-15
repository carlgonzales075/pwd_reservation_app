import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/modules/auth/auth_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/dispatch_info.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/employee.dart';
import 'package:pwd_reservation_app/modules/auth/register/register.dart';
import 'package:pwd_reservation_app/modules/auth/register/register_upload.dart';
import 'package:pwd_reservation_app/modules/domain/domain.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/partner_employee.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/screen_change.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_info_extended.dart';
import 'package:pwd_reservation_app/modules/employee/drivers/vehicle_route_info.dart';
import 'package:pwd_reservation_app/modules/employee/employee_screen.dart';
import 'package:pwd_reservation_app/modules/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/bus_selected.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/reservation/reservation.dart';
import 'package:pwd_reservation_app/modules/reservation/select_bus.dart';
import 'package:pwd_reservation_app/modules/shared/config/env_config.dart';
// import 'package:camera/camera.dart';

// late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();
  runApp(
    MultiProvider(
      providers: [
          ChangeNotifierProvider(
            create: (context) => CredentialsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => StopsProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => PassengerProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => ReservationProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => DomainProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => EmployeeProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => EmployeeScreenSwitcher()
          ),
          ChangeNotifierProvider(
            create: (context) => VehicleRouteInfoProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => DispatchInfoProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => VehicleInfoExtendedProvider()
          ),
          ChangeNotifierProvider(
            create: (context) => PartnerEmployeeProvider()
          ),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   // This widget is the root of your application.
   @override 
   Widget build(BuildContext context) {
      // context.read<CameraProvider>().updateCameras(_cameras);
      return MaterialApp( 
        theme: ThemeData(primarySwatch: Colors.blue), 
        routes: <String, WidgetBuilder> {
          "/": (BuildContext context) => const MainAuthScreen(),
          "/employee-home": (BuildContext context) => const EmployeeHomeScreen(),
          "/register": (BuildContext context) => const RegisterAuthScreen(),
          "/register-upload": (BuildContext context) => const UploadScreen(),
          "/home": (BuildContext context) => const HomeScreen(),
          "/reservation": (BuildContext context) => const ReservationScreen(),
          "/select-bus": (BuildContext context) => const SelectBusScreen(),
          "/domain": (BuildContext context) => const DomainScreen()
        }
      ); 
   } 
} 