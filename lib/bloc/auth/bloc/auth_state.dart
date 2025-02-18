part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final Either<String, String>
      result; // Left: lỗi, Right: token (hoặc thông báo thành công)

  const AuthLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// State cho kết quả signup
class AuthSignupLoaded extends AuthState {
  final Either<String, bool> result; // Left: lỗi, Right: true (thành công)
  const AuthSignupLoaded({required this.result});

  @override
  List<Object> get props => [result];
}
