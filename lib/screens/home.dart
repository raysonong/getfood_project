import 'package:flutter/material.dart';
import 'package:getfood_project/models/restaurant_categories.dart';
import 'package:getfood_project/models/restaurants.dart';
import 'package:getfood_project/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getfood_project/utilities/dialogutil.dart';
import 'package:provider/provider.dart';
// Theme and Style
import 'package:getfood_project/style.dart';
// Imported Screens
import 'package:getfood_project/screens/restaurant_category.dart';
import 'package:getfood_project/screens/restaurant.dart';

// Home Screen
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = 'GetFood';
  int index = 0;
  List<Widget> navList;

  Future getRestaurantCategories;
  Future getRestaurantList;

  // Initalize State
  @override
  void initState() {
    super.initState();

    // Retrieve current user logged in
    final firebaseUser = Provider.of<User>(context, listen: false);

    // Retrieve restaurant categories for building category list widget
    getRestaurantCategories = FirestoreService().getRestaurantCategories();
    // Retrieve restaurants for building restaurant list widget
    getRestaurantList =
        FirestoreService(uid: firebaseUser.uid).getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: screenPaddingStyle,
      shrinkWrap: true,
      children: <Widget>[
        // Search Field
        _buildSearchField(),
        // End of Search Field
        SizedBox(
          height: 30,
        ),
        // Categories
        _buildCategoryList(),
        // End of Categories
        SizedBox(
          height: 30,
        ),
        // Restaurants List
        _buildRestaurantList(),
        // End of Restaurants List
      ],
    );
  }

  // Search Field
  Widget _buildSearchField() {
    return TextField(
      readOnly: true,
      onTap: () => showSearch(context: context, delegate: DataSearch()),
      decoration: InputDecoration(
        // Label Text
        hintText: 'Find restaurants, dishes, categories...',
        // Prefix Icon
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
  // End of Search Field

  // Category List
  Widget _buildCategoryList() {
    return FutureBuilder<List<RestaurantCategories>>(
      // Retrieve the categories data
      future: getRestaurantCategories,
      // Build the category list
      builder: (context, snapshot) {
        // Display all the list of available categories
        if (snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              // End of Heading
              // Display the list of categories
              Container(
                height: 100.0,
                child: ListView.separated(
                  shrinkWrap: true,
                  // Make the list view scroll horizontal
                  scrollDirection: Axis.horizontal,
                  // Add spacing between categories
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  // Build all available categories
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      // Go to the restaurant category screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantCategoryScreen(
                            categoryId: snapshot.data[index].categoryId,
                            categoryName: snapshot.data[index].categoryName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadiusStyle,
                      ),
                      width: 150.0,
                      height: 100.0,
                      child: ClipRRect(
                        borderRadius: borderRadiusStyle,
                        child: Stack(
                          children: [
                            // Category Image
                            Image.asset(
                              'images/restaurant_categories/' +
                                  snapshot.data[index].imagePath,
                              width: 150.0,
                              height: 100.0,
                              fit: BoxFit.fill,
                            ),
                            // End of Category Image
                            // Image Color Blender
                            Container(
                              color: imageBlenderColorStyle,
                            ),
                            // End of Image Color Blender
                            // Category Name
                            Center(
                              child: Text(
                                snapshot.data[index].categoryName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor3Style,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            // End of Category Name
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Total number of categories
                  itemCount: snapshot.data.length,
                ),
              ),
            ],
          );
        } else {
          // Return empty column if no categories found
          return Column();
        }
      },
    );
  }
  // End of Category List

  // Restaurant List
  Widget _buildRestaurantList() {
    return FutureBuilder<List<Restaurants>>(
      // Retrieve the categories data
      future: getRestaurantList,
      // Build the category list
      builder: (context, snapshot) {
        // Display all the list of available categories
        if (snapshot.hasData) {
          // Retrieve current user logged in
          final firebaseUser = context.watch<User>();
          // Display
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Restaurants',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              // End of Heading
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
                                                ? 'Favourited!'
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
        } else {
          // Return empty column
          return Column();
        }
      },
    );
  }
  // End of Restaurant List
}
// End of Home Screen

// Search Section
class DataSearch extends SearchDelegate<String> {
  // Search Field Label
  @override
  String get searchFieldLabel => 'Find restaurants, dishes, categories...';
  // End of Search Field Label

  // Build Actions
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        // Clear the search query input
        onPressed: () => query = '',
        // Clear Icon
        icon: Icon(Icons.clear),
      ),
    ];
  }
  // End of Build Actions

  // Build Leading
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      // Close the search
      onPressed: () => close(context, null),
      // Arrow Icon
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }
  // End of Build Leading

  // Build Results
  @override
  Widget buildResults(BuildContext context) {
    // Display Search List
    return _viewSearchList();
  }
  // End of Build Results

  // Build Suggestions
  @override
  Widget buildSuggestions(BuildContext context) {
    // Display Search List
    return _viewSearchList();
  }
  // End of Build Suggestions

  // View Search List
  Widget _viewSearchList() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 30.0,
        horizontal: 0.0,
      ),
      physics: ScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show Restaurant Categories Result
          _restaurantCategoriesResult(),
          // End of Show Restaurant Categories Result
          // Show Restaurants Result
          _restaurantsResult(),
          // End of Show Restaurants Result
        ],
      ),
    );
  }
  // End of View Search List

  // Restaurant Categories Result
  Widget _restaurantCategoriesResult() {
    return FutureBuilder<List<RestaurantCategories>>(
      // Retrieve the categories data
      future: FirestoreService().getRestaurantCategoriesBySearchQuery(query),
      // Build the category list
      builder: (context, snapshot) {
        // Display all the list of available categories if there are query results
        if (snapshot.hasData && query.length > 0 && snapshot.data.length > 0) {
          // Retrieve all search results
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                child: Text(
                  'Categories',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              // End of Heading
              // Display all results for the current input query
              Container(
                color: Theme.of(context).cardColor,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ListTile(
                    // Go to the restaurant category screen
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantCategoryScreen(
                          categoryId: snapshot.data[index].categoryId,
                          categoryName: snapshot.data[index].categoryName,
                        ),
                      ),
                    ),
                    // Display search icon on the left
                    leading: Icon(
                      Icons.search,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    // Display category name
                    title: Text(
                      snapshot.data[index].categoryName,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          );
        }
        // Return empty column if search result not found
        else {
          return Column();
        }
      },
    );
  }
  // End of Restaurant Categories Result

  // Restaurant Result
  Widget _restaurantsResult() {
    return FutureBuilder<List<Restaurants>>(
      // Retrieve the restaurants data
      future: FirestoreService().getRestaurantsBySearchQuery(query),
      // Build the restaurant list
      builder: (context, snapshot) {
        // Display all the list of available categories if there are query results
        if (snapshot.hasData && query.length > 0 && snapshot.data.length > 0) {
          // Retrieve all search results
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Heading
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                child: Text(
                  'Restaurants',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              // End of Heading
              // Display all results for the current input query
              Container(
                color: Theme.of(context).cardColor,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => GestureDetector(
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
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Hero(
                              tag: snapshot.data[index].restaurantImage,
                              child: Image.asset(
                                'images/restaurants/' +
                                    snapshot.data[index].restaurantImage,
                                width: 100.0,
                                height: 75.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  snapshot.data[index].restaurantName,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
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
                                      snapshot.data[index].averageRatings != ""
                                          ? "${snapshot.data[index].averageRatings}/5"
                                          : "No reviews yet",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  // End of Rating Amount
                                ],
                              ),
                              // End of Rating
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        // Return empty column if search result not found
        else {
          return Column();
        }
      },
    );
  }
  // End of Restaurant Result
}
// End of Search Section
