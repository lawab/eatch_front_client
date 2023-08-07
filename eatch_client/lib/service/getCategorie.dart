import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getDataCategoriesFuture = ChangeNotifierProvider<GetDataCategoriesFuture>(
    (ref) => GetDataCategoriesFuture());

class GetDataCategoriesFuture extends ChangeNotifier {
  List<Categorie> listCategori = [];
  List<Products> listBoisson = [];

  GetDataCategoriesFuture() {
    getData();
  }
  //RÔLE_Manager

  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var restaurantId = prefs.getString('idRestaurant').toString();
    //String adressUrl = prefs.getString('ipport').toString();
    print('restaurantId');
    print(restaurantId);
    try {
      http.Response response = await http.get(
        Uri.parse(
            'http://13.39.81.126:4003/api/products/getProducts/categories/64c7ada91fba039e192d4c55'), //4002 //products/fetch/categories/$restaurantId
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          'Authorization': 'Bearer $token ',
        },
      );

      print(response.statusCode);
      print('Produit get produit');
      //print(response.body);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var ee = Categorie(title: 'Menu', sId: 'Menu');
        listCategori.add(ee);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listCategori.add(Categorie.fromJson(data[i]));
            if (data[i]['title'] == 'Jus' || data[i]['title'] == 'Sodas') {
              for (int j = 0; j < data[i]['products'].length; j++) {
                listBoisson.add(Products.fromJson(data[i]['products'][j]));
              }
            }
          }
        }
        print('listBoisson.length');
        print(listBoisson.length);
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

class Categorie {
  Creator? cCreator;
  Restaurant? restaurant;
  String? sId;
  String? image;
  String? deletedAt;
  List<Products>? products;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? title;

  Categorie(
      {this.cCreator,
      this.restaurant,
      this.sId,
      this.image,
      this.deletedAt,
      this.products,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.title});

  Categorie.fromJson(Map<String, dynamic> json) {
    cCreator =
        json['_creator'] != null ? Creator.fromJson(json['_creator']) : null;
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    sId = json['_id'];
    image = json['image'];
    deletedAt = json['deletedAt'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cCreator != null) {
      data['_creator'] = cCreator!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['_id'] = sId;
    data['image'] = image;
    data['deletedAt'] = deletedAt;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['title'] = title;
    return data;
  }
}

class Creator {
  String? sId;
  String? role;
  String? email;
  String? firstName;
  String? lastName;

  Creator({this.sId, this.role, this.email, this.firstName, this.lastName});

  Creator.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    role = json['role'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['role'] = role;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}

class Restaurant {
  String? sId;

  Restaurant({this.sId});

  Restaurant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    return data;
  }
}

class Products {
  String? sId;
  Recette? recette;
  Restaurant? restaurant;
  Category? category;
  int? price;
  String? sCreator;
  int? quantity;
  String? productName;
  bool? promotion;
  String? devise;
  String? image;
  int? liked;
  int? likedPersonCount;
  String? deletedAt;
  List<Comments>? comments;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? choix;
  bool? choixTotal;

  Products({
    this.sId,
    this.recette,
    this.restaurant,
    this.category,
    this.price,
    this.sCreator,
    this.quantity,
    this.productName,
    this.promotion,
    this.devise,
    this.image,
    this.liked,
    this.likedPersonCount,
    this.deletedAt,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.choix,
    this.choixTotal,
  });

  Products.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    recette =
        json['recette'] != null ? Recette.fromJson(json['recette']) : null;
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    price = json['price'];
    sCreator = json['_creator'];
    quantity = json['quantity'];
    productName = json['productName'];
    promotion = json['promotion'];
    devise = json['devise'];
    image = json['image'];
    liked = json['liked'];
    likedPersonCount = json['likedPersonCount'];
    deletedAt = json['deletedAt'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    choix = false;
    choixTotal = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (recette != null) {
      data['recette'] = recette!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['price'] = price;
    data['_creator'] = sCreator;
    data['quantity'] = quantity;
    data['productName'] = productName;
    data['promotion'] = promotion;
    data['devise'] = devise;
    data['image'] = image;
    data['liked'] = liked;
    data['likedPersonCount'] = likedPersonCount;
    data['deletedAt'] = deletedAt;
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    //false=choix;
    return data;
  }
}

class Recette {
  String? sId;
  String? title;
  String? image;
  String? description;
  List<Engredients>? engredients;
  String? sCreator;
  String? deletedAt;

  Recette(
      {this.sId,
      this.title,
      this.image,
      this.description,
      this.engredients,
      this.sCreator,
      this.deletedAt});

  Recette.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    if (json['engredients'] != null) {
      engredients = <Engredients>[];
      json['engredients'].forEach((v) {
        engredients!.add(Engredients.fromJson(v));
      });
    }
    sCreator = json['_creator'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    if (engredients != null) {
      data['engredients'] = engredients!.map((v) => v.toJson()).toList();
    }
    data['_creator'] = sCreator;
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Engredients {
  String? material;
  int? grammage;
  String? sId;

  Engredients({this.material, this.grammage, this.sId});

  Engredients.fromJson(Map<String, dynamic> json) {
    material = json['material'];
    grammage = json['grammage'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material'] = material;
    data['grammage'] = grammage;
    data['_id'] = sId;
    return data;
  }
}

class Infos {
  String? town;
  String? address;
  String? logo;

  Infos({this.town, this.address, this.logo});

  Infos.fromJson(Map<String, dynamic> json) {
    town = json['town'];
    address = json['address'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['town'] = town;
    data['address'] = address;
    data['logo'] = logo;
    return data;
  }
}

class Category {
  Creator? cCreator;
  Restaurant? restaurant;
  String? sId;
  String? title;
  String? image;
  String? deletedAt;

  Category(
      {this.cCreator,
      this.restaurant,
      this.sId,
      this.title,
      this.image,
      this.deletedAt});

  Category.fromJson(Map<String, dynamic> json) {
    cCreator =
        json['_creator'] != null ? Creator.fromJson(json['_creator']) : null;
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    sId = json['_id'];
    title = json['title'];
    image = json['image'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cCreator != null) {
      data['_creator'] = cCreator!.toJson();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['_id'] = sId;
    data['title'] = title;
    data['image'] = image;
    data['deletedAt'] = deletedAt;
    return data;
  }
}

class Comments {
  String? sId;
  Client? client;
  String? message;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? sCreator;

  Comments(
      {this.sId,
      this.client,
      this.message,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.sCreator});

  Comments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    client = json['client'] != null ? Client.fromJson(json['client']) : null;
    message = json['message'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    sCreator = json['_creator'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    data['message'] = message;
    data['deletedAt'] = deletedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['_creator'] = sCreator;
    return data;
  }
}

class Client {
  String? sId;
  String? fisrtName;
  String? lastName;
  bool? isOnline;
  String? phoneNumber;

  Client(
      {this.sId,
      this.fisrtName,
      this.lastName,
      this.isOnline,
      this.phoneNumber});

  Client.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fisrtName = json['fisrtName'];
    lastName = json['lastName'];
    isOnline = json['isOnline'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fisrtName'] = fisrtName;
    data['lastName'] = lastName;
    data['isOnline'] = isOnline;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
