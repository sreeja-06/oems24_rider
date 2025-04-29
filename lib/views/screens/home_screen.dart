import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart' as location_marker;
import 'package:nm/views/screens/account_screen.dart';
import 'package:nm/views/screens/dashboard_screen.dart';
import 'package:nm/views/screens/ride_history_screen.dart';
import '../../controllers/home_controller.dart';
import '../widgets/active_ride_bottom_sheet.dart';
import '../widgets/ride_request_dialog.dart';
import '../../models/ride_request.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  HomeScreen({super.key});

  void showRideRequestDialog(RideRequest request) {
    Get.snackbar(
      '',
      '',
      titleText: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: RideRequestDialog(
          request: request,
          onAccept: () {
            Get.back();
            controller.handleAcceptRide(request);
          },
          onReject: () {
            Get.back();
            controller.showStandardSnackbar(
              title: 'Request Rejected',
              message: 'You have rejected the ride request',
              backgroundColor: Colors.grey[700]!,
              icon: Icons.cancel,
            );
          },
          timeoutSeconds: 15,
        ),
      ),
      messageText: const SizedBox.shrink(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 15),
      isDismissible: false,
      forwardAnimationCurve: Curves.easeOutQuart,
      reverseAnimationCurve: Curves.easeInQuart,
      animationDuration: const Duration(milliseconds: 500),
      overlayBlur: 0,
      overlayColor: Colors.black.withOpacity(0.3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool showAppBar = controller.currentIndex.value != 3 && // Hide AppBar for Account tab
                        controller.currentIndex.value != 2 && // Hide AppBar for Dashboard tab  
                        controller.currentIndex.value != 1;   // Hide AppBar for Rides tab
      
      return Scaffold(
        appBar: showAppBar ? AppBar(
          title: const Text('OEMS24 Captain'),
          actions: [
            Obx(() => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: 4, end: 4),
                showBadge: controller.unreadNotificationsCount.value > 0,
                badgeContent: Text(
                  '${controller.unreadNotificationsCount.value}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => Get.toNamed('/notifications'),
                ),
              ),
            )),
          ],
        ) : null,
        body: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return _buildHomeContent();
            case 1:
              return const RideHistoryScreen();
            case 2:
              return const DashboardScreen();
            case 3:
              return const AccountScreen();
            default:
              return _buildHomeContent();
          }
        }),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Rides',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        )),
      );
    });
  }

  Widget _buildHomeContent() {
    return Stack(
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
                if (controller.activeRide.value != null) ...[
                  Marker(
                    point: LatLng(
                      controller.activeRide.value!.pickupLat,
                      controller.activeRide.value!.pickupLng,
                    ),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => controller.onPickupLocationTap(),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(
                      controller.activeRide.value!.dropLat,
                      controller.activeRide.value!.dropLng,
                    ),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Obx(() {
            if (controller.activeRide.value != null && controller.rideStatus.value != 'completed') {
              return ActiveRideBottomSheet(
                ride: controller.activeRide.value!,
                rideStatus: controller.rideStatus.value,
                onStartRide: controller.onStartRide,
                onEndRide: controller.onEndRide,
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SwitchListTile(
                          title: Text(
                            controller.isOnline.value ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: controller.isOnline.value
                                  ? Colors.blue
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: controller.isOnline.value,
                          onChanged: (_) => controller.toggleOnlineStatus(),
                          activeColor: Colors.blue,
                        ),
                        if (!controller.isOnline.value)
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 8,
                            ),
                            child: Text(
                              'Go online to start receiving ride requests',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}