import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dribble_finance_app_design/models/person.dart';
import 'package:dribble_finance_app_design/service/service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PersonService personService;
  HomeCubit(this.personService) : super(HomeInitial());

  Future<void> fetchUsers() async {
    emit(HomeLoading());
    try {
      final users = await personService.fetchPersons();
      emit(HomeLoaded(users: users));
    } catch (e) {
      emit(HomeError(errorMessage: 'Bir hata meydana geldi.'));
    }
  }
}
