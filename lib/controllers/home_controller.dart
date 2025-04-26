import 'dart:async';
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
  
  @override
  void onInit() {
    super.onInit();
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
        Get.snackbar(
          'Location Service Disabled',
          'Please enable location services to use this app',
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          Get.snackbar(
            'Location Permission Denied',
            'Location permissions are required to use this app',
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        Get.snackbar(
          'Location Permission Denied Forever',
          'Location permissions are required to use this app. Please enable them in settings.',
          snackPosition: SnackPosition.TOP,
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
      }, onError: (error) {
        print('Location stream error: $error');
        // Only show error notification if there's an actual error
        if (error is geo.LocationServiceDisabledException) {
          Get.snackbar(
            'Location Error',
            'Location services are disabled. Please enable them to continue.',
            snackPosition: SnackPosition.TOP,
          );
        } else if (error is geo.PermissionDeniedException) {
          Get.snackbar(
            'Location Error',
            'Location permissions are required. Please grant them to continue.',
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            'Location Error',
            'Failed to get location updates. Please check your GPS signal.',
            snackPosition: SnackPosition.TOP,
          );
        }
      });
    } catch (e) {
      print('Error initializing location: $e');
      // Only show error notification if there's an actual error
      if (e is geo.LocationServiceDisabledException) {
        Get.snackbar(
          'Location Error',
          'Location services are disabled. Please enable them to continue.',
          snackPosition: SnackPosition.TOP,
        );
      } else if (e is geo.PermissionDeniedException) {
        Get.snackbar(
          'Location Error',
          'Location permissions are required. Please grant them to continue.',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Location Error',
          'Failed to initialize location services',
          snackPosition: SnackPosition.TOP,
        );
      }
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
      Get.snackbar(
        'Cannot go offline',
        'You have an active ride in progress',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    // Show notification before changing status
    Get.snackbar(
      'Status Updating',
      isOnline.value ? 'Going offline...' : 'Going online...',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 500),
    );
    
    // Change status after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
    isOnline.value = !isOnline.value;
    Get.snackbar(
      'Status Updated',
      isOnline.value ? 'You are now online' : 'You are now offline',
      snackPosition: SnackPosition.TOP,
    );
    });
  }

  void _showMockRideRequest() {
    final mockRequest = RideRequest(
      id: '123',
      userId: 'user123',
      customerName: 'John Doe',
      customerPhone: '+91 98765 43210',
      pickupLocation: 'MG Road Metro Station',
      dropLocation: 'Indiranagar Metro Station',
      pickupLat: 12.9716,
      pickupLng: 77.5946,
      dropLat: 12.9816,
      dropLng: 77.5975,
      pickupAddress: 'MG Road Metro Station',
      dropAddress: 'Indiranagar Metro Station',
      distance: 5200.0,
      distanceInKm: 5.2,
      estimatedDuration: 900,
      estimatedDurationInMins: 15,
      estimatedFare: 250.0,
      estimatedFareInMins: 250.0,
      paymentMethod: 'CASH',
      createdAt: DateTime.now(),
      notes: '',
    );

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => RideRequestDialog(
        request: mockRequest,
        timeoutSeconds: requestTimeoutSeconds, // Changed from secondsRemaining to timeoutSeconds
        onAccept: () {
          Navigator.of(context).pop();
          handleAcceptRide(mockRequest);
        },
        onReject: () {
          Navigator.of(context).pop();
          Get.snackbar(
            'Request Rejected',
            'You have rejected the ride request',
            snackPosition: SnackPosition.TOP,
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
    
    Get.snackbar(
      'Ride Accepted',
      'Navigate to pickup location',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void verifyOtp(String enteredOtp) {
    if (enteredOtp == rideOtp.value) {
      otpTimer?.cancel();
      Get.back(closeOverlays: true); // Close any remaining dialogs
      onStartRide();
    } else {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the correct OTP',
        snackPosition: SnackPosition.TOP,
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
    Get.snackbar(
      'Arrived at Pickup',
      'Waiting for passenger',
      snackPosition: SnackPosition.TOP,
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
    Get.snackbar(
      'Ride Started',
      'Navigate to drop location',
      snackPosition: SnackPosition.TOP,
    );
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
        _completeRide();
        // Force UI update by temporarily switching to a different valid index
        final currentIndex = this.currentIndex.value;
        this.currentIndex.value = (currentIndex + 1) % 4; // Switch to next tab
        Future.delayed(const Duration(milliseconds: 50), () {
          this.currentIndex.value = currentIndex; // Restore original index
        });
      },
    );
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

          // Update dashboard with ride completion
          final dashboardController = Get.find<DashboardController>();
          dashboardController.handleRideCompletion(activeRide.value!);

          // Update ride history
          final rideHistoryController = Get.find<RideHistoryController>();
          rideHistoryController.addRide(rideHistory);
    
    // Show ride summary
    Get.snackbar(
      'Ride Completed',
            'Fare: ₹${activeRide.value!.estimatedFare.toStringAsFixed(2)}',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
    );

          // Reset all states to initial values
    activeRide.value = null;
    rideStatus.value = 'none';
          rideOtp.value = '';
          isOnline.value = false; // Reset online status to offline
          
          // Cancel any active timers
          otpTimer?.cancel();
          requestTimer?.cancel();

          // Force UI update
          update();

          // Close any open dialogs
          Get.back(closeOverlays: true);
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