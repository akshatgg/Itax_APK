// ignore_for_file: public_member_api_docs, sort_constructors_first
class BusinessDetails {
  final String gst;
  final String pan;
  final String status;
  final String businessName;
  final String tradeName;
  final String tan;

  BusinessDetails({
    required this.gst,
    required this.pan,
    required this.status,
    required this.businessName,
    required this.tradeName,
    required this.tan,
  });

  BusinessDetails.empty()
      : gst = '',
        pan = '',
        status = '',
        businessName = '',
        tradeName = '',
        tan = '';

  BusinessDetails copyWith({
    String? gst,
    String? pan,
    String? status,
    String? businessName,
    String? tradeName,
    String? tan,
  }) {
    return BusinessDetails(
      gst: gst ?? this.gst,
      pan: pan ?? this.pan,
      status: status ?? this.status,
      businessName: businessName ?? this.businessName,
      tradeName: tradeName ?? this.tradeName,
      tan: tan ?? this.tan,
    );
  }

  @override
  String toString() {
    return 'BusinessDetails(gst: $gst, pan: $pan, status: $status, businessName: $businessName, tradeName: $tradeName, tan: $tan)';
  }
}
