/// Flight result filter/sort options.
enum FlightFilterType {
  price('价格'),
  departureTime('起飞时间'),
  airline('航空公司');

  const FlightFilterType(this.label);
  final String label;
}
