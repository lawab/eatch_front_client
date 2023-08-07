import 'dart:convert';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getCommande.dart';
import 'package:http/http.dart' as http;
import 'package:eatch_client/commande/commandeClient/detailsMenu.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/multipart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

class Recapitulatif extends ConsumerStatefulWidget {
  final List<ProduitsCommande> listRecap;
  final double prix;
  const Recapitulatif({Key? key, required this.listRecap, required this.prix})
      : super(key: key);

  @override
  RecapitulatifState createState() => RecapitulatifState();
}

class RecapitulatifState extends ConsumerState<Recapitulatif> {
  bool espace = false;
  bool carte = true;
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCommandeFuture);
    return Scaffold(
      backgroundColor: Palette.yellowColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Palette.marronColor),
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width / 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Votre commande',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100 - 420,
                  child: ListView.builder(
                    itemCount: widget.listRecap.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.grey,
                          // strokeAlign: StrokeAlign.center
                        )),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 30,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        '${widget.listRecap[index].nombre}x  ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${widget.listRecap[index].title}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                '${widget.listRecap[index].price.toString()} MAD',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Mode de paiement',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: espace == true
                                ? Palette.yellowColor
                                : Colors.grey,
                            child: const Text('En Espece'),
                          ),
                          onTap: () {
                            setState(() {
                              espace = true;
                              carte = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: carte == true
                                ? Palette.yellowColor
                                : Colors.grey,
                            child: const Text('Par carte'),
                          ),
                          onTap: () {
                            setState(() {
                              espace = false;
                              carte = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Palette.marronColor,
                    borderRadius: BorderRadius.circular(15.0),
                    image: const DecorationImage(
                        opacity: 150,
                        image: AssetImage('commande.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Expanded(child: Container()),
                          Text(
                            '${widget.prix} Mad',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: (() {
                            List<String> produits = [];
                            List<MenuCommande> menuC = [];
                            List<ArticleCommande> productC = [];
                            for (int i = 0; i < widget.listRecap.length; i++) {
                              if (widget.listRecap[i].boisson != null) {
                                for (int j = 0;
                                    j < widget.listRecap[i].products!.length;
                                    j++) {
                                  produits.add(
                                      widget.listRecap[i].products![j].sId!);
                                }
                              } else {
                                var jj = ArticleCommande(
                                    id: widget.listRecap[i].id,
                                    qte: widget.listRecap[i].nombre);
                                productC.add(jj);
                              }
                            }

                            for (int i = 0; i < widget.listRecap.length; i++) {
                              if (widget.listRecap[i].boisson != null) {
                                var rr = MenuCommande(
                                    qte: widget.listRecap[i].nombre,
                                    produit: produits);
                                menuC.add(rr);
                              }
                            }
                            var json = {
                              'menus': menuC,
                              'product': productC,
                              'num_order': viewModel.listCommande.length + 1,
                              'prix': widget.prix,
                              'num_table': 5
                            };
                            print(
                                '***********************************************************');
                            var body = jsonEncode(json);
                            print(body);
                            /*creationCommande(
                                context, menuC, productC, widget.prix,viewModel.listCommande.length + 1);*/
                          }),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              minimumSize: const Size(180, 50)),
                          child: const Text("Commander"),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> creationCommande(
    contextt,
    List<MenuCommande> menuCC,
    List<ArticleCommande> productCC,
    double prix,
    int num_order,
  ) async {
    ////////////

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('IdUser').toString();
    var token = prefs.getString('token');

    var url = Uri.parse(
        "http://13.39.81.126:4004/api/orders/createMobile"); //13.39.81.126
    final request = MultipartRequest(
      'POST',
      url,
      onProgress: (int bytes, int total) {
        final progress = bytes / total;
        print('progress: $progress ($bytes/$total)');
      },
    );
    var json = {
      'menus': menuCC,
      'product': productCC,
      'num_order': num_order,
      'prix': prix,
      'num_table': 5
    };
    var body = jsonEncode(json);

    request.headers.addAll({
      "body": body,
    });

    request.fields['form_key'] = 'form_value';

    print("RESPENSE SEND STEAM FILE REQ");
    //var responseString = await streamedResponse.stream.bytesToString();
    var response = await request.send();
    print("Upload Response$response");
    print(response.statusCode);
    print(request.headers);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        await response.stream.bytesToString().then((value) {
          print(value);
        });
        //stopMessage();
        //finishWorking();

        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.green,
            message: "Restaurant Modifié",
          ),
        );
        //ref.refresh(getDataRsetaurantFuture);
      } else {
        showTopSnackBar(
          Overlay.of(contextt),
          const CustomSnackBar.info(
            backgroundColor: Colors.red,
            message: "Erreur de création",
          ),
        );
        print("Error Create Programme  !!!");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class MenuCommande {
  int? qte;

  List<String>? produit;

  MenuCommande({
    this.qte,
    this.produit,
  });

  MenuCommande.fromJson(Map<String, dynamic> json) {
    qte = json['qte'];
    produit = json['produit'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qte'] = qte;
    data['produit'] = produit;

    return data;
  }
}

class ArticleCommande {
  int? qte;

  String? id;

  ArticleCommande({
    this.qte,
    this.id,
  });

  ArticleCommande.fromJson(Map<String, dynamic> json) {
    qte = json['qte'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qte'] = qte;
    data['id'] = id;

    return data;
  }
}
