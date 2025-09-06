import 'package:flutter/material.dart';
import 'package:social_media_app/core/utils/colors.dart';

class NoPages extends StatelessWidget {
  const NoPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("no pages found")),
      body: Center(
        child: Column(
          children: [
            Icon(Icons.error, size: 100, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              '404- page not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
