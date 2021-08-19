import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getfood_project/services/firebase_auth_service.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// Change Password Screen
class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text(
          "Change Password",
        ),
      ),
      // End of App Bar
      // Body
      body: ListView(
        padding: screenPaddingStyle,
        shrinkWrap: true,
        children: <Widget>[
          _changePasswordForm(),
        ],
      ),
      // End of Body
    );
  }

  // Change Password Form
  Widget _changePasswordForm() {
    final _formKey = GlobalKey<FormState>();
    var _thisCurrentPassword = GlobalKey<FormFieldState>();
    var _thisNewPassword = GlobalKey<FormFieldState>();
    var _thisNewConfirmPassword = GlobalKey<FormFieldState>();

    final firebaseUser = context.watch<User>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Current Password Field
          TextFormField(
            key: _thisCurrentPassword,
            decoration: InputDecoration(
              // Label Text
              labelText: 'Current Password',
              // Prefix Icon
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // Mask Input Field
            obscureText: true,
            // Validate Input Field
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password!';
              }
              return null;
            },
          ),
          // End of Current Password Field
          SizedBox(
            height: 20,
          ),
          // New Password Field
          TextFormField(
            key: _thisNewPassword,
            decoration: InputDecoration(
              // Label Text
              labelText: 'New Password',
              // Prefix Icon
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // Mask Input Field
            obscureText: true,
            // Validate Input Field
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password!';
              } else if (value.length <= 5) {
                return 'Password must be more than 5 characters!';
              }
              return null;
            },
          ),
          // End of New Password Field
          SizedBox(
            height: 20,
          ),
          // New Confirm Password Field
          TextFormField(
            key: _thisNewConfirmPassword,
            decoration: InputDecoration(
              // Label Text
              labelText: 'Confirm New Password',
              // Prefix Icon
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            // Mask Input Field
            obscureText: true,
            // Validate Input Field
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your confirm password!';
              } else if (value != _thisNewPassword.currentState.value) {
                return 'Confirm Password does not match your chosen password!';
              }
              return null;
            },
          ),
          // End of New Confirm Password Field
          SizedBox(height: 50),
          // Update Button
          ElevatedButton(
            onPressed: () async {
              // Execute if all the entered values are valid
              if (_formKey.currentState.validate()) {
                // Validate password
                Future<bool> result = context
                    .read<AuthenicationService>()
                    .validatePassword(
                        firebaseUser: firebaseUser,
                        currentPassword:
                            _thisCurrentPassword.currentState.value);

                // If password correct
                if (await result != null) {
                  // Update new password
                  context.read<AuthenicationService>().updatePassword(
                      firebaseUser: firebaseUser,
                      newPassword: _thisNewPassword.currentState.value);

                  // Display success popup
                  showDialogOK(context, 'Change Password',
                      'You have successfully changed your password!', () {});
                } else {
                  // Display login fail popup
                  showDialogOK(context, 'Change Password',
                      'The login password you entered is incorrect!', () {});
                }

                // Reset the form
                _formKey.currentState.reset();
              }
            },
            child: Text('Update'),
          ),
          // End of Update Button
        ],
      ),
    );
  }
  // End of Change Password Form
}
// End of Change Password Screen
