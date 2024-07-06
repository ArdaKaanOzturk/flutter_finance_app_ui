import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/pages/transfer_money/summary.dart';
import 'package:flutter/material.dart';

class EnterAmountPage extends StatelessWidget {
  final Person person;
  const EnterAmountPage({required this.person, super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(person.imageUrl ?? 'https://via.placeholder.com/150'),
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    person.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter amount',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SummaryPage(amount: amountController.text, person: person),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}