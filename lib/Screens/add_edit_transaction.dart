import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timiplan/Model/transactions.dart';

class AddEditTransaction extends StatefulWidget {
  final Transaction? existingTransaction;
  final Function(Transaction) onSave;

  const AddEditTransaction({
    super.key,
    this.existingTransaction,
    required this.onSave,
  });

  @override
  State<AddEditTransaction> createState() => _AddEditTransactionState();
}

class _AddEditTransactionState extends State<AddEditTransaction> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late bool _isIncome;
  late DateTime _selectedDate;

  final _amountController = TextEditingController();
  final _formatter = NumberFormat('#,##0', 'en_NG');

  @override
  void initState() {
    super.initState();
    final t = widget.existingTransaction;
    _title = t?.title ?? '';
    _amount = t?.amount ?? 0;
    _isIncome = t?.isIncome ?? true;
    _selectedDate = t?.date ?? DateTime.now();

    if (_amount != 0) {
      _amountController.text = _formatter.format(_amount);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    // Remove commas and format as user types
    String cleaned = value.replaceAll(',', '');
    double? val = double.tryParse(cleaned);
    if (val != null) {
      String newText = _formatter.format(val);
      if (newText != value) {
        _amountController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTx = Transaction(
        id: widget.existingTransaction?.id ?? DateTime.now().toString(),
        title: _title,
        amount: double.parse(_amountController.text.replaceAll(',', '')),
        isIncome: _isIncome,
        date: _selectedDate,
      );

      widget.onSave(newTx);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTransaction != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isEditing ? 'Edit Transaction' : 'Add Transaction',
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val!,
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _amountController,
                onChanged: _onAmountChanged,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved:
                    (val) => _amount = double.parse(val!.replaceAll(',', '')),
                validator: (val) {
                  String cleaned = val?.replaceAll(',', '') ?? '';
                  return cleaned.isEmpty || double.tryParse(cleaned) == null
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              SwitchListTile(
                title: const Text('Is Income?'),
                value: _isIncome,
                onChanged: (val) => setState(() => _isIncome = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
