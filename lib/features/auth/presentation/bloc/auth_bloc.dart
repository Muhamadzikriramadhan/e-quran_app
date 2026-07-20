import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    GetCurrentUserUseCase? getCurrentUserUseCase,
    LoginWithGoogleUseCase? loginWithGoogleUseCase,
    LogoutUseCase? logoutUseCase,
  })  : _getCurrentUserUseCase = getCurrentUserUseCase ??
            GetCurrentUserUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  supabaseClient: Supabase.instance.client,
                ),
              ),
            ),
        _loginWithGoogleUseCase = loginWithGoogleUseCase ??
            LoginWithGoogleUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  supabaseClient: Supabase.instance.client,
                ),
              ),
            ),
        _logoutUseCase = logoutUseCase ??
            LogoutUseCase(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(
                  supabaseClient: Supabase.instance.client,
                ),
              ),
            ),
        super(AuthInitial()) {
        
    on<CheckAuthEvent>((event, emit) {
      final user = _getCurrentUserUseCase();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _loginWithGoogleUseCase();
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _logoutUseCase();
      } catch (e) {
        debugPrint('AuthBloc Logout Warning: $e');
      }
      emit(Unauthenticated());
    });
  }
}
