// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 6;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      password: fields[5] as String,
      gender: fields[6] as String,
      aadhaar: fields[7] as String,
      pan: fields[8] as String,
      pin: fields[9] as String,
      isBusinessProfile: fields[10] as bool,
      gst: fields[12] as String,
      state: fields[11] as String,
      area: fields[17] as String,
      buildingName: fields[15] as String,
      buildingNo: fields[14] as String,
      city: fields[18] as String,
      flatNo: fields[13] as String,
      street: fields[16] as String,
      businessAddress: fields[25] as String,
      tradeName: fields[22] as String,
      tan: fields[23] as String,
      businessName: fields[21] as String,
      bStatus: fields[20] as String,
      businessState: fields[24] as String,
      userImage: fields[19] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.aadhaar)
      ..writeByte(8)
      ..write(obj.pan)
      ..writeByte(9)
      ..write(obj.pin)
      ..writeByte(10)
      ..write(obj.isBusinessProfile)
      ..writeByte(11)
      ..write(obj.state)
      ..writeByte(12)
      ..write(obj.gst)
      ..writeByte(13)
      ..write(obj.flatNo)
      ..writeByte(14)
      ..write(obj.buildingNo)
      ..writeByte(15)
      ..write(obj.buildingName)
      ..writeByte(16)
      ..write(obj.street)
      ..writeByte(17)
      ..write(obj.area)
      ..writeByte(18)
      ..write(obj.city)
      ..writeByte(19)
      ..write(obj.userImage)
      ..writeByte(20)
      ..write(obj.bStatus)
      ..writeByte(21)
      ..write(obj.businessName)
      ..writeByte(22)
      ..write(obj.tradeName)
      ..writeByte(23)
      ..write(obj.tan)
      ..writeByte(24)
      ..write(obj.businessState)
      ..writeByte(25)
      ..write(obj.businessAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      aadhaar: json['aadhaar'] as String? ?? '',
      pan: json['pan'] as String? ?? '',
      pin: json['pin'] as String? ?? '',
      isBusinessProfile: json['isBusinessProfile'] as bool? ?? false,
      gst: json['gst'] as String? ?? '',
      state: json['state'] as String? ?? '',
      area: json['area'] as String? ?? '',
      buildingName: json['buildingName'] as String? ?? '',
      buildingNo: json['buildingNo'] as String? ?? '',
      city: json['city'] as String? ?? '',
      flatNo: json['flatNo'] as String? ?? '',
      street: json['street'] as String? ?? '',
      businessAddress: json['businessAddress'] as String? ?? '',
      tradeName: json['tradeName'] as String? ?? '',
      tan: json['tan'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      bStatus: json['bStatus'] as String? ?? '',
      businessState: json['businessState'] as String? ?? '',
      userImage: UnitListParser.fromJson(json['userImage'] as String?),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'gender': instance.gender,
      'aadhaar': instance.aadhaar,
      'pan': instance.pan,
      'pin': instance.pin,
      'isBusinessProfile': instance.isBusinessProfile,
      'state': instance.state,
      'gst': instance.gst,
      'flatNo': instance.flatNo,
      'buildingNo': instance.buildingNo,
      'buildingName': instance.buildingName,
      'street': instance.street,
      'area': instance.area,
      'city': instance.city,
      'userImage': UnitListParser.toJson(instance.userImage),
      'bStatus': instance.bStatus,
      'businessName': instance.businessName,
      'tradeName': instance.tradeName,
      'tan': instance.tan,
      'businessState': instance.businessState,
      'businessAddress': instance.businessAddress,
    };
