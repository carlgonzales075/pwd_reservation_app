import 'package:flutter/material.dart';
import 'package:pwd_reservation_app/commons/themes/theme_modules.dart';

class CustomDialogs {
  static void customErrorDialog(BuildContext context, String errorTitle, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            errorTitle,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(errorMessage),
          actions: [ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomThemeColors.themeBlue,
              foregroundColor: CustomThemeColors.themeWhite,
              minimumSize: const Size.fromHeight(50)
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK')
          )],
          actionsAlignment: MainAxisAlignment.center,
        );
      }
    );
  }

  static void customInfoDialog(BuildContext context, String infoTitle, String infoMessage, VoidCallback? customInfoFunc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            infoTitle,
            style: const TextStyle(
              fontSize: 20,
              color: CustomThemeColors.themeLightBlue,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(infoMessage),
          actions: [ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomThemeColors.themeBlue,
              foregroundColor: CustomThemeColors.themeWhite,
              minimumSize: const Size.fromHeight(50)
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (customInfoFunc != null) {
                customInfoFunc();
              }
            },
            child: const Text('OK')
          )],
          actionsAlignment: MainAxisAlignment.center,
        );
      }
    );
  }

  static void customFatalError(BuildContext context, String errorMessage, VoidCallback logErrorFunction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            'Error Encountered',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold
            )
          ),
          content: Text(errorMessage),
          actions: [ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              minimumSize: const Size.fromHeight(60)
            ),
            onPressed: () {
              Navigator.of(context).pop();
              logErrorFunction();
            },
            child: const Text('Report Error')
          )],
          actionsAlignment: MainAxisAlignment.center,
        );
      }
    );
  }

  static void customDecisionDialog(BuildContext context, String optionTitle, String optionMessage,
                            VoidCallback selectYesFunction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            optionTitle,
            style: const TextStyle(
              fontSize: 20,
              color: CustomThemeColors.themeBlue,
              fontWeight: FontWeight.bold
            )
          ),
          content: Text(optionMessage),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // minimumSize: const Size.fromHeight(60)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back')
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomThemeColors.themeBlue,
                foregroundColor: CustomThemeColors.themeWhite,
                // minimumSize: const Size.fromHeight(60)
              ),
              onPressed: () {
                Navigator.of(context).pop();
                selectYesFunction();
              },
              child: const Text('OK')
            )
          ],
          actionsAlignment: MainAxisAlignment.end,

        );
      }
    );
  }

  static void customTwoChoiceDialog(BuildContext context, String optionTitle, String optionMessage,
                             {VoidCallback? firstOption, VoidCallback? secondOption,
                             String? firstLabel, String? secondLabel}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(
            optionTitle,
            style: const TextStyle(
              fontSize: 20,
              color: CustomThemeColors.themeBlue,
              fontWeight: FontWeight.bold
            )
          ),
          content: Text(optionMessage),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomThemeColors.themeBlue,
                    foregroundColor: CustomThemeColors.themeWhite
                  ),
                  onPressed: () {
                    if (firstOption != null) {
                      Navigator.of(context).pop();
                      firstOption();
                    }
                  },
                  child: Text(firstLabel.toString())
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomThemeColors.themeBlue,
                    foregroundColor: CustomThemeColors.themeWhite
                  ),
                  onPressed: () {
                    if (secondOption != null) {
                      secondOption();
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(secondLabel.toString())
                )
              ],
            )
          ],
          actionsAlignment: MainAxisAlignment.end,

        );
      }
    );
  }

  static void unskippableDialog(BuildContext context, String title, Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
          },
          child: AlertDialog.adaptive(
            title: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: CustomThemeColors.themeBlue,
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: content,
            ),
          ),
        );
      }
    );
  }

  static void unskippableDecisionDialog(BuildContext context, String title,
                                 Widget content,
                                 VoidCallback selectYesFunction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
          },
          child: AlertDialog.adaptive(
            title: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  color: CustomThemeColors.themeBlue,
                  fontWeight: FontWeight.w500
                )
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: content,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // minimumSize: const Size.fromHeight(60)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back')
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomThemeColors.themeBlue,
                  foregroundColor: CustomThemeColors.themeWhite,
                  // minimumSize: const Size.fromHeight(60)
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  selectYesFunction();
                },
                child: const Text('OK')
              )
            ],
            actionsAlignment: MainAxisAlignment.end,
          ),
        );
      }
    );
  }
}
