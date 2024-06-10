part of 'send_cubit.dart';

abstract class SendState extends Equatable {
  const SendState();
  
  @override
  List<Object?> get props => [];

  get person => null;
}

class SendInitial extends SendState {}

class SendPersonSelected extends SendState {
  final Person person;

  const SendPersonSelected(this.person);

  @override
  List<Object> get props => [person];
}

class SendAmountEntered extends SendState {
  final Person person;
  final double amount;

  const SendAmountEntered(this.person, this.amount);

  @override
  List<Object> get props => [person, amount];
}
