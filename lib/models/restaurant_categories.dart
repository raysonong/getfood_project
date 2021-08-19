class RestaurantCategories {
  String categoryId;
  String categoryName;
  String imagePath;

  RestaurantCategories({this.categoryId, this.categoryName, this.imagePath});

  RestaurantCategories.fromMap(id, Map<String, dynamic> data) {
    this.categoryId = id;
    this.categoryName = data['category_name'];
    this.imagePath = data['image_path'];
  }
}
