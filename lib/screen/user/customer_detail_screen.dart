import 'package:admin/bloc/auth/bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String id;
  const CustomerDetailScreen({super.key, required this.id});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(GetCustomerById(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetCustomerByIDFailure) {
          print(" Tải khách hàng thất bại${state.error}");
          return Scaffold(
            appBar: AppBar(title: const Text('Thông tin tài khoản')),
            body: Center(
              child: Text("Không thể tải thống tin khách hàng"),
            ),
          );
        }

        if (state is GetCustomerByIDSuccess) {
          final user = state.user;
          String optimizedUrl = "${user.profileImage}?w=150&h=150&c=fill";
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                context.read<AuthBloc>().add(GetAllCustomer());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                elevation: 0,
                title: const Text('Thông tin tài khoản'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Hình đại diện
                    CircleAvatar(
                      radius: 50,
                      child: CachedNetworkImage(
                        imageUrl: optimizedUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Image.asset(
                          'assets/placeholder.jpg',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 70,
                          color: Color.fromARGB(255, 207, 204, 204),
                        ),
                        fadeInDuration: const Duration(milliseconds: 200),
                        fadeOutDuration: const Duration(milliseconds: 200),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tên và SĐT
                    Text(
                      user.name ?? "Trống",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ListTile(
                      title: Text("Số điện thoại:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.phone ?? "Trống",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    ListTile(
                      title: Text(user.email ?? "Trống",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${user.email}",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    ListTile(
                      title: Text("Địa chỉ:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user.address ?? "Trống",
                          maxLines: 3,
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    const SizedBox(height: 20),

                    // Nút Cập nhật và Xóa tài khoản
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 80.0, right: 80.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.green))),
                          child: const Text("Liên hệ",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
