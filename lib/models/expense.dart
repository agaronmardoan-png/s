import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final int amount;
  final ExpenseCategory category;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });

  Expense copyWith({int? amount}) {
    return Expense(
      id: id,
      title: title,
      amount: amount ?? this.amount,
      category: category,
    );
  }
}
