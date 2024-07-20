import 'package:bloc/bloc.dart';
import 'package:dribble_finance_app_design/cubit/app_cubit_states.dart';

class AppCubits extends Cubit{
  AppCubits(): super(InitialState()){
    emit(WelcomeState());
  }
}