import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dribble_finance_app_design/models/person.dart';

part 'send_state.dart';

class SendCubit extends Cubit<SendState> {
  SendCubit() : super(SendInitial());

  void selectPerson(Person person) {
    emit(SendPersonSelected(person));
  }

  void enterAmount(double amount) {
    emit(SendAmountEntered(state.person!, amount));
  }

  void reset() {
    emit(SendInitial());
  }
}