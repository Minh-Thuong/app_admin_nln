import 'package:admin/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthLoginRequest>((event, emit) async {
      emit(AuthLoading()); // Đang tải
try {
        final result = await _authRepository.login(event.email, event.password);
        emit(AuthLoaded(result: result)); // Đăng nhập thành công
      } catch (e) {
        emit(AuthFailure(error: 'Đăng nhập thất bại, vui lòng kiểm tra lại thông tin')); // Đăng nhập thất bại
      }
    });

    on<AuthSignupRequest>((event, emit) async {
      emit(AuthLoading());
      final result = await _authRepository.signup(
          event.name, event.email, event.phone, event.address, event.password);
      emit(AuthSignupLoaded(result: result));
    });
  }
}
