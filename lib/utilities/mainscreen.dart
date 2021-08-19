import 'package:flutter/material.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:getfood_project/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
// Theme and Style
import 'package:getfood_project/style.dart';
// Imported Screen
import 'package:getfood_project/screens/home.dart';
import 'package:getfood_project/screens/account.dart';
import 'package:getfood_project/screens/favourites.dart';
import 'package:getfood_project/screens/orderhistory.dart';
import 'package:getfood_project/screens/about.dart';
import 'package:getfood_project/screens/settings.dart';

// Main Screen
class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> title;
  int index = 0;
  List<Widget> navList;
  bool displayAppBarActions = true;

  _MainScreenState() {
    // Nav Draw Titles
    title = [
      'GetFood',
      'Account',
      'Favourites',
      'Order History',
      'Settings',
      'About',
    ];
    // Nav Drawer Screens
    navList = [
      HomeScreen(),
      ProfileScreen(),
      FavouritesScreen(),
      OrderHistoryScreen(),
      SettingsScreen(),
      AboutScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    return Scaffold(
      // App Bar
      appBar: AppBar(
        actions: [
          if (displayAppBarActions && !firebaseUser.isAnonymous)
            // Favorite Button
            IconButton(
              onPressed: () {
                setState(() {
                  // Update index drawer
                  index = 2;
                });
              },
              icon: Icon(Icons.favorite_outline),
            ),
          // End of Favorite Button
        ],
        title: Text(
          title[index],
        ),
      ),
      // End of App Bar
      // Body
      body: navList[index],
      // End of Body
      // Drawer
      drawer: NavDrawer(
        onTap: (context, i, daa) {
          setState(
            () {
              // Update index drawer
              index = i;
              // Update App Bar Display Actions
              displayAppBarActions = daa;
              // Close the drawer
              Navigator.pop(context);
            },
          );
        },
      ),
    );
    // End of Drawer
  }
}
// End of Main Screen

// Nav Drawer
class NavDrawer extends StatefulWidget {
  final Function onTap;

  // Constructor for onTap function
  NavDrawer({Key key, this.onTap});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Future userName;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // Retrieve restaurant categories for building category list widget
    userName = FirestoreService(uid: firebaseUser.uid).getUserName();
  }

  @override
  Widget build(BuildContext context) {
    // Style
    TextStyle subtitle1Style = Theme.of(context).textTheme.subtitle1;

    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    // Variable to retrieve the user data
    String email = firebaseUser.isAnonymous ? '(No email)' : firebaseUser.email;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FutureBuilder(
                      future: userName,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          // Username
                          return Text(
                            firebaseUser.isAnonymous
                                ? 'User'
                                : snapshot.data != ""
                                    ? snapshot.data
                                    : 'User',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                          // End of Username
                        }
                      },
                    ),
                    SizedBox(
                      height: 2.5,
                    ),
                    // Email
                    Text(
                      email,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    // End of Email
                  ],
                ),
              ),
            ),
            // End of Drawer Header
            // Nav List
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: iconColorStyle,
              ),
              title: Text('Home', style: subtitle1Style),
              onTap: () => widget.onTap(context, 0, true),
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: iconColorStyle,
              ),
              title: Text('Account', style: subtitle1Style),
              onTap: () {
                // Check if user is anonymous
                if (!firebaseUser.isAnonymous) {
                  widget.onTap(context, 1, true);
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
            ListTile(
              leading: Icon(
                Icons.favorite_outline,
                color: iconColorStyle,
              ),
              title: Text('Favourites', style: subtitle1Style),
              onTap: () {
                // Check if user is anonymous
                if (!firebaseUser.isAnonymous) {
                  widget.onTap(context, 2, true);
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
            ListTile(
              leading: Icon(
                Icons.history,
                color: iconColorStyle,
              ),
              title: Text('Order History', style: subtitle1Style),
              onTap: () => widget.onTap(context, 3, true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Divider(
                thickness: 2,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings_outlined,
                color: iconColorStyle,
              ),
              title: Text('Settings', style: subtitle1Style),
              onTap: () => widget.onTap(context, 4, false),
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: iconColorStyle,
              ),
              title: Text('About', style: subtitle1Style),
              onTap: () => widget.onTap(context, 5, false),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app_outlined,
                color: Colors.red[400],
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () => showDialogConfirm(
                context,
                'Logout',
                'Do you want to logout from GetFood?',
                () => context.read<AuthenicationService>().logOut(),
              ),
            ),
            // End of Nav List
          ],
        ),
      ),
    );
  }
}
// End of Nav Drawer
