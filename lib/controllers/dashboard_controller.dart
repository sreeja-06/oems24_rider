import 'package:get/get.dart';
import '../models/ride_request.dart';

class DashboardController extends GetxController {
  // Basic earnings data
  final todayEarnings = 0.0.obs;
  final weeklyEarnings = 0.0.obs;
  final monthlyEarnings = 0.0.obs;
  final totalRides = 0.obs;
  final rating = 0.0.obs;
  final isLoading = true.obs;
  final todayRides = 0.obs;
  final averageRating = 0.0.obs;
  final totalEarnings = 0.0.obs;

  // Additional stats
  final isOnline = false.obs;
  final hoursOnline = 0.obs;
  final totalKm = 0.0.obs;
  final missedRides = 0.obs;
  final cancelledRides = 0.obs;
  final redeemableBalance = 0.0.obs;

  // Trips and incentives
  final recentTrips = <TripDetails>[].obs;
  final incentives = <IncentiveDetails>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // TODO: Replace with actual API calls
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demonstration
      todayEarnings.value = 1250.0;
      weeklyEarnings.value = 8500.0;
      monthlyEarnings.value = 32000.0;
      totalRides.value = 145;
      rating.value = 4.8;
      todayRides.value = 5;
      averageRating.value = 4.7;
      totalEarnings.value = 45000.0;
      
      // Additional stats
      isOnline.value = true;
      hoursOnline.value = 6;
      totalKm.value = 120.5;
      missedRides.value = 2;
      cancelledRides.value = 1;
      redeemableBalance.value = 1500.0;

      // Mock recent trips
      recentTrips.value = [
        TripDetails(
          id: 'T123',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          distance: 12.5,
          duration: 25,
          earnings: 350.0,
        ),
        TripDetails(
          id: 'T122',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          distance: 8.2,
          duration: 18,
          earnings: 220.0,
        ),
      ];

      // Mock incentives
      incentives.value = [
        IncentiveDetails(
          reason: 'Peak Hour Bonus',
          description: 'Completed 3 rides during peak hours',
          amount: 150.0,
        ),
        IncentiveDetails(
          reason: 'Weekly Challenge',
          description: 'Completed 20 rides this week',
          amount: 500.0,
        ),
      ];

    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> redeemEarnings() async {
    if (redeemableBalance.value < 1000) {
      Get.snackbar(
        'Cannot Redeem',
        'Minimum redeemable amount is ₹1,000',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      // TODO: Implement actual redemption logic
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        'Amount will be credited within 24 hours',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process redemption',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void handleRideCompletion(RideRequest ride) {
    // Update daily earnings
    todayEarnings.value += ride.estimatedFare;
    weeklyEarnings.value += ride.estimatedFare;
    monthlyEarnings.value += ride.estimatedFare;
    totalEarnings.value += ride.estimatedFare;

    // Update ride counts
    totalRides.value++;
    todayRides.value++;

    // Update travel stats
    totalKm.value += ride.distanceInKm;
    
    // Add to redeemable balance
    redeemableBalance.value += ride.estimatedFare;

    // Add to recent trips
    recentTrips.insert(0, TripDetails(
      id: ride.id,
      timestamp: DateTime.now(),
      distance: ride.distanceInKm,
      duration: ride.estimatedDurationInMins,
      earnings: ride.estimatedFare,
    ));

    // Keep only last 10 trips
    if (recentTrips.length > 10) {
      recentTrips.removeLast();
    }

    // Show success message
    Get.snackbar(
      'Earnings Updated',
      'Added ${formatCurrency(ride.estimatedFare)} to your earnings',
      snackPosition: SnackPosition.TOP,
    );
  }

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }
}

class TripDetails {
  final String id;
  final DateTime timestamp;
  final double distance;
  final int duration;
  final double earnings;

  TripDetails({
    required this.id,
    required this.timestamp,
    required this.distance,
    required this.duration,
    required this.earnings,
  });
}

class IncentiveDetails {
  final String reason;
  final String description;
  final double amount;

  IncentiveDetails({
    required this.reason,
    required this.description,
    required this.amount,
  });
}