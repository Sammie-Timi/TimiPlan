import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:timiplan/Model/transactions.dart';
import 'package:timiplan/Screens/add_edit_transaction.dart';
import 'package:timiplan/Screens/history.dart';
import 'package:timiplan/Screens/home.dart';
import 'package:timiplan/Screens/stats.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  // List<Transaction> transactions = [];

  onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
   }

  openAddTransaction() async {
    Future.delayed(Duration(seconds: 1), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        enableDrag: true,
        useSafeArea: true,

        builder:
            (context) => DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 1.0,
              builder:
                  (context, scrollController) => Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 16,
                      right: 16,
                      top: 24,
                    ),

                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: AddEditTransaction(
                        onSave: (newTx) {
                          setState(() {
                            transactions.add(newTx);
                          });
                        },
                      ),
                    ),
                  ),
            ),
      );
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Home(transactions: transactions),
      Transactions(transactions: transactions),
      Stats(transactions: transactions),

      Center(child: Text('Settings')),

      // HistoryScreen(),
      // AddTransactionScreen(),
      // StatsScreen(),
      // SettingsScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageStorage(
        bucket: bucket,
        child: IndexedStack(index: currentIndex, children: screens),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: openAddTransaction,
        backgroundColor: Colors.yellow.shade700,
        foregroundColor: Colors.black,
        elevation: 10,
        tooltip: "Add Transactions",
        splashColor: Colors.black26,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 40),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 65,
        elevation: 10,
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              splashColor: Colors.grey.shade800,
              height: double.infinity,
              animationDuration: Duration(seconds: 2),
              minWidth: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              onPressed: () => onTabTapped(0),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedHome06,
                    color:
                        currentIndex == 0
                            ? Colors.yellow.shade700
                            : Colors.white70,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Home",
                    style: GoogleFonts.poppins(
                      color:
                          currentIndex == 0
                              ? Colors.yellow.shade700
                              : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              splashColor: Colors.yellow.shade50,
              animationDuration: Duration(seconds: 1),
              minWidth: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () => onTabTapped(1),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedTransactionHistory,
                    color:
                        currentIndex == 1
                            ? Colors.yellow.shade700
                            : Colors.white70,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Transactions",
                    style: GoogleFonts.poppins(
                      color:
                          currentIndex == 1
                              ? Colors.yellow.shade700
                              : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 60),
            MaterialButton(
              splashColor: Colors.yellow.shade50,
              animationDuration: Duration(seconds: 1),
              minWidth: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () => onTabTapped(2),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedBarChart,
                    color:
                        currentIndex == 2
                            ? Colors.yellow.shade700
                            : Colors.white70,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Stats",
                    style: GoogleFonts.poppins(
                      color:
                          currentIndex == 2
                              ? Colors.yellow.shade700
                              : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              splashColor: Colors.yellow.shade50,
              animationDuration: Duration(seconds: 1),
              minWidth: 30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () => onTabTapped(3),
              child: Column(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedSetting07,
                    color:
                        currentIndex == 3
                            ? Colors.yellow.shade700
                            : Colors.white70,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Settings",
                    style: GoogleFonts.poppins(
                      color:
                          currentIndex == 3
                              ? Colors.yellow.shade700
                              : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
