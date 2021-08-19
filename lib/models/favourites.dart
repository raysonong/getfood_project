class Favourites {
  String userId;
  String restaurantId;

  Favourites({this.userId, this.restaurantId});

  Favourites.fromMap(Map<String, dynamic> data) {
    this.userId = data['userId'];
    this.restaurantId = data['restaurantId'];
  }
}
