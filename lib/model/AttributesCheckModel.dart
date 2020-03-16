import 'AtttributesOption.dart';

class AttributesCheckModel{
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<AtttributesOption> options;

  AttributesCheckModel(
      {this.id,
        this.name,
        this.position,
        this.visible,
        this.variation,
        this.options});
}