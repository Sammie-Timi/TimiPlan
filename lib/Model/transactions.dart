class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

List<Transaction> transactions = [
  Transaction(
    id: 't1',
    title: 'Groceries',
    amount: 2500,
    date: DateTime(2025, 5, 16),
    isIncome: false,
  ),
  Transaction(
    id: 't2',
    title: 'Salary',
    amount: 20000,
    date: DateTime(2025, 5, 15),
    isIncome: true,
  ),
  Transaction(
    id: 't3',
    title: 'Rent',
    amount: 3000,
    date: DateTime(2025, 5, 10),
    isIncome: false,
  ),
  Transaction(
    id: 't4',
    title: 'Bus Ticket',
    amount: 1000,
    date: DateTime(2025, 5, 8),
    isIncome: false,
  ),
  Transaction(
    id: 't5',
    title: 'Rice',
    amount: 2500,
    date: DateTime(2025, 1, 16),
    isIncome: false,
  ),
  Transaction(
    id: 't6',
    title: 'Bonus',
    amount: 50000,
    date: DateTime(2025, 1, 15),
    isIncome: true,
  ),
  Transaction(
    id: 't7',
    title: 'Sweet',
    amount: 3000,
    date: DateTime(2025, 1, 10),
    isIncome: false,
  ),
  Transaction(
    id: 't8',
    title: 'Gift Card',
    amount: 1000,
    date: DateTime(2025, 1, 8),
    isIncome: false,
  ),
];
