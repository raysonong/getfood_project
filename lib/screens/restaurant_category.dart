import 'package:firebase_auth/firebase_auth.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:getfood_project/models/restaurants.dart';
import 'package:getfood_project/services/firestore_service.dart';
// Theme and Style
import 'package:getfood_project/style.dart';
// Imported Screens
import 'package:getfood_project/screens/restaurant.dart';

// Restaurant Category Screen
class RestaurantCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  RestaurantCategoryScreen(
      {@required this.categoryId, @required this.categoryName});

  @override
  _RestaurantCategoryScreenState createState() =>
      _RestaurantCategoryScreenState();
}

class _RestaurantCategoryScreenState extends State<RestaurantCategoryScreen> {
  Future getRestaurantList;

  // Initalize State
  @override
  void initState() {
    super.initState();

    final firebaseUser = Provider.of<User>(context, listen: false);

    getRestaurantList = FirestoreService(uid: firebaseUser.uid).getRestaurants(
      searchCategoryId: widget.categoryId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: Text(
          widget.categoryName,
        ),
      ),
      // End of App Bar
      // Body
      body: SingleChildScrollView(
        padding: screenPaddingStyle,
        child: _buildRestaurantList(),
      ),
      // End of Body
    );
  }

  // Restaurant List
  Widget _buildRestaurantList() {
    return FutureBuilder<List<Restaurants>>(
      // Retrieve the categories data
      future: getRestaurantList,
      // Build the category list
      builder: (context, snapshot) {
        // Display all the list of available categories
        if (snapshot.hasData && snapshot.data.length > 0) {
          // Retrieve current user logged in
          final firebaseUser = context.watch<User>();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Number of Restaurants
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  snapshot.data.length.toString() + ' restaurant(s)',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              // End of Number of Restaurants
              // Restaurants
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var restaurant = snapshot.data[index];
                  bool isFavourite = restaurant.favouriteId != "";
                  return GestureDetector(
                    onTap: () {
                      // Go to the restaurant screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantScreen(
                            restaurantId: snapshot.data[index].restaurantId,
                            restaurantName: snapshot.data[index].restaurantName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: borderRadiusStyle,
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadiusStyle,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Restaurant Image
                            Hero(
                              tag: restaurant.restaurantImage,
                              child: Image.asset(
                                'images/restaurants/' +
                                    restaurant.restaurantImage,
                                height: 230.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            // End of Restaurant Image
                            // Restaurant Info
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 10.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Restaurant Name
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    child: Text(
                                      restaurant.restaurantName,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                  ),
                                  // End of Restaurant Name
                                  // Restaurant Categories
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Container(
                                      height: 18.0,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        // Display in row
                                        scrollDirection: Axis.horizontal,
                                        // Make it non-scrollable
                                        physics: NeverScrollableScrollPhysics(),
                                        // Circle Separator
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
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
                                        // Builder
                                        itemBuilder: (context, index) => Text(
                                          restaurant.categories[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        itemCount: restaurant.categories.length,
                                      ),
                                    ),
                                  ),
                                  // End of Restaurant Categories
                                  // Rating
                                  Row(
                                    children: <Widget>[
                                      // Star Icon
                                      Icon(
                                        Icons.star,
                                        color: primaryColorStyle,
                                      ),
                                      // End of Star Icon
                                      // Rating Amount
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          restaurant.averageRatings != ""
                                              ? "${restaurant.averageRatings}/5"
                                              : "No reviews yet",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                      // End of Rating Amount
                                    ],
                                  ),
                                  // End of Rating
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  // Favourites
                                  GestureDetector(
                                    onTap: () async {
                                      // Check if user is anonymous
                                      if (!firebaseUser.isAnonymous) {
                                        // If its favourited, remove it
                                        if (isFavourite) {
                                          // Remove favourites in database
                                          await FirestoreService(
                                                  uid: firebaseUser.uid)
                                              .removeFavourites(
                                                  restaurant.favouriteId)
                                              .then((value) =>
                                                  restaurant.favouriteId = "");
                                        } else {
                                          // Add to favourites in database
                                          restaurant.favouriteId =
                                              await FirestoreService(
                                                      uid: firebaseUser.uid)
                                                  .addFavourites(
                                                      restaurant.restaurantId);
                                        }

                                        // Refresh favourite State
                                        setState(() {
                                          isFavourite = isFavourite;
                                        });
                                      } else {
                                        // Display dialog box
                                        showDialogOK(
                                          context,
                                          "GetFood",
                                          "You need an account to use this feature!",
                                          () {},
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: isFavourite
                                              ? Colors.red
                                              : iconColorStyle,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            isFavourite
                                                ? 'Favourited'
                                                : 'Add to favourites',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // End of Favourites
                                ],
                              ),
                            ),
                            // End of Restaurant Info
                          ],
                        ),
                      ),
                    ),
                  );
                },
                // Total number of categories
                itemCount: snapshot.data.length,
              ),
              // End of Restaurants
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            // Display Loading Indicator
            child: CircularProgressIndicator(
              color: complementaryColorStyle,
            ),
          );
        } else {
          // Return not found
          return Center(
            child: Text(
              'No restaurant(s) found',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        }
      },
    );
  }
  // End of Restaurant List
}
// End of Restaurant Category Screen
