import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/screens/changepassword.dart';
import 'package:getfood_project/services/firebase_auth_service.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
// Theme and Style
import 'package:getfood_project/style.dart';
import 'package:getfood_project/theme.dart';

// Settings Screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    return ListView(
      padding: screenPadding2Style,
      shrinkWrap: true,
      children: [
        _buttonTile(
          context,
          icon: Icons.brightness_6_outlined,
          title: 'Theme',
          performAction: () => _swapTheme(context),
        ),
        _buttonTile(
          context,
          icon: Icons.lock_outlined,
          title: 'Change Password',
          performAction: () {
            if (!firebaseUser.isAnonymous) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            } else {
              // Display dialog box
              showDialogOK(
                context,
                "GetFood",
                "You need an account to access this page!",
                () {},
              );
            }
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 10.0,
          ),
          child: Divider(
            thickness: 2,
          ),
        ),
        _buttonTile(
          context,
          icon: Icons.exit_to_app_outlined,
          title: 'Logout',
          isLogout: true,
        ),
      ],
    );
  }

  // Swap Theme Function
  void _swapTheme(context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );
    // Swap the theme
    themeProvider.swapTheme();
  }

  // Button Tile
  Widget _buttonTile(BuildContext context,
      {@required IconData icon,
      @required String title,
      Function performAction,
      bool isLogout = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
      // Icon
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : iconColorStyle,
      ),
      // End of Icon
      // Title
      title: Text(
        title,
        style: TextStyle(
          color: isLogout
              ? Colors.red
              : Theme.of(context).textTheme.subtitle1.color,
        ),
      ),
      // End of Title
      // On Tap
      onTap: () {
        // Perform Action
        if (!isLogout) {
          performAction();
        } else {
          // Logout Dialog
          showDialogConfirm(
            context,
            'Logout',
            'Do you want to logout from GetFood?',
            () => context.read<AuthenicationService>().logOut(),
          );
        }
      },
    );
  }
}
// End of Settings Screen
