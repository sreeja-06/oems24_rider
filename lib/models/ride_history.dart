class RideHistory {
  final String id;
  final String customerName;
  final String pickupLocation;
  final String dropLocation;
  final double fare;
  final double distance;
  final int duration;
  final DateTime completedAt;
  final String status;
  final double? passengerRating;
  final String? passengerFeedback;

  RideHistory({
    required this.id,
    required this.customerName,
    required this.pickupLocation,
    required this.dropLocation,
    required this.fare,
    required this.distance,
    required this.duration,
    required this.completedAt,
    this.status = 'completed',
    this.passengerRating,
    this.passengerFeedback,
  });

  // Convert datetime to readable format
  String get formattedDate {
    return '${completedAt.day}/${completedAt.month}/${completedAt.year} ${completedAt.hour}:${completedAt.minute.toString().padLeft(2, '0')}';
  }
}