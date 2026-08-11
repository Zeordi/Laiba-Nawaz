Submit Task Feature (Client Architecture)

Layers
- Domain: Entities, Repository interface, UseCases (`SubmitAudioUseCase`, `SubmitTextUseCase`).
- Data: RemoteDataSource (API integration stub) and RepositoryImpl mapping to domain.
- Presentation: BLoC (`SubmitTaskBloc`) with Events/State + UI (`SubmitTaskScreen`).

Flow
- Mic navigation (center item) pushes `RouteNames.submitTaskScreen`.
- Screen provides `SubmitTaskBloc` and starts a simple recording timer.
- Bottom actions dispatch events: Pause/Stop; integrate real recorder later.
- UseCases call repository -> remote datasource stubs; replace with real API.

Files
- domain/entity/submit_task_entity.dart
- domain/repository/submit_task_repository.dart
- domain/usecase/submit_audio_usecase.dart
- domain/usecase/submit_text_usecase.dart
- data/datasource/submit_task_remote_datasource.dart
- data/repository/submit_task_repository_impl.dart
- presentation/state/submit_task_{bloc,event,state}.dart
- presentation/ui/screen/submit_task_screen.dart
