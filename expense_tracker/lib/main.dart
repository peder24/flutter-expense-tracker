import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData.dark(),
      home: const ExpenseHomePage(),
    );
  }
}

class Expense {
  final String title;
  final double amount;
  final String category;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
  });
}

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() =>
      _ExpenseHomePageState();
}

class _ExpenseHomePageState
    extends State<ExpenseHomePage> {

  final List<Expense> expenses = [];

  final TextEditingController
      titleController =
      TextEditingController();

  final TextEditingController
      amountController =
      TextEditingController();

  String selectedCategory = "Food";

  final List<String> categories = [
    "Food",
    "Transport",
    "Shopping",
    "Drink",
    "Other"
  ];

  double get totalExpense {

    double total = 0;

    for (var expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  void addExpense() {

    final String title =
        titleController.text;

    final double? amount =
        double.tryParse(
            amountController.text);

    if (title.isEmpty || amount == null) {
      return;
    }

    setState(() {

      expenses.add(
        Expense(
          title: title,
          amount: amount,
          category: selectedCategory,
        ),
      );

      titleController.clear();
      amountController.clear();
    });
  }

  void deleteExpense(int index) {

    setState(() {
      expenses.removeAt(index);
    });
  }

  Color getCategoryColor(String category) {

    switch (category) {

      case "Food":
        return Colors.orange;

      case "Transport":
        return Colors.blue;

      case "Shopping":
        return Colors.purple;

      case "Drink":
        return Colors.brown;

      default:
        return Colors.green;
    }
  }

  Map<String, double> getCategoryTotals() {

    Map<String, double> totals = {};

    for (var expense in expenses) {

      totals[expense.category] =
          (totals[expense.category] ?? 0)
          + expense.amount;
    }

    return totals;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        title: const Text(
          "Expense Tracker",
        ),

        centerTitle: true,

        backgroundColor:
            Colors.black,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.all(16),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // TOTAL CARD
                Container(

                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(20),

                  decoration: BoxDecoration(

                    color:
                        Colors.deepPurple,

                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(

                        "Total Expense",

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(

                        "Rp ${totalExpense.toStringAsFixed(0)}",

                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE INPUT
                TextField(

                  controller:
                      titleController,

                  decoration: InputDecoration(

                    hintText:
                        "Expense Title",

                    filled: true,

                    fillColor:
                        Colors.grey[900],

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // AMOUNT INPUT
                TextField(

                  controller:
                      amountController,

                  keyboardType:
                      TextInputType.number,

                  decoration: InputDecoration(

                    hintText:
                        "Amount",

                    filled: true,

                    fillColor:
                        Colors.grey[900],

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // CATEGORY
                DropdownButtonFormField<String>(

                  value: selectedCategory,

                  dropdownColor:
                      Colors.grey[900],

                  items:
                      categories.map((category) {

                    return DropdownMenuItem(

                      value: category,

                      child: Text(category),
                    );
                  }).toList(),

                  onChanged: (value) {

                    setState(() {
                      selectedCategory = value!;
                    });
                  },

                  decoration: InputDecoration(

                    filled: true,

                    fillColor:
                        Colors.grey[900],

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // BUTTON
                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(

                    onPressed: addExpense,

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.deepPurple,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),

                    child: const Text(

                      "Add Expense",

                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PIE CHART
                if (expenses.isNotEmpty)

                  Container(

                    width: double.infinity,

                    height: 320,

                    padding:
                        const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.grey[900],

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Expense Analytics",

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Expanded(

                          child: PieChart(

                            PieChartData(

                              centerSpaceRadius: 40,

                              sectionsSpace: 3,

                              sections:

                                  getCategoryTotals()
                                      .entries
                                      .map((entry) {

                                return PieChartSectionData(

                                  color:
                                      getCategoryColor(
                                          entry.key),

                                  value: entry.value,

                                  title:
                                      "${entry.key}\n${entry.value.toStringAsFixed(0)}",

                                  radius: 90,

                                  titleStyle:
                                      const TextStyle(

                                    fontSize: 12,

                                    fontWeight:
                                        FontWeight.bold,

                                    color:
                                        Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                const Text(

                  "Recent Expenses",

                  style: TextStyle(

                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // EMPTY STATE
                if (expenses.isEmpty)

                  Container(

                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(40),

                    decoration: BoxDecoration(

                      color: Colors.grey[900],

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: const Center(

                      child: Text(

                        "No expenses yet",

                        style: TextStyle(
                          color:
                              Colors.white54,
                        ),
                      ),
                    ),
                  ),

                // EXPENSE LIST
                ...expenses.asMap().entries.map((entry) {

                  int index = entry.key;

                  Expense expense =
                      entry.value;

                  return Card(

                    color:
                        Colors.grey[900],

                    margin:
                        const EdgeInsets.only(
                            bottom: 12),

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                              15),
                    ),

                    child: ListTile(

                      contentPadding:
                          const EdgeInsets.all(10),

                      leading: CircleAvatar(

                        backgroundColor:
                            getCategoryColor(
                                expense.category),

                        child: Text(
                          expense.category[0],
                        ),
                      ),

                      title:
                          Text(expense.title),

                      subtitle:
                          Text(expense.category),

                      trailing: Row(

                        mainAxisSize:
                            MainAxisSize.min,

                        children: [

                          Text(

                            "Rp ${expense.amount.toStringAsFixed(0)}",
                          ),

                          IconButton(

                            onPressed: () {
                              deleteExpense(
                                  index);
                            },

                            icon: const Icon(

                              Icons.delete,

                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}