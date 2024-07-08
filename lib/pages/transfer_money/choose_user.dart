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
  bool isLoading = true;
  List<Person>? persons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SendCubit>().FetchUsers();
  }


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
          if (state is UserFetchLoading) {
            setState(() {
              isLoading = true;
            });
          }

          if(state is UserFetchFailed){
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }

          if(state is UserFetchSuccess){
            setState(() {
              persons = state.users;
              isLoading = false;
              print(persons);
            });
          }

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
          child: SingleChildScrollView(
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
                
                  isLoading ? Center( child: CircularProgressIndicator(),) : ListView.builder(

                        itemCount: persons?.length,
                        shrinkWrap: false,
                        itemBuilder: (context, index) {                            
                          return GestureDetector(
                            onTap: () => _handlePersonSelection(context, persons?[index]?? Person(name: '', amount: 0)),
                            child: Container(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(persons?[index].imageUrl ?? 'https://via.placeholder.com/150'),
                                  radius: 28,
                                ),
                                title: Text(persons? [index].name ?? ''),
                                selectedTileColor: AppColors.accent,
                              ),
                            ),
                          );
                        },
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
      ),
    );
  }
}
