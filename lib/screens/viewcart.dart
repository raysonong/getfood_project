import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/models/restaurant_dishes.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// View Cart Screen
class ViewCartScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final List<dynamic> cartList;
  final double subtotal;
  final double deliveryCharge;

  ViewCartScreen({
    @required this.restaurantId,
    @required this.restaurantName,
    @required this.cartList,
    @required this.subtotal,
    @required this.deliveryCharge,
  });

  @override
  _ViewCartScreenState createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  final _formKey = GlobalKey<FormState>();
  var _thisAddress = GlobalKey<FormFieldState>();

  Future<String> userAddress;
  List<Future<RestaurantDishes>> cartList;
  double totalDishPrice;
  double subtotal;
  double deliveryCharge;
  double serviceCharge;
  double total;
  Future<RestaurantDishes> dish;
  Future getRestaurant;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // Get user's address
    userAddress = FirestoreService(uid: firebaseUser.uid).getUserAddress();
    // To store the list of items added to cart
    cartList = [];
    // To store each total dish price
    totalDishPrice = 0;
    // To store subtotal in cart
    subtotal = widget.subtotal ?? 0;
    // To store delivery charge
    deliveryCharge = widget.deliveryCharge ?? 0;
    // To store service charge
    serviceCharge = 0.2;
    // To store total price
    total = subtotal + deliveryCharge + serviceCharge;
    // Foreach every dishes
    widget.cartList.forEach((cart) {
      // Retrieve the dish by ID
      dish =
          FirestoreService().getRestaurantDishById(cart[1], quantity: cart[0]);
      // Add dish to list
      cartList.add(dish);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text('View Cart'),
      ),
      // End of App Bar
      // Body
      body: SingleChildScrollView(
        padding: screenPaddingStyle,
        child: _buildCartInfo(),
      ),
      // End of Body
      // Sticky Bottom
      bottomNavigationBar: cartList.isEmpty
          ? Row()
          : Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Total Price
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            '\$' + total.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    // End of Total Price
                    // View Cart Button
                    ElevatedButton(
                      onPressed: () async {
                        var quantities = [];
                        var dishes = [];

                        // Validate address
                        if (_thisAddress.currentState.value != "") {
                          // Attempt to add the address in database
                          Future<bool> result = FirestoreService(
                                  uid: firebaseUser.uid)
                              .addUserAddress(_thisAddress.currentState.value);

                          // Check whether the adding is successful
                          if (await result) {
                            result.then((value) async {
                              // Foreach every dishes
                              widget.cartList.forEach((cart) {
                                quantities.add(cart[0]);
                                dishes.add(cart[1]);
                              });

                              // Attempt to add the order in database
                              Future<String> result =
                                  FirestoreService(uid: firebaseUser.uid)
                                      .addOrder(
                                widget.restaurantId,
                                quantities,
                                dishes,
                                subtotal.toStringAsFixed(2),
                                deliveryCharge.toStringAsFixed(2),
                                serviceCharge.toStringAsFixed(2),
                                total.toStringAsFixed(2),
                              );

                              // Check whether the adding is successful
                              if (await result != null) {
                                result.then((value) {
                                  // Display Success dialog box
                                  showDialogOK(
                                    context,
                                    'Checkout',
                                    "You have successfully order your items! It will be delivered in the meantime.",
                                    () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    },
                                  );
                                });
                              } else {
                                result.then((value) {
                                  // Display Error dialog box
                                  showDialogOK(
                                    context,
                                    'Checkout',
                                    "An internal error has occured, please try again later.",
                                    () {},
                                  );
                                });
                              }
                            });
                          } else {
                            result.then((value) {
                              // Display Error dialog box
                              showDialogOK(
                                context,
                                'Checkout',
                                "An internal error has occured, please try again later.",
                                () {},
                              );
                            });
                          }
                        } else {
                          // Display Error dialog box
                          showDialogOK(
                            context,
                            'Checkout',
                            "Please enter your address!",
                            () {},
                          );
                        }
                      },
                      child: Text('Checkout'),
                    ),
                    // End of View Cart Button
                  ],
                ),
              ),
            ),
      // End of Sticky Bottom
    );
  }

  // Cart Info
  Widget _buildCartInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Address
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "Delivery Address",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            'Your items will be delivered to this address.',
          ),
        ),
        _addressForm(),
        // End of address
        SizedBox(height: 50.0),
        // Restaurant Dishes
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            widget.restaurantName,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        _buildRestaurantDishesList(),
        // End of Restaurant Dishes
        SizedBox(height: 30.0),
        // Subtotal
        _displayRowPrice('Subtotal', subtotal),
        // End of Subtotal
        SizedBox(height: 10.0),
        // Delivery Charge
        _displayRowPrice('Delivery Charge', deliveryCharge),
        // End of Delivery Charge
        SizedBox(height: 10.0),
        // Service Charge
        _displayRowPrice('Service Charge', serviceCharge),
        // End of Service Charge
      ],
    );
  }
  // End of Cart Info

  // Address Form
  Widget _addressForm() {
    // Retrieve current user logged in
    final firebaseUser = context.watch<User>();
    return FutureBuilder(
      future: userAddress,
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
                // Address Field
                TextFormField(
                  key: _thisAddress,
                  // Address
                  initialValue: snapshot.data,
                  decoration: InputDecoration(
                    // Label Text
                    hintText: "Address",
                    // Prefix Icon
                    prefixIcon: Icon(
                      Icons.house,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                // End of Address Field
                SizedBox(height: 30.0),
                // Update Button
                ElevatedButton(
                  onPressed: () async {
                    // Validate address
                    if (_thisAddress.currentState.value != "") {
                      // Attempt to add the address in database
                      Future<bool> result =
                          FirestoreService(uid: firebaseUser.uid)
                              .addUserAddress(_thisAddress.currentState.value);

                      // Check whether the adding is successful
                      if (await result) {
                        result.then((value) {
                          // Display Success dialog box
                          showDialogOK(
                            context,
                            'Checkout',
                            "Your address has been successfully updated!",
                            () {},
                          );
                        });
                      } else {
                        result.then((value) {
                          // Display Error dialog box
                          showDialogOK(
                            context,
                            'Checkout',
                            "An internal error has occured, please try again later.",
                            () {},
                          );
                        });
                      }
                    } else {
                      // Display Error dialog box
                      showDialogOK(
                        context,
                        'Checkout',
                        "Please enter your address!",
                        () {},
                      );
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

  // Row Price
  Widget _displayRowPrice(String tag, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Tag
        Text(tag, style: Theme.of(context).textTheme.bodyText1),
        // End of Tag
        // Price
        Text(
          '\$' + price.toStringAsFixed(2),
          style: Theme.of(context).textTheme.headline4,
        ),
        // End of Price
      ],
    );
  }
  // End of Row Price

  // Restaurant Dishes List
  Widget _buildRestaurantDishesList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // Add spacing between dishes
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
      // Build all available dishes
      itemBuilder: (context, index) {
        return FutureBuilder<RestaurantDishes>(
          // Retrieve the restaurant dishes
          future: cartList[index],
          // Build the dishes list
          builder: (context, snapshot) {
            // Display all the list of available dishes
            if (snapshot.hasData) {
              // Calculate the dish price multiply by the quantity
              totalDishPrice =
                  double.parse(snapshot.data.price) * snapshot.data.quantity;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      // Dish Quantity
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Text(snapshot.data.quantity.toString() + "x",
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      // End of Dish Quantity
                      // Dish Name
                      Text(
                        snapshot.data.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      // End of Dish Name
                    ],
                  ),
                  // Dish Price
                  Text('\$' + totalDishPrice.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyText1),
                  // End of Dish Price
                ],
              );
            } else {
              return Row();
            }
          },
        );
      },
      // Total number of dishes
      itemCount: cartList.length,
    );
  }
  // End of Restaurant Dishes List
}
// End of View Cart Screen
