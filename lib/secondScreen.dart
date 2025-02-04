import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_example/ContactDbBox.dart';
import 'package:hive_example/models/contactModel.dart';
import 'package:sizer/sizer.dart';
import 'package:hive_ce/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
class secondScreen extends StatefulWidget {
  const secondScreen({super.key});

  @override
  State<secondScreen> createState() => _secondScreenState();
}

class _secondScreenState extends State<secondScreen> {

  final _textController = TextEditingController();
  Uint8List? image;
  List<dynamic> contactList = [];

  Future<void> pickImage() async{
    final ImagePicker picker = ImagePicker();
    final XFile? pic = await picker.pickImage(source: ImageSource.gallery);
    if(pic != null){
        image = await pic.readAsBytes();
        setState(() {

        });

    }
  }

  @override
  void initState() {
    super.initState();
    contactList = ContactDbBox.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact with image'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
                    children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                controller: _textController,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon:Icon(Icons.camera_alt_outlined,color: Colors.green,),
                    onPressed: (){
                      pickImage();

                    },
                  ),
                  prefixIcon: image!=null
                      ?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                                            backgroundImage: MemoryImage(image!),),
                      )
                      :Icon(Icons.person),
                  fillColor: Color.fromRGBO(145, 206, 121, 0.3),
                  filled: true,

                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(145, 206, 121, 0.6), width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(121, 206, 196, 0.6), width: 1)),
                ),
                
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: 20.h,
                child: ElevatedButton(
                  onPressed: () async{
                    contactModel contact = contactModel(title: _textController.text, imageBytes: image);
                    await ContactDbBox.insertData(contact);
                    setState(() {
                      image=null;
                      _textController.clear();
                      contactList=ContactDbBox.getList();

                    });
            
                  },
                  child: Text('ADD'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green,foregroundColor: Colors.white,overlayColor: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 60.h,
                child: ListView.builder(
                  itemCount: contactList.length,
                    itemBuilder: (context,index){
                    return Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: ContactDbBox.box.getAt(index)?.imageBytes != null
                                ? MemoryImage(ContactDbBox.box.getAt(index)?.imageBytes ?? Uint8List(0)) // Convert Uint8List to ImageProvider
                                : AssetImage('lib/assets/si.jpg')
                          ),
                          title: Text(ContactDbBox.box.getAt(index)!.title.toString()??''),
                          trailing: IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.delete_outline,color: Colors.red.shade300,)),
                        ),
                        Divider(
                          color: Colors.black12,
                          thickness: 1.5,
                        )
                      ],
                    );
                    },
            
                ),
              ),
            
            )
                    ],
                  ),
          )),
    );
  }
}
