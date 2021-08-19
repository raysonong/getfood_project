import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/models/orders.dart';
import 'package:getfood_project/models/restaurant_dishes.dart';
import 'package:getfood_project/models/restaurants.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:provider/provider.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

// Order History Screen
class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Future<List<Orders>> getOrderHistory;
  double totalDishPrice;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // Get user's address
    getOrderHistory = FirestoreService(uid: firebaseUser.uid).getOrderHistory();
    // Store total dish price
    totalDishPrice = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenPaddingStyle,
      shrinkWrap: true,
      children: [
        _buildOrderHistoryList(),
      ],
    );
  }

  // Row Price
  Widget _displayRowPrice(String tag, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Tag
        Text(tag, style: Theme.of(context).textTheme.bodyText1),
        // End of Tag
        // Price
        Text(
          '\$' + price,
          style: Theme.of(context).textTheme.headline4,
        ),
        // End of Price
      ],
    );
  }
  // End of Row Price

  // Order History List
  Widget _buildOrderHistoryList() {
    return FutureBuilder<List<Orders>>(
      // Retrieve the order histories
      future: getOrderHistory,
      // Build the order history list
      builder: (context, snapshot) {
        // Display all the list of order history
        if (snapshot.hasData && snapshot.data.length > 0) {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // Add spacing between order histories
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30.0,
                ),
                child: Divider(
                  thickness: 2,
                ),
              );
            },
            // Build order history
            itemBuilder: (context, index) {
              var order = snapshot.data[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  FutureBuilder<Restaurants>(
                    // Retrieve the restaurant by ID
                    future: FirestoreService()
                        .getRestaurantById(order.restaurantId),
                    // Build the restaurant name
                    builder: (context, snapshot) {
                      // Display the Restaurant Name
                      if (snapshot.hasData) {
                        // Restaurant Name
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            snapshot.data.restaurantName,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        );
                        // End of Restaurant Name
                      } else {
                        return Text(
                          '',
                          style: Theme.of(context).textTheme.headline2,
                        );
                      }
                    },
                  ),
                  // End of Restaurant Name
                  // Display all ordered dishes
                  ListView.separated(
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
                        future: FirestoreService()
                            .getRestaurantDishById(order.dishes[index]),
                        // Build the dishes list
                        builder: (context, snapshot) {
                          // Display all the list of available dishes
                          if (snapshot.hasData) {
                            var dish = snapshot.data;
                            // Calculate the dish price multiply by the quantity
                            totalDishPrice = double.parse(dish.price) *
                                order.quantities[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    // Dish Quantity
                                    Padding(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Text(
                                        order.quantities[index].toString() +
                                            "x",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    // End of Dish Quantity
                                    // Dish Name
                                    Text(
                                      dish.name,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    // End of Dish Name
                                  ],
                                ),
                                // Dish Price
                                Text(
                                  '\$' + totalDishPrice.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                // End of Dish Price
                              ],
                            );
                          } else {
                            return Row();
                          }
                        },
                      );
                    },
                    itemCount: order.quantities.length,
                  ),
                  // End of ordered dishes
                  SizedBox(height: 30.0),
                  // Subtotal
                  _displayRowPrice('Subtotal', order.subtotal),
                  // End of Subtotal
                  SizedBox(height: 10.0),
                  // Delivery Charge
                  _displayRowPrice('Delivery Charge', order.deliveryCharge),
                  // End of Delivery Charge
                  SizedBox(height: 10.0),
                  // Service Charge
                  _displayRowPrice('Service Charge', order.serviceCharge),
                  // End of Service Charge
                  SizedBox(height: 10.0),
                  // Total
                  _displayRowPrice('Total', order.total),
                  // End of Total
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
          // Return no order history
          return Center(
            child: Text(
              'You have not order anything yet.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
  }
  // End of Order History List
}
// End of Order History Screen
