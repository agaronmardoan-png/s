import 'package:flutter/material.dart';
import 'package:s/data/%20expense_data.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../widgets/expense_tile.dart';
import '../widgets/expense_form.dart';
import '../widgets/category_filter.dart';
import 'edit_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  ExpenseCategory selectedCategory = ExpenseCategory.food;
  ExpenseCategory? filterCategory;

  List<Expense> get filteredExpenses {
    if (filterCategory == null) {
      return expenses;
    }

    return expenses
        .where((expense) => expense.category == filterCategory)
        .toList();
  }

  int get totalAmount {
    return filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void addExpense() {
    final title = titleController.text.trim();
    final amount = int.tryParse(amountController.text);

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Լրացրեք տվյալները ճիշտ ձևով'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      expenses.insert(
        0,
        Expense(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          amount: amount,
          category: selectedCategory,
        ),
      );

      titleController.clear();
      amountController.clear();
    });
  }

  void deleteExpense(Expense expense) {
    final originalIndex = expenses.indexWhere((item) => item.id == expense.id);

    setState(() {
      expenses.removeWhere((item) => item.id == expense.id);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերադարձնել',
          onPressed: () {
            setState(() {
              expenses.insert(originalIndex.clamp(0, expenses.length), expense);
            });
          },
        ),
      ),
    );
  }

  Future<void> editExpense(Expense expense) async {
    final updatedExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditExpenseScreen(expense: expense);
        },
      ),
    );

    if (updatedExpense == null || !mounted) return;

    setState(() {
      final index = expenses.indexWhere((item) => item.id == expense.id);

      if (index != -1) {
        expenses[index] = updatedExpense;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ընդամենը՝ $totalAmount դր.'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Column(
        children: [
          ExpenseForm(
            titleController: titleController,
            amountController: amountController,
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
            onAdd: addExpense,
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CategoryFilter(
              selectedCategory: filterCategory,
              onChanged: (category) {
                setState(() {
                  filterCategory = category;
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'Ծախսեր դեռ չկան',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final expense = items[index];

                      return Dismissible(
                        key: ValueKey(expense.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          deleteExpense(expense);
                        },
                        child: ExpenseTile(
                          expense: expense,
                          onTap: () {
                            editExpense(expense);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
