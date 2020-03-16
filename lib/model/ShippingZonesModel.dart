class ShippingZonesModel {
  int id;
  String name;
  int order;
  Links lLinks;

  ShippingZonesModel({this.id, this.name, this.order, this.lLinks});

  ShippingZonesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    order = json['order'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'ShippingZonesModel{id: $id, name: $name, order: $order, lLinks: $lLinks}';
  }


}

class Links {
  List<Self> self;
  List<Collection> collection;
  List<Describedby> describedby;

  Links({this.self, this.collection, this.describedby});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = new List<Self>();
      json['self'].forEach((v) {
        self.add(new Self.fromJson(v));
      });
    }
    if (json['collection'] != null) {
      collection = new List<Collection>();
      json['collection'].forEach((v) {
        collection.add(new Collection.fromJson(v));
      });
    }
    if (json['describedby'] != null) {
      describedby = new List<Describedby>();
      json['describedby'].forEach((v) {
        describedby.add(new Describedby.fromJson(v));
      });
    }
  }


  @override
  String toString() {
    return 'Links{self: $self, collection: $collection, describedby: $describedby}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self.map((v) => v.toJson()).toList();
    }
    if (this.collection != null) {
      data['collection'] = this.collection.map((v) => v.toJson()).toList();
    }
    if (this.describedby != null) {
      data['describedby'] = this.describedby.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Collection {
  String href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }

  @override
  String toString() {
    return 'Collection{href: $href}';
  }

}

class Describedby {
  String href;

  Describedby({this.href});

  Describedby.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }

  @override
  String toString() {
    return 'Describedby{href: $href}';
  }

}

class Self {
  String href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }

  @override
  String toString() {
    return 'Self{href: $href}';
  }

}
