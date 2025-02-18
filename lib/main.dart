import 'package:admin/bloc/auth/bloc/auth_bloc.dart';
import 'package:admin/datasource/auth_datasource.dart';
import 'package:admin/repository/auth_repository.dart';
import 'package:admin/screen/home_screen.dart';
import 'package:admin/screen/login/login_screen.dart';
import 'package:admin/screen/signup/signup_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  // Tạo instance của AuthenticationRemote, với Dio có baseUrl phù hợp
  final authDatasource = AuthenticationRemote(
    dio: Dio(BaseOptions(baseUrl: 'http://10.2.0.162:8080')),
  );
  // Tạo Repository và truyền datasource vào
  final authRepository = AuthenticationRepository(authDatasource);

  runApp(ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, child) {
      return StoreManagementApp(authRepository: authRepository);
    },
  ));
}

class StoreManagementApp extends StatelessWidget {
  final IAuthRepository authRepository;
  const StoreManagementApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authRepository),
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
