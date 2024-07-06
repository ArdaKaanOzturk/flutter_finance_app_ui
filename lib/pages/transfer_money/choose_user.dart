import 'package:dribble_finance_app_design/pages/transfer_money/enter_amount.dart';
import 'package:dribble_finance_app_design/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dribble_finance_app_design/theme/colors.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/cubit/send_cubit.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  Person? selectedPerson;

  void _handlePersonSelection(BuildContext context, Person person) {
    if (selectedPerson == person) {
      context.read<SendCubit>().unselectPerson();
    } else {
      context.read<SendCubit>().selectPerson(person);
    }
  }

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
      body: BlocListener<SendCubit, SendState>(
        listener: (context, state) {
          if (state is SendPersonSelected) {
            setState(() {
              selectedPerson = state.person;
            });
          } else if (state is SendPersonUnselected) {
            setState(() {
              selectedPerson = null;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search receiver',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Person>>(
                  future: PersonService().fetchPersons(),
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(person.imageUrl ?? 'https://via.placeholder.com/150'),
                                radius: 40,
                              ),
                              title: Text(person.name),
                              selected: selectedPerson == person,
                              selectedTileColor: AppColors.accent,
                              onTap: () {
                                _handlePersonSelection(context, person);
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: selectedPerson != null
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<SendCubit>(),
                              child: EnterAmountPage(person: selectedPerson!),
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
