import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/pages/transfer_money/cubit/send_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dribble_finance_app_design/pages/home/home.dart';

class SummaryPage extends StatefulWidget {
  final String amount;
  final Person person;

  const SummaryPage({super.key, required this.amount, required this.person});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool isLoading = false;
  Person? person;

  @override
  void initState() {
    super.initState();
    context.read<SendCubit>().enterAmount(double.parse(widget.amount), widget.person);
  }

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
        child: BlocListener<SendCubit, SendState>(
          listener: (context, state) {
            if (state is AmountLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is SendAmountEntered) {
              setState(() {
                person = state.person;
                isLoading = false;
              });
            }
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(person?.imageUrl ?? 'https://via.placeholder.com/150'),
                      ),
                      title: Text(person?.name ?? "Not found"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '\$${widget.amount}',
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
                              content: Text('\$${widget.amount} has been sent to ${person?.name}.'),
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
                ),
        ),
      ),
    );
  }
}
