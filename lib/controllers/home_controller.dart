import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../models/ride_request.dart';
import '../models/ride_history.dart';
import '../views/screens/directions_screen.dart';
import '../views/widgets/ride_request_dialog.dart';
import '../views/widgets/otp_verification_dialog.dart';
import '../views/widgets/payment_dialog.dart';
import 'dashboard_controller.dart';
import 'ride_history_controller.dart';

class HomeController extends GetxController {
  final isOnline = false.obs;
  final activeRide = Rxn<RideRequest>();
  final rideStatus = 'none'.obs; // none, accepted, arrived, started, completed
  final rideOtp = ''.obs;
  final otpTimeoutSeconds = 300; // 5 minutes
  Timer? requestTimer;
  Timer? otpTimer;
  final requestTimeoutSeconds = 30;
  final unreadNotificationsCount = 0.obs;
  final currentLocation = const LatLng(12.9716, 77.5946).obs;
  final currentHeading = 0.0.obs;
  final locationAccuracy = 0.0.obs;
  StreamSubscription<geo.Position>? positionStream;
  final currentIndex = 0.obs;
  
  // Helper method for standardized Snackbar styling
  void showStandardSnackbar({
    required String title,
    required String message,
    Color backgroundColor = const Color(0xFF007BFF),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      animationDuration: const Duration(milliseconds: 500),
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
      icon: icon != null ? Icon(icon, color: textColor) : null,
    );
  }
  
  @override
  void onInit() {
    super.onInit();
    
    // Ensure RideHistoryController and DashboardController are available
    if (!Get.isRegistered<RideHistoryController>()) {
      Get.lazyPut(() => RideHistoryController());
    }
    
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut(() => DashboardController());
    }
    
    // Remove automatic location initialization
    ever(isOnline, (bool online) {
      if (online) {
        _initializeLocation(); // Initialize location when going online
        // Simulating a ride request after 5 seconds of going online
        Future.delayed(const Duration(seconds: 5), () {
          if (isOnline.value) {
            _showMockRideRequest();
          }
        });
      }
    });
  }

  Future<void> _initializeLocation() async {
    try {
      // Check location permission
      bool serviceEnabled;
      geo.LocationPermission permission;

      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showStandardSnackbar(
          title: 'Location Service Disabled',
          message: 'Please enable location services to use this app',
          backgroundColor: Colors.red,
          icon: Icons.location_off,
        );
        return;
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          showStandardSnackbar(
            title: 'Location Permission Denied',
            message: 'Location permissions are required to use this app',
            backgroundColor: Colors.red,
            icon: Icons.location_off,
          );
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        showStandardSnackbar(
          title: 'Location Permission Denied Forever',
          message: 'Location permissions are required to use this app. Please enable them in settings.',
          backgroundColor: Colors.red,
          icon: Icons.location_off,
        );
        return;
      }

      // Get initial position with high accuracy
      final position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      currentLocation.value = LatLng(position.latitude, position.longitude);
      currentHeading.value = position.heading;
      locationAccuracy.value = position.accuracy;

      // Start listening to location updates with optimized settings
      positionStream = geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 3, // Update every 3 meters
          timeLimit: Duration(seconds: 1), // Update at least every second
        ),
      ).listen((geo.Position position) {
        // Only update if accuracy is good (within 15 meters) or if it's better than previous accuracy
        if (position.accuracy <= 15 || position.accuracy < locationAccuracy.value) {
          currentLocation.value = LatLng(position.latitude, position.longitude);
          currentHeading.value = position.heading;
          locationAccuracy.value = position.accuracy;
          update();
        }
      });
    } catch (e) {
      print('Error initializing location: $e');
    }
  }

  // Integrated from MainController
  void changePage(int index) {
    currentIndex.value = index;
  }

  // Integrated from MainController
  void logout() {
    // TODO: Clear any stored credentials or user data
    Get.offAllNamed('/login');
  }

  void toggleOnlineStatus() {
    if (activeRide.value != null && rideStatus.value != 'completed') {
      showStandardSnackbar(
        title: 'Cannot go offline',
        message: 'You have an active ride in progress',
        backgroundColor: Colors.red.withOpacity(0.9),
        icon: Icons.error_outline,
      );
      return;
    }
    
    // Show notification before changing status
    showStandardSnackbar(
      title: 'Status Updating',
      message: isOnline.value ? 'Going offline...' : 'Going online...',
      duration: const Duration(milliseconds: 800),
      icon: isOnline.value ? Icons.offline_bolt : Icons.online_prediction,
    );
    
    // Change status after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      isOnline.value = !isOnline.value;
      showStandardSnackbar(
        title: 'Status Changed',
        message: isOnline.value ? 'You are now online' : 'You are now offline',
        backgroundColor: isOnline.value ? Colors.blue : Colors.grey[700]!,
        icon: isOnline.value ? Icons.online_prediction : Icons.offline_bolt,
      );
    });
  }

  void _showMockRideRequest() {
    // Generate a sample ride request with realistic data
    final currentLat = currentLocation.value.latitude;
    final currentLng = currentLocation.value.longitude;
    
    // Generate nearby coordinates for pickup (roughly within 1-3 km)
    final pickupLat = currentLat + (0.01 * (0.5 - Random().nextDouble()));
    final pickupLng = currentLng + (0.01 * (0.5 - Random().nextDouble()));
    
    // Generate coordinates for drop-off (roughly within 3-8 km from pickup)
    final dropLat = pickupLat + (0.03 * (0.5 - Random().nextDouble()));
    final dropLng = pickupLng + (0.03 * (0.5 - Random().nextDouble()));
    
    // Calculate rough distance in km (simplified)
    final distanceInKm = 5.2; // This would be calculated from the coordinates in a real app
    
    // Estimate duration based on distance (assuming average speed of 20 km/h)
    final estimatedDurationInMins = (distanceInKm / 20 * 60).round();
    
    // Estimate fare based on distance (base fare + per km charge)
    final baseFare = 50.0;
    final perKmCharge = 12.0;
    final estimatedFare = baseFare + (distanceInKm * perKmCharge);
    
    final mockRequest = RideRequest(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user123',
      customerName: 'John Doe', 
      customerPhone: '+91 98765 43210',
      pickupLocation: 'MG Road Metro Station',
      dropLocation: 'Indiranagar Metro Station',
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropLat: dropLat,
      dropLng: dropLng,
      pickupAddress: 'MG Road Metro Station, Bengaluru',
      dropAddress: 'Indiranagar Metro Station, Bengaluru',
      distance: distanceInKm * 1000, // Convert to meters
      distanceInKm: distanceInKm,
      estimatedDuration: estimatedDurationInMins * 60, // Convert to seconds
      estimatedDurationInMins: estimatedDurationInMins,
      estimatedFare: estimatedFare,
      estimatedFareInMins: estimatedFare,
      paymentMethod: 'CASH',
      createdAt: DateTime.now(),
      notes: '',
    );

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => RideRequestDialog(
        request: mockRequest,
        timeoutSeconds: requestTimeoutSeconds,
        onAccept: () {
          Navigator.of(context).pop();
          handleAcceptRide(mockRequest);
        },
        onReject: () {
          Navigator.of(context).pop();
          showStandardSnackbar(
            title: 'Request Rejected',
            message: 'You have rejected the ride request',
            backgroundColor: Colors.grey[700]!,
            icon: Icons.cancel,
          );
        },
      ),
    );
  }

  void handleAcceptRide(RideRequest request) {
    // Use hardcoded OTP
    rideOtp.value = '1234';
    activeRide.value = request;
    rideStatus.value = 'accepted';
    
    showStandardSnackbar(
      title: 'Ride Accepted',
      message: 'Navigate to pickup location',
      icon: Icons.directions_car,
    );
  }

  void verifyOtp(String enteredOtp) {
    if (enteredOtp == rideOtp.value) {
      otpTimer?.cancel();
      Get.back(closeOverlays: true); // Close any remaining dialogs
      onStartRide();
    } else {
      showStandardSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter the correct OTP',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      // Reopen OTP dialog
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => OtpVerificationDialog(
          otp: rideOtp.value,
          onVerify: verifyOtp,
          onCancel: _cancelRide,
        ),
      );
    }
  }

  void _cancelRide() {
    activeRide.value = null;
    rideStatus.value = 'none';
    rideOtp.value = '';
    otpTimer?.cancel();
  }

  void onArrivedAtPickup() {
    rideStatus.value = 'arrived';
    showStandardSnackbar(
      title: 'Arrived at Pickup',
      message: 'Waiting for passenger',
      backgroundColor: Colors.blue,
      icon: Icons.location_on,
    );
    
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => OtpVerificationDialog(
        otp: rideOtp.value,
        onVerify: verifyOtp,
        onCancel: _cancelRide,
      ),
    );
  }

  void onStartRide() {
    rideStatus.value = 'started';
    showStandardSnackbar(
      title: 'Ride Started',
      message: 'Navigate to drop location',
      backgroundColor: Colors.blue,
      icon: Icons.play_arrow,
    );
    
    // Navigate to the drop direction screen
    Get.toNamed('/drop-direction');
  }

  void onEndRide() {
    Get.defaultDialog(
      title: 'End Ride',
      content: const Text('Are you sure you want to end this ride?'),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        
        // Show payment dialog
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) => PaymentDialog(
            ride: activeRide.value!,
            onPaymentReceived: () {
              // Show end ride confirmation dialog
              showEndRideConfirmationDialog();
            },
          ),
        );
      },
    );
  }

  // Method to show the end ride confirmation dialog
  void showEndRideConfirmationDialog() {
    Get.defaultDialog(
      title: 'End Ride',
      content: const Text('The payment has been received. Would you like to end the ride now?'),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        forceEndRide(); // Now force end the ride
      },
    );
  }

  // Direct method to force end ride and navigate home
  void forceEndRide() {
    if (activeRide.value == null) {
      print("ERROR: Cannot end null ride");
      return;
    }

    print("INFO: Force ending ride and navigating to home");
    
    // Create ride history entry
    final rideHistory = RideHistory(
      id: activeRide.value!.id,
      customerName: activeRide.value!.customerName,
      pickupLocation: activeRide.value!.pickupLocation,
      dropLocation: activeRide.value!.dropLocation,
      fare: activeRide.value!.estimatedFare,
      distance: activeRide.value!.distanceInKm,
      duration: activeRide.value!.estimatedDurationInMins,
      completedAt: DateTime.now(),
    );

    try {
      // Ensure controllers exist before using them
      if (!Get.isRegistered<DashboardController>()) {
        Get.put(DashboardController());
      }
      
      if (!Get.isRegistered<RideHistoryController>()) {
        Get.put(RideHistoryController());
      }
      
      // Update dashboard with ride completion
      final dashboardController = Get.find<DashboardController>();
      dashboardController.handleRideCompletion(activeRide.value!);

      // Update ride history
      final rideHistoryController = Get.find<RideHistoryController>();
      rideHistoryController.addRide(rideHistory);
      
      print("INFO: Successfully added ride to history");
    } catch (e) {
      print("ERROR: Failed to update ride history: $e");
    }
    
    // Show ride summary
    showStandardSnackbar(
      title: 'Ride Completed',
      message: 'Fare: ₹${activeRide.value!.estimatedFare.toStringAsFixed(2)}',
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 5),
      icon: Icons.check_circle,
    );
    
    // Reset all states
    rideStatus.value = 'none';
    activeRide.value = null;
    rideOtp.value = '';
    
    // Cancel timers
    otpTimer?.cancel();
    requestTimer?.cancel();
    
    // Update UI
    update();
    
    // Navigate home after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offAllNamed('/home');
    });
  }

  // New method for direct ride completion without showing dialog
  void completeRideDirectly() {
    print("DEBUGGING: completeRideDirectly called");
    
    if (activeRide.value == null) {
      print("DEBUGGING: activeRide is null, returning");
      return;
    }

    // Create ride history entry
    print("DEBUGGING: Creating ride history entry");
    final rideHistory = RideHistory(
      id: activeRide.value!.id,
      customerName: activeRide.value!.customerName,
      pickupLocation: activeRide.value!.pickupLocation,
      dropLocation: activeRide.value!.dropLocation,
      fare: activeRide.value!.estimatedFare,
      distance: activeRide.value!.distanceInKm,
      duration: activeRide.value!.estimatedDurationInMins,
      completedAt: DateTime.now(),
    );

    try {
      // Ensure controllers exist before using them
      if (!Get.isRegistered<DashboardController>()) {
        Get.put(DashboardController());
      }
      
      if (!Get.isRegistered<RideHistoryController>()) {
        Get.put(RideHistoryController());
      }
      
      // Update dashboard with ride completion
      print("DEBUGGING: Updating dashboard");
      final dashboardController = Get.find<DashboardController>();
      dashboardController.handleRideCompletion(activeRide.value!);

      // Update ride history
      print("DEBUGGING: Updating ride history");
      final rideHistoryController = Get.find<RideHistoryController>();
      rideHistoryController.addRide(rideHistory);
      
      print("DEBUGGING: Successfully added ride to history");
    } catch (e) {
      print("DEBUGGING: Error updating controllers: $e");
    }
    
    // Show ride summary
    print("DEBUGGING: Showing snackbar");
    showStandardSnackbar(
      title: 'Ride Completed',
      message: 'Fare: ₹${activeRide.value!.estimatedFare.toStringAsFixed(2)}',
      backgroundColor: Colors.blue,
      duration: const Duration(seconds: 5),
      icon: Icons.check_circle,
    );

    print("DEBUGGING: Resetting ride state");
    // Make a local copy before resetting
    final RideRequest? localCopy = activeRide.value;
    
    // Reset all states to initial values
    rideStatus.value = 'none';
    activeRide.value = null;
    rideOtp.value = '';
    
    // Cancel any active timers
    print("DEBUGGING: Cancelling timers");
    otpTimer?.cancel();
    requestTimer?.cancel();

    // Force UI update
    print("DEBUGGING: Forcing UI update");
    update();

    // Use Future.delayed to ensure state is updated before navigation
    print("DEBUGGING: Navigating to home screen after delay");
    Future.delayed(const Duration(milliseconds: 100), () {
      print("DEBUGGING: Now navigating to home");
      Get.offAllNamed('/home')!
        .then((_) => print("DEBUGGING: Navigation completed"))
        .catchError((error) => print("DEBUGGING: Navigation error: $error"));
    });
  }

  void _completeRide() {
    if (activeRide.value == null) return;

    // Mark ride as completed
    rideStatus.value = 'completed';
    
    // Show payment dialog
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PaymentDialog(
        ride: activeRide.value!,
        onPaymentReceived: () {
          // Use completeRideDirectly for consistent navigation logic
          completeRideDirectly();
        },
      ),
    );
  }

  void onPickupLocationTap() {
    if (activeRide.value == null) return;

    // Navigate to directions screen
    Get.to(() => DirectionsScreen());
  }

  void cancelRide() {
    activeRide.value = null;
    rideStatus.value = 'none';
    rideOtp.value = '';
    otpTimer?.cancel();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    otpTimer?.cancel();
    requestTimer?.cancel();
    super.onClose();
  }
}