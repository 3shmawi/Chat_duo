import 'package:flutter/material.dart';

enum UseCases {
  loading,
  empty,
  error,
  success,
}

class UseCaseWidget extends StatelessWidget {
  const UseCaseWidget(
    this.useCase, {
    this.body,
    super.key,
  });

  final UseCases useCase;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    switch (useCase) {
      case UseCases.loading:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading..."),
            ],
          ),
        );
      case UseCases.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_food_beverage,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No data available",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        );
      case UseCases.error:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                "An error happened!",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        );
      case UseCases.success:
        return body ?? const SizedBox.shrink();
    }
  }
}
