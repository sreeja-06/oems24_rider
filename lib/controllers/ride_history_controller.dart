import 'package:get/get.dart';
import '../models/ride_history.dart';

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
    // TODO: Implement API call to fetch real data
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data for demonstration
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
        rating: 4.5,
      ),
    ];
    
    isLoading.value = false;
  }

  void addRide(RideHistory ride) {
    rides.insert(0, ride); // Add to the beginning of the list
    // Update the UI immediately
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