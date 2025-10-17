class UserModel {
  final String id;
  final String username;
  final String name;
  final String email;
  final String avatar;
  final String? roleId;
  final String employeeId;
  final String position;
  final String division;
  final String role;
  final String status;
  final String note;
  final bool isDeleted;
  final bool isBlocked;
  final bool needsPasswordChange;
  final bool isEmailVerified;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.avatar,
    this.roleId,
    required this.employeeId,
    required this.position,
    required this.division,
    required this.role,
    required this.status,
    required this.note,
    required this.isDeleted,
    required this.isBlocked,
    required this.needsPasswordChange,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle roleId: can be a string or an object with _id field
    String? roleIdValue;
    final roleIdRaw = json['roleId'];
    if (roleIdRaw is Map<String, dynamic>) {
      roleIdValue = roleIdRaw['_id'] as String?;
    } else if (roleIdRaw is String) {
      roleIdValue = roleIdRaw;
    }

    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      roleId: roleIdValue,
      employeeId: json['employeeId'] ?? '',
      position: json['position'] ?? '',
      division: json['division'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      note: json['note'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      needsPasswordChange: json['needsPasswordChange'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'name': name,
      'email': email,
      'avatar': avatar,
      'roleId': roleId,
      'employeeId': employeeId,
      'position': position,
      'division': division,
      'role': role,
      'status': status,
      'note': note,
      'isDeleted': isDeleted,
      'isBlocked': isBlocked,
      'needsPasswordChange': needsPasswordChange,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? avatar,
    String? roleId,
    String? employeeId,
    String? position,
    String? division,
    String? role,
    String? status,
    String? note,
    bool? isDeleted,
    bool? isBlocked,
    bool? needsPasswordChange,
    bool? isEmailVerified,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      roleId: roleId ?? this.roleId,
      employeeId: employeeId ?? this.employeeId,
      position: position ?? this.position,
      division: division ?? this.division,
      role: role ?? this.role,
      status: status ?? this.status,
      note: note ?? this.note,
      isDeleted: isDeleted ?? this.isDeleted,
      isBlocked: isBlocked ?? this.isBlocked,
      needsPasswordChange: needsPasswordChange ?? this.needsPasswordChange,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
