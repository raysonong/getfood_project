import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/models/accounts.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future userInfo;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // Get user's info
    userInfo = FirestoreService(uid: firebaseUser.uid).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenPaddingStyle,
      shrinkWrap: true,
      children: [
        _editAccountInfoForm(),
      ],
    );
  }

  // Address Form
  Widget _editAccountInfoForm() {
    final _formKey = GlobalKey<FormState>();
    var _thisAddress = GlobalKey<FormFieldState>();
    var _thisUsername = GlobalKey<FormFieldState>();
    var _thisPhoneNumber = GlobalKey<FormFieldState>();

    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    return FutureBuilder<AccountInfo>(
      future: userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            // Display Loading Indicator
            child: CircularProgressIndicator(
              color: complementaryColorStyle,
            ),
          );
        } else {
          // Build form
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Username Field
                _inputField(
                  _thisUsername,
                  'userName',
                  'Username',
                  Icons.person,
                  snapshot.data.username,
                ),
                // End of Username Field
                SizedBox(height: 20.0),
                // Contact Number Field
                _inputField(
                  _thisPhoneNumber,
                  'userPhoneNumber',
                  'Phone Number',
                  Icons.phone_android,
                  snapshot.data.phoneNumber,
                  keyboardType: TextInputType.number,
                ),
                // End of Contact Number Field
                SizedBox(height: 20.0),
                // Address Field
                _inputField(
                  _thisAddress,
                  'userAddress',
                  'Address',
                  Icons.house,
                  snapshot.data.address,
                ),
                // End of Address Field
                SizedBox(height: 50.0),
                // Update Button
                ElevatedButton(
                  onPressed: () async {
                    // Validate user info
                    if (_formKey.currentState.validate()) {
                      // Attempt to add the user info in database
                      Future<bool> result =
                          FirestoreService(uid: firebaseUser.uid).addUserInfo(
                        _thisUsername.currentState.value,
                        _thisPhoneNumber.currentState.value,
                        _thisAddress.currentState.value,
                      );

                      // Check whether the adding is successful
                      if (await result) {
                        result.then((value) {
                          // Display Success dialog box
                          showDialogOK(
                            context,
                            'Account',
                            "Your account info has been successfully updated!",
                            () {},
                          );
                        });
                      } else {
                        result.then((value) {
                          // Display Error dialog box
                          showDialogOK(
                            context,
                            'Account',
                            "An internal error has occured, please try again later.",
                            () {},
                          );
                        });
                      }
                    }
                  },
                  child: Text(
                    'Update',
                  ),
                ),
                // End of Update Button
              ],
            ),
          );
        }
      },
    );
  }
  // End of Address Form

  // Input Field
  Widget _inputField(_key, inputName, hintText, prefixIcon, initialValue,
      {keyboardType = TextInputType.text}) {
    // Input Widget
    return TextFormField(
      key: _key,
      keyboardType: keyboardType,
      initialValue: initialValue,
      decoration: InputDecoration(
        // Label Text
        hintText: hintText,
        // Prefix Icon
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
    // End of Input Widget
  }
  // End of Input Field
}
// End of Profile Screen
