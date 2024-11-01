import 'package:chat_duo/screens/_resources/colors.dart';
import 'package:flutter/material.dart';

enum UseCase {
  empty,
  success,
  failure,
  loading,
}

class AppUseCase extends StatelessWidget {
  const AppUseCase(this.useCase, {this.body, this.errorMessage, super.key});

  final UseCase useCase;
  final Widget? body;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    switch (useCase) {
      case UseCase.empty:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_sharp,
                color: AppColors.primary,
                size: 150,
              ),
              Text(
                'No data available',
                style: TextStyle(color: AppColors.primary, fontSize: 24),
              ),
            ],
          ),
        );
      case UseCase.success:
        return body ?? Container();
      case UseCase.failure:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 150,
              ),
              const Text(
                'An error occurred',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        );
      case UseCase.loading:
        return Center(
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(color: AppColors.primary, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
