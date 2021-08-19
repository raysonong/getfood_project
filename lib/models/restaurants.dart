import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurants {
  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String location;
  String deliveryCharge;
  GeoPoint geoPoint;

  List<String> categories;
  String favouriteId;
  String userRating;
  String averageRatings;

  Restaurants(
      {this.restaurantId,
      this.restaurantName,
      this.restaurantImage,
      this.location,
      this.geoPoint,
      this.deliveryCharge,
      this.categories,
      this.favouriteId,
      this.userRating,
      this.averageRatings});

  Restaurants.fromMap(id, Map<String, dynamic> data,
      {List<String> restaurantCategories,
      String favourite,
      String userRating,
      String ratings}) {
    this.restaurantId = id;
    this.restaurantName = data['restaurant_name'];
    this.restaurantImage = data['restaurant_image'];
    this.location = data['restaurant_location'];
    this.geoPoint = data['geopoint'];
    this.deliveryCharge = data['delivery_charge'].toString();
    this.categories = restaurantCategories ?? [];
    this.favouriteId = favourite ?? "";
    this.userRating = userRating;
    this.averageRatings = ratings.toString();
  }
}
