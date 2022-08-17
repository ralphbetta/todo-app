//for sqflite database

class Task{
  late int? id;
  late String? title;
  late String? details;


  Task({
    this.id,
    this.title,
    this.details
  });

  //retrieve from database
  Task.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    details = json['details'];

  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['details'] = this.details;
    return data;
  }


}


