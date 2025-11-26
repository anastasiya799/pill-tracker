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
}