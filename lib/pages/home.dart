import 'package:flutter/material.dart';
import 'package:dribble_finance_app_design/theme/colors.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Person>> futurePersons;

  @override
  void initState() {
    super.initState();
    futurePersons = fetchPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Available balance',
                style: TextStyle(
                  color: Color.fromARGB(255, 95, 92, 92),
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                '\$4820.23',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton('Pay', Icons.payment),
                  _buildActionButton('Send', Icons.send),
                  _buildActionButton('Request', Icons.request_page),
                  _buildActionButton('Cash In', Icons.account_balance_wallet),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
  child: Container(
    decoration: const BoxDecoration(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0), // Sol üst köşe
        topRight: Radius.circular(25.0), // Sağ üst köşe
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Person>>(
        future: futurePersons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load persons'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0 || snapshot.data![index - 1].amount.sign != transaction.amount.sign)
                      Text(
                        transaction.amount > 0 ? 'Received' : 'Sent',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    _buildTransactionItem(transaction),
                  ],
                );
              },
            );
          }
        },
      ),
    ),
  ),
),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.accent,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(text),
      ],
    );
  }

  Widget _buildTransactionItem(Person transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(transaction.name),
        trailing: Text(
          transaction.amount.toStringAsFixed(2),
          style: TextStyle(
            color: transaction.amount > 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}