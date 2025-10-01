import 'package:flutter/cupertino.dart';
// Create a separate widget file or add to the same file
class CupertinoTimePickerModal extends StatelessWidget {
  final DateTime initialDateTime;

  const CupertinoTimePickerModal({
    super.key,
    required this.initialDateTime,
  });

  @override
  Widget build(BuildContext context) {
    DateTime tempDateTime = initialDateTime;

    return Container(
      height: 250,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(tempDateTime),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: initialDateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  tempDateTime = newDateTime;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}