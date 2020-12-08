import 'package:intl/intl.dart';

class ChatModel{
  String message;
  String reciverId;
  String senderId;
  bool senderDel;
  bool reciverDel;
  String type;
  int timestamp;
  String replay;
  String docId;
  bool isReplay;
  ChatModel({this.message,this.reciverDel,
  this.senderDel,this.senderId,
  this.isReplay,this.reciverId,
  this.docId,
  
  this.timestamp, this.type,
  this.replay});
  Map<String,dynamic> toMap()=>{
    "message":message,
    "reciverId":reciverId,
    "senderId":senderId,
    "senderDel":false,
    "reciverDel":false,
    "type":"text",
    "replay":null,
    "isReplay":false,



    "timestamp":DateTime.now().millisecondsSinceEpoch
    
  };


}
String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a ');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp );
    
    var diff = now.difference(date);
    var time = '';
    if(diff.inSeconds<60){
      time=diff.inSeconds.toString()+" sec ago";
    }else if(diff.inMinutes<60){
      time=diff.inMinutes.toString()+" min ago";
    }else if(diff.inHours<24){
      time=diff.inHours.toString()+" hrs ago";
    }

   else if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    
     
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else if(diff.inDays/7>5) {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }else{
        var f = DateFormat('yyy, mm, dd :: HH:mm a ');
        time=f.format(date);

      }
    }

    return time;
  }
