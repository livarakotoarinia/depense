import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountCtrl.text.isEmpty || _titleCtrl.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleCtrl.text;
    final enteredAmount = double.parse(_amountCtrl.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    // close modal when bouton enter in keybord is clicked
    Navigator.of(context).pop();
  }

  void _openDatePicker() {
    showDatePicker(
      context: context,
      locale: Locale('fr'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Titre'),
              controller: _titleCtrl,
              onSubmitted: (_) => _submitData(),
              // onChanged: (value) => titleInput = value,
            ),
            TextField(
              controller: _amountCtrl,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitData(),
              // onChanged: (value) => amountInput = value,
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // ignore: unnecessary_null_comparison
                    _selectedDate == null
                        ? 'Aucune date choisie'
                        : 'Date choisie: ${DateFormat.yMd('fr').format(_selectedDate!)}',
                  ),
                  TextButton(
                    onPressed: _openDatePicker,
                    child: Text(
                      'Choisir une date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text(
                'Ajouter transaction',
              ),
            )
          ],
        ),
      ),
    );
  }
}
