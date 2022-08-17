//for sqflite database

class DataModel{
  late int? id;
  late int? isCompleted;
  late int? color;
  late int? remind;
  late String? title;
  late String? note;
  late String? date;
  late String? startTime;
  late String? endTime;
  late String? repeat;


  DataModel({
    this.id,
    this.isCompleted,
    this.color,
    this.remind,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.repeat,
  });


  //retrieve from database
  DataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    repeat = json['repeat'];
    remind = json['remind'];
  }


  //used sending data to database

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isCompleted'] = this.isCompleted;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['title'] = this.title;
    data['note'] = this.note;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['endTime'] =this.endTime;
    data['repeat'] =this.repeat;
    return data;
  }


}


