import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timiplan/Model/transactions.dart';

class StatsChart extends StatefulWidget {
  final List<Transaction> transactions;
  final String filter;

  const StatsChart({
    super.key,

    required this.transactions,
    required this.filter,
  });

  @override
  State<StatsChart> createState() => _StatsChartState();
}

enum ChartFilter { week, month, year }

class _StatsChartState extends State<StatsChart> {
  Map<String, dynamic> getChartData(
    List<Transaction> transactions,
    ChartFilter filter,
  ) {
    final now = DateTime.now();
    List<FlSpot> spots = [];
    List<String> labels = [];
    switch (filter) {
      case ChartFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        for (int i = 0; i < 7; i++) {
          final day = startOfWeek.add(Duration(days: i));
          final dailyTransactions = transactions
              .where(
                (transaction) =>
                    transaction.date.year == day.year &&
                    transaction.date.month == day.month &&
                    transaction.date.day == day.day,
              )
              .fold<double>(
                0.0,
                (sum, transaction) =>
                    (transaction.isIncome
                        ? transaction.amount
                        : -transaction.amount) +
                    sum,
              );
          spots.add(FlSpot(i.toDouble(), dailyTransactions));
          labels.add(DateFormat.E().format(day));
        }
        break;
      case ChartFilter.month:
        for (int i = 1; i <= 12; i++) {
          final monthTransactions = transactions
              .where(
                (transaction) =>
                    transaction.date.year == now.year &&
                    transaction.date.month == i,
              )
              .fold(
                0.0,
                (sum, transaction) =>
                    (transaction.isIncome
                        ? transaction.amount
                        : -transaction.amount) +
                    sum,
              );
          spots.add(FlSpot((i - 1).toDouble(), monthTransactions));
          labels.add(DateFormat.MMM().format(DateTime(now.year, i)));
        }
        break;
      case ChartFilter.year:
        final years =
            transactions.map((t) => t.date.year).toSet().toList()..sort();

        for (int i = 0; i < years.length; i++) {
          final year = years[i];
          final total = transactions
              .where((transactions) => transactions.date.year == year)
              .fold(
                0.0,
                (sum, transactions) =>
                    sum +
                    (transactions.isIncome
                        ? transactions.amount
                        : -transactions.amount),
              );
          spots.add(FlSpot(i.toDouble(), total));
          labels.add(year.toString());
        }
        break;
    }

    return {'spots': spots, 'labels': labels};
  }

  @override
  Widget build(BuildContext context) {
    ChartFilter getChartFilterFromString(String filter) {
      switch (filter.toLowerCase()) {
        case 'week':
          return ChartFilter.week;
        case 'month':
          return ChartFilter.month;
        case 'year':
          return ChartFilter.year;
        default:
          return ChartFilter.month;
      }
    }

    final chartFilter = getChartFilterFromString(widget.filter);
    final chartData = getChartData(transactions, chartFilter);
    final spots = chartData['spots'] as List<FlSpot>;
    final labels = chartData['labels'] as List<String>;
    const double pointWidth = 50.0;
    final chartWidth = spots.length * pointWidth;
    final isAllZero = spots.isEmpty || spots.every((spot) => spot.y == 0);
    if (isAllZero) {
      return Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: Text(
          "No data available for this period.",
          style: GoogleFonts.roboto(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: SizedBox(
          width: chartWidth,
          height: 200,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                getTouchedSpotIndicator: (barData, List<int> spotIndexes) {
                  return spotIndexes.map((index) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: Colors.black,
                        strokeWidth: 3,
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ), // line under the tooltip
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 6,
                            color: Colors.white, // indicator dot color
                            strokeColor: Colors.black,
                            strokeWidth: 3,
                          );
                        },
                      ),
                    );
                  }).toList();
                },

                touchTooltipData: LineTouchTooltipData(
                  tooltipBorderRadius: BorderRadius.circular(10),
                  getTooltipColor: (touchedSpot) => Colors.black45,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((barSpot) {
                      return LineTooltipItem(
                        '\₦${barSpot.y.toStringAsFixed(0)}',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),

              minY: 0,
              gridData: FlGridData(show: false),

              titlesData: FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();

                      if (index >= 0 && index < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            labels[index],
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    interval: 1,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  dotData: FlDotData(show: false),
                  spots: spots,
                  isCurved: true,

                  curveSmoothness: 0.5,
                  color: Colors.yellow.shade700,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow.shade700.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
