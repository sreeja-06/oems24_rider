import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart' as location_marker;
import '../../controllers/home_controller.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/passenger_rating_dialog.dart';
import '../../utils/format_util.dart';

class DropDirectionScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final mapController = MapController();

  DropDirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if ride is still active
    if (controller.activeRide.value == null || controller.rideStatus.value != 'started') {
      // If ride is not active or not in started state, redirect to home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/home');
      });
    }

    // Handle potentially null or zero values
    final dropLocation = controller.activeRide.value?.dropLocation ?? 'Drop Location';
    final dropLat = controller.activeRide.value?.dropLat ?? controller.currentLocation.value.latitude;
    final dropLng = controller.activeRide.value?.dropLng ?? controller.currentLocation.value.longitude;
    final pickupLat = controller.activeRide.value?.pickupLat ?? controller.currentLocation.value.latitude;
    final pickupLng = controller.activeRide.value?.pickupLng ?? controller.currentLocation.value.longitude;
    final distanceInKm = controller.activeRide.value?.distanceInKm ?? 0.0;
    final durationInMins = controller.activeRide.value?.estimatedDurationInMins ?? 0;
    final customerName = controller.activeRide.value?.customerName ?? 'Customer';
    
    // Default values for display
    final displayDistance = distanceInKm <= 0 ? '5.0 km' : '${distanceInKm.toStringAsFixed(1)} km';
    final displayDuration = durationInMins <= 0 ? '15 min' : '$durationInMins min';
    
    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Navigate to Drop'),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _showExitConfirmationDialog(context)) {
                Get.back();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: controller.currentLocation.value,
                zoom: 15.0,
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (!hasGesture) {
                    controller.currentLocation.value = position.center!;
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.nm',
                ),
                location_marker.CurrentLocationLayer(
                  positionStream: Stream.value(location_marker.LocationMarkerPosition(
                    latitude: controller.currentLocation.value.latitude,
                    longitude: controller.currentLocation.value.longitude,
                    accuracy: 5.0,
                  )),
                  headingStream: Stream.value(location_marker.LocationMarkerHeading(
                    heading: controller.currentHeading.value,
                    accuracy: 5.0,
                  )),
                  style: const location_marker.LocationMarkerStyle(
                    marker: location_marker.DefaultLocationMarker(
                      color: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    markerSize: const Size(40, 40),
                    accuracyCircleColor: const Color.fromRGBO(33, 150, 243, 0.3),
                    headingSectorColor: const Color.fromRGBO(33, 150, 243, 0.3),
                    showAccuracyCircle: true,
                    showHeadingSector: true,
                  ),
                ),
                MarkerLayer(
                  markers: [
                    // Show pickup marker (blue)
                    Marker(
                      point: LatLng(pickupLat, pickupLng),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    // Show drop marker (red)
                    Marker(
                      point: LatLng(dropLat, dropLng),
                      width: 40, 
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                // Draw a polyline between pickup and drop (simplified direct line)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        LatLng(pickupLat, pickupLng),
                        LatLng(dropLat, dropLng),
                      ],
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            // Recenter button
            Positioned(
              right: 16,
              top: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                onPressed: () {
                  // Center the map to show both pickup and destination
                  final bounds = LatLngBounds.fromPoints([
                    LatLng(pickupLat, pickupLng),
                    LatLng(dropLat, dropLng),
                    controller.currentLocation.value,
                  ]);
                  mapController.fitBounds(
                    bounds,
                    options: const FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                    ),
                  );
                },
                child: const Icon(Icons.my_location),
              ),
            ),
            // Bottom ride info card
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Drop Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dropLocation,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                customerName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => controller.callPassenger(),
                                    icon: const Icon(Icons.phone, size: 20),
                                    tooltip: 'Call Passenger',
                                    color: Colors.blue,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => controller.showMessagePassengerDialog(),
                                    icon: const Icon(Icons.message, size: 20),
                                    tooltip: 'Message Passenger',
                                    color: Colors.blue,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Distance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                displayDistance,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estimated Time',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                displayDuration,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _showEndRideDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('End Ride'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    bool shouldExit = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Navigation?'),
          content: const Text('Are you sure you want to exit the navigation? You can return to it from the ride card.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                shouldExit = false;
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                shouldExit = true;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return shouldExit;
  }

  void _showEndRideDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('End Ride'),
          content: const Text('Have you arrived at the drop location?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRatingDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    if (controller.activeRide.value == null) return;

    Get.dialog(
      PassengerRatingDialog(
        passengerName: controller.activeRide.value!.customerName,
        onSubmit: (rating, feedback) async {
          // Store rating and feedback for ride completion
          controller.setRatingData(rating, feedback);
          
          // Close rating dialog
          Get.back();
          
          // Show payment dialog
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (context) => PaymentDialog(
              ride: controller.activeRide.value!,
              onPaymentReceived: () {
                controller.showEndRideConfirmationDialog();
              },
            ),
          );
        },
      ),
      barrierDismissible: false,
    );
  }
}
