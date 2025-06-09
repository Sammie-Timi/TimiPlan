import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timiplan/Model/transactions.dart';
import 'package:intl/intl.dart';
import 'package:timiplan/Screens/add_edit_transaction.dart';
import 'package:timiplan/Screens/history.dart';
import 'package:timiplan/Widgets/wallet_card.dart';

class Home extends StatefulWidget {
  final List<Transaction> transactions;
  const Home({super.key, required this.transactions});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  String greetings = '';

  @override
  void initState() {
    super.initState();
    updateGreeting();
    timer = Timer.periodic(Duration(minutes: 1), (_) => updateGreeting());
  }

  @override
  dispose() {
    super.dispose();
  }

  updateGreeting() {
    final hour = DateTime.now().hour;
    String newGreeting;
    if (hour < 12) {
      newGreeting = 'Good Morning!';
    } else if (hour < 17) {
      newGreeting = 'Good Afternoon!';
    } else {
      newGreeting = 'Good Evening!';
    }

    setState(() {
      greetings = newGreeting;
    });
  }

  double get income => widget.transactions
      .where((transaction) => transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  double get expense => widget.transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  void deleteTransaction(String id) {
    setState(() {
      widget.transactions.removeWhere((t) => t.id == id);
    });
  }

  void editTransaction(Transaction tx) async {
    await Future.delayed(Duration(seconds: 1), () {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              insetAnimationCurve: Curves.linearToEaseOut,
              insetAnimationDuration: Duration(seconds: 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AddEditTransaction(
                  existingTransaction: tx,
                  onSave: (updatedTx) {
                    setState(() {
                      final index = widget.transactions.indexWhere(
                        (t) => t.id == tx.id,
                      );
                      widget.transactions[index] = updatedTx;
                    });
                    Navigator.of(
                      context,
                    ).pop(); // Close the dialog after saving
                  },
                ),
              ),
            ),
      );
    });

    debugPrint('Editing: ${tx.title}');
  }

  bool showBalance = true;
  @override
  Widget build(BuildContext context) {
    final balance = income - expense;
    final currencyFormatter = NumberFormat('#,##0', 'en_NG');
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors
                .transparent, // Set to transparent if you want your app bar or background to show
        statusBarIconBrightness:
            Brightness
                .light, // Or Brightness.light depending on your background
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20,
                bottom: 20,
                top: 20,
              ),
              child: Row(
                children: [
                  Text(
                    greetings,
                    style: GoogleFonts.roboto(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    color: Colors.white,
                    splashColor: Colors.white,
                    onPressed: () {},
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedNotification02,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Balance Area
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total Balance',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        splashColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            showBalance = !showBalance;
                          });
                        },
                        icon: Icon(
                          showBalance
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    showBalance
                        ? '₦${currencyFormatter.format(balance)}'
                        : '*****',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Income: ',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        showBalance
                            ? '₦${currencyFormatter.format(income)}'
                            : '****',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Expense: ',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        showBalance
                            ? '₦${currencyFormatter.format(expense)}'
                            : '****',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade900, thickness: 2),
                ],
              ),
            ),
            // Transactions Card
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'My Wallet',
                style: GoogleFonts.roboto(color: Colors.white54, fontSize: 14),
              ),
            ),
            WalletCard(
              balance: 5480.00,
              progress: 0.9,
              name: 'Samuel Omotayo',
              bankName: 'TimiBank',
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recent Transactions',
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Transactions(
                                      transactions: transactions,
                                    ),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.roboto(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.transactions.length,
                        itemBuilder: (ctx, index) {
                          final tx = widget.transactions[index];
                          return Dismissible(
                            key: Key(tx.id),
                            direction: DismissDirection.horizontal,
                            onDismissed: (_) => deleteTransaction(tx.id),
                            background: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),

                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_sweep,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Remove',
                                      style: GoogleFonts.roboto(
                                        color: Colors.redAccent,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            secondaryBackground: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              color: Colors.grey.shade50,
                              elevation: 1,
                              child: ListTile(
                                splashColor: Colors.grey.shade300,
                                onTap: () => editTransaction(tx),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black87,
                                  foregroundColor:
                                      tx.isIncome ? Colors.green : Colors.red,
                                  child: Icon(
                                    tx.isIncome
                                        ? Icons.arrow_downward_rounded
                                        : Icons.arrow_upward_rounded,
                                  ),
                                ),
                                title: Text(
                                  tx.title,
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('dd MMM yyyy').format(tx.date),
                                  style: GoogleFonts.roboto(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: Text(
                                  '${tx.isIncome ? '+' : '-'}₦${currencyFormatter.format(tx.amount)}',
                                  style: GoogleFonts.roboto(
                                    color:
                                        tx.isIncome ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
