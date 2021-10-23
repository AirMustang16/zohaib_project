// ignore_for_file: non_constant_identifier_names

class CameraData {
  final String address;
  final int created_time;
  final String item;
  final String message;
  final String post_id;
  double latitude;
  double longitude;
  String type;
  String province;
  String city;

  CameraData(
      this.address,
      this.created_time,
      this.item,
      this.message,
      this.post_id,
      this.latitude,
      this.longitude,
      this.type,
      this.city,
      this.province);
}
