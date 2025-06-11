import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timiplan/Model/transactions.dart';
import 'package:timiplan/Widgets/stats_chart.dart';

class Stats extends StatefulWidget {
  final List<Transaction> transactions;
  const Stats({super.key, required this.transactions});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  double get income => widget.transactions
      .where((transaction) => transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  double get expense => widget.transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  final List<String> filters = ['Week', 'Month', 'Year'];
  final List<String> transactionTypes = ['Expenses', 'Income'];
  int selectedIndex = 1;
  int selectedTransactionType = 0;

  List<Transaction> get filteredTransactions {
    return widget.transactions.where((transaction) {
      return selectedTransactionType == 0
          ? !transaction.isIncome
          : transaction.isIncome;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final balance = income - expense;
    final currencyFormatter = NumberFormat('#,##0', 'en_NG');
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(
          ' Statistics',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        scrolledUnderElevation: 2,
        shadowColor: Colors.white70,
        elevation: 1,
        surfaceTintColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  '₦${currencyFormatter.format(balance)}',
                  style: GoogleFonts.roboto(
                    color: Colors.grey.shade800,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 4),
              //
              Center(
                child: Builder(
                  builder: (context) {
                    final now = DateTime.now();
                    String label;
                    switch (filters[selectedIndex].toLowerCase()) {
                      case 'week':
                        final startOfWeek = now.subtract(
                          Duration(days: now.weekday - 1),
                        );
                        final endOfWeek = startOfWeek.add(Duration(days: 6));
                        label =
                            '${DateFormat('dd MMM').format(startOfWeek)} - ${DateFormat('dd MMM yyyy').format(endOfWeek)}';
                        break;
                      case 'month':
                        label = DateFormat('dd, MMM yyyy').format(now);
                        break;
                      case 'year':
                        // Show range of years in user's transactions
                        final years =
                            widget.transactions
                                .map((t) => t.date.year)
                                .toSet()
                                .toList()
                              ..sort();
                        if (years.isNotEmpty) {
                          label =
                              years.length == 1
                                  ? years.first.toString()
                                  : '${years.first} - ${years.last}';
                        } else {
                          label = DateFormat('yyyy').format(now);
                        }
                        break;
                      default:
                        label = DateFormat('dd MMM yyyy').format(now);
                    }
                    return Text(
                      label,
                      style: GoogleFonts.roboto(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(2),

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(filters.length, (index) {
                    final isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        curve: Curves.easeInBack,

                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Colors.yellow.shade700
                                    : Colors.transparent,
                            width: isSelected ? 2 : 0,
                          ),
                        ),
                        duration: Duration(milliseconds: 300),
                        child: Text(
                          filters[index],
                          style: GoogleFonts.roboto(
                            color:
                                isSelected
                                    ? Colors.yellow.shade700
                                    : Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                value: selectedTransactionType,
                dropdownColor: Colors.white70,
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: GoogleFonts.roboto(color: Colors.black54, fontSize: 16),

                onChanged: (int? newType) {
                  setState(() {
                    if (newType != null) {
                      selectedTransactionType = newType;
                    }
                  });
                },
                items:
                    transactionTypes.map<DropdownMenuItem<int>>((String type) {
                      return DropdownMenuItem<int>(
                        value: transactionTypes.indexOf(type),
                        child: Text(
                          type,
                          style: GoogleFonts.roboto(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              widget.transactions.isEmpty
                  ? Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: Text(
                      "No data available for this period.",
                      style: GoogleFonts.roboto(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  : StatsChart(
                    transactions: filteredTransactions,
                    filter: filters[selectedIndex],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
