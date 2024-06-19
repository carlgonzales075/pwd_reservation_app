import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/users/utils/users.dart';

class EmployeeMenus extends StatelessWidget {
  const EmployeeMenus({super.key});

  @override
  Widget build (BuildContext context) {
    final bool isDispatcher = context.read<UserProvider>().role == 'Dispatcher';
    final bool isVerifier = context.read<UserProvider>().role == 'Verifier';
    final List<String> highLevel = ['Administrator', 'Employee'];
    final bool isHighLevel = highLevel.contains(context.read<UserProvider>().role);
    const double height = 80;
    
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Visibility(
          //   visible: isHighLevel,
          //   child: EmployeeMenu(
          //     title: 'Vehicle Asset Management',
          //     height: height,
          //     employeeGridButtons: <Widget>[
          //       EmployeeGridButtons(
          //         onTap: () {},
          //         icon: Icons.add_circle,
          //         label: 'Add New',
          //       ),
          //       EmployeeGridButtons(
          //         onTap: () {},
          //         label: 'Update',
          //         icon: Icons.update
          //       ),
          //       EmployeeGridButtons(
          //         onTap: () {},
          //         label: 'Edit Seats',
          //         icon: Icons.chair_alt_rounded
          //       ),
          //     ]
          //   ),
          // ),
          // Visibility(
          //   visible: isHighLevel,
          //   child: EmployeeMenu(
          //     title: 'User Management',
          //     height: height,
          //     employeeGridButtons: <Widget>[
          //       EmployeeGridButtons(
          //         onTap: () {},
          //         icon: Icons.add_circle,
          //         label: 'Add User',
          //       ),
          //       EmployeeGridButtons(
          //         onTap: () {},
          //         icon: Icons.update,
          //         label: 'Update User',
          //       )
          //     ]
          //   ),
          // ),
          Visibility(
            visible: isHighLevel || isDispatcher,
            child: EmployeeMenu(
              title: 'Dispatch Process',
              height: height,
              employeeGridButtons: <Widget>[
                EmployeeGridButtons(
                  onTap: () {
                    Navigator.pushNamed(context, '/employee-dispatch');
                  },
                  icon: Icons.place_sharp,
                  label: 'Dispatch',
                ),
                // EmployeeGridButtons(
                //   onTap: () {},
                //   label: 'Cancel',
                //   icon: Icons.pan_tool_outlined
                // )
              ]
            ),
          ),
          Visibility(
            visible: isHighLevel || isVerifier,
            child: EmployeeMenu(
              title: 'Priority Request Verification Process',
              height: height,
              employeeGridButtons: <Widget>[
                EmployeeGridButtons(
                  onTap: () {
                    Navigator.pushNamed(context, '/employee-verify');
                  },
                  icon: Icons.fact_check_sharp,
                  label: 'Verify',
                )
              ]
            ),
          )
        ]
      ),
    );
  }
}

class GridMenuTitle extends StatelessWidget {
  const GridMenuTitle({
    super.key,
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: CustomThemeColors.themeBlue
      ),
    );
  }
}

class EmployeeMenu extends StatelessWidget {
  const EmployeeMenu({
    super.key,
    required this.title,
    required this.employeeGridButtons,
    required this.height
  });

  final String title;
  final List<Widget> employeeGridButtons;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridMenuTitle(
          title: title,
        ),
        SizedBox(
          height: height,
          width: double.infinity,
          child: GridView.count(
            primary: false,
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            children: employeeGridButtons
          ),
        ),
      ],
    );
  }
}

class EmployeeGridButtons extends StatelessWidget {
  const EmployeeGridButtons({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon
  });

  final VoidCallback onTap;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.2),
          highlightColor: Colors.blue.withOpacity(0.1),
          child: GridTile(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Colors.blue.shade800,
                ),
                const SizedBox(height: 5,),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}