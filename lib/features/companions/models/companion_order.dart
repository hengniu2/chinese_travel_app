/// 随行人员信息（一人一条）
class TravelerInfo {
  TravelerInfo({
    this.name = '',
    this.idCard = '',
    this.phone = '',
  });

  String name;
  String idCard;
  String phone;

  TravelerInfo copyWith({String? name, String? idCard, String? phone}) {
    return TravelerInfo(
      name: name ?? this.name,
      idCard: idCard ?? this.idCard,
      phone: phone ?? this.phone,
    );
  }
}

/// Payload for order confirmation (passed from booking to order confirmation).
class CompanionOrderConfirmPayload {
  const CompanionOrderConfirmPayload({
    required this.companionId,
    required this.selectedDate,
    required this.durationIndex,
    required this.durationLabel,
    required this.extraLabels,
    required this.extraSelected,
    required this.extraPrices,
    required this.serviceFee,
    required this.extrasPrice,
    required this.platformFee,
    required this.totalPrice,
    this.notes,
  });

  final String companionId;
  final DateTime? selectedDate;
  final int durationIndex;
  final String durationLabel;
  final List<String> extraLabels;
  final List<bool> extraSelected;
  final List<double> extraPrices;
  final double serviceFee;
  final double extrasPrice;
  final double platformFee;
  final double totalPrice;
  final String? notes;
}
