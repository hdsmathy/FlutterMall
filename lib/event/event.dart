//Bus 初始化
import 'package:event_bus/event_bus.dart';
import 'package:olamall_app/model/CarItemModel.dart';

EventBus eventBus = EventBus();

class CarEvent{
  int size;
  CarEvent(int size){
    this.size = size;
  }
}


class AddressEvent{
}

class ClearCarEvent{
  List<Data> _carList;
  ClearCarEvent(List<Data> _carList){
    this._carList = _carList;
  }
  getCarList(){
    return _carList;
  }
}


class MainSelectEvent{
  int index;
  MainSelectEvent(int index){
    this.index = index;
  }
}

class MineSelectEvent{
  bool refresh;
  MineSelectEvent(this.refresh);
}