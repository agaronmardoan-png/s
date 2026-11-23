import 'package:flutter/material.dart';
import '../models/expense_category.dart';

class CategoryFilter extends StatelessWidget {
  final ExpenseCategory? selectedCategory;
  final ValueChanged<ExpenseCategory?> onChanged;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Բոլորը'),
            selected: selectedCategory == null,
            onSelected: (_) => onChanged(null),
          ),
          const SizedBox(width: 8),
          ...ExpenseCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text('${category.emoji} ${category.name}'),
                selected: selectedCategory == category,
                onSelected: (_) => onChanged(category),
              ),
            );
          }),
        ],
      ),
    );
  }
}
