import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final getDataCommandeFuture =
    ChangeNotifierProvider<GetDataCommandeCuisineFuture>(
        (ref) => GetDataCommandeCuisineFuture());

class GetDataCommandeCuisineFuture extends ChangeNotifier {
  List<CommandeCuisine> listCommande = [];

  GetDataCommandeCuisineFuture() {
    getData();
  }

  Future getData() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    String adressUrl = prefs.getString('ipport').toString();
    var restaurantid = prefs.getString('idRestaurant');*/
    try {
      http.Response response = await http.get(
        Uri.parse('http://13.39.81.126:4004/api/orders/fetch/all'),
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8',
          //'Authorization': 'Bearer $token ',
        },
      );

      print(response.statusCode);
      //print("Liste des commandes ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['deletedAt'] == null) {
            listCommande.add(CommandeCuisine.fromJson(data[i]));
          }
        }
      } else {
        return Future.error(" server erreur");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}

class CommandeCuisine {
  String? sId;
  Null orderTitle;
  bool? isTracking;

  String? status;
  Null deletedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CommandeCuisine(
      {this.sId,
      this.orderTitle,
      this.isTracking,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CommandeCuisine.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderTitle = json['order_title'];
    isTracking = json['is_tracking'];

    status = json['status'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['order_title'] = this.orderTitle;
    data['is_tracking'] = this.isTracking;

    data['status'] = this.status;
    data['deletedAt'] = this.deletedAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
