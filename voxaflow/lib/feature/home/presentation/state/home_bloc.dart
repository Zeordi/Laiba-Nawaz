import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/feature/home/domain/usecase/get_home_data_usecase.dart';
import 'package:voxflow/feature/home/presentation/state/home_event.dart';
import 'package:voxflow/feature/home/presentation/state/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({
    required this.getHomeDataUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    final homeResult = await getHomeDataUseCase.call();
    
    homeResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (homeData) => emit(HomeLoaded(homeData: homeData)),
    );
  }
}
