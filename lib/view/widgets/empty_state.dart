import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final bool isFavorites;
  final VoidCallback? onExplore;

  const EmptyState({
    super.key,
    required this.isFavorites,
    this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFavorites
                  ? Icons.favorite_border
                  : Icons.search_off,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              isFavorites
                  ? 'No saved items yet'
                  : 'No products found',
              style: AppTextStyles.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFavorites
                  ? 'Tap the heart on any product to save it here.'
                  : 'Try another search or choose a different category.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            if (isFavorites && onExplore != null) ...[
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: onExplore,
                child: const Text('Explore products'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}