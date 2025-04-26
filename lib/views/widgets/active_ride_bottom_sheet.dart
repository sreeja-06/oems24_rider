import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ride_request.dart';
import '../../controllers/home_controller.dart';

class ActiveRideBottomSheet extends StatelessWidget {
  final RideRequest ride;
  final String rideStatus;
  final VoidCallback onArrivedAtPickup;
  final VoidCallback onStartRide;
  final VoidCallback onEndRide;

  const ActiveRideBottomSheet({
    Key? key,
    required this.ride,
    required this.rideStatus,
    required this.onArrivedAtPickup,
    required this.onStartRide,
    required this.onEndRide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _buildActionButton(),
          const SizedBox(height: 8),
          Text(
            '${ride.distanceInKm.toStringAsFixed(1)} km • ${ride.estimatedDurationInMins} mins',
            style: const TextStyle(
              color: Colors.grey,
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
        statusColor = Colors.orange;
        break;
      case 'arrived':
        statusText = 'Waiting for Passenger';
        statusColor = Colors.blue;
        break;
      case 'started':
        statusText = 'Ride in Progress';
        statusColor = Colors.green;
        break;
      default:
        statusText = 'Unknown Status';
        statusColor = Colors.grey;
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
    return Column(
      children: [
        _buildLocationRow(
          'Pickup',
          ride.pickupLocation,
          Icons.location_on,
          Colors.green,
          true,
        ),
        const SizedBox(height: 8),
        _buildLocationRow(
          'Drop',
          ride.dropLocation,
          Icons.location_on,
          Colors.red,
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
                    color: Colors.grey,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (showDirections && rideStatus == 'accepted')
            TextButton.icon(
              onPressed: () {
                Get.find<HomeController>().onPickupLocationTap();
              },
              icon: const Icon(Icons.directions, color: Colors.blue),
              label: const Text('Directions'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                backgroundColor: Colors.blue.withOpacity(0.1),
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
        return ElevatedButton(
          onPressed: onArrivedAtPickup,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Arrived at Pickup'),
        );
      case 'arrived':
        return ElevatedButton(
          onPressed: onStartRide,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('Start Ride'),
        );
      case 'started':
        return ElevatedButton(
          onPressed: onEndRide,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text('End Ride'),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}