class CreateCategoryRequest {
  final String name;
  final String type; // "Need", "Want", or "Saving"

  CreateCategoryRequest({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
      };
}