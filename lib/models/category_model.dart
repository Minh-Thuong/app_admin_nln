
// import 'package:flutter/src/widgets/icon_data.dart';

// class Category {
//   Result? result;

//   Category({this.result});

//   Category.fromJson(Map<String, dynamic> json) {
//     result =
//         json['result'] != null ? new Result.fromJson(json['result']) : null;
//   }

//   IconData? get icon => null;

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.result != null) {
//       data['result'] = this.result!.toJson();
//     }
//     return data;
//   }
// }

// class Result {
//   String? id;
//   String? name;
//   String? profileImage;
//   String? cloudinaryImageId;

//   Result({this.id, this.name, this.profileImage, this.cloudinaryImageId});

//   Result.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     profileImage = json['profileImage'];
//     cloudinaryImageId = json['cloudinaryImageId'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['profileImage'] = this.profileImage;
//     data['cloudinaryImageId'] = this.cloudinaryImageId;
//     return data;
//   }
// }
class Category {
  final String id;
  final String name;
  final String? profileImage;
  final String? cloudinaryImageId;

  Category({
    required this.id,
    required this.name,
    this.profileImage,
    this.cloudinaryImageId,
  });

  // Hàm khởi tạo từ JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      cloudinaryImageId: json['cloudinaryImageId'],
    );
  }
}

