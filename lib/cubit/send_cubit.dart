// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:equatable/equatable.dart';

part 'send_state.dart';

class SendCubit extends Cubit<SendState> {
  SendCubit() : super(SendInitial());

  void selectPerson(Person person) {
    emit(SendPersonSelected(person));
  }

  void unselectPerson() {
    emit(SendPersonUnselected());
  }

  void enterAmount(double amount, Person person) {
    emit(AmountLoading());
    // Simulate a delay to show loading state
    Future.delayed(const Duration(seconds: 1), () {
      emit(SendAmountEntered(person, amount));
    });
  }
}
