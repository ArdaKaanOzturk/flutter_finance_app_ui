//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dribble_finance_app_design/theme/colors.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/cubit/send_cubit.dart';
import 'package:dribble_finance_app_design/pages/home.dart';

class SendPage extends StatelessWidget {
  const SendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search receiver',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Person>>(
                future: fetchPersons(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No receivers available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final person = snapshot.data![index];
                        return BlocBuilder<SendCubit, SendState>(
                          builder: (context, state) {
                            final selectedPerson = state is SendPersonSelected ? state.person : null;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(person.imageUrl ?? 'https://via.placeholder.com/150'),
                                radius: 40,
                              ),
                              title: Text(person.name),
                              selected: selectedPerson == person,
                              selectedTileColor: AppColors.accent,
                              onTap: () {
                                context.read<SendCubit>().selectPerson(person);
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            BlocBuilder<SendCubit, SendState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state is SendPersonSelected
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<SendCubit>(),
                                child: EnterAmountPage(person: state.person),
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Continue'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EnterAmountPage extends StatelessWidget {
  final Person person;
  const EnterAmountPage({required this.person, Key? key}) : super(key: key);

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
                context.read<SendCubit>().enterAmount(double.parse(amountController.text));
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<SendCubit>(),
                      child: SummaryPage(),
                    ),
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

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<SendCubit, SendState>(
          builder: (context, state) {
            if (state is SendAmountEntered) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(state.person.imageUrl ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text(state.person.name),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '\$${state.amount}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Pop-up dışına basmayı etkisiz hale getir
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Money Has Been Transferred'),
                            content: Text('\$${state.amount} has been sent to ${state.person.name}.'),
                            actions: <Widget>[
                              Center(
                                child: TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const HomePage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Transfer Now'),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
