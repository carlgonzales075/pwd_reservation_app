import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/modules/auth/auth_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/auth/register/register.dart';
import 'package:pwd_reservation_app/modules/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/modules/reservation/drivers/routes.dart';
import 'package:pwd_reservation_app/modules/reservation/reservation.dart';
import 'package:pwd_reservation_app/modules/reservation/select_bus.dart';
// import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          )
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
      return MaterialApp( 
        theme: ThemeData(primarySwatch: Colors.blue), 
        routes: <String, WidgetBuilder> {
          "/": (BuildContext context) => const MainAuthScreen(),
          "/register": (BuildContext context) => const RegisterAuthScreen(),
          "/home": (BuildContext context) => const HomeScreen(),
          "/reservation": (BuildContext context) => const ReservationScreen(),
          "/select-bus": (BuildContext context) => const SelectBusScreen()
        }
      ); 
   } 
} 

  // @override 
  // Widget build(BuildContext context) {
  //     return Scaffold(
  //        appBar: AppBar(title: Text(title),), 
  //        body: ListView(
  //         shrinkWrap: true,
  //         padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
  //         children: const <Widget>[
  //           ProductBox(
  //             name: "iPhone", 
  //             description: "iPhone is the stylist phone ever", 
  //             price: 1000, 
  //             image: "test.jpg"
  //           )
  //         ],
  //        ), 
  //     ); 
  //  }

// class ProductBox extends StatelessWidget {
//   const ProductBox({
//     super.key,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image
//   });
//   final String name;
//   final String description;
//   final int price;
//   final String image;

//   @override
//   Widget build (BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(2),
//       height: 120,
//       child: Card(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Image.asset("appimages/$image"),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(5),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Text(
//                       name,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     Text(description),
//                     Text("Price: $price")
//                   ],
//                 ),
//               )
//             )
//           ],
//         )
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String _response = '';

//   Future<void> fetchData() async {
//     const String url = 'http://172.28.144.1:8080/items/vehicles';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       setState(() {
//         _response = response.body;
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('API Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: fetchData,
//               child: const Text('Fetch Data'),
//             ),
//             const SizedBox(height: 20),
//             Text(_response),
//           ],
//         ),
//       ),
//     );
//   }
// }
