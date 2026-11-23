import 'package:flutter/material.dart';
import '../models/expense_category.dart';

class ExpenseForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final ExpenseCategory selectedCategory;
  final Function(ExpenseCategory) onCategoryChanged;
  final VoidCallback onAdd;

  const ExpenseForm({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Անվանում',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Գումար',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ExpenseCategory.values.map((category) {
              return ChoiceChip(
                label: Text('${category.emoji} ${category.name}'),
                selected: selectedCategory == category,
                onSelected: (_) {
                  onCategoryChanged(category);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAdd,
              child: const Text('Ավելացնել'),
            ),
          ),
        ],
      ),
    );
  }
}
