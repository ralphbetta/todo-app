import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/todo_with_model/home_form.dart';

import 'home_database.dart';
import 'home_model.dart';


//this will contain everything at once
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Tester", style: TextStyle(color: Colors.black),),
      ),
      body: Body(),
    );
  }
}


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {


  // this is meant to be in constant..............................
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
    print(_journals);
  }

  Future<void> _addItem(Task task) async {
    await SQLHelper.createItem(task);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeForm()));
            },
                child: Container(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.all(10),
                    child: Text("+Add User", style: TextStyle(color: Colors.white),))),

            // _inputForm(),
            Expanded(
              child: ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (_, index){
                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 20,
                  width: 200,
                  color: Colors.green,
                  child: Row(

                    children: [
                      Text(_journals[index]['title']),
                      Expanded(child: Container()),
                      InkWell(
                        onTap: (){
                          _deleteItem(_journals[index]['id']);
                        },
                          child: Text('Delete')),
                      SizedBox(width: 20,),
                      InkWell(
                        onTap: (){},
                          child: Text('Edit')),
                    ],
                  ),
                );
              })
            )
          ],
        ),
      ),
    );

  }

  Column _inputForm() {
    return Column(
            children: [
              SizedBox(height: 100,),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    hintText: "enter title"
                ),
              ),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                    hintText: "enter details"
                ),
              ),
              TextButton(onPressed: (){
                // Insert a new journal to the database
                _validator();
              },
                  child: Container(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.all(10),
                      child: Text("Submit", style: TextStyle(color: Colors.white),))),

            ],
          );
  }
  _validator(){
    if(_titleController.text.isNotEmpty && _detailsController.text.isNotEmpty){
      print('completed');
      final _task = Task(
        title: _titleController.text,
        details: _detailsController.text
      );
      _addItem(_task);
      print(_journals);

    }else if(_titleController.text.isEmpty || _detailsController.text.isEmpty){
      print('unable to complete');
    }
  }


}

