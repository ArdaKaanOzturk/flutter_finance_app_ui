import 'package:dribble_finance_app_design/pages/home/cubit/home_cubit.dart';
import 'package:dribble_finance_app_design/pages/transfer_money/cubit/send_cubit.dart';
import 'package:dribble_finance_app_design/pages/home/home.dart';
import 'package:dribble_finance_app_design/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SendCubit>(
          create: (context) => SendCubit(PersonService()),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(PersonService()),
        ),
      ],
      child: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
