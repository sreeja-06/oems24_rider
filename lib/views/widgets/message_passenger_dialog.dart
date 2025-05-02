import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/messaging_service.dart';
import '../../constants/app_constants.dart';

class MessagePassengerDialog extends StatefulWidget {
  final String rideId;
  final String passengerName;

  const MessagePassengerDialog({
    Key? key,
    required this.rideId,
    required this.passengerName,
  }) : super(key: key);

  @override
  State<MessagePassengerDialog> createState() => _MessagePassengerDialogState();
}

class _MessagePassengerDialogState extends State<MessagePassengerDialog> {
  final TextEditingController _messageController = TextEditingController();
  final MessagingService _messagingService = Get.find<MessagingService>();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() => _isSending = true);
    
    try {
      final success = await _messagingService.sendMessageToPassenger(
        widget.rideId,
        message,
      );

      if (success) {
        Get.back(); // Close dialog
        Get.snackbar(
          'Message Sent',
          'Your message has been sent to ${widget.passengerName}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send message. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Message ${widget.passengerName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quick Messages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _messagingService.messageTemplates.map((template) {
                return InkWell(
                  onTap: _isSending ? null : () => _sendMessage(template),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      template,
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Custom Message',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: !_isSending,
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSending
                  ? null
                  : () => _sendMessage(_messageController.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
} 