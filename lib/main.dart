import 'package:admin/bloc/auth/bloc/auth_bloc.dart';
import 'package:admin/bloc/category/bloc/category_bloc.dart';
import 'package:admin/bloc/product/bloc/product_bloc.dart';
import 'package:admin/datasource/auth_datasource.dart';
import 'package:admin/datasource/category_datasource.dart';
import 'package:admin/datasource/product_datasource.dart';
import 'package:admin/dio/dio_client.dart';
import 'package:admin/repository/auth_repository.dart';
import 'package:admin/repository/category_repository.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:admin/screen/home_screen.dart';
import 'package:admin/screen/login/login_screen.dart';
import 'package:admin/screen/signup/signup_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  // Sử dụng DioClient singleton để lấy Dio instance
  final dio = DioClient.instance;
  final authDatasource = AuthenticationRemote(
    dio: dio,
  );
  // Tạo Repository và truyền datasource vào
  final authRepository = AuthenticationRepository(authDatasource);

  runApp(ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider (create: (context) => AuthBloc(authRepository),),
          BlocProvider(create: (context) => CategoryBloc(CategoriesRepository(CategoryRemote(dio: DioClient.instance)))),
         BlocProvider(create: (context) => ProductBloc(ProductsRepository(ProductRemote(dio: DioClient.instance)))),
        ],
        child: StoreManagementApp(authRepository: authRepository));
    },
  ));
}

class StoreManagementApp extends StatelessWidget {
  final IAuthRepository authRepository;
  const StoreManagementApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
