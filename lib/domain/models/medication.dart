class Medication {
  final String id;
  final String name;
  final String dosage;
  final String type;
  final List<String> schedule;
  final String notes;
  final String icon;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.schedule,
    required this.notes,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'type': type,
      'schedule': schedule,
      'notes': notes,
      'icon': icon,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      type: map['type'] ?? '',
      schedule: List<String>.from(map['schedule'] ?? []),
      notes: map['notes'] ?? '',
      icon: map['icon'] ?? '💊',
    );
  }
}