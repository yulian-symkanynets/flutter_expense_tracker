import 'package:expense_app/new_expense.dart';
import 'package:expense_app/widgets/chart/chart.dart';
import 'package:expense_app/widgets/expense_list/expenses_list.dart';
import 'package:flutter/material.dart';

import 'models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: "Flutter Couse",
      amount: 21.21,
      dateTime: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "McDonald",
      amount: 18.69,
      dateTime: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          },
        ),
        content: Text("Expense deleted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text("No Contend"),
    );
    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onRemove: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpense),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
