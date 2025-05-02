import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';

class PassengerRatingDialog extends StatefulWidget {
  final String passengerName;
  final String? passengerPhoto;
  final Function(double rating, String feedback) onSubmit;

  const PassengerRatingDialog({
    Key? key,
    required this.passengerName,
    this.passengerPhoto,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<PassengerRatingDialog> createState() => _PassengerRatingDialogState();
}

class _PassengerRatingDialogState extends State<PassengerRatingDialog> {
  double _rating = 5.0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return IconButton(
          onPressed: () {
            setState(() => _rating = starValue.toDouble());
          },
          icon: Icon(
            starValue <= _rating 
                ? Icons.star_rounded 
                : Icons.star_outline_rounded,
            size: 36,
            color: starValue <= _rating
                ? const Color(0xFFFFB800)
                : Colors.grey[400],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          constraints: const BoxConstraints(),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Rate Your Passenger',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (widget.passengerPhoto != null) ...[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.passengerPhoto!),
                  backgroundColor: Colors.grey[200],
                  child: widget.passengerPhoto == null
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 12),
              ],
              Text(
                widget.passengerName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              _buildStarRating(),
              const SizedBox(height: 24),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add feedback (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppConstants.primaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setState(() => _isSubmitting = true);
                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          ); // Simulate network delay
                          if (mounted) {
                            widget.onSubmit(
                              _rating,
                              _feedbackController.text.trim(),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 