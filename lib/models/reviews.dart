class Reviews {
  double rating;

  Reviews({this.rating});

  Reviews.fromMap(Map<String, dynamic> data) {
    this.rating = data['rating'];
  }
}
