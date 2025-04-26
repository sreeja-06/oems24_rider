class RideRequest {
  final String id;
  final String userId;
  final String pickupLocation;
  final String dropLocation;
  final double pickupLat;
  final double pickupLng;
  final double dropLat;
  final double dropLng;
  final double distance;
  final int estimatedDuration;
  final double estimatedFare;
  final String paymentMethod;
  final DateTime createdAt;
  final String? notes;
  final double distanceInKm;
  final int estimatedDurationInMins;
  final double estimatedFareInMins;
  final String customerName;
  final String customerPhone;
  final String dropAddress;
  final String pickupAddress;

  RideRequest({
    required this.id,
    required this.userId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.distance,
    required this.estimatedDuration,
    required this.estimatedFare,
    required this.paymentMethod,
    required this.createdAt,
    required this.notes,
    required this.customerPhone,
    required this.dropAddress,
    required this.pickupAddress,
    required this.distanceInKm,
    required this.estimatedDurationInMins,
    required this.customerName,
    required this.estimatedFareInMins,
  });

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      id: json['id'] as String,
      userId: json['userId'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropLocation: json['dropLocation'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      dropLat: (json['dropLat'] as num).toDouble(),
      dropLng: (json['dropLng'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      estimatedDuration: json['estimatedDuration'] as int,
      estimatedFare: (json['estimatedFare'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
      customerPhone: json['customerPhone'] as String,
      dropAddress: json['dropAddress'] as String,
      pickupAddress: json['pickupAddress'] as String,
      distanceInKm: (json['distanceInKm'] as num).toDouble(),
      estimatedDurationInMins: json['estimatedDurationInMins'] as int,
      customerName: json['customerName'] as String,
      estimatedFareInMins: (json['estimatedFareInMins'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'distance': distance,
      'estimatedDuration': estimatedDuration,
      'estimatedFare': estimatedFare,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'customerPhone': customerPhone,
      'dropAddress': dropAddress,
      'pickupAddress': pickupAddress,
      'distanceInKm': distanceInKm,
      'estimatedDurationInMins': estimatedDurationInMins,
      'customerName': customerName,
    };
  }

  RideRequest copyWith({
    String? id,
    String? userId,
    String? pickupLocation,
    String? dropLocation,
    double? pickupLat,
    double? pickupLng,
    double? dropLat,
    double? dropLng,
    double? distance,
    int? estimatedDuration,
    double? estimatedFare,
    String? paymentMethod,
    DateTime? createdAt,
    String? notes,
    String? customerPhone,
    String? dropAddress,
    String? pickupAddress,
    double? distanceInKm,
    int? estimatedDurationInMins,
    String? customerName,
    double? estimatedFareInMins,
  }) {
    return RideRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropLat: dropLat ?? this.dropLat,
      dropLng: dropLng ?? this.dropLng,
      distance: distance ?? this.distance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
      customerPhone: customerPhone ?? this.customerPhone,
      dropAddress: dropAddress ?? this.dropAddress,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      estimatedDurationInMins: estimatedDurationInMins ?? this.estimatedDurationInMins,
      customerName: customerName ?? this.customerName,
      estimatedFareInMins: estimatedFareInMins ?? this.estimatedFareInMins,
    );
  }
}