class OldProdeuctListModel {
  List<Products> products;

  OldProdeuctListModel({this.products});

  OldProdeuctListModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String title;
  int id;
  String createdAt;
  String updatedAt;
  String type;
  String status;
  bool downloadable;
  bool virtual;
  String permalink;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String priceHtml;
  bool taxable;
  String taxStatus;
  String taxClass;
  bool managingStock;
  int stockQuantity;
  bool inStock;
  bool backordersAllowed;
  bool backordered;
  bool soldIndividually;
  bool purchaseable;
  bool featured;
  bool visible;
  String catalogVisibility;
  bool onSale;
  String productUrl;
  String buttonText;
//  Null weight;
  Dimensions dimensions;
  bool shippingRequired;
  bool shippingTaxable;
  String shippingClass;
//  Null shippingClassId;
  String description;
  String shortDescription;
  bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  List<int> relatedIds;
//  List<Null> upsellIds;
//  List<Null> crossSellIds;
  int parentId;
  List<String> categories;
//  List<Null> tags;
  List<ImagesModel> images;
  List<Attributes> attributes;
//  List<Null> downloads;
  int downloadLimit;
  int downloadExpiry;
  String downloadType;
  String purchaseNote;
  int totalSales;
  List<Variations> variations;
//  List<Null> parent;
//  List<Null> groupedProducts;
  int menuOrder;
  Products(
      {this.title,
        this.id,
        this.createdAt,
        this.updatedAt,
        this.type,
        this.status,
        this.downloadable,
        this.virtual,
        this.permalink,
        this.sku,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.priceHtml,
        this.taxable,
        this.taxStatus,
        this.taxClass,
        this.managingStock,
        this.stockQuantity,
        this.inStock,
        this.backordersAllowed,
        this.backordered,
        this.soldIndividually,
        this.purchaseable,
        this.featured,
        this.visible,
        this.catalogVisibility,
        this.onSale,
        this.productUrl,
        this.buttonText,
        this.dimensions,
        this.shippingRequired,
        this.shippingTaxable,
        this.shippingClass,
        this.description,
        this.shortDescription,
        this.reviewsAllowed,
        this.averageRating,
        this.ratingCount,
        this.relatedIds,
        this.parentId,
        this.categories,
        this.images,
        this.attributes,
        this.downloadLimit,
        this.downloadExpiry,
        this.downloadType,
        this.purchaseNote,
        this.totalSales,
        this.variations,
        this.menuOrder});

  Products.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    status = json['status'];
    downloadable = json['downloadable'];
    virtual = json['virtual'];
    permalink = json['permalink'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    priceHtml = json['price_html'];
    taxable = json['taxable'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    managingStock = json['managing_stock'];
    stockQuantity = json['stock_quantity'];
    inStock = json['in_stock'];
    backordersAllowed = json['backorders_allowed'];
    backordered = json['backordered'];
    soldIndividually = json['sold_individually'];
    purchaseable = json['purchaseable'];
    featured = json['featured'];
    visible = json['visible'];
    catalogVisibility = json['catalog_visibility'];
    onSale = json['on_sale'];
    productUrl = json['product_url'];
    buttonText = json['button_text'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    shippingRequired = json['shipping_required'];
    shippingTaxable = json['shipping_taxable'];
    shippingClass = json['shipping_class'];
    description = json['description'];
    shortDescription = json['short_description'];
    reviewsAllowed = json['reviews_allowed'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    relatedIds = json['related_ids'].cast<int>();
    parentId = json['parent_id'];
    categories = json['categories'].cast<String>();
    if (json['images'] != null) {
      images = new List<ImagesModel>();
      json['images'].forEach((v) {
        images.add(new ImagesModel.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
    downloadType = json['download_type'];
    purchaseNote = json['purchase_note'];
    totalSales = json['total_sales'];
    if (json['variations'] != null) {
      variations = new List<Variations>();
      json['variations'].forEach((v) {
        variations.add(new Variations.fromJson(v));
      });
    }
    menuOrder = json['menu_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['status'] = this.status;
    data['downloadable'] = this.downloadable;
    data['virtual'] = this.virtual;
    data['permalink'] = this.permalink;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['price_html'] = this.priceHtml;
    data['taxable'] = this.taxable;
    data['tax_status'] = this.taxStatus;
    data['tax_class'] = this.taxClass;
    data['managing_stock'] = this.managingStock;
    data['stock_quantity'] = this.stockQuantity;
    data['in_stock'] = this.inStock;
    data['backorders_allowed'] = this.backordersAllowed;
    data['backordered'] = this.backordered;
    data['sold_individually'] = this.soldIndividually;
    data['purchaseable'] = this.purchaseable;
    data['featured'] = this.featured;
    data['visible'] = this.visible;
    data['catalog_visibility'] = this.catalogVisibility;
    data['on_sale'] = this.onSale;
    data['product_url'] = this.productUrl;
    data['button_text'] = this.buttonText;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions.toJson();
    }
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['shipping_class'] = this.shippingClass;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['average_rating'] = this.averageRating;
    data['rating_count'] = this.ratingCount;
    data['related_ids'] = this.relatedIds;
    data['parent_id'] = this.parentId;
    data['categories'] = this.categories;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['download_limit'] = this.downloadLimit;
    data['download_expiry'] = this.downloadExpiry;
    data['download_type'] = this.downloadType;
    data['purchase_note'] = this.purchaseNote;
    data['total_sales'] = this.totalSales;
    if (this.variations != null) {
      data['variations'] = this.variations.map((v) => v.toJson()).toList();
    }
    data['menu_order'] = this.menuOrder;
    return data;
  }
}

class Dimensions {
  String length;
  String width;
  String height;
  String unit;

  Dimensions({this.length, this.width, this.height, this.unit});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['unit'] = this.unit;
    return data;
  }
}

class Images {
  int id;
  String createdAt;
  String updatedAt;
  String src;
  String title;
  String alt;
  int position;

  Images(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.src,
        this.title,
        this.alt,
        this.position});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    src = json['src'];
    title = json['title'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['src'] = this.src;
    data['title'] = this.title;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

class Attributes {
  String name;
  String slug;
  int position;
  bool visible;
  bool variation;

  Attributes(
      {this.name,
        this.slug,
        this.position,
        this.visible,
        this.variation
      });

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    position = json['position'];
    visible = json['visible'];
    variation = json['variation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['variation'] = this.variation;
    return data;
  }
}

class Variations {
  int id;
  String createdAt;
  String updatedAt;
  bool downloadable;
  bool virtual;
  String permalink;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  bool taxable;
  String taxStatus;
  String taxClass;
  bool managingStock;
  int stockQuantity;
  bool inStock;
  bool backordersAllowed;
  bool backordered;
  bool purchaseable;
  bool visible;
  bool onSale;
  Null weight;
  Dimensions dimensions;
  String shippingClass;
  Null shippingClassId;
  List<ImagesModel> image;
  List<Attributes> attributes;
  int downloadLimit;
  int downloadExpiry;

  Variations(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.downloadable,
        this.virtual,
        this.permalink,
        this.sku,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.taxable,
        this.taxStatus,
        this.taxClass,
        this.managingStock,
        this.stockQuantity,
        this.inStock,
        this.backordersAllowed,
        this.backordered,
        this.purchaseable,
        this.visible,
        this.onSale,
        this.weight,
        this.dimensions,
        this.shippingClass,
        this.shippingClassId,
        this.image,
        this.attributes,
        this.downloadLimit,
        this.downloadExpiry});

  Variations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    downloadable = json['downloadable'];
    virtual = json['virtual'];
    permalink = json['permalink'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    taxable = json['taxable'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    managingStock = json['managing_stock'];
    stockQuantity = json['stock_quantity'];
    inStock = json['in_stock'];
    backordersAllowed = json['backorders_allowed'];
    backordered = json['backordered'];
    purchaseable = json['purchaseable'];
    visible = json['visible'];
    onSale = json['on_sale'];
    weight = json['weight'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    if (json['image'] != null) {
      image = new List<ImagesModel>();
      json['image'].forEach((v) {
        image.add(new ImagesModel.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['downloadable'] = this.downloadable;
    data['virtual'] = this.virtual;
    data['permalink'] = this.permalink;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['taxable'] = this.taxable;
    data['tax_status'] = this.taxStatus;
    data['tax_class'] = this.taxClass;
    data['managing_stock'] = this.managingStock;
    data['stock_quantity'] = this.stockQuantity;
    data['in_stock'] = this.inStock;
    data['backorders_allowed'] = this.backordersAllowed;
    data['backordered'] = this.backordered;
    data['purchaseable'] = this.purchaseable;
    data['visible'] = this.visible;
    data['on_sale'] = this.onSale;
    data['weight'] = this.weight;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions.toJson();
    }
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    if (this.image != null) {
      data['image'] = this.image.map((v) => v.toJson()).toList();
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    data['download_limit'] = this.downloadLimit;
    data['download_expiry'] = this.downloadExpiry;
    return data;
  }
}

class ImagesModel {
  int id;
  String createdAt;
  String updatedAt;
  String src;
  String title;
  String alt;
  int position;

  ImagesModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.src,
        this.title,
        this.alt,
        this.position});

  ImagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    src = json['src'];
    title = json['title'];
    alt = json['alt'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['src'] = this.src;
    data['title'] = this.title;
    data['alt'] = this.alt;
    data['position'] = this.position;
    return data;
  }
}

