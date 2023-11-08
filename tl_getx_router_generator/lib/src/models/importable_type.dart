class ImportableType {
  final String? import;
  final String? name;
  final String className;
  final bool isRequired;
  final bool isNullable;
  final bool isOptional;
  final bool isPositional;
  final List<ImportableType> typeArguments;

  //function Type时可用
  final ImportableType? returnType;

  String get argumentName => name ?? className;

  const ImportableType(
      {required this.className,
      this.name,
      this.isOptional = false,
      this.import,
      this.isRequired = false,
      this.isNullable = false,
        this.isPositional=false,
      this.typeArguments = const [],
      this.returnType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'import': import,
      'className': className,
      'name': name,
      'isOptional': isOptional,
      'isPositional': isPositional,
      'isRequired': isRequired,
      'isNullable': isNullable,
      'returnType': returnType?.toMap(),
      'typeArguments': typeArguments.map((x) => x.toMap()).toList(),
    };
  }

  factory ImportableType.fromMap(Map<String, dynamic> map) {
    return ImportableType(
      import: map['import'] as String?,
      className: map['className'] as String? ?? '',
      name: map['name'] as String?,
      isRequired: map['isRequired'] == true,
      isOptional: map['isOptional'] == true,
      isPositional: map['isPositional'] == true,
      isNullable: map['isNullable'] == true,
      returnType: map['returnType'] != null
          ? ImportableType.fromMap(map['returnType'] as Map<String, dynamic>)
          : null,
      typeArguments: List<ImportableType>.from(map['typeArguments']?.map(
              (dynamic x) => ImportableType.fromMap(x as Map<String, dynamic>))
          as Iterable),
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (other is ImportableType) {
      return other.className == className &&
          other.import == import &&
          returnType == other.returnType;
    }
    return false;
  }
}
