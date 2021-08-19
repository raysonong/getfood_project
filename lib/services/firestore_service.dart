import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfood_project/models/orders.dart';
import 'package:getfood_project/models/restaurant_dishes.dart';
import 'package:getfood_project/models/restaurant_in_category.dart';
import 'package:getfood_project/models/accounts.dart';
import 'package:getfood_project/models/restaurant_categories.dart';
import 'package:getfood_project/models/restaurants.dart';
import 'package:getfood_project/models/reviews.dart';

class FirestoreService {
  final String uid;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _restaurantCategories =
      FirebaseFirestore.instance.collection("restaurant_categories");
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection("restaurants");
  final CollectionReference _restaurantInCategory =
      FirebaseFirestore.instance.collection("restaurant_in_category");
  final CollectionReference _restaurantDishes =
      FirebaseFirestore.instance.collection("restaurant_dishes");
  final CollectionReference _orders =
      FirebaseFirestore.instance.collection("orders");
  final CollectionReference _favourites =
      FirebaseFirestore.instance.collection("favourites");
  final CollectionReference _reviews =
      FirebaseFirestore.instance.collection("reviews");

  FirestoreService({this.uid = ""});

  // Get the username
  Future<String> getUserName() async {
    try {
      // Retrieve the username
      var snapshot = await _users.doc(uid).get();
      AccountInfo user = AccountInfo.fromMap(snapshot.data());

      // Return the username
      return user.username ?? "";
    } catch (e) {
      return "";
    }
  }

  // Get the user's address
  Future<String> getUserAddress() async {
    try {
      // Retrieve the user address
      var snapshot = await _users.doc(uid).get();
      AccountInfo user = AccountInfo.fromMap(snapshot.data());

      // Return the address
      return user.address ?? "";
    } catch (e) {
      return "";
    }
  }

  // Add user's address
  Future<bool> addUserAddress(String address) async {
    // Add the address to the database and return the status
    bool result = await _users
        .doc(uid)
        .set({'address': address})
        .then(
          (value) => true,
        )
        .onError((error, stackTrace) => false);

    // Return result
    return result;
  }

  // Get the user's info
  Future<AccountInfo> getUserInfo() async {
    try {
      // Retrieve the user address
      var snapshot = await _users.doc(uid).get();
      AccountInfo user = AccountInfo.fromMap(snapshot.data());

      // Return the user info
      return user ?? AccountInfo();
    } catch (e) {
      return AccountInfo();
    }
  }

  // Add user's address
  Future<bool> addUserInfo(
      String username, String phoneNumber, String address) async {
    // Add the user info to the database and return the status
    bool result = await _users
        .doc(uid)
        .set({
          'username': username,
          'phone_number': phoneNumber,
          'address': address,
        })
        .then(
          (value) => true,
        )
        .onError((error, stackTrace) => false);

    // Return ID
    return result;
  }

  // Get all restaurant categories
  Future<List<RestaurantCategories>> getRestaurantCategories() async {
    List<RestaurantCategories> list = [];
    QuerySnapshot snapshot = await _restaurantCategories.get();

    // Foreach every restaurant categories
    snapshot.docs.forEach((document) {
      RestaurantCategories category =
          RestaurantCategories.fromMap(document.id, document.data());
      list.add(category);
    });

    // Return all the retrieved data
    return list;
  }

  // Get all restaurant categories By ID
  Future<RestaurantCategories> getRestaurantCategoryById(String id) async {
    var snapshot = await _restaurantCategories.doc(id).get();

    RestaurantCategories category =
        RestaurantCategories.fromMap(snapshot.id, snapshot.data());

    // Return all the retrieved data
    return category;
  }

  // Get all restaurant categories by search query
  Future<List<RestaurantCategories>> getRestaurantCategoriesBySearchQuery(
      String query) async {
    List<RestaurantCategories> list = [];
    QuerySnapshot snapshot = await _restaurantCategories.get();

    // Foreach every restaurant categories
    snapshot.docs.forEach(
      (document) {
        RestaurantCategories category =
            RestaurantCategories.fromMap(document.id, document.data());
        // Check if it starts with the input query and lower the case to eliminate case-sensitivity and check if query is not empty
        if (category.categoryName
                .toLowerCase()
                .startsWith(query.toLowerCase()) &&
            query.isNotEmpty) {
          // Add search query result to the list
          list.add(category);
        }
      },
    );

    // Return all the retrieved data
    return list;
  }

  // Get all restaurants
  Future<List<Restaurants>> getRestaurants(
      {String searchCategoryId, bool searchFavourites = false}) async {
    List<Restaurants> list = [];
    QuerySnapshot snapshot = await _restaurants.get();

    // Foreach every restaurants
    await Future.forEach(snapshot.docs, (QueryDocumentSnapshot document) async {
      bool isCategoryFound = true;
      String favourite;
      String userRating;
      String ratings;

      // Check if search category ID is set
      if (searchCategoryId != null) {
        // Retrieve the restaurant's category
        isCategoryFound =
            await isCategoriesInRestaurant(document.id, searchCategoryId);
      }

      // Get favourites
      favourite = await getFavouritesByUserandRestaurant(document.id);

      // Filter condition
      if (isCategoryFound && (favourite != "" || !searchFavourites)) {
        // Get user rating
        userRating = await getRatingByUserandRestaurant(uid, document.id);

        // Get favourites
        ratings = await getRestaurantRatings(document.id);

        // Retrieve the restaurant's category
        List<String> restaurantCategories =
            await getCategoriesByRestaurantId(document.id);

        Restaurants restaurants = Restaurants.fromMap(
          document.id,
          document.data(),
          restaurantCategories: restaurantCategories,
          favourite: favourite,
          userRating: userRating,
          ratings: ratings,
        );

        // Add the restaurant
        list.add(restaurants);
      }
    });

    // Return all the retrieved data
    return list;
  }

  // Get all restaurant By ID
  Future<Restaurants> getRestaurantById(String id) async {
    var snapshot = await _restaurants.doc(id).get();

    // Get user rating
    String userRating = await getRatingByUserandRestaurant(uid, snapshot.id);

    // Get average ratings
    String ratings = await getRestaurantRatings(snapshot.id);

    Restaurants restaurant = Restaurants.fromMap(
      snapshot.id,
      snapshot.data(),
      ratings: ratings,
      userRating: userRating,
    );

    // Return all the retrieved data
    return restaurant;
  }

  // Get all restaurants by search query
  Future<List<Restaurants>> getRestaurantsBySearchQuery(String query) async {
    List<Restaurants> list = [];
    QuerySnapshot snapshot = await _restaurants.get();

    String ratings = "";

    // Foreach every restaurants
    await Future.forEach(
      snapshot.docs,
      (QueryDocumentSnapshot document) async {
        // Get ratings
        ratings = await getRestaurantRatings(document.id);

        Restaurants restaurants = Restaurants.fromMap(
          document.id,
          document.data(),
          ratings: ratings,
        );

        // Check if it starts with the input query and lower the case to eliminate case-sensitivity and check if query is not empty
        if (restaurants.restaurantName
                .toLowerCase()
                .startsWith(query.toLowerCase()) &&
            query.isNotEmpty) {
          list.add(restaurants);
        }
      },
    );

    // Return all the retrieved data
    return list;
  }

  // Get all categories by restaurant ID
  Future<List<String>> getCategoriesByRestaurantId(id) async {
    List<String> list = [];
    QuerySnapshot snapshot =
        await _restaurantInCategory.where('restaurantId', isEqualTo: id).get();

    await Future.forEach(
      snapshot.docs,
      (document) async {
        RestaurantCategories categories = await getRestaurantCategoryById(
            RestaurantInCategory.fromMap(document.data()).categoryId);

        // Add the category
        list.add(categories.categoryName);
      },
    );

    // Return all the retrieved data
    return list;
  }

  // Check if categories is in the restaurant
  Future<bool> isCategoriesInRestaurant(restaurantId, searchCategoryId) async {
    var isCategoriesInRestaurant = false;
    QuerySnapshot snapshot = await _restaurantInCategory
        .where('restaurantId', isEqualTo: restaurantId)
        .get();

    await Future.forEach(
      snapshot.docs,
      (document) async {
        RestaurantCategories categories = await getRestaurantCategoryById(
            RestaurantInCategory.fromMap(document.data()).categoryId);

        // Check if match
        if ((searchCategoryId == categories.categoryId) &&
            !isCategoriesInRestaurant) {
          // Set searched category matched
          isCategoriesInRestaurant = true;
        }
      },
    );

    // Return all the retrieved data
    return isCategoriesInRestaurant;
  }

  // Get favourites by user and restaurant
  Future<String> getFavouritesByUserandRestaurant(restaurantId) async {
    QuerySnapshot snapshot = await _favourites
        .where('userId', isEqualTo: uid)
        .where('restaurantId', isEqualTo: restaurantId)
        .get();

    if (snapshot.docs.length > 0) {
      return snapshot.docs.first.id;
    } else {
      return "";
    }
  }

  // Add Favourites
  Future addFavourites(String restaurantId) async {
    DocumentReference newDoc = await _favourites.add({
      'userId': uid,
      'restaurantId': restaurantId,
    });

    // Return ID
    return newDoc.id;
  }

  // Remove Favourites
  Future removeFavourites(String favouriteId) async {
    return await _favourites.doc(favouriteId).delete();
  }

  // Get all dishes
  Future<List<RestaurantDishes>> getRestaurantDishes(
      String restaurantId) async {
    List<RestaurantDishes> list = [];
    QuerySnapshot snapshot = await _restaurantDishes
        .where('restaurant_id', isEqualTo: restaurantId)
        .get();

    // Foreach every dishes
    snapshot.docs.forEach((document) {
      RestaurantDishes dishes =
          RestaurantDishes.fromMap(document.id, document.data());
      list.add(dishes);
    });

    // Return all the retrieved data
    return list;
  }

  // Get dish by ID
  Future<RestaurantDishes> getRestaurantDishById(String dishId,
      {int quantity}) async {
    var snapshot = await _restaurantDishes.doc(dishId).get();

    RestaurantDishes dish = RestaurantDishes.fromMap(
        snapshot.id, snapshot.data(),
        quantity: quantity);

    // Return all the retrieved data
    return dish;
  }

  // Get order history by user
  Future<List<Orders>> getOrderHistory() async {
    List<Orders> list = [];
    QuerySnapshot snapshot =
        await _orders.where('userId', isEqualTo: uid).get();

    // Foreach every order histories
    snapshot.docs.forEach((document) {
      Orders orders = Orders.fromMap(document.data());
      list.add(orders);
    });

    // Return all the retrieved data
    return list;
  }

  // Add Order
  Future<String> addOrder(
      String restaurantId,
      List<dynamic> quantities,
      List<dynamic> dishes,
      String subtotal,
      String deliveryCharge,
      String serviceCharge,
      String total) async {
    // Add order
    DocumentReference newDoc = await _orders.add({
      'userId': uid,
      'restaurantId': restaurantId,
      'quantities': quantities,
      'dishes': dishes,
      'subtotal': subtotal,
      'delivery_charge': deliveryCharge,
      'service_charge': serviceCharge,
      'total_price': total,
    });

    // Return ID
    return newDoc.id;
  }

  // Get rating list by user and restaurant
  Future<String> getRatingByUserandRestaurant(
      String userId, String restaurantId) async {
    QuerySnapshot snapshot = await _reviews
        .where('user_id', isEqualTo: userId)
        .where('restaurant_id', isEqualTo: restaurantId)
        .get();

    if (snapshot.docs.length > 0) {
      return snapshot.docs.first.id;
    } else {
      return "";
    }
  }

  // Get Restaurant Average Ratings
  Future<String> getRestaurantRatings(String restaurantId) async {
    double ratings = 0;

    QuerySnapshot snapshot =
        await _reviews.where('restaurant_id', isEqualTo: restaurantId).get();

    // Check if there are any restaurant reviews
    if (snapshot.size > 0) {
      // Foreach every ratings
      snapshot.docs.forEach((document) {
        Reviews dishes = Reviews.fromMap(document.data());

        // Add total rating
        ratings += dishes.rating;
      });

      // Calculate average rating
      return (ratings / snapshot.size.toDouble()).toStringAsFixed(2);
    } else {
      // Return nothing if no ratings found
      return "";
    }
  }

  // Add review for the restaurant
  Future<String> addRestaurantReview(
      String reviewId, String restaurantId, double rating) async {
    // Delete the previous review
    try {
      await _reviews.doc(reviewId).delete();
    } catch (e) {}

    // Add the review to the database and return the status
    DocumentReference newDoc = await _reviews.add({
      'user_id': uid,
      'restaurant_id': restaurantId,
      'rating': rating,
    });

    // Return ID
    return newDoc.id;
  }
}
