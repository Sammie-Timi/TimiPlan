import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timiplan/Model/transactions.dart';

class Transactions extends StatefulWidget {
  final List<Transaction> transactions;
  const Transactions({super.key, required this.transactions});

  @override
  State<Transactions> createState() => _TransactionsState();
}

enum TransactionFilter { all, day, week, month, year }

class _TransactionsState extends State<Transactions> {
  TransactionFilter selectedFilter = TransactionFilter.all;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<int> years = List.generate(5, (i) => DateTime.now().year - i);
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  List<Transaction> get filteredTransactions {
    final now = DateTime.now();

    switch (selectedFilter) {
      case TransactionFilter.day:
        return widget.transactions
            .where(
              (t) =>
                  t.date.year == now.year &&
                  t.date.month == now.month &&
                  t.date.day == now.day,
            )
            .toList();
      case TransactionFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        return widget.transactions
            .where(
              (t) =>
                  t.date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
                  t.date.isBefore(endOfWeek.add(Duration(days: 1))),
            )
            .toList();
      case TransactionFilter.month:
        return widget.transactions
            .where(
              (t) =>
                  t.date.year == selectedYear && t.date.month == selectedMonth,
            )
            .toList();
      case TransactionFilter.year:
        return widget.transactions
            .where((t) => t.date.year == now.year)
            .toList();
      case TransactionFilter.all:
        return widget.transactions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'en_NG');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transactions History',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip.elevated(
                    label: Text('All'),
                    selected: selectedFilter == TransactionFilter.all,
                    onSelected:
                        (_) => setState(
                          () => selectedFilter = TransactionFilter.all,
                        ),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip.elevated(
                    label: Text('Today'),
                    selected: selectedFilter == TransactionFilter.day,
                    onSelected:
                        (_) => setState(
                          () => selectedFilter = TransactionFilter.day,
                        ),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip.elevated(
                    label: Text('This Week'),
                    selected: selectedFilter == TransactionFilter.week,
                    onSelected:
                        (_) => setState(
                          () => selectedFilter = TransactionFilter.week,
                        ),
                  ),
                  SizedBox(width: 8),
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTapDown: (details) {
                          final RenderBox button =
                              context.findRenderObject() as RenderBox;
                          final RenderBox overlay =
                              Overlay.of(context).context.findRenderObject()
                                  as RenderBox;
                          final Offset position = button.localToGlobal(
                            Offset.zero,
                            ancestor: overlay,
                          );
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              position.dx,
                              position.dy + button.size.height,
                              position.dx + button.size.width,
                              position.dy,
                            ),
                            items: List.generate(
                              12,
                              (index) => PopupMenuItem<int>(
                                value: index,
                                child: Row(
                                  children: [
                                    if (selectedMonth == index + 1)
                                      Icon(
                                        Icons.check,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                    if (selectedMonth == index + 1)
                                      SizedBox(width: 4),
                                    Text(months[index]),
                                  ],
                                ),
                              ),
                            ),
                          ).then((index) {
                            if (index != null) {
                              setState(() {
                                selectedMonth = index + 1;
                                selectedFilter = TransactionFilter.month;
                              });
                            }
                          });
                        },
                        child: ChoiceChip.elevated(
                          label: Text(months[selectedMonth - 1]),
                          selected: selectedFilter == TransactionFilter.month,
                          onSelected: (_) {
                            setState(() {
                              selectedFilter = TransactionFilter.month;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8),
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTapDown: (details) {
                          final RenderBox button =
                              context.findRenderObject() as RenderBox;
                          final RenderBox overlay =
                              Overlay.of(context).context.findRenderObject()
                                  as RenderBox;
                          final Offset position = button.localToGlobal(
                            Offset.zero,
                            ancestor: overlay,
                          );
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              position.dx,
                              position.dy + button.size.height,
                              position.dx + button.size.width,
                              position.dy,
                            ),
                            items:
                                years
                                    .map(
                                      (year) => PopupMenuItem<int>(
                                        value: year,
                                        child: Row(
                                          children: [
                                            if (selectedYear == year)
                                              Icon(
                                                Icons.check,
                                                color: Colors.blue,
                                                size: 18,
                                              ),
                                            if (selectedYear == year)
                                              SizedBox(width: 4),
                                            Text(year.toString()),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ).then((year) { 
                            if (year != null) {
                              setState(() {
                                selectedYear = year;
                                selectedFilter = TransactionFilter.month;
                              });
                            }
                          });
                        },
                        child: ChoiceChip.elevated(
                          label: Text(selectedYear.toString()),
                          selected:
                              selectedFilter == TransactionFilter.month ||
                              selectedFilter == TransactionFilter.year,
                          onSelected: (_) {
                            setState(() {
                              selectedFilter == TransactionFilter.month ||
                                  selectedFilter == TransactionFilter.year;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                filteredTransactions.isEmpty
                    ? Center(
                      child: Text(
                        'No transactions yet!',
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return ListTile(
                          title: Text(
                            transaction.title,
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [ 
                              Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                ).format(transaction.date),
                                style: GoogleFonts.roboto(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                DateFormat('hh:mm a').format(transaction.date),
                                style: GoogleFonts.roboto(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            transaction.isIncome
                                ? '+${currencyFormatter.format(transaction.amount)}'
                                : '-${currencyFormatter.format(transaction.amount)}',
                            style: TextStyle(
                              color:
                                  transaction.isIncome
                                      ? Colors.green
                                      : Colors.red,
                            ),
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
