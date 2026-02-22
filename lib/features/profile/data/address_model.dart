/// Shipping address (收货地址).
class AddressModel {
  const AddressModel({
    required this.id,
    required this.receiver,
    required this.phone,
    required this.region,
    required this.detail,
    this.isDefault = false,
  });

  final String id;
  final String receiver;
  final String phone;
  final String region;
  final String detail;
  final bool isDefault;

  String get fullAddress => '$region $detail';
}
