import 'package:athkarapp/models/habitsModel.dart';
import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  final HabitRecord? transaction;
  final Function(String name, String id) onClickedDone;

  const TransactionDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      amountController.text = transaction.id;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'تعديل العادة' : 'إضافة عادة جديدة';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
              buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Id',
        ),
        keyboardType: TextInputType.number,
        validator: (amount) =>
            amount != null && amount.isEmpty ? 'Enter an id' : null,
        controller: amountController,
      );

  Widget buildRadioButtons() => Column(
        children: [
          RadioListTile<bool>(
            title: Text('Expense'),
            value: true,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
          RadioListTile<bool>(
            title: Text('Income'),
            value: false,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final id = amountController.text;

          widget.onClickedDone(name, id);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
