class Rider {
  final String name;
  final String phone;
  final String email;
  final String vehicleType;
  final String vehicleNumber;
  final String? licenseNumber;
  final String password;
  final String? profileImageUrl;
  final String? licenseImageUrl;

  Rider({
    required this.name,
    required this.phone,
    required this.email,
    required this.vehicleType,
    required this.vehicleNumber,
    this.licenseNumber,
    required this.password,
    this.profileImageUrl,
    this.licenseImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'licenseNumber': licenseNumber,
      'password': password,
      'profileImageUrl': profileImageUrl,
      'licenseImageUrl': licenseImageUrl,
    };
  }

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      vehicleType: json['vehicleType'],
      vehicleNumber: json['vehicleNumber'],
      licenseNumber: json['licenseNumber'],
      password: json['password'],
      profileImageUrl: json['profileImageUrl'],
      licenseImageUrl: json['licenseImageUrl'],
    );
  }
} 