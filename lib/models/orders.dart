class Orders {
  String userId;
  String restaurantId;
  List<dynamic> quantities;
  List<dynamic> dishes;
  String subtotal;
  String deliveryCharge;
  String serviceCharge;
  String total;

  Orders(
      {this.userId,
      this.restaurantId,
      this.quantities,
      this.dishes,
      this.subtotal,
      this.deliveryCharge,
      this.serviceCharge,
      this.total});

  Orders.fromMap(Map<String, dynamic> data) {
    this.userId = data['userId'];
    this.restaurantId = data['restaurantId'];
    this.quantities = data['quantities'];
    this.dishes = data['dishes'];
    this.subtotal = data['subtotal'];
    this.deliveryCharge = data['delivery_charge'];
    this.serviceCharge = data['service_charge'];
    this.total = data['total_price'];
  }
}
