class AtttributesOption {
  String title;
  bool isChecked;

  AtttributesOption({this.title, this.isChecked});

  AtttributesOption.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isChecked = json['isChecked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isChecked'] = this.isChecked;
    return data;
  }
}