import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/dispatch/drivers/dispatch.dart';

class RouteListBuilder extends StatelessWidget {
  const RouteListBuilder({
    super.key,
    required this.controller,
    required this.subController,
    required this.titleKey,
    required this.icon
  });

  final TextEditingController controller;
  final TextEditingController subController;
  final String titleKey;
  final IconData icon;

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: DirectusDispatch.getRoutes(
          context,
          limitQuery: 10,
          pageQuery: 1
        ),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            final data = snapshot.data;
            if (data != null) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListTile(
                      tileColor: Colors.lightBlue[50],
                      leading: Icon(
                        icon,
                        color: CustomThemeColors.themeBlue,
                      ),
                      onTap: () {
                        controller.text = data[index]['route_name'];
                        subController.text = data[index]['id'];
                        Navigator.pop(context);
                      },
                      title: Text(
                        data[index][titleKey],
                        style: const TextStyle(
                          color: CustomThemeColors.themeBlue
                        ),
                      ),
                    ),
                  );
                }
              );
            } else {
              return const Center(child: Text('No routes loaded yet.'));
            }
          }
        }
      ),
    );
  }
}

class DriversListBuilder extends StatelessWidget {
  const DriversListBuilder({
    super.key,
    required this.controller,
    required this.subController
  });

  final TextEditingController controller;
  final TextEditingController subController;

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: DirectusDispatch.getDrivers(
          context,
          limitQuery: 10,
          pageQuery: 1
        ),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            final data = snapshot.data;
            if (data != null) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final userInfo = data[index]['user_id'];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListTile(
                      tileColor: Colors.lightBlue[50],
                      leading: const Icon(
                        Icons.personal_injury_rounded,
                        color: CustomThemeColors.themeBlue,
                      ),
                      onTap: () {
                        controller.text = '${userInfo['first_name']} ${userInfo['last_name']}';
                        subController.text = data[index]['id'];
                        Navigator.pop(context);
                      },
                      title: Text(
                        '${userInfo['first_name']} ${userInfo['last_name']}',
                        style: const TextStyle(
                          color: CustomThemeColors.themeBlue
                        ),
                      ),
                      subtitle: const Text('Driver'),
                    ),
                  );
                }
              );
            } else {
              return const Center(child: Text('No driver/conductor is vacant now.'));
            }
          }
        }
      ),
    );
  }
}

class ConductorsListBuilder extends StatelessWidget {
  const ConductorsListBuilder({
    super.key,
    required this.controller,
    required this.subController
  });

  final TextEditingController controller;
  final TextEditingController subController;

  @override
  Widget build (BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: DirectusDispatch.getConductors(
          context,
          limitQuery: 10,
          pageQuery: 1
        ),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            final data = snapshot.data;
            if (data != null) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final userInfo = data[index]['user_id'];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: ListTile(
                      tileColor: Colors.lightBlue[50],
                      leading: const Icon(
                        Icons.people_sharp,
                        color: CustomThemeColors.themeBlue,
                      ),
                      onTap: () {
                        controller.text = '${userInfo['first_name']} ${userInfo['last_name']}';
                        subController.text = data[index]['id'];
                        Navigator.pop(context);
                      },
                      title: Text(
                        '${userInfo['first_name']} ${userInfo['last_name']}',
                        style: const TextStyle(
                          color: CustomThemeColors.themeBlue
                        ),
                      ),
                      subtitle: const Text('Conductor'),
                    ),
                  );
                }
              );
            } else {
              return const Center(child: Text('No driver/conductor is vacant now.'));
            }
          }
        }
      ),
    );
  }
}