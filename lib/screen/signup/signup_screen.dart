import 'package:admin/bloc/auth/bloc/auth_bloc.dart';
import 'package:admin/screen/login/login_screen.dart';
import 'package:admin/util/auth_action.dart';
import 'package:admin/widgets/buildloginorsignup_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false; // Biến kiểm soát hiển thị mật khẩu

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Đặt true để tránh tràn khi bàn phím xuất hiện
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // SingleChildScrollView cho phép cuộn khi bàn phím xuất hiện
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Logo
              Image.network(
                "https://res.cloudinary.com/dnwp3ccn7/image/upload/v1739813369/b3r0xolfjdjilchpnvme.png",
                height: 150,
              ),
              const SizedBox(height: 16),
              // Tiêu đề
              const Text(
                "Women's Secret Beauty",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Đăng ký tài khoản",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              // Ô nhập Họ và Tên
              _buildTextField(
                  icon: Icons.person,
                  controller: _nameController,
                  hintText: "Họ và tên",
                  keyboardType: TextInputType.name),
              const SizedBox(height: 16),
              // Ô nhập Email
              _buildTextField(
                icon: Icons.email,
                hintText: "Địa chỉ email",
                controller: _emailController, // Cần khai báo _emailController
                keyboardType:
                    TextInputType.emailAddress, // Loại bàn phím cho email
              ),
              const SizedBox(height: 16),
              // Ô nhập Số điện thoại
              _buildTextField(
                icon: Icons.phone,
                hintText: "Số điện thoại",
                controller: _phoneController, // Cần khai báo _phoneController
                keyboardType:
                    TextInputType.phone, // Loại bàn phím cho số điện thoại
              ),
              const SizedBox(height: 16),
              // Ô nhập Địa chỉ
              _buildTextField(
                icon: Icons.location_on,
                hintText: "Địa chỉ",
                controller:
                    _addressController, // Cần khai báo _addressController
                keyboardType:
                    TextInputType.streetAddress, // Loại bàn phím cho địa chỉ
              ),
              const SizedBox(height: 16),
              // Ô nhập Password
              _buildPasswordTextField(Icons.lock, "Mật khẩu"),
              const SizedBox(height: 16),

              // Nút đăng nhập
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }
                  return buildLoginButton(
                    text: "Đăng ký",
                    onPressed: _signup,
                  );
                },
                listener: (context, state) {
                  if (state is AuthSignupLoaded) {
                    state.result.fold((errorMessage) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }, (isSuccess) {
                      // Nếu thành công => chuyển LoginScreen
                      if (isSuccess) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    });
                  }
                },
              ),

              const SizedBox(height: 16),
              //đã có tài khoản
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                child: const Text(
                  "Bạn đã có tài khoản? Đăng nhập ngay",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required IconData icon,
      required String hintText,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 17, 196, 23), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField(IconData icon, String hintText) {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: const Color.fromARGB(255, 17, 196, 23), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, String imagePath) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {},
      icon: Image.network(imagePath, height: 24),
      label: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  void _signup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();

    // Kiểm tra điều kiện ràng buộc
    if (name.isEmpty) {
      _showError("Tên không được để trống");
      return;
    }

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(email)) {
      _showError("Email không hợp lệ");
      return;
    }

    if (phone.isEmpty || !RegExp(r"^\d{10}$").hasMatch(phone)) {
      _showError("Số điện thoại không hợp lệ");
      return;
    }

    if (address.isEmpty) {
      _showError("Địa chỉ không được để trống");
      return;
    }

    if (password.isEmpty || password.length < 8) {
      _showError("Mật khẩu phải có ít nhất 8 ký tự");
      return;
    }

    // Gọi hàm signup từ bloc
    AuthAction(
      context,
      {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'password': password,
      },
      false, // false: đăng ký, true: đăng nhập
    );
  }

// Hàm hiển thị lỗi
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
