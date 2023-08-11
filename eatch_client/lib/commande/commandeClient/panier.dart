import 'dart:convert';
import 'package:eatch_client/commande/commandeClient/detail.dart';
import 'package:eatch_client/commande/commandeClient/detailsMenu.dart';
import 'package:eatch_client/commande/commandeClient/menuu.dart';
import 'package:eatch_client/commande/commandeClient/recapitulatif.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Panier extends ConsumerStatefulWidget {
  const Panier({Key? key}) : super(key: key);

  @override
  PanierState createState() => PanierState();
}

class PanierState extends ConsumerState<Panier> {
  double prixTotal = 0;
  List<ProduitsCommande> listPanier = [];
  @override
  void initState() {
    panierr();
    // TODO: implement initState
    super.initState();
  }

  void panierr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tt = prefs.getString('panierCommande').toString();
    print('object');
    var panierCommande = jsonDecode(tt);
    for (int i = 0; i < panierCommande.length; i++) {
      setState(() {
        listPanier.add(ProduitsCommande.fromJson(panierCommande[i]));
        prixTotal = prixTotal +
            ((listPanier[i].price!.toInt()) * (listPanier[i].nombre!.toInt()))
                .toDouble();
      });
    }
  }

  MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  Size size(BuildContext buildContext) {
    return mediaQueryData(buildContext).size;
  }

  double width(BuildContext buildContext) {
    return size(buildContext).width;
  }

  double height(BuildContext buildContext) {
    return size(buildContext).height;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(getDataCategoriesFuture);
    final viewModele = ref.watch(getDataMenuFuture);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listCategori, viewModele.listMenus);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listCategori, viewModele.listMenus);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, context,
      List<Categorie> listCat, List<Menus> listMenu) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Row(
              children: [
                //////////////// Interface de gauche avec l'image
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Palette.violetColor,
                        padding: const EdgeInsets.all(100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            image: const DecorationImage(
                                image: AssetImage('assets/logo_vert.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      /////////////////// Boutton d'ajout de commande
                      Positioned(
                        top: 50,
                        left: 100,
                        width: 160,
                        height: 100,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Palette.yellowColor,
                                    ),
                                    Text(
                                      'Ajouter des articles',
                                      style: TextStyle(
                                          fontFamily: 'Allerta',
                                          fontSize: 15,
                                          color: Palette.yellowColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MenuClient(
                                                commande: listCat,
                                                page: 0,
                                                listMenu: listMenu,
                                              )));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////// Interface pour affiche de la commande et des détails
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Palette.violetColor,
                    child: //panier(),
                        ListView.builder(
                      itemCount: listPanier.length,
                      itemBuilder: (contextT, index) {
                        int count = listPanier[index].nombre!;
                        return Card(
                          elevation: 5,
                          child: SizedBox(
                            height: 155,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                              image: NetworkImage(listPanier[
                                                              index]
                                                          .boisson !=
                                                      null
                                                  ? 'http://13.39.81.126:4009${listPanier[index].imageUrl!}'
                                                  : 'http://13.39.81.126:4003${listPanier[index].imageUrl!}'),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listPanier[index].title!,
                                              style: const TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${listPanier[index].price} MAD',
                                              style: const TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                '${listPanier[index].personnalisation},${listPanier[index].boisson}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: /*ajout(
                        listPanier[index].nombre!, listPanier[index].price!),*/
                                        Container(
                                      width: 110,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                setState(() {
                                                  prixTotal = 0;

                                                  if (count > 0) {
                                                    count--;
                                                    listPanier[index].nombre =
                                                        count;

                                                    for (int i = 0;
                                                        i < listPanier.length;
                                                        i++) {
                                                      prixTotal = prixTotal +
                                                          ((listPanier[i]
                                                                      .price!
                                                                      .toInt()) *
                                                                  (listPanier[i]
                                                                      .nombre!
                                                                      .toInt()))
                                                              .toDouble();
                                                      prefs.setInt('panier',
                                                          listPanier.length);
                                                      if (count == 0) {
                                                        listPanier.removeWhere(
                                                            (element) =>
                                                                listPanier[
                                                                        index]
                                                                    .title ==
                                                                element.title);
                                                        if (listPanier
                                                            .isEmpty) {
                                                          prefs.setInt(
                                                              'panier', 0);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MenuClient(
                                                                commande:
                                                                    listCat,
                                                                page: 0,
                                                                listMenu:
                                                                    listMenu,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    }
                                                  }
                                                  prefs.setString(
                                                      'panierCommande',
                                                      jsonEncode(listPanier));
                                                });
                                              },
                                              child: Icon(
                                                count == 1
                                                    ? Icons.delete
                                                    : Icons.remove,
                                                color: Colors.black,
                                                size: 25,
                                              )),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white),
                                              child: Center(
                                                child: Text(
                                                  listPanier[index]
                                                      .nombre!
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                setState(() {
                                                  prixTotal = 0;
                                                  count++;
                                                  listPanier[index].nombre =
                                                      count;
                                                  prefs.setInt('panier',
                                                      listPanier.length + 1);
                                                  prefs.setString(
                                                      'panierCommande',
                                                      jsonEncode(listPanier));
                                                  for (int i = 0;
                                                      i < listPanier.length;
                                                      i++) {
                                                    prixTotal = prixTotal +
                                                        ((listPanier[i]
                                                                    .price!
                                                                    .toInt()) *
                                                                (listPanier[i]
                                                                    .nombre!
                                                                    .toInt()))
                                                            .toDouble();
                                                  }
                                                });
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                color: Palette.yellowColor,
                                                size: 25,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          /////////////////// Boutton de retour
          /*Positioned(
            top: 25,
            left: 50,
            width: 100,
            height: 100,
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close,
                          color: Palette.yellowColor,
                        ),
                        Text(
                          'Retour',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Palette.yellowColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('panier', 0);
                      Navigator.pop(context);
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient()));*/
                    },
                  ),
                ],
              ),
            ),
          ),*/

          ///////////////////////////// Bouton de validation du panier
          Positioned(
            bottom: 20,
            width: 300,
            height: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Recapitulatif(
                        listRecap: listPanier,
                        prix: prixTotal,
                      ),
                    ),
                  );
                }),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    minimumSize: const Size(180, 50)),
                child: Text("Valider le panier pour $prixTotal dh"),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget verticalView(double height, double width, context,
      List<Categorie> listCat, List<Menus> listMenu) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Row(
              children: [
                //////////////// Interface de gauche avec l'image
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: height,
                        color: Palette.violetColor,
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, top: 100, bottom: 100),
                        child: Container(
                          /*padding: const EdgeInsets.only(
                              right: 10, left: 10, top: 100, bottom: 100),*/
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: const Image(
                              image: AssetImage('assets/logo_vert.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      /////////////////// Boutton d'ajout de commande
                      Positioned(
                        top: 50,
                        left: 100,
                        width: 160,
                        height: 100,
                        child: Container(
                          child: Column(
                            children: [
                              InkWell(
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Palette.yellowColor,
                                    ),
                                    Text(
                                      'Ajouter des articles',
                                      style: TextStyle(
                                          fontFamily: 'Allerta',
                                          fontSize: 15,
                                          color: Palette.yellowColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MenuClient(
                                                commande: listCat,
                                                page: 0,
                                                listMenu: listMenu,
                                              )));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ////////////// Interface pour affiche de la commande et des détails
                Expanded(
                  child: Container(
                    height: height,
                    color: Palette.violetColor,
                    child: //panier(),
                        ListView.builder(
                      itemCount: listPanier.length,
                      itemBuilder: (contextT, index) {
                        int count = listPanier[index].nombre!;
                        return Card(
                          elevation: 5,
                          child: SizedBox(
                            height: 155,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          image: DecorationImage(
                                              image: NetworkImage(listPanier[
                                                              index]
                                                          .boisson !=
                                                      null
                                                  ? 'http://13.39.81.126:4009${listPanier[index].imageUrl!}'
                                                  : 'http://13.39.81.126:4003${listPanier[index].imageUrl!}'),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listPanier[index].title!,
                                              style: const TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${listPanier[index].price} MAD',
                                              style: const TextStyle(
                                                  fontFamily: 'Allerta',
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                '${listPanier[index].personnalisation},${listPanier[index].boisson}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    child: /*ajout(
                        listPanier[index].nombre!, listPanier[index].price!),*/
                                        Container(
                                      width: 110,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                setState(() {
                                                  prixTotal = 0;

                                                  if (count > 0) {
                                                    count--;
                                                    listPanier[index].nombre =
                                                        count;

                                                    for (int i = 0;
                                                        i < listPanier.length;
                                                        i++) {
                                                      prixTotal = prixTotal +
                                                          ((listPanier[i]
                                                                      .price!
                                                                      .toInt()) *
                                                                  (listPanier[i]
                                                                      .nombre!
                                                                      .toInt()))
                                                              .toDouble();
                                                      prefs.setInt('panier',
                                                          listPanier.length);
                                                      if (count == 0) {
                                                        listPanier.removeWhere(
                                                            (element) =>
                                                                listPanier[
                                                                        index]
                                                                    .title ==
                                                                element.title);
                                                        if (listPanier
                                                            .isEmpty) {
                                                          prefs.setInt(
                                                              'panier', 0);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MenuClient(
                                                                commande:
                                                                    listCat,
                                                                page: 0,
                                                                listMenu:
                                                                    listMenu,
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    }
                                                  }
                                                  prefs.setString(
                                                      'panierCommande',
                                                      jsonEncode(listPanier));
                                                });
                                              },
                                              child: Icon(
                                                count == 1
                                                    ? Icons.delete
                                                    : Icons.remove,
                                                color: Colors.black,
                                                size: 25,
                                              )),
                                          Expanded(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white),
                                              child: Center(
                                                child: Text(
                                                  listPanier[index]
                                                      .nombre!
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                prixTotal = 0;
                                                count++;
                                                listPanier[index].nombre =
                                                    count;
                                                prefs.setInt('panier',
                                                    listPanier.length + 1);
                                                prefs.setString(
                                                    'panierCommande',
                                                    jsonEncode(listPanier));
                                                for (int i = 0;
                                                    i < listPanier.length;
                                                    i++) {
                                                  prixTotal = prixTotal +
                                                      ((listPanier[i]
                                                                  .price!
                                                                  .toInt()) *
                                                              (listPanier[i]
                                                                  .nombre!
                                                                  .toInt()))
                                                          .toDouble();
                                                }
                                              });
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: Palette.yellowColor,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          /////////////////// Boutton de retour
          /*Positioned(
            top: 35,
            left: 50,
            width: 100,
            height: 100,
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Palette.yellowColor,
                        ),
                        Text(
                          'Annulez',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Palette.yellowColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt('panier', 0);
                      Navigator.pop(context);
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient()));*/
                    },
                  ),
                ],
              ),
            ),
          ),*/

          ///////////////////////////// Bouton de validation du panier
          Positioned(
            bottom: 20,
            width: 300,
            height: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Recapitulatif(
                        listRecap: listPanier,
                        prix: prixTotal,
                      ),
                    ),
                  );
                }),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    minimumSize: const Size(180, 50)),
                child: Text("Valider le panier pour $prixTotal dh"),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
