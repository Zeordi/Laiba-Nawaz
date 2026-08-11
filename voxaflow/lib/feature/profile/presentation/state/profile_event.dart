abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String phoneNumber;
  final String department;
  
  UpdateProfileEvent({
    required this.name,
    required this.phoneNumber,
    required this.department,
  });
}

class LogOutProfileEvent extends ProfileEvent {}
