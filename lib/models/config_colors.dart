class ConfigColors {
  final String id;
  final String elementName;
  final String colorVar;
  final String colorName;
  final String colorCode;

  ConfigColors({
    required this.id,
    required this.elementName,
    required this.colorVar,
    required this.colorName,
    required this.colorCode,
  });

  factory ConfigColors.fromJson(Map<String, dynamic> json) {
    return ConfigColors(
      id: json['id'],
      elementName: json['element_name'],
      colorVar: json['color_var'],
      colorName: json['color_name'],
      colorCode: json['color_code'],
    );
  }
}
