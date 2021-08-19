class RestaurantDishes {
  String id;
  int quantity;
  String name;
  String price;
  String restaurantId;

  RestaurantDishes(
      {this.id, this.quantity, this.name, this.price, this.restaurantId});

  RestaurantDishes.fromMap(String dishId, Map<String, dynamic> data,
      {int quantity}) {
    this.id = dishId;
    this.quantity = quantity ?? 0;
    this.name = data['name'];
    this.price = data['price'].toString();
    this.restaurantId = data['restaurant_id'];
  }
}
