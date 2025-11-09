/// Job Status Enum
enum JobStatus {
  pending,
  accepted,
  completed,
  cancelled;

  /// Convert string to JobStatus
  static JobStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return JobStatus.pending;
      case 'ACCEPTED':
        return JobStatus.accepted;
      case 'COMPLETED':
        return JobStatus.completed;
      case 'CANCELLED':
        return JobStatus.cancelled;
      default:
        return JobStatus.pending;
    }
  }

  /// Convert JobStatus to API string
  String toApiString() {
    return toString().split('.').last.toUpperCase();
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case JobStatus.pending:
        return 'Pendiente';
      case JobStatus.accepted:
        return 'Aceptado';
      case JobStatus.completed:
        return 'Completado';
      case JobStatus.cancelled:
        return 'Cancelado';
    }
  }
}

/// Job Model
/// Represents a job posted by a client and assigned to a contractor
class Job {
  final String id;
  final String description;
  final JobStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String clientId;
  final String contractorId;
  final String serviceId;

  Job({
    required this.id,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.clientId,
    required this.contractorId,
    required this.serviceId,
  });

  /// Create Job from JSON response
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      description: json['description'] as String,
      status: JobStatus.fromString(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      clientId: json['clientId'] as String,
      contractorId: json['contractorId'] as String,
      serviceId: json['serviceId'] as String,
    );
  }

  /// Convert Job to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status.toApiString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'clientId': clientId,
      'contractorId': contractorId,
      'serviceId': serviceId,
    };
  }

  /// Check if job is pending
  bool get isPending => status == JobStatus.pending;

  /// Check if job is accepted
  bool get isAccepted => status == JobStatus.accepted;

  /// Check if job is completed
  bool get isCompleted => status == JobStatus.completed;

  /// Check if job is cancelled
  bool get isCancelled => status == JobStatus.cancelled;

  /// Create a copy with updated fields
  Job copyWith({
    String? id,
    String? description,
    JobStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? clientId,
    String? contractorId,
    String? serviceId,
  }) {
    return Job(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clientId: clientId ?? this.clientId,
      contractorId: contractorId ?? this.contractorId,
      serviceId: serviceId ?? this.serviceId,
    );
  }
}

/// Job Create Request Model
class CreateJobRequest {
  final String serviceId;
  final String description;

  CreateJobRequest({
    required this.serviceId,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'description': description,
    };
  }
}
