import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart' as location_marker;
import '../../controllers/home_controller.dart';
import '../widgets/payment_dialog.dart';
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
      // Prevent back button from closing this screen during an active ride
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Navigate to Drop'),
          automaticallyImplyLeading: false, // Hide back button
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: controller.currentLocation.value,
                zoom: 14.0,
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
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Passenger',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.blue),
                            onPressed: () {
                              // Open dialer with customer phone number
                              // This would typically use url_launcher
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Calling passenger...'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        'Drop Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dropLocation,
                        style: const TextStyle(fontSize: 14),
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
                          if (controller.activeRide.value != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fare',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  FormatUtil.formatCurrency(
                                    controller.activeRide.value!.estimatedFare,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _showReachedDropLocationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Reached Drop Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  void _showReachedDropLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Arrival'),
          content: const Text('Have you reached the drop location?'),
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
                _showPaymentDialog(context);
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

  void _showPaymentDialog(BuildContext context) {
    if (controller.activeRide.value == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaymentDialog(
        ride: controller.activeRide.value!,
        onPaymentReceived: () {
          controller.showEndRideConfirmationDialog();
        },
      ),
    );
  }
}
