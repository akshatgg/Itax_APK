import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../utils/unit_list_parser.dart';

part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeConstants.userModel)
class UserModel {
  static final Uint8List defaultImage = Uint8List(0);
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String phone;
  @HiveField(5)
  final String password;
  @HiveField(6)
  final String gender;
  @HiveField(7)
  final String aadhaar;
  @HiveField(8)
  final String pan;
  @HiveField(9)
  final String pin;
  @HiveField(10)
  final bool isBusinessProfile;
  @HiveField(11)
  final String state;
  @HiveField(12)
  final String gst;
  @HiveField(13)
  final String flatNo;
  @HiveField(14)
  final String buildingNo;
  @HiveField(15)
  final String buildingName;
  @HiveField(16)
  final String street;
  @HiveField(17)
  final String area;
  @HiveField(18)
  final String city;
  @HiveField(19)
  @JsonKey(fromJson: UnitListParser.fromJson, toJson: UnitListParser.toJson)
  final Uint8List? userImage;
  @HiveField(20)
  final String bStatus;
  @HiveField(21)
  final String businessName;
  @HiveField(22)
  final String tradeName;
  @HiveField(23)
  final String tan;
  @HiveField(24)
  final String businessState;
  @HiveField(25)
  final String businessAddress;

  UserModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.gender = '',
    this.aadhaar = '',
    this.pan = '',
    this.pin = '',
    this.isBusinessProfile = false,
    this.gst = '',
    this.state = '',
    this.area = '',
    this.buildingName = '',
    this.buildingNo = '',
    this.city = '',
    this.flatNo = '',
    this.street = '',
    this.businessAddress = '',
    this.tradeName = '',
    this.tan = '',
    this.businessName = '',
    this.bStatus = '',
    this.businessState = '',
    Uint8List? userImage,
  }) : userImage = userImage ??
            defaultImage; // Assign default value inside initializer

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? gender,
    String? aadhaar,
    String? pan,
    String? pin,
    bool? isBusinessProfile,
    String? gst,
    String? flatNo,
    String? buildingNo,
    String? buildingName,
    String? street,
    String? area,
    String? city,
    String? state,
    Uint8List? userImage,
    String? bStatus,
    String? businessAddress,
    String? tradeName,
    String? tan,
    String? businessName,
    String? businessState,
  }) {
    return UserModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        gender: gender ?? this.gender,
        aadhaar: aadhaar ?? this.aadhaar,
        pan: pan ?? this.pan,
        pin: pin ?? this.pin,
        isBusinessProfile: isBusinessProfile ?? this.isBusinessProfile,
        gst: gst ?? this.gst,
        area: area ?? this.area,
        buildingName: buildingName ?? this.buildingName,
        buildingNo: buildingNo ?? this.buildingNo,
        city: city ?? this.city,
        flatNo: flatNo ?? this.flatNo,
        state: state ?? this.state,
        street: street ?? this.street,
        userImage: userImage ?? this.userImage,
        bStatus: bStatus ?? this.bStatus,
        businessAddress: businessAddress ?? this.businessAddress,
        businessName: businessName ?? this.businessName,
        tan: tan ?? this.tan,
        tradeName: tradeName ?? this.tradeName,
        businessState: businessState ?? this.businessState);
  }
}
