import 'package:admin/models/user.dart';
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
    on<AuthLoginRequest>(_onloginRequested);
    on<AuthSignupRequest>(_onSignupRequested);
    on<GetAllCustomer>(_onGetAllCustomer);
    on<GetCustomerById>(_onGetCustomerById);
  }
  Future<void> _onloginRequested(
      AuthLoginRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Đang tải
    try {
      final result = await _authRepository.login(event.email, event.password);
      emit(AuthLoaded(result: result)); // Đăng nhập thành công
    } catch (e) {
      print(e);
      emit(AuthFailure(
          error:
              'Đăng nhập thất bại, vui lòng kiểm tra lại thông tin')); // Đăng nhập thất bại
    }
  }

  Future<void> _onSignupRequested(
      AuthSignupRequest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authRepository.signup(
        event.name, event.email, event.phone, event.address, event.password);
    emit(AuthSignupLoaded(result: result));
  }

  Future<void> _onGetAllCustomer(
      GetAllCustomer event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.getALLcustomer();
      emit(GetCustomerLoaded(user: result));
    } catch (e) {
      emit(GetCustomerFailure(
          error: 'Lấy thông tin thất bại, vui lòng kiểm tra lại thông tin $e'));
    }
  }

  Future<void> _onGetCustomerById(
      GetCustomerById event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.getCustomerById(event.id);
      emit(GetCustomerByIDSuccess(user: result));
    } catch (e) {
      emit(GetCustomerFailure(
          error: 'Lấy thông tin thất bại, vui lòng kiểm tra lại thông tin $e'));
    }
  }
}
