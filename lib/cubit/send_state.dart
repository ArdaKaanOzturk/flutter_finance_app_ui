
part of 'send_cubit.dart';
abstract class SendState extends Equatable {
  const SendState();
  
  @override
  List<Object?> get props => [];

  Person? get person => null;
}

class SendInitial extends SendState {}

class SendPersonSelected extends SendState {
  @override
  final Person person;

  const SendPersonSelected(this.person);

  @override
  List<Object> get props => [person];
}

class SendPersonUnselected extends SendState {}

class SendAmountEntered extends SendState {
  @override
  final Person person;
  final double amount;

  const SendAmountEntered(this.person, this.amount);

  @override
  List<Object> get props => [person, amount];
}

class AmountLoading extends SendState {
  @override
  List<Object> get props => [];
}
