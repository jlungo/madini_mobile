import 'package:go_router/go_router.dart';
import 'core/config/router_config.dart';
import 'package:provider/provider.dart';

import 'package:provider/single_child_widget.dart';

import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'services/storage_service.dart';
import 'state/theme_provider.dart';

List<SingleChildWidget> getProviders() {
  final apiClient = ApiClient(config: kDefaultAppConfig);
  final storageService = StorageService.instance;

  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    apiClient: apiClient,
    config: kDefaultAppConfig,
  );

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    storageService: storageService,
  );

  final authProvider = AuthProvider(authRepository: authRepository);

  return [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    Provider<ApiClient>.value(value: apiClient),
    Provider<AuthRepository>.value(value: authRepository),
    ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
    Provider<GoRouter>.value(value: appRouter(authProvider)),
  ];
}
