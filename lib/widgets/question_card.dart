import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/theme_provider.dart';

/// بطاقة السؤال المحسنة مع دعم الصور
class QuestionCard extends StatelessWidget {
  final String questionText;
  final String? imageUrl;
  final String category;
  final String difficulty;
  final bool showImage;

  const QuestionCard({
    super.key,
    required this.questionText,
    this.imageUrl,
    required this.category,
    required this.difficulty,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس البطاقة مع الفئة والصعوبة
              Row(
                children: [
                  _buildCategoryChip(category),
                  const SizedBox(width: 8),
                  _buildDifficultyChip(difficulty),
                  const Spacer(),
                  _buildQuestionNumber(),
                ],
              ),
              const SizedBox(height: 16),
              
              // الصورة (إذا كانت متوفرة)
              if (showImage && imageUrl != null) ...[
                _buildQuestionImage(imageUrl!),
                const SizedBox(height: 16),
              ],
              
              // نص السؤال
              Text(
                questionText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final categoryData = _getCategoryData(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: categoryData['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            categoryData['icon'],
            size: 16,
            color: categoryData['color'],
          ),
          const SizedBox(width: 4),
          Text(
            categoryData['name'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: categoryData['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    final difficultyData = _getDifficultyData(difficulty);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: difficultyData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: difficultyData['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            difficultyData['icon'],
            size: 16,
            color: difficultyData['color'],
          ),
          const SizedBox(width: 4),
          Text(
            difficultyData['name'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: difficultyData['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Q',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryAccent,
        ),
      ),
    );
  }

  Widget _buildQuestionImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getCategoryData(String category) {
    switch (category.toLowerCase()) {
      case 'science':
        return {
          'name': 'Science',
          'icon': Icons.science,
          'color': Colors.blue,
        };
      case 'history':
        return {
          'name': 'History',
          'icon': Icons.history_edu,
          'color': Colors.orange,
        };
      case 'geography':
        return {
          'name': 'Geography',
          'icon': Icons.public,
          'color': Colors.green,
        };
      case 'literature':
        return {
          'name': 'Literature',
          'icon': Icons.menu_book,
          'color': Colors.purple,
        };
      case 'sports':
        return {
          'name': 'Sports',
          'icon': Icons.sports,
          'color': Colors.red,
        };
      case 'entertainment':
        return {
          'name': 'Entertainment',
          'icon': Icons.movie,
          'color': Colors.pink,
        };
      default:
        return {
          'name': 'General',
          'icon': Icons.quiz,
          'color': AppColors.primaryAccent,
        };
    }
  }

  Map<String, dynamic> _getDifficultyData(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return {
          'name': 'Easy',
          'icon': Icons.sentiment_satisfied,
          'color': Colors.green,
        };
      case 'medium':
        return {
          'name': 'Medium',
          'icon': Icons.sentiment_neutral,
          'color': Colors.orange,
        };
      case 'hard':
        return {
          'name': 'Hard',
          'icon': Icons.sentiment_dissatisfied,
          'color': Colors.red,
        };
      default:
        return {
          'name': 'Medium',
          'icon': Icons.sentiment_neutral,
          'color': Colors.orange,
        };
    }
  }
}
