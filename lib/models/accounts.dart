class AccountInfo {
  String username;
  String phoneNumber;
  String address;

  AccountInfo({this.username, this.phoneNumber, this.address});

  AccountInfo.fromMap(Map<String, dynamic> data) {
    this.username = data['username'] ?? "";
    this.phoneNumber = data['phone_number'] ?? "";
    this.address = data['address'] ?? "";
  }
}
