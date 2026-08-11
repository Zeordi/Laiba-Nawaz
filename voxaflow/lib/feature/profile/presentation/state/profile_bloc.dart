import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voxflow/feature/profile/domain/use_case/profile_use_case.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_event.dart';
import 'package:voxflow/feature/profile/presentation/state/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase useCase;

  ProfileBloc({required this.useCase}) : super(ProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await useCase.getProfile();
      result.fold(
        (left) => emit(ProfileError(message: left.message)),
        (right) => emit(ProfileLoaded(profile: right)),
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await useCase.updateProfile(event.name, event.phoneNumber, event.department);
      result.fold(
        (left) => emit(ProfileError(message: left.message)),
        (right) => emit(ProfileUpdateSuccess(message: "Profile Updated Successfully", profile: right)),
      );
    });

    on<LogOutProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      final result = await useCase.logOut();
      result.fold(
        (left) => emit(ProfileError(message: left.message)),
        (right) => emit(ProfileLoggedOut()),
      );
    });
  }
}
