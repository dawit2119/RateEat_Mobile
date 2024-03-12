// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'menu.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class RestaurantAdapter extends TypeAdapter<Restaurant> {
//   @override
//   final int typeId = 45;

//   @override
//   Restaurant read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Restaurant(
//       id: fields[0] as String?,
//       name: fields[1] as String?,
//       currencyCode: fields[2] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Restaurant obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.name)
//       ..writeByte(2)
//       ..write(obj.currencyCode);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is RestaurantAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
