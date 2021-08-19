import 'package:flutter/material.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
import 'package:getfood_project/services/firebase_auth_service.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// Login Register Screen
class LoginRegisterScreen extends StatefulWidget {
  LoginRegisterScreen({Key key}) : super(key: key);

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLoginScreen = true;

  @override
  Widget build(BuildContext context) {
    // Style
    TextStyle bodyText1Style = Theme.of(context).textTheme.bodyText1;

    // Return Scaffold
    return Scaffold(
      // Body Section
      body: ListView(
        padding: screenPaddingStyle,
        shrinkWrap: true,
        children: <Widget>[
          // Logo
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
            child: Image.asset(
              'images/logo/logo_dark.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ),
          // End of Logo
          Container(
            child: Column(
              children: <Widget>[
                // Login and Register Screen Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Login Screen Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Set the screen state
                          isLoginScreen = true;
                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: isLoginScreen
                              ? primaryColorStyle
                              : bodyText1Style.color,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // End of Login Screen Button
                    Container(
                      width: 1,
                      height: 18,
                      color: bodyText1Style.color,
                    ),
                    // Register Screen Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Set the screen state
                          isLoginScreen = false;
                        });
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: isLoginScreen
                              ? bodyText1Style.color
                              : primaryColorStyle,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    // End of Register Screen Button
                  ],
                ),
                // End of Login and Register Screen Button
                SizedBox(
                  height: 30,
                ),
                // Login / Register Form
                if (isLoginScreen) _loginForm() else _registerForm(),
                // End of Login / Register Form
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'OR',
                        style: bodyText1Style,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // Continue Without Login Button
                      TextButton(
                        onPressed: () async {
                          Future<String> result;

                          // Prompt the user
                          showDialogConfirm(
                            context,
                            "Login",
                            "You will be limited to basic features when you login without an account. Continue?",
                            () async {
                              // Attempt login anonymously
                              result = context
                                  .read<AuthenicationService>()
                                  .loginAnonymously();

                              // Check if login successful
                              if (await result != null) {
                                result.then((value) {
                                  // Display error popup
                                  showDialogOK(
                                    context,
                                    'Login',
                                    'An internal error has occured, please try again later.',
                                    () {},
                                  );
                                });
                              }
                            },
                          );
                          // End of confirm dialog
                        },
                        child: Text(
                          'Login without an Account',
                          style: TextStyle(
                            color: complementaryColorStyle,
                          ),
                        ),
                      )
                      // End of Continue Without Login Button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // End of Body Section
    );
  }

  // Login Form
  Widget _loginForm() {
    final _formKey = GlobalKey<FormState>();
    var _thisEmail = GlobalKey<FormFieldState>();
    var _thisPassword = GlobalKey<FormFieldState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Email Field
          _inputField(
            _thisEmail,
            'loginEmail',
            'Email',
            Icons.mail_rounded,
          ),
          // End of Email Field
          SizedBox(
            height: 20,
          ),
          // Password Field
          _inputField(_thisPassword, 'loginPassword', 'Password', Icons.lock,
              obscureText: true),
          // End of Password Field
          SizedBox(height: 50),
          // Login Button
          ElevatedButton(
            onPressed: () async {
              // Execute if all the entered values are valid
              if (_formKey.currentState.validate()) {
                // Attempt login account
                Future<String> result =
                    context.read<AuthenicationService>().loginAccount(
                          email: _thisEmail.currentState.value,
                          password: _thisPassword.currentState.value,
                        );

                // Check if login is not successful
                if (await result != null) {
                  result.then((value) {
                    // Display error popup
                    showDialogOK(
                        context,
                        'Login',
                        'The email and password you entered is incorrect!',
                        () {});
                  });
                }
              }
            },
            child: Text('Login'),
          ),
          // End of Login Button
        ],
      ),
    );
  }
  // End of Login Form

  // Register Form
  Widget _registerForm() {
    final _formKey = GlobalKey<FormState>();
    var _thisEmail = GlobalKey<FormFieldState>();
    var _thisPassword = GlobalKey<FormFieldState>();
    var _thisConfirmPassword = GlobalKey<FormFieldState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Email Field
          _inputField(
            _thisEmail,
            'registerEmail',
            'Email',
            Icons.mail_rounded,
          ),
          // End of Email Field
          SizedBox(
            height: 20,
          ),
          // Password Field
          _inputField(
            _thisPassword,
            'registerPassword',
            'Password',
            Icons.lock,
            obscureText: true,
          ),
          // End of Password Field
          SizedBox(
            height: 20,
          ),
          // Confirm Password Field
          _inputField(
            _thisConfirmPassword,
            'registerConfirmPassword',
            'Confirm Password',
            Icons.lock,
            obscureText: true,
            passwordKey: _thisPassword,
          ),
          // End of Confirm Password Field
          SizedBox(height: 50.0),
          // Register Button
          ElevatedButton(
            onPressed: () async {
              // Execute if all the entered values are valid
              if (_formKey.currentState.validate()) {
                // Attempt to create user account
                Future<String> result =
                    context.read<AuthenicationService>().registerAccount(
                          email: _thisEmail.currentState.value,
                          password: _thisPassword.currentState.value,
                        );

                // Check if register is not successful
                if (await result != null) {
                  result.then((value) {
                    // Display error popup
                    showDialogOK(context, 'Register', value, () {});
                  });
                }
              }
            },
            child: Text(
              'Register Account',
            ),
          ),
          // End of Register Button
        ],
      ),
    );
  }
  // End of Register Form

  // Input Field
  Widget _inputField(_key, inputName, hintText, prefixIcon,
      {obscureText = false, passwordKey}) {
    // Validate whether input is empty or not
    String _genericValidator(value) {
      if (value.isEmpty) {
        return 'Please enter your ${hintText.toString().toLowerCase()}!';
      }
      return null;
    }

    // Validate register email
    String _validateRegisterEmail(value) {
      if (value.isEmpty) {
        return 'Please enter your ${hintText.toString().toLowerCase()}!';
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return 'Please enter a valid email!';
      }
      return null;
    }

    // Validate register password
    String _validateRegisterPassword(value) {
      if (value.isEmpty) {
        return 'Please enter your ${hintText.toString().toLowerCase()}!';
      } else if (value.length <= 5) {
        return 'Password must be more than 5 characters!';
      }
      return null;
    }

    // Validate register confirm password
    String _validateRegisterConfirmPassword(value, passwordKey) {
      if (value.isEmpty) {
        return 'Please enter your confirm password!';
      } else if (value != passwordKey.currentState.value) {
        return 'Confirm Password does not match your chosen password!';
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
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      // Mask Input Field
      obscureText: obscureText,
      // Validate Input Field
      validator: (value) {
        // Validate login email and password
        if (inputName == 'loginEmail' || inputName == 'loginPassword')
          return _genericValidator(value);
        // Validate register email
        else if (inputName == 'registerEmail')
          return _validateRegisterEmail(value);
        // Validate register password
        else if (inputName == 'registerPassword')
          return _validateRegisterPassword(value);
        // Validate register confirm password
        else if (inputName == 'registerConfirmPassword')
          return _validateRegisterConfirmPassword(value, passwordKey);
        else
          // if input name does not exist return an error message
          return 'An error occured while trying to validate this field.';
      },
    );
    // End of Input Widget
  }
  // End of Input Field
}
// End of Login Register Screen
