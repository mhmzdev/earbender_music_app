/*

  Dependency Injection is used in order to utilize classes 
  that depend on other classes, without having to actually pass 
  the depending class(s) as part of the parameter of the dependent class

  Given A, B, and C

  A is dependent on B and C and takes them as paramaeters as A(B b, C c)

  Now instead of initialing A with B and C every time it is required in the code 
  as well as B and C itself not being concrete and instead abstracted inorder to 
  omit implementation. 

  Dependency Injection helps in this by defining all such dependenies. The flutter 
  engine then does the task of providing the correct dependency to the correct
  dependent whenever referenced through the injection instance 

  final sl = GetIt.instance;

  where sl is the reference to the injector and whatever has been registered through 
  the injecter can be referenced using 

  sl<A>()

  This takes care of the job of initialzing A with B and C, given both B and C have
  also been registered through the injector.

*/

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
