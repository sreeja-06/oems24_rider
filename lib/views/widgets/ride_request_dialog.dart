import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/ride_request.dart';
import '../../utils/format_util.dart';

class RideRequestDialog extends StatefulWidget {
  final RideRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final int timeoutSeconds;

  const RideRequestDialog({
    Key? key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.timeoutSeconds,
  }) : super(key: key);

  @override
  State<RideRequestDialog> createState() => _RideRequestDialogState();
}

class _RideRequestDialogState extends State<RideRequestDialog> {
  late int secondsRemaining;

  @override
  void initState() {
    super.initState();
    secondsRemaining = widget.timeoutSeconds;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
      setState(() {
          if (secondsRemaining > 0) {
            secondsRemaining--;
            _startTimer();
        } else {
            widget.onReject();
        }
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Ride Request',
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF007BFF),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007BFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${secondsRemaining}s',
                    style: const TextStyle(
                      color: Color(0xFF007BFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  widget.request.customerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.request.pickupLocation,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(
                    widget.request.dropLocation,
                    style: const TextStyle(fontSize: 14),
                  ),
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
                    Text(
                      FormatUtil.formatCurrency(widget.request.estimatedFare),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF007BFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${FormatUtil.formatDistance(widget.request.distanceInKm)} • ${FormatUtil.formatDuration(widget.request.estimatedDurationInMins * 60)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
                Row(
                children: [
                    TextButton(
                      onPressed: widget.onReject,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Text('Reject'),
                    ),
                    ElevatedButton(
                      onPressed: widget.onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                      ),
                      ),
                      child: const Text('Accept'),
                  ),
                ],
              ),
              ],
              ),
            ],
        ),
      ),
    );
  }
}
