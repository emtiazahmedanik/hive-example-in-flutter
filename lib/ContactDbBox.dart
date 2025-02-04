import 'package:hive_ce/hive.dart';
import 'package:hive_example/models/contactModel.dart';

class ContactDbBox{
  static late Box<contactModel> box ;
  static Future<void> init() async{
    if(!Hive.isBoxOpen('newcontact')){
      box = await Hive.openBox<contactModel>('newcontact');
    }else{
      box = Hive.box<contactModel>('newcontact');
    }
  }
  static Future<void> insertData(contactModel contact) async{
    box.add(contact);
  }
  static dynamic showData(int index){
    return box.getAt(index);
  }
  static List<dynamic> getList(){
    return box.keys.toList();
  }

}