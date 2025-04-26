import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart' as location_marker;
import '../../controllers/home_controller.dart';
import '../widgets/otp_verification_dialog.dart';

class DirectionsScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  DirectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directions to Pickup'),
        
      ),
      body: Stack(
        children: [
          FlutterMap(
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
                  if (controller.activeRide.value != null)
                    Marker(
                      point: LatLng(
                        controller.activeRide.value!.pickupLat,
                        controller.activeRide.value!.pickupLng,
                      ),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.activeRide.value?.pickupLocation ?? '',
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
                              '${controller.activeRide.value?.distanceInKm.toStringAsFixed(1)} km',
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
                              '${controller.activeRide.value?.estimatedDurationInMins} min',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Reached Pickup Location'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => OtpVerificationDialog(
                            otp: controller.rideOtp.value,
                            onVerify: controller.verifyOtp,
                            onCancel: controller.cancelRide,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}