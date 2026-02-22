enum PrizeStatus { pending, received }

class PrizeModel {
  const PrizeModel({
    required this.id,
    required this.title,
    required this.pointsOrDesc,
    required this.status,
    required this.date,
  });

  final String id;
  final String title;
  final String pointsOrDesc;
  final PrizeStatus status;
  final String date;
}
