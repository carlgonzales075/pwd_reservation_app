import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/auth/drivers/auth.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/drivers/verify.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/verify_form.dart';

class VerifyPWDScreen extends StatefulWidget {
  const VerifyPWDScreen({super.key});

  @override
  State<VerifyPWDScreen> createState() => _VerifyPWDScreenState();
}

class _VerifyPWDScreenState extends State<VerifyPWDScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify PWD'),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              DirectusAuth directusAuth = DirectusAuth(context);
              directusAuth.logOutDialog(context);
            },
            icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: DirectusVerification.getVerifyRequests(
            context,
            limitQuery: 10,
            pageQuery: 1
          ),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              final data = snapshot.data;
              if (data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 80,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No pending requests from passengers yet.',
                          style: TextStyle(
                            color: CustomThemeColors.themeBlue
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final userInfo = data[index]['passenger_id']['user_id'];
                    final DateTime dateCreated = DateTime.parse(data[index]['date_created']);
                    final dateFormatted = DateFormat('MMM dd, yyyy hh:mm').format(dateCreated);
                    return ListTile(
                      isThreeLine: true,
                      title: Text(
                        '${userInfo['first_name']} ${userInfo['last_name']}',
                        style: const TextStyle(
                          color: CustomThemeColors.themeBlue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Request on: ',
                          style: const TextStyle(
                            color: Colors.black87
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: dateFormatted.toString(),
                              style: const TextStyle(
                                color: CustomThemeColors.themeBlue
                              )
                            )
                          ]
                        ),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomThemeColors.themeBlue,
                          foregroundColor: CustomThemeColors.themeWhite
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => VerifyForm(
                                fullName: '${userInfo['first_name']} ${userInfo['last_name']}',
                                frontId: data[index]['id_image_front'],
                                backId: data[index]['id_image_back'],
                                selfie: data[index]['id_selfie'],
                                disabilityInfo: data[index]['passenger_id']['disability_info'],
                                rfidNo: data[index]['passenger_id']['rfid_tag'],
                                processingId: data[index]['id'],
                                passengerId: data[index]['passenger_id']['id'],
                              )
                            )
                          );
                        },
                        child: const Text('View'),
                      ),
                    );
                  }
                );
              }
            }
          }
        ),
      ),
    );
  }
}