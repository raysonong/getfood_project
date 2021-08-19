import 'package:flutter/material.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// Add User Info Screen
class AddUserInfoScreen extends StatefulWidget {
  AddUserInfoScreen({Key key}) : super(key: key);

  @override
  _AddUserInfoScreenState createState() => _AddUserInfoScreenState();
}

class _AddUserInfoScreenState extends State<AddUserInfoScreen> {
  bool isLoginScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body Section
      body: ListView(
        padding: screenPaddingStyle,
        shrinkWrap: true,
        children: <Widget>[
          Text(
            'Almost There!',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 10.0),
          Text(
            'Before using our service, please provide your username and address!',
            style: paragraph1Style,
          ),
          SizedBox(
            height: 30,
          ),
          // Add User Info Form
          _addUserInfoForm(),
          // End of Add User Info Form
        ],
      ),
      // End of Body Section
    );
  }

  // Add User Info Form
  Widget _addUserInfoForm() {
    final _formKey = GlobalKey<FormState>();
    var _thisUsername = GlobalKey<FormFieldState>();
    var _thisAddress = GlobalKey<FormFieldState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Username Field
          _inputField(_thisUsername, 'username', 'Username', Icons.person),
          // End of Username Field
          SizedBox(height: 20.0),
          // Address Field
          _inputField(_thisAddress, 'address', 'Address', Icons.home),
          // End of Address Field
          SizedBox(height: 50.0),
          // Next Button
          ElevatedButton(
            onPressed: () async {
              // Execute if all the entered values are valid
              if (_formKey.currentState.validate()) {
                // idk
              }
            },
            child: Text(
              'Finish',
            ),
          ),
          // End of Next Button
        ],
      ),
    );
  }
  // End of Add User Info Form

  // Input Field
  Widget _inputField(_key, inputName, hintText, prefixIcon,
      {obscureText = false}) {
    // Validate whether input is empty or not
    String _genericValidator(value) {
      if (value.isEmpty) {
        return 'Please enter your ${hintText.toString().toLowerCase()}!';
      }
      return null;
    }

    // Validate register email
    String _validateUsername(value) {
      if (value.isEmpty) {
        return 'Please enter your username!';
      } else if (value.length <= 3) {
        return 'Username must be more than 3 characters!';
      } else if (value.length >= 18) {
        return 'Username must be less than 18 characters!';
      }
      return null;
    }

    // Input Widget
    return TextFormField(
      key: _key,
      decoration: InputDecoration(
        // Label Text
        hintText: hintText,
        // Prefix Icon
        prefixIcon: Icon(
          prefixIcon,
          color: iconColorStyle,
        ),
      ),
      // Mask Input Field
      obscureText: obscureText,
      // Validate Input Field
      validator: (value) {
        // Validate address
        if (inputName == 'address')
          return _genericValidator(value);
        // Validate username
        else if (inputName == 'username')
          return _validateUsername(value);
        else
          // if input name does not exist return an error message
          return 'An error occured while trying to validate this field.';
      },
    );
    // End of Input Widget
  }
  // End of Input Field
}
// End of Add User Info Screen
