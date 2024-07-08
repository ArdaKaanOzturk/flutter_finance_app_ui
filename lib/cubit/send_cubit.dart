import 'package:bloc/bloc.dart';
import 'package:dribble_finance_app_design/service/service.dart';
import 'package:equatable/equatable.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:flutter/material.dart';

part 'send_state.dart';

class SendCubit extends Cubit<SendState> {
  final PersonService personService;
  SendCubit(this.personService) : super(SendInitial());

  void selectPerson(Person person) {
    emit(SendPersonSelected(person));
  }

  void unselectPerson() {
    emit(SendPersonUnselected());
  }

  void enterAmount(double amount, Person person) {
    emit(AmountLoading());
    Future.delayed(const Duration(seconds: 1), () {
      emit(SendAmountEntered(person, amount));
    });
  }

  Future<void> FetchUsers() async{
    emit(const UserFetchLoading());
    try {
      final users = await personService.fetchPersons();
      emit(UserFetchSuccess(users: users));
    } catch (e) {
     emit(const UserFetchFailed(errorMessage: 'Bir hata meydana geldi.'));
    }
  }

}
