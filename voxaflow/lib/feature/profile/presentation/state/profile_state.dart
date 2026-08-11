import 'package:voxflow/feature/profile/domain/entity/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

class ProfileLoggedOut extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  final ProfileEntity profile;
  ProfileUpdateSuccess({required this.message, required this.profile});
}
