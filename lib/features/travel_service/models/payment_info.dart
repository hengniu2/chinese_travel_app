/// Payment method and status.
enum PaymentMethod {
  creditCard('信用卡'),
  alipay('支付宝'),
  wechatPay('微信支付');

  const PaymentMethod(this.label);
  final String label;
}

enum PaymentStatus {
  pending,
  processing,
  success,
  failed,
}
