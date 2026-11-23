enum ExpenseCategory {
  food('Սնունդ', '🍔'),
  transport('Տրանսպորտ', '🚌'),
  entertainment('Զվարճանք', '🎮'),
  other('Այլ', '📦');

  final String name;
  final String emoji;

  const ExpenseCategory(this.name, this.emoji);
}
