import 'package:flutter/material.dart';

class JobDetialsInfoSheet extends StatefulWidget {
  const JobDetialsInfoSheet({super.key});

  @override
  State<JobDetialsInfoSheet> createState() => _JobDetialsInfoSheetState();
}

class _JobDetialsInfoSheetState extends State<JobDetialsInfoSheet> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 20) {
          // Close the BottomSheet on a downward swipe
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.3,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return Container(
            // height: 300,
            width: double.infinity,
            child: Text('data'),
            color: Colors.white,
          );
        },
      ),
    );
  }
}
