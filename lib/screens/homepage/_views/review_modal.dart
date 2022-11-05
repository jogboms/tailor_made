import 'package:flutter/material.dart';

class ReviewModal extends StatelessWidget {
  const ReviewModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        animationDuration: const Duration(seconds: 5),
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Can you rate the experience so far?', textAlign: TextAlign.center),
              const SizedBox(height: 24.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    color: Colors.red,
                    iconSize: 30.0,
                    icon: const Icon(Icons.sentiment_very_dissatisfied),
                    onPressed: () => Navigator.pop<int>(context, 1),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    color: Colors.orange,
                    iconSize: 30.0,
                    icon: const Icon(Icons.sentiment_dissatisfied),
                    onPressed: () => Navigator.pop<int>(context, 2),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    color: Colors.blueGrey,
                    iconSize: 30.0,
                    icon: const Icon(Icons.sentiment_neutral),
                    onPressed: () => Navigator.pop<int>(context, 3),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    color: Colors.lightGreen,
                    iconSize: 30.0,
                    icon: const Icon(Icons.sentiment_satisfied),
                    onPressed: () => Navigator.pop<int>(context, 4),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    color: Colors.green,
                    iconSize: 30.0,
                    icon: const Icon(Icons.sentiment_very_satisfied),
                    onPressed: () => Navigator.pop<int>(context, 5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
