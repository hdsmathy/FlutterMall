class CommodityDetails {
  Product product;

  CommodityDetails({this.product});

  CommodityDetails.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  String name;
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
  String weight;
  Dimensions dimensions;
  bool shippingRequired;
  bool shippingTaxable;
  String shippingClass;
  String shippingClassId;
  String description;
  String shortDescription;
  bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  List<int> relatedIds;
  List<String> upsellIds;
  List<String> crossSellIds;
  int parentId;
  List<String> categories;
  List<String> tags;
  List<Images> images;
  String featuredSrc;
  List<String> attributes;
  List<String> downloads;
  int downloadLimit;
  int downloadExpiry;
  String downloadType;
  String purchaseNote;
  int totalSales;
  List<String> variations;
  List<String> parent;
  List<String> groupedProducts;
  int menuOrder;

  Product(
      {this.name,
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
        this.weight,
        this.dimensions,
        this.shippingRequired,
        this.shippingTaxable,
        this.shippingClass,
        this.shippingClassId,
        this.description,
        this.shortDescription,
        this.reviewsAllowed,
        this.averageRating,
        this.ratingCount,
        this.relatedIds,
        this.upsellIds,
        this.crossSellIds,
        this.parentId,
        this.categories,
        this.tags,
        this.images,
        this.featuredSrc,
        this.attributes,
        this.downloads,
        this.downloadLimit,
        this.downloadExpiry,
        this.downloadType,
        this.purchaseNote,
        this.totalSales,
        this.variations,
        this.parent,
        this.groupedProducts,
        this.menuOrder});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
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
    weight = json['weight'];
    dimensions = json['dimensions'] != null
        ? new Dimensions.fromJson(json['dimensions'])
        : null;
    shippingRequired = json['shipping_required'];
    shippingTaxable = json['shipping_taxable'];
    shippingClass = json['shipping_class'];
    shippingClassId = json['shipping_class_id'];
    description = json['description'];
    shortDescription = json['short_description'];
    reviewsAllowed = json['reviews_allowed'];
    averageRating = json['average_rating'];
    ratingCount = json['rating_count'];
    relatedIds = json['related_ids'].cast<int>();
    upsellIds = json['upsell_ids'].cast<String>();
    crossSellIds = json['cross_sell_ids'].cast<String>();
    parentId = json['parent_id'];
    categories = json['categories'].cast<String>();
    tags = json['tags'].cast<String>();
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    featuredSrc = json['featured_src'];
    attributes = json['attributes'].cast<String>();
    downloads = json['downloads'].cast<String>();
    downloadLimit = json['download_limit'];
    downloadExpiry = json['download_expiry'];
    downloadType = json['download_type'];
    purchaseNote = json['purchase_note'];
    totalSales = json['total_sales'];
    variations = json['variations'].cast<String>();
    parent = json['parent'].cast<String>();
    groupedProducts = json['grouped_products'].cast<String>();
    menuOrder = json['menu_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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
    data['weight'] = this.weight;
    if (this.dimensions != null) {
      data['dimensions'] = this.dimensions.toJson();
    }
    data['shipping_required'] = this.shippingRequired;
    data['shipping_taxable'] = this.shippingTaxable;
    data['shipping_class'] = this.shippingClass;
    data['shipping_class_id'] = this.shippingClassId;
    data['description'] = this.description;
    data['short_description'] = this.shortDescription;
    data['reviews_allowed'] = this.reviewsAllowed;
    data['average_rating'] = this.averageRating;
    data['rating_count'] = this.ratingCount;
    data['related_ids'] = this.relatedIds;
    data['upsell_ids'] = this.upsellIds;
    data['cross_sell_ids'] = this.crossSellIds;
    data['parent_id'] = this.parentId;
    data['categories'] = this.categories;
    data['tags'] = this.tags;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['featured_src'] = this.featuredSrc;
    data['attributes'] = this.attributes;
    data['downloads'] = this.downloads;
    data['download_limit'] = this.downloadLimit;
    data['download_expiry'] = this.downloadExpiry;
    data['download_type'] = this.downloadType;
    data['purchase_note'] = this.purchaseNote;
    data['total_sales'] = this.totalSales;
    data['variations'] = this.variations;
    data['parent'] = this.parent;
    data['grouped_products'] = this.groupedProducts;
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
