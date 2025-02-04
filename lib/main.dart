import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hive_example/ContactDbBox.dart';
import 'package:hive_example/models/contactModel.dart';
import 'package:hive_example/secondScreen.dart';
import 'package:sizer/sizer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('contact');

  Hive.registerAdapter(contactModelAdapter());
  await ContactDbBox.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context,orientation,deviceType){
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _namefield = TextEditingController();
  final _editfield = TextEditingController();
  final _focusnode = FocusNode();
  int index=1;
  final box = Hive.box('contact');
  List<dynamic> keyList = [];


  @override
  void initState() {
    super.initState();
    keyList = box.keys.toList();
  }

  void onpressed(){
    setState(() {

    });
  }
  void _insertdata() async{
    await box.add( _namefield.text);

  }
  void _retrive(){
    keyList = box.keys.toList();
  }
  void _delete(var index){
    box.deleteAt(index);
  }
  void _updateData(int index){
    box.putAt(index, _editfield.text);
  }
  void showalertdialog(BuildContext context,int index){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Change Data'),
            content: TextField(
              controller: _editfield,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis), // Truncate text if too long
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',style: TextStyle(color: Colors.blue.shade400),)
              ),
              TextButton(
                  onPressed: (){
                    _updateData(index);
                    onpressed();
                    Navigator.pop(context);

                  },
                  child: Text('Change Data',style: TextStyle(color: Colors.red.shade400))
              )
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>secondScreen()));
              }, 
              icon: Icon(Icons.navigate_next_outlined)
          )
        ],
      ),
      body: SafeArea(
          child: GestureDetector(
            onTap: _focusnode.unfocus,
            child: SingleChildScrollView(
              child: Column(
                spacing: 5,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            focusNode: _focusnode,
                            controller: _namefield,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue.shade200),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            onPressed: () async{
                              _focusnode.unfocus();
                              _insertdata();
                              _namefield.clear();
                              _retrive();
                              onpressed();

                            },
                            child: Text('ADD'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                elevation: 0
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 70.h,
                    child: ListView.builder(
                      itemCount: keyList.length,
                        itemBuilder: (context,index)=>
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onLongPress: (){
                                  _editfield.text=box.getAt(index);
                                  showalertdialog(context, index);

                                },
                                child: ListTile(
                                  title: Text(box.getAt(index)),
                                  tileColor: Colors.black12,
                                  textColor: Colors.purple,
                                  trailing: IconButton(
                                      onPressed: (){
                                        _delete(index);
                                        _retrive();
                                        onpressed();
                                      },
                                      icon: Icon(Icons.delete,color: Colors.red.shade400,)
                                  ),
                                ),
                              ),
                            )
                    ),
                  )
                ],
              ),
            ),
          )
      ),

    );
  }
}
