part of 'send_cubit.dart';

abstract class SendState extends Equatable {
  const SendState();

  @override
  List<Object?> get props => [];
}

class SendInitial extends SendState {}

class SendPersonSelected extends SendState {
  final Person person;

  const SendPersonSelected(this.person);

  @override
  List<Object> get props => [person];
}

class SendPersonUnselected extends SendState {}

class SendAmountEntered extends SendState {
  final Person person;
  final double amount;

  const SendAmountEntered(this.person, this.amount);

  @override
  List<Object> get props => [person, amount];
}

class AmountLoading extends SendState {}

class UserFetchSuccess extends SendState {
  final List<Person> users;

  const UserFetchSuccess({required this.users});
}

class UserFetchFailed extends SendState {
  final String errorMessage;

 const UserFetchFailed({required this.errorMessage});
}

class UserFetchLoading extends SendState {
  const UserFetchLoading();
}



