import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/dispatch/drivers/dispatch.dart';
import 'package:pwd_reservation_app/modules/employee/modules/dispatch/widgets.dart/future_builder.dart';
import 'package:pwd_reservation_app/modules/employee/modules/verify/widgets/verify_formfields.dart';

class DispatchForm extends StatefulWidget {
  const DispatchForm({
    super.key,
    required this.title,
    required this.vehicleRouteId
  });

  final String title;
  final String vehicleRouteId;

  @override
  State<DispatchForm> createState() => _DispatchFormState();
}

class _DispatchFormState extends State<DispatchForm> {
  final TextEditingController _routeInfo = TextEditingController();
  final TextEditingController _routeInfoSub = TextEditingController();

  final TextEditingController _driverInfo = TextEditingController();
  final TextEditingController _driverInfoSub = TextEditingController();

  final TextEditingController _conductorInfo = TextEditingController();
  final TextEditingController _conductorInfoSub = TextEditingController();

  late bool canDispatch;

  @override
  void initState() {
    super.initState();

    _routeInfoSub.addListener(_updateButtonState);
    _driverInfoSub.addListener(_updateButtonState);
    _conductorInfoSub.addListener(_updateButtonState);

    _updateButtonState();
  }

  @override
  void dispose() {
    _routeInfo.dispose();
    _routeInfoSub.dispose();
    _driverInfo.dispose();
    _driverInfoSub.dispose();
    _conductorInfo.dispose();
    _conductorInfoSub.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      canDispatch = _routeInfoSub.text.isEmpty || _driverInfoSub.text.isEmpty || _conductorInfoSub.text.isEmpty;
    });
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: CustomThemeColors.themeBlue,
        foregroundColor: CustomThemeColors.themeWhite,
      ),
      body: DispatchFormBody(
        routeInfo: _routeInfo,
        routeInfoSub: _routeInfoSub,
        driverInfo: _driverInfo,
        driverInfoSub: _driverInfoSub,
        conductorInfo: _conductorInfo,
        conductorInfoSub: _conductorInfoSub
      ),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white
          ),
          onPressed: !canDispatch ? () {
            DirectusDispatch.updateVehicleRoute(
              context,
              vehicleRouteId: widget.vehicleRouteId,
              driverId: _driverInfoSub.text,
              routeId: _routeInfoSub.text,
              conductorId: _conductorInfoSub.text
            );
          }: null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.access_time_sharp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Dispatch'),
              ),
            ],
          )
        )
      ],
    );
  }
}

class DispatchFormBody extends StatelessWidget {
  const DispatchFormBody({
    super.key,
    required TextEditingController routeInfo,
    required TextEditingController routeInfoSub,
    required TextEditingController driverInfo,
    required TextEditingController driverInfoSub,
    required TextEditingController conductorInfo,
    required TextEditingController conductorInfoSub,
  }) : _routeInfo = routeInfo, _routeInfoSub = routeInfoSub, _driverInfo = driverInfo, _driverInfoSub = driverInfoSub, _conductorInfo = conductorInfo, _conductorInfoSub = conductorInfoSub;

  final TextEditingController _routeInfo;
  final TextEditingController _routeInfoSub;
  final TextEditingController _driverInfo;
  final TextEditingController _driverInfoSub;
  final TextEditingController _conductorInfo;
  final TextEditingController _conductorInfoSub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FormTextLabel(label: 'Select Route'),
          FormTextField(
            label: 'Route',
            controller: _routeInfo,
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DispatchModalBottomSheet(
                    title: 'Select Route',
                    controller: _routeInfo,
                    subController: _routeInfoSub,
                    dispatchBuilder: RouteListBuilder(
                      controller: _routeInfo,
                      subController: _routeInfoSub,
                      titleKey: 'route_name',
                      icon: Icons.route_outlined,
                    ),
                  );
                }
              );
            },
          ),
          const FormTextLabel(label: 'Select Driver'),
          FormTextField(
            label: 'Driver',
            controller: _driverInfo,
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DispatchModalBottomSheet(
                    title: 'Select Driver',
                    controller: _driverInfo,
                    subController: _driverInfoSub,
                    dispatchBuilder: DriversListBuilder(
                      controller: _driverInfo,
                      subController: _driverInfoSub
                    ),
                  );
                }
              );
            },
          ),
          const FormTextLabel(label: 'Select Conductor'),
          FormTextField(
            label: 'Conductor',
            controller: _conductorInfo,
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DispatchModalBottomSheet(
                    title: 'Select Conductor',
                    controller: _conductorInfo,
                    subController: _conductorInfoSub,
                    dispatchBuilder: ConductorsListBuilder(
                      controller: _conductorInfo,
                      subController: _conductorInfoSub
                    ),
                  );
                }
              );
            },
          )
        ],
      ),
    );
  }
}

class DispatchModalBottomSheet extends StatelessWidget {
  const DispatchModalBottomSheet({
    super.key,
    required this.title,
    required this.controller,
    required this.subController,
    required this.dispatchBuilder
  });

  final String title;
  final TextEditingController subController;
  final TextEditingController controller;
  final Widget dispatchBuilder;

  @override
  Widget build (BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            TextButton.icon(
              onPressed: () {
                controller.text = '';
                subController.text = '';
                Navigator.of(context).pop();
              },
              label: const Text('Clear')
            )
          ],
        ),
        dispatchBuilder
      ],
    );
  }
}