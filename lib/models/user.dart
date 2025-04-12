// class User {
//   Result? result;

//   User({this.result});

//   User.fromJson(Map<String, dynamic> json) {
//     result = json['result'] != null ? Result.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (result != null) {
//       data['result'] = result!.toJson();
//     }
//     return data;
//   }
// }

// class Result {
//   String? id;
//   String? name;
//   String? email;
//   String? phone;
//   String? address;
//   String? password;
//   Null profileImage;
//   Null cloudinaryImageId;
//   List<Roles>? roles;

//   Result(
//       {this.id,
//       this.name,
//       this.email,
//       this.phone,
//       this.address,
//       this.password,
//       this.profileImage,
//       this.cloudinaryImageId,
//       this.roles});

//   Result.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     phone = json['phone'];
//     address = json['address'];
//     password = json['password'];
//     profileImage = json['profileImage'];
//     cloudinaryImageId = json['cloudinaryImageId'];
//     if (json['roles'] != null) {
//       roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(Roles.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['address'] = address;
//     data['password'] = password;
//     data['profileImage'] = profileImage;
//     data['cloudinaryImageId'] = cloudinaryImageId;
//     if (roles != null) {
//       data['roles'] = roles!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Roles {
//   String? name;
//   Null description;
//   List<Permissions>? permissions;

//   Roles({this.name, this.description, this.permissions});

//   Roles.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     description = json['description'];
//     if (json['permissions'] != null) {
//       permissions = <Permissions>[];
//       json['permissions'].forEach((v) {
//         permissions!.add(Permissions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['description'] = description;
//     if (permissions != null) {
//       data['permissions'] = permissions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Permissions {
//   String? name;
//   Null description;

//   Permissions({this.name, this.description});

//   Permissions.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     description = json['description'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['description'] = description;
//     return data;
//   }
// }


class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? password;
  String? profileImage;
  String? cloudinaryImageId;
  List<Roles>? roles;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.password,
      this.profileImage,
      this.cloudinaryImageId,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    password = json['password'];
    profileImage = json['profileImage'];
    cloudinaryImageId = json['cloudinaryImageId'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['password'] = this.password;
    data['profileImage'] = this.profileImage;
    data['cloudinaryImageId'] = this.cloudinaryImageId;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  String? name;
  String? description;
  List<Permissions>? permissions;

  Roles({this.name, this.description, this.permissions});

  Roles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permissions {
  String? name;
  String? description;

  Permissions({this.name, this.description});

  Permissions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}