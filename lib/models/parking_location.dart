class ParkingLocation {
  final String id;
  final String name;
  final String address;
  final String redova;
  final String stupaca;

  ParkingLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.redova,
    required this.stupaca,
  });

  @override
  String toString() {
    return 'ParkingLocation(id: $id, name: $name, address: $address, redova: $redova, stupaca: $stupaca)';
  }
}
