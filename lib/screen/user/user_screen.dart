import 'package:admin/bloc/auth/bloc/auth_bloc.dart';
import 'package:admin/screen/user/customer_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(GetAllCustomer());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
              body: const Center(child: CircularProgressIndicator()));
        }
        if (state is GetCustomerFailure) {
          print("Tải khách hàng thất bại${state.error}");
          return Scaffold(
              appBar: AppBar(
                title: Text("Danh sách khách hàng"),
                centerTitle: true,
              ),
              body: Center(child: Text("Không thể tải danh sách khách hàng")));
        }

        if (state is GetCustomerLoaded) {
          final customers = state.user;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text("Danh sách khách hàng"),
              centerTitle: true,
            ),
            body: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final custommer = customers[index];
                  final String imageUrl =
                      "${custommer.profileImage}?w=150&h=150&c=fill";
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CustomerDetailScreen(id: custommer.id!);
                          },
                        ));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.green),
                      ),
                      title: Text(
                        custommer.name ?? "Unknown",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        custommer.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        "Xem chi tiết",
                        style: TextStyle(color: Colors.blue),
                      ),
                      leading: custommer.profileImage != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              height: 50.h,
                              width: 50.w,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported,
                              size: 50,
                            ),
                    ),
                  );
                }),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
