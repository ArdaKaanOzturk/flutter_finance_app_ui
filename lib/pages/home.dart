import 'package:dribble_finance_app_design/pages/send.dart';
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.payment,
                      label: 'Pay',
                      onTap: () {
                        // Handle Pay button tap
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.send,
                      label: 'Send',
                      onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SendPage(),
      ),
    );
  },
                    ),
                    _buildActionButton(
                      icon: Icons.request_page,
                      label: 'Request',
                      onTap: () {
                        // Handle Request button tap
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.money,
                      label: 'Cash In',
                      onTap: () {
                        // Handle Cash In button tap
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
  child: Container(
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0), // Sol üst köşe
        topRight: Radius.circular(25.0), // Sağ üst köşe
      ),
    ),
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
              return 
              index == 0 ? 
              Center(
                child: Container(
                  width: 60,
                  height: 2,
                  color: Colors.black,
                ),
              ) : 
              Column(
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

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(23),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 29, color: Colors.white),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
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
