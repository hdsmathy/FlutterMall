import 'package:flutter/material.dart';

class BannerAdsModel {
  String message;
  int code;
  Data data;

  BannerAdsModel({this.message, this.code, this.data});

  BannerAdsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<ThemefarmerHomeSlider> themefarmerHomeSlider;
  List<ThemefarmerHomeProductTabs> themefarmerHomeProductTabs;
  List<ThemefarmerHomeBanners> themefarmerHomeBanners;
  List<Banner> banner;

  Data(
      {this.themefarmerHomeSlider,
        this.themefarmerHomeProductTabs,
        this.themefarmerHomeBanners,
        this.banner});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['themefarmer_home_slider'] != null) {
      themefarmerHomeSlider = new List<ThemefarmerHomeSlider>();
      json['themefarmer_home_slider'].forEach((v) {
        themefarmerHomeSlider.add(new ThemefarmerHomeSlider.fromJson(v));
      });
    }
    if (json['themefarmer_home_product_tabs'] != null) {
      themefarmerHomeProductTabs = new List<ThemefarmerHomeProductTabs>();
      json['themefarmer_home_product_tabs'].forEach((v) {
        themefarmerHomeProductTabs
            .add(new ThemefarmerHomeProductTabs.fromJson(v));
      });
    }
    if (json['themefarmer_home_banners'] != null) {
      themefarmerHomeBanners = new List<ThemefarmerHomeBanners>();
      json['themefarmer_home_banners'].forEach((v) {
        themefarmerHomeBanners.add(new ThemefarmerHomeBanners.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = new List<Banner>();
      json['banner'].forEach((v) {
        banner.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.themefarmerHomeSlider != null) {
      data['themefarmer_home_slider'] =
          this.themefarmerHomeSlider.map((v) => v.toJson()).toList();
    }
    if (this.themefarmerHomeProductTabs != null) {
      data['themefarmer_home_product_tabs'] =
          this.themefarmerHomeProductTabs.map((v) => v.toJson()).toList();
    }
    if (this.themefarmerHomeBanners != null) {
      data['themefarmer_home_banners'] =
          this.themefarmerHomeBanners.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThemefarmerHomeSlider {
  String img;
  String url;

  ThemefarmerHomeSlider({this.img, this.url});

  ThemefarmerHomeSlider.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['url'] = this.url;
    return data;
  }
}

class ThemefarmerHomeProductTabs {
  String name;
  String label;
  Color color;
  String orderby;
  String order;

  ThemefarmerHomeProductTabs({this.name, this.label, this.orderby, this.order,this.color = Colors.white});


  ThemefarmerHomeProductTabs.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    orderby = json['orderby'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['orderby'] = this.orderby;
    data['order'] = this.order;
    return data;
  }
}

class ThemefarmerHomeBanners {
  String width;
  String image;
  String link;
  String buttonLabel;
  String text;

  ThemefarmerHomeBanners(
      {this.width, this.image, this.link, this.buttonLabel, this.text});

  ThemefarmerHomeBanners.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    image = json['image'];
    link = json['link'];
    buttonLabel = json['button_label'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['image'] = this.image;
    data['link'] = this.link;
    data['button_label'] = this.buttonLabel;
    data['text'] = this.text;
    return data;
  }
}

class Banner {
  String heading;
  String description;
  String image;
  String buttonText;
  String buttonUrl;

  Banner(
      {this.heading,
        this.description,
        this.image,
        this.buttonText,
        this.buttonUrl});

  Banner.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    description = json['description'];
    image = json['image'];
    buttonText = json['button_text'];
    buttonUrl = json['button_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['image'] = this.image;
    data['button_text'] = this.buttonText;
    data['button_url'] = this.buttonUrl;
    return data;
  }
}
