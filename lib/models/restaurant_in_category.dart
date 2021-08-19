class RestaurantInCategory {
  String categoryId;
  String restaurantId;

  RestaurantInCategory({this.categoryId, this.restaurantId});

  RestaurantInCategory.fromMap(Map<String, dynamic> data) {
    this.categoryId = data['categoryId'];
    this.restaurantId = data['restaurantId'];
  }
}
