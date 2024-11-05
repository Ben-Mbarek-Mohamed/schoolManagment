import 'package:hive/hive.dart';
import 'package:madrasti/models/notification.dart';


class NotificationService{
  Box<NotificationModel> box = Hive.box<NotificationModel>('notifications');

  List<NotificationModel> getAll(){
    return box.values.toList().cast<NotificationModel>();
  }

  Future<void> add(NotificationModel notification) async {
    int id = await box.add(notification);
    notification.id = id;
    box.put(id, notification);
  }
  NotificationModel? get(int id){
    return box.get(id);
  }

  void delete(int id){
    box.delete(id);
  }
  void update(NotificationModel notification){
    box.put(notification.id, notification);
  }

  void closeBox(){
    box.close();
  }
}