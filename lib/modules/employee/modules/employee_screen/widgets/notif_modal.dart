import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';
import 'package:pwd_reservation_app/modules/employee/modules/inspect_seats/drivers/last_update.dart';

class NotifModal extends StatelessWidget {
  const NotifModal({
    super.key,
    required this.id
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return Consumer<LastUpdateProvider>(
      builder: (context, hasUpdates, child) {
        final bool finalNotif = hasUpdates.showNotif as bool
        && hasUpdates.hasUpdates as int > 0;
        if (finalNotif) {
          FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            looping: false,
            volume: 0.5,
            asAlarm: false,
          );
          // hasUpdates.updateIsPlayed();
        }
        return finalNotif ?
          Dismissible(
          key: Key(id),
          direction: DismissDirection.horizontal,
          onDismissed: (direction) {
            hasUpdates.hideNotif();
          },
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/seats');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.notification_important, color: Colors.cyan),
                  const SizedBox(width: 10, height: 50,),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${hasUpdates.hasUpdates} New Reservations!\n\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomThemeColors.themeBlue,
                            ),
                          ),
                          TextSpan(
                            text: '${hasUpdates.hasUpdates} ${
                              hasUpdates.hasUpdates as int > 1 ? 'Passengers' : 'Passenger'
                            } has just reserved seats!\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: CustomThemeColors.themeBlue,
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ) :
        Container();
      }
    );
  }
}
