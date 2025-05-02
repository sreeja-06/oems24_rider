import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ride_history_controller.dart';
import '../../constants/app_constants.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Try to find existing controller first, create one only if not found
    final RideHistoryController controller;
    if (Get.isRegistered<RideHistoryController>()) {
      controller = Get.find<RideHistoryController>();
      // Refresh data when returning to this screen
      controller.loadRideHistory();
    } else {
      controller = Get.put(RideHistoryController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadRideHistory(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rides.isEmpty) {
          return const Center(
            child: Text(
              'No rides yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rides.length,
          itemBuilder: (context, index) {
            final ride = controller.rides[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ride.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.formatCurrency(ride.fare),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLocationRow(
                      'From',
                      ride.pickupLocation,
                      Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 8),
                    _buildLocationRow(
                      'To',
                      ride.dropLocation,
                      Icons.location_on,
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ride.formattedDate,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 18,
                              color: AppConstants.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ride.passengerRating != null 
                                  ? ride.passengerRating!.toStringAsFixed(1) 
                                  : "N/A",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLocationRow(String label, String location, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(width: 8),
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
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}