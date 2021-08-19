import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/models/restaurant_dishes.dart';
import 'package:getfood_project/models/restaurants.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
// Theme and Style
import 'package:getfood_project/style.dart';
// Imported Screens
import 'package:getfood_project/screens/restaurantlocation.dart';
import 'package:getfood_project/screens/viewcart.dart';

// Restaurant Screen
class RestaurantScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  RestaurantScreen(
      {@required this.restaurantId, @required this.restaurantName});

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  List<dynamic> cartList;
  double subtotal;
  double deliveryCharge;
  Future getRestaurant;
  Future getRestaurantDishes;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // To store the list of items added to cart
    cartList = [];
    // To store subtotal in cart
    subtotal = 0;
    // To store delivery charge
    deliveryCharge = 0;
    // Get restaurant based on the ID
    getRestaurant = FirestoreService(uid: firebaseUser.uid)
        .getRestaurantById(widget.restaurantId);
    // Get dishes based on the restaurant ID
    getRestaurantDishes =
        FirestoreService().getRestaurantDishes(widget.restaurantId);
    // To get the delivery charge from the database
    getRestaurant.then(
      (value) => deliveryCharge += double.parse(value.deliveryCharge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text(widget.restaurantName),
      ),
      // End of App Bar
      // Body
      body: SingleChildScrollView(
        child: _buildRestaurantInfo(),
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
                            'Subtotal',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Text(
                            '\$' + subtotal.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ),
                    // End of Total Price
                    // View Cart Button
                    ElevatedButton(
                      onPressed: () {
                        // Go to the restaurant screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCartScreen(
                              restaurantId: widget.restaurantId,
                              restaurantName: widget.restaurantName,
                              cartList: cartList,
                              subtotal: subtotal,
                              deliveryCharge: deliveryCharge,
                            ),
                          ),
                        );
                      },
                      child: Text('View Cart'),
                    ),
                    // End of View Cart Button
                  ],
                ),
              ),
            ),
      // End of Sticky Bottom
    );
  }

  // Restaurant Info
  Widget _buildRestaurantInfo() {
    return FutureBuilder<Restaurants>(
      // Retrieve the restaurant ID
      future: getRestaurant,
      // Build the restaurant info
      builder: (context, snapshot) {
        // Display restaurant info
        if (snapshot.hasData) {
          // Retrieve current user logged in
          final firebaseUser = context.watch<User>();

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  // Restaurant Image
                  Hero(
                    tag: snapshot.data.restaurantImage,
                    child: Image.asset(
                      'images/restaurants/' + snapshot.data.restaurantImage,
                      height: 250.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Restaurant Info
                  Container(
                    padding: EdgeInsets.all(15.0),
                    color: Theme.of(context).cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Restaurant Name
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            widget.restaurantName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        // End of Restaurant Name
                        // Restaurant Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Location Icon
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.location_pin,
                                color: primaryColorStyle,
                              ),
                            ),
                            // End of Location Icon
                            // Location Name
                            Text(
                              snapshot.data.location,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            // End of Location Name
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: textColor2Style,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // Restaurant Location Button
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(0, 0),
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                // Go to the location screen
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantLocationScreen(
                                    restaurantName:
                                        snapshot.data.restaurantName,
                                    geoPoint: snapshot.data.geoPoint,
                                  ),
                                ),
                              ),
                              child: Text(
                                'View Map',
                                style: TextStyle(
                                  color: complementaryColorStyle,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            // End of Restaurant Location Button
                          ],
                        ),
                        // End of Restaurant Location
                        // Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Star Icon
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.star,
                                color: primaryColorStyle,
                              ),
                            ),
                            // End of Star Icon
                            // Average Ratings
                            Text(
                              snapshot.data.averageRatings != ""
                                  ? "${snapshot.data.averageRatings}/5"
                                  : "No reviews yet",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            // End of Average Ratings
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: textColor2Style,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            // Rating Button
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size(0, 0),
                                padding: EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                // Check if user is anonymous
                                if (firebaseUser.isAnonymous) {
                                  // Display dialog box
                                  showDialogOK(
                                    context,
                                    "GetFood",
                                    "You need an account to use this feature!",
                                    () {},
                                  );
                                } else {
                                  // Display Modal Bottom Sheet
                                  return showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: screenPaddingStyle,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                              ),
                                              child: Text(
                                                'Ratings',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                            ),
                                            // 1 Star Option
                                            ListTile(
                                              // Add Review
                                              onTap: () async {
                                                // Add to rating in database
                                                Future<String> ratingId =
                                                    FirestoreService(
                                                            uid: firebaseUser
                                                                .uid)
                                                        .addRestaurantReview(
                                                  snapshot.data.userRating,
                                                  snapshot.data.restaurantId,
                                                  1,
                                                );

                                                snapshot.data.userRating =
                                                    await ratingId;

                                                setState(() {
                                                  snapshot.data.userRating =
                                                      snapshot.data.userRating;
                                                });

                                                // Close the bottom modal
                                                Navigator.pop(context);
                                              },
                                              // Display star icon on the left
                                              leading: Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              // Display number of stars
                                              title: Text(
                                                "1 Star",
                                              ),
                                            ),
                                            // End of 1 Star Option
                                            // 2 Stars Option
                                            ListTile(
                                              // Add Review
                                              onTap: () async {
                                                // Add to rating in database
                                                Future<String> ratingId =
                                                    FirestoreService(
                                                            uid: firebaseUser
                                                                .uid)
                                                        .addRestaurantReview(
                                                  snapshot.data.userRating,
                                                  snapshot.data.restaurantId,
                                                  2,
                                                );

                                                snapshot.data.userRating =
                                                    await ratingId;

                                                setState(() {
                                                  snapshot.data.userRating =
                                                      snapshot.data.userRating;
                                                });

                                                // Close the bottom modal
                                                Navigator.pop(context);
                                              },
                                              // Display star icon on the left
                                              leading: Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              // Display number of stars
                                              title: Text(
                                                "2 Stars",
                                              ),
                                            ),
                                            // End of 2 Stars Option
                                            // 3 Stars Option
                                            ListTile(
                                              // Add Review
                                              onTap: () async {
                                                // Add to rating in database
                                                Future<String> ratingId =
                                                    FirestoreService(
                                                            uid: firebaseUser
                                                                .uid)
                                                        .addRestaurantReview(
                                                  snapshot.data.userRating,
                                                  snapshot.data.restaurantId,
                                                  3,
                                                );

                                                snapshot.data.userRating =
                                                    await ratingId;

                                                setState(() {
                                                  snapshot.data.userRating =
                                                      snapshot.data.userRating;
                                                });

                                                // Close the bottom modal
                                                Navigator.pop(context);
                                              },
                                              // Display star icon on the left
                                              leading: Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              // Display number of stars
                                              title: Text(
                                                "3 Stars",
                                              ),
                                            ),
                                            // End of 3 Stars Option
                                            // 4 Stars Option
                                            ListTile(
                                              // Add Review
                                              onTap: () async {
                                                // Add to rating in database
                                                Future<String> ratingId =
                                                    FirestoreService(
                                                            uid: firebaseUser
                                                                .uid)
                                                        .addRestaurantReview(
                                                  snapshot.data.userRating,
                                                  snapshot.data.restaurantId,
                                                  4,
                                                );

                                                snapshot.data.userRating =
                                                    await ratingId;

                                                setState(() {
                                                  snapshot.data.userRating =
                                                      snapshot.data.userRating;
                                                });

                                                // Close the bottom modal
                                                Navigator.pop(context);
                                              },
                                              // Display star icon on the left
                                              leading: Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              // Display number of stars
                                              title: Text(
                                                "4 Stars",
                                              ),
                                            ),
                                            // End of 4 Stars Option
                                            // 5 Stars Option
                                            ListTile(
                                              // Add Review
                                              onTap: () async {
                                                // Add to rating in database
                                                Future<String> ratingId =
                                                    FirestoreService(
                                                            uid: firebaseUser
                                                                .uid)
                                                        .addRestaurantReview(
                                                  snapshot.data.userRating,
                                                  snapshot.data.restaurantId,
                                                  5,
                                                );

                                                snapshot.data.userRating =
                                                    await ratingId;

                                                setState(() {
                                                  snapshot.data.userRating =
                                                      snapshot.data.userRating;
                                                });

                                                // Close the bottom modal
                                                Navigator.pop(context);
                                              },
                                              // Display star icon on the left
                                              leading: Icon(
                                                Icons.star,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              // Display number of stars
                                              title: Text(
                                                "5 Stars",
                                              ),
                                            ),
                                            // End of 5 Stars Option
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Rate this Restaurant',
                                style: TextStyle(
                                  color: complementaryColorStyle,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            // End of Rating Button
                          ],
                        ),
                        // End of Rating
                      ],
                    ),
                  ),
                  // End of Restaurant Info
                  // Restaurant Dishes
                  Container(
                    padding: screenPaddingStyle,
                    child: _buildRestaurantDishesList(),
                  ),
                  // End of Restaurant Dishes
                ],
              );
            },
            // Total number of categories
            itemCount: 1,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: screenPaddingStyle,
            child: Center(
              // Display Loading Indicator
              child: CircularProgressIndicator(
                color: complementaryColorStyle,
              ),
            ),
          );
        } else {
          // Return not found
          return Padding(
            padding: screenPaddingStyle,
            child: Center(
              child: Text(
                'No restaurant found',
                style: paragraph1Style,
              ),
            ),
          );
        }
      },
    );
  }
  // End of Restaurant Info

  // Restaurant Dishes List
  Widget _buildRestaurantDishesList() {
    return FutureBuilder<List<RestaurantDishes>>(
      // Retrieve the restaurant dishes
      future: getRestaurantDishes,
      // Build the dishes list
      builder: (context, snapshot) {
        // Display all the list of available dishes
        if (snapshot.hasData && snapshot.data.length > 0) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // Add spacing between dishes
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 20);
            },
            // Build all available dishes
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Dish Info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Dish Name
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          snapshot.data[index].name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      // End of Dish Name
                      // Dish Price
                      Text(
                        "\$" +
                            double.parse(snapshot.data[index].price)
                                .toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      // End of Dish Price
                    ],
                  ),
                  // End of Dish Info
                  // Cart Button
                  Row(
                    children: [
                      // Minus Quantity Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(5.0),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          setState(() {
                            // Check if quantity is more than 0
                            if (snapshot.data[index].quantity > 0) {
                              // Update the item quantity
                              cartList.removeWhere(
                                  (item) => item[1] == snapshot.data[index].id);
                              // Deduce the item quantity from cart
                              cartList.add([
                                --snapshot.data[index].quantity,
                                snapshot.data[index].id
                              ]);
                              // Remove item if the quantity is less than equal to 0
                              if (snapshot.data[index].quantity <= 0) {
                                cartList.removeWhere((item) =>
                                    item[1] == snapshot.data[index].id);
                              }
                              // Deduct the item price to subtotal
                              subtotal -=
                                  double.parse(snapshot.data[index].price);
                            }
                          });
                        },
                        child: Text('-'),
                      ),
                      // End of Minus Quantity Button
                      // Display Quantity
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(snapshot.data[index].quantity.toString()),
                      ),
                      // End of Display Quantity
                      // Add Quantity Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(5.0),
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          setState(() {
                            // Update the item quantity
                            cartList.removeWhere(
                                (item) => item[1] == snapshot.data[index].id);
                            // Increase the quantity and add the item to cart
                            cartList.add([
                              ++snapshot.data[index].quantity,
                              snapshot.data[index].id
                            ]);
                            // Add the item price to subtotal
                            subtotal +=
                                double.parse(snapshot.data[index].price);
                          });
                        },
                        child: Text('+'),
                      ),
                      // End of Add Quantity Button
                    ],
                  ),
                  // End of Cart Button
                ],
              );
            },
            // Total number of dishes
            itemCount: snapshot.data.length,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            // Display Loading Indicator
            child: CircularProgressIndicator(
              color: complementaryColorStyle,
            ),
          );
        } else {
          // Return no dishes
          return Text(
            'This restaurant does not have any dishes...',
            style: Theme.of(context).textTheme.bodyText1,
          );
        }
      },
    );
  }
  // End of Restaurant Dishes List
}
// End of Restaurant Screen
