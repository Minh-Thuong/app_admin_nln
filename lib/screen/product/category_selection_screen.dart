import 'package:admin/models/category_model.dart';
import 'package:flutter/material.dart';


/// 3. Màn hình chọn danh mục (Hình 2)
class CategorySelectionScreen extends StatefulWidget {
  final List<Category> initiallySelected;
  const CategorySelectionScreen({super.key, required this.initiallySelected});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  // Danh sách tất cả danh mục có thể chọn
  // Tuỳ bạn thêm bớt
  final List<Category> _allCategories = [
    Category(name: "Cơm", icon: Icons.rice_bowl),
    Category(name: "Phở", icon: Icons.restaurant_menu),
    Category(name: "Mì", icon: Icons.ramen_dining),
    Category(name: "Bún", icon: Icons.ramen_dining),
    Category(name: "Cháo", icon: Icons.ramen_dining),
  ];

  // danh sách danh mục user chọn
  late List<Category> _selected;

  @override
  void initState() {
    super.initState();
    // Ban đầu, _selected = danh mục đã chọn từ màn hình trước
    _selected = List.from(widget.initiallySelected);
  }

  bool _isSelected(Category cat) => _selected.any((c) => c.name == cat.name);


  void _toggleCategory(Category cat) {
    setState(() {
      if (_isSelected(cat)) {
        // Bỏ chọn
        _selected.removeWhere((c) => c.name == cat.name);
      } else {
        // Thêm chọn
        _selected.add(cat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh mục"),
        actions: [
          IconButton(
            onPressed: () {
              // Đống màn hình
              Navigator.pop<List<Category>>(context, _selected);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Column(
        children: [
          // Text field tìm tên danh mục
          TextField(
            decoration: InputDecoration(
              hintText: "Tìm tên danh mục",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Danh sách danh mục
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: _allCategories.length,
              itemBuilder: (context, index) {
                final cat = _allCategories[index];
                final selected = _isSelected(cat);
                return InkWell(
                  onTap: () {
                    _toggleCategory(cat);
                  },
                  child: Column(children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selected ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        cat.icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(cat.name),
                    // hiển thị check mark nếu đã chọn
                    if (selected)
                      const Icon(Icons.check_circle,
                          size: 16, color: Colors.green),
                  ]),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                      context, _selected); // Quay lại mà không thay đổi
                },
                child: const Text("Quay lại"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Trả danh sách _selected về màn hình trước
                  Navigator.pop<List<Category>>(context, _selected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Cập nhật"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
