class ShippingMethodModel {
  String id;
  String title;
  String description;
  bool isHideTips;
  String freight;///运费



  @override
  String toString() {
    return 'ShippingMethodModel{id: $id, title: $title, description: $description,isHideTips: $isHideTips}';
  }


  ShippingMethodModel({this.id, this.title, this.description, this.isHideTips,
    this.freight});


}


