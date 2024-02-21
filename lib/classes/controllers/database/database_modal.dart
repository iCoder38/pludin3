class Planets {
  late final int id;
  late final String userId;
  late final String fullName;
  late final String lastName;
  late final String middleName;
  late final String email;
  late final String gender;
  late final String contactNumber;
  late final String role;
  late final String dob;
  late final String address;
  late final String zipCode;
  late final String city;
  late final String state;
  late final String status;
  late final String image;
  late final String device;
  late final String deviceToken;
  late final String socialId;
  late final String socialType;
  late final String latitude;
  late final String longitude;
  late final String firebaseId;
  late final String username;

  Planets({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.gender,
    required this.contactNumber,
    required this.role,
    required this.dob,
    required this.address,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.status,
    required this.image,
    required this.device,
    required this.deviceToken,
    required this.socialId,
    required this.socialType,
    required this.latitude,
    required this.longitude,
    required this.firebaseId,
    required this.username,
  });

  Planets.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        userId = result["userId"],
        fullName = result["fullName"],
        lastName = result["lastName"],
        middleName = result["middleName"],
        email = result["email"],
        gender = result["gender"],
        contactNumber = result["contactNumber"],
        role = result["role"],
        dob = result["dob"],
        address = result["address"],
        zipCode = result["zipCode"],
        city = result["city"],
        state = result["state"],
        status = result["status"],
        image = result["image"],
        device = result["device"],
        deviceToken = result["deviceToken"],
        socialId = result["socialId"],
        socialType = result["socialType"],
        latitude = result["latitude"],
        longitude = result["longitude"],
        firebaseId = result["firebaseId"],
        username = result["username"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'lastName': lastName,
      'middleName': middleName,
      'email': email,
      'gender': gender,
      'contactNumber': contactNumber,
      'role': role,
      'dob': dob,
      'address': address,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'status': status,
      'image': image,
      'device': device,
      'deviceToken': deviceToken,
      'socialId': socialId,
      'socialType': socialType,
      'latitude': latitude,
      'longitude': longitude,
      'firebaseId': firebaseId,
      'username': username,
    };
  }
}
