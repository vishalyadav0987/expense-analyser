class GetCategoriesResponse {
  final bool success;
  final String message;
  final List<CategoryModel> data;

  GetCategoriesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetCategoriesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String type;
  final String? userId; // Optional for local mapping

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.userId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
      type: json['Type'] ?? '',
      userId: json['UserID'], // In case backend sends it
    );
  }

  // To easily save in SQLite
  Map<String, dynamic> toMap(String uid) {
    return {'id': id, 'user_id': uid, 'name': name, 'type': type};
  }
}
