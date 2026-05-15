class InstructionModel {
  final String text;
  final String streetName;
  final double distance;
  final int time;
  final int sign;
  final List<int> interval;

  InstructionModel({
    required this.text,
    required this.streetName,
    required this.distance,
    required this.time,
    required this.sign,
    required this.interval,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      text: json['text'],
      streetName: json['street_name'],
      distance: (json['distance'] as num).toDouble(),
      time: (json['time'] as num).toInt(),
      sign: (json['sign'] as num).toInt(),
      interval: (json['interval'] as List).cast<int>(),
    );
  }
}
