import 'dart:typed_data';

import 'package:hive_ce/hive.dart';
part 'contactModel.g.dart';
@HiveType(typeId: 0)
class contactModel{
  @HiveField(0)
  String? title;

  @HiveField(1)
  Uint8List? imageBytes;
  contactModel({required this.title,required this.imageBytes});
}