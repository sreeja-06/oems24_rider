import 'package:get/get.dart';
import '../models/ride_history.dart';
import '../constants/app_constants.dart';

class RideHistoryController extends GetxController {
  final rides = <RideHistory>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRideHistory();
  }

  Future<void> loadRideHistory() async {
    isLoading.value = true;
    
    try {
      // In a real app, fetch from a database or API
      await Future.delayed(const Duration(seconds: 1));
      
      // Only add mock data if list is empty (to prevent duplicates)
      if (rides.isEmpty) {
        // Add mock data for demonstration
        // In a real app, you'd fetch this from a database or API
        rides.value = [
          RideHistory(
            id: '1',
            customerName: 'John Doe',
            pickupLocation: 'MG Road',
            dropLocation: 'Indiranagar',
            fare: 250.0,
            distance: 5.2,
            duration: 15,
            completedAt: DateTime.now().subtract(const Duration(days: 1)),
            passengerRating: 4.5,
            passengerFeedback: 'Great passenger, very punctual!',
          ),
        ];
      }
    } catch (e) {
      print("ERROR: Failed to load ride history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void addRide(RideHistory ride) {
    // Check if we already have this ride (by id) to prevent duplicates
    if (!rides.any((existingRide) => existingRide.id == ride.id)) {
      rides.insert(0, ride); // Add to the beginning of the list
      // In a real app, you would also save to a database or API
      print("INFO: Added ride ${ride.id} to history");
    } else {
      print("INFO: Ride ${ride.id} already exists in history, skipping");
    }
    // Update the UI
    update();
  }

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String formatDistance(double distance) {
    return '${distance.toStringAsFixed(1)} km';
  }

  String formatDuration(int duration) {
    return '$duration min';
  }
}