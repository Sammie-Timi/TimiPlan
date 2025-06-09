import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

class WalletCard extends StatefulWidget {
  final double balance;
  final double progress;
  final String name;
  final String bankName;
  // final String cardType;
  const WalletCard({
    super.key,
    required this.balance,
    required this.progress,
    required this.name,
    required this.bankName,

    // required this.cardType,
  });

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0', 'en_NG');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.hardEdge,

        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(width: 10, color: Colors.transparent),
          ),
          elevation: 50,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 5, color: Colors.transparent),
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.black, Colors.white54],
                begin: AlignmentDirectional.topStart,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.88, 0.98],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current Balance',
                      style: GoogleFonts.roboto(
                        color: Colors.white54,
                        fontSize: 14,
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
                        color: Colors.white54,
                        size: 18,
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget.bankName,
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  showBalance
                      ? '₦${currencyFormatter.format(widget.balance)}'
                      : '****',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: widget.progress,
                    backgroundColor: Colors.grey.shade700,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.progress < 0.5
                          ? Colors.red
                          : Colors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      widget.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),

                    Spacer(),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedCreditCard,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
