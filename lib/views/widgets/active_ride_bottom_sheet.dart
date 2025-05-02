import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ride_request.dart';
import '../../controllers/home_controller.dart';
import '../../utils/format_util.dart';
import '../../constants/app_constants.dart';

class ActiveRideBottomSheet extends StatelessWidget {
  final RideRequest ride;
  final String rideStatus;
  final VoidCallback onStartRide;
  final VoidCallback onEndRide;

  const ActiveRideBottomSheet({
    Key? key,
    required this.ride,
    required this.rideStatus,
    required this.onStartRide,
    required this.onEndRide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle potentially empty values
    final distanceInKm = ride.distanceInKm <= 0 ? 5.0 : ride.distanceInKm;
    final durationInMins = ride.estimatedDurationInMins <= 0 ? 15 : ride.estimatedDurationInMins;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRideStatus(),
          const SizedBox(height: 16),
          _buildLocationInfo(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(),
              ),
              if (rideStatus == 'accepted' || rideStatus == 'started') ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () {
                      final controller = Get.find<HomeController>();
                      controller.callPassenger();
                    },
                    icon: const Icon(Icons.phone),
                    tooltip: 'Call Passenger',
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                      foregroundColor: AppConstants.primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: () {
                      final controller = Get.find<HomeController>();
                      controller.showMessagePassengerDialog();
                    },
                    icon: const Icon(Icons.message),
                    tooltip: 'Message Passenger',
                    style: IconButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                      foregroundColor: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${FormatUtil.formatDistance(distanceInKm)} • ${FormatUtil.formatDuration(durationInMins * 60)}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideStatus() {
    String statusText;
    Color statusColor;

    switch (rideStatus) {
      case 'accepted':
        statusText = 'Go to Pickup Location';
        statusColor = AppConstants.primaryColor;
        break;
      case 'arrived':
        statusText = 'Waiting for Passenger';
        statusColor = AppConstants.primaryColor;
        break;
      case 'started':
        statusText = 'Ride in Progress';
        statusColor = AppConstants.primaryColor;
        break;
      default:
        statusText = 'Unknown Status';
        statusColor = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    // Handle empty location strings
    final pickupLocation = ride.pickupLocation.isEmpty ? 'Pickup Location' : ride.pickupLocation;
    final dropLocation = ride.dropLocation.isEmpty ? 'Drop Location' : ride.dropLocation;
    
    return Column(
      children: [
        _buildLocationRow(
          'Pickup',
          pickupLocation,
          Icons.location_on,
          AppConstants.primaryColor,
          true,
        ),
        const SizedBox(height: 8),
        _buildLocationRow(
          'Drop',
          dropLocation,
          Icons.location_on,
          AppConstants.primaryColor,
          false,
        ),
      ],
    );
  }

  Widget _buildLocationRow(
    String label,
    String location,
    IconData icon,
    Color color,
    bool showDirections,
  ) {
    final HomeController controller = Get.find<HomeController>();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (showDirections && rideStatus == 'accepted')
            TextButton.icon(
              onPressed: () {
                controller.onPickupLocationTap();
              },
              icon: Icon(Icons.directions, color: AppConstants.primaryColor),
              label: Text('Directions', style: TextStyle(color: AppConstants.primaryColor)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    switch (rideStatus) {
      case 'accepted':
        // Don't show the "Arrived at Pickup" button here anymore
        // Instead show a message prompting to use directions screen
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppConstants.primaryColor, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Use the Directions screen to navigate and mark arrival at pickup location',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      case 'arrived':
        return ElevatedButton(
          onPressed: onStartRide,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Start Ride'),
        );
      case 'started':
        return ElevatedButton(
          onPressed: onEndRide,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('End Ride'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}