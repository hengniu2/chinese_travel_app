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
