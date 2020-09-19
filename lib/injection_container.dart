import 'features/main/data/datasources/main_local_data_source.dart';
import 'features/main/data/repositories/main_repository_impl.dart';
import 'features/main/domain/repositories/main_repository.dart';
import 'features/main/domain/usecases/check_if_music_is_saved.dart';
import 'features/main/domain/usecases/get_all_saved_music_paths.dart';
import 'features/main/domain/usecases/update_or_remove_music_path.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/main/presentation/bloc/main_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Main
  // Bloc
  sl.registerFactory(
      () => MainBloc(isSaved: sl(), allSaved: sl(), updateOrRemove: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CheckIfMusicIsSaved(sl()));
  sl.registerLazySingleton(() => GetAllSavedMusicPaths(sl()));
  sl.registerLazySingleton(() => UpdateOrRemoveMusicPath(sl()));

  // Repository
  sl.registerLazySingleton<MainRepository>(
      () => MainRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<MainLocalDataSource>(
      () => MainLocalDataSourceImpl(sharedPreferences: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
