/// Service Model
/// Represents a service offered by a contractor
class Service {
  final String id;
  final String name;
  final String description;
  final double rate;
  final String contractorId;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.rate,
    required this.contractorId,
  });

  /// Create Service from JSON response
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Sin nombre',
      description: json['description']?.toString() ?? 'Sin descripción',
      rate: (json['rate'] is num)
          ? (json['rate'] as num).toDouble()
          : double.tryParse(json['rate']?.toString() ?? '0') ?? 0.0,
      contractorId: json['contractorId']?.toString() ?? '',
    );
  }

  /// Convert Service to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rate': rate,
      'contractorId': contractorId,
    };
  }

  /// Create a copy with updated fields
  Service copyWith({
    String? id,
    String? name,
    String? description,
    double? rate,
    String? contractorId,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      contractorId: contractorId ?? this.contractorId,
    );
  }
}

/// Service Input Model (for creating/updating services)
class ServiceInput {
  String name;
  String description;
  double rate;

  ServiceInput({
    required this.name,
    required this.description,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'rate': rate,
    };
  }
}

