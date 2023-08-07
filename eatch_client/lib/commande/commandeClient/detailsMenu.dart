import 'dart:convert';
import 'package:eatch_client/commande/commandeClient/menuu.dart';
import 'package:eatch_client/commande/commandeClient/panier.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart' as cat;
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsMenu extends ConsumerStatefulWidget {
  final Menus menu;
  final int page;
  const DetailsMenu({Key? key, required this.menu, required this.page})
      : super(key: key);

  @override
  DetailsMenuState createState() => DetailsMenuState();
}

class DetailsMenuState extends ConsumerState<DetailsMenu> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prix = widget.menu.price!.toInt();
      panier = prefs.getInt('panier')!.toInt();
    });
    print('panier');
    print(panier);
  }

  int panier = 0;
  bool perso = false;
  bool oignon = false;
  bool sauce = false;
  bool persoboisson = true;
  bool miranda = false;
  bool miranda2 = false;
  bool coca = false;
  bool coca2 = false;
  int count = 1;
  int prix = 0;
  List<ProduitsCommande> listCommander = [];
  List<cat.Products> listBoisson = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cat.getDataCategoriesFuture);
    listBoisson.clear();
    listBoisson.addAll(viewModel.listBoisson);
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                //////////////// Interface de gauche avec l'image
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(100),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                            image: NetworkImage(
                                'http://13.39.81.126:4009${widget.menu.image!}'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
                ////////////// Interface pour affiche de la commande et des détails
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Palette.violetColor,
                    child: recapitulatif(widget.menu.price!.toInt()),
                  ),
                )
              ],
            ),
          ),
          /////////////////// Boutton de retour
          Positioned(
            top: 25,
            right: 50,
            width: 100,
            height: 100,
            child: Container(
              child: Column(
                children: [
                  InkWell(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text(
                          'Accueil',
                          style: TextStyle(
                              fontFamily: 'Allerta',
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      ref.refresh(cat.getDataCategoriesFuture);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient(
                                    commande: viewModel.listCategori,
                                    page: widget.page,
                                  )));
                    },
                  ),
                ],
              ),
            ),
          ),
          panier == 0
              ? Container()
              : Positioned(
                  left: 0,
                  top: MediaQuery.of(context).size.height / 2 - 50,
                  width: 100,
                  height: 100,
                  child: InkWell(
                    child: Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Palette.marronColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Panier',
                              style: TextStyle(
                                  fontFamily: 'Boogaloo',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$panier produits',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                        /**/
                        ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Panier()));
                    },
                  ),
                ),
        ],
      )),
    );
  }

  Widget recapitulatif(int price) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Stack(alignment: Alignment.center, children: [
          /////////////////// Boutton de validation de la commande
          Positioned(
            bottom: 20,
            width: 300,
            height: 50,
            child: Container(
                child: ElevatedButton(
              onPressed: (() async {
                var liquide = '';
                int countt = 0;
                for (int i = 0; i < listBoisson.length; i++) {
                  if (listBoisson[i].choix == true) {
                    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
                    countt++;
                  }
                }

                List<Products> products = [];
                for (int i = 0; i < widget.menu.products!.length; i++) {
                  if (widget.menu.products![i].category!.title != 'Sodas' &&
                      widget.menu.products![i].category!.title != 'Jus') {
                    products.add(widget.menu.products![i]);
                  }
                }
                print('coooouuunnntttt $countt');
                for (int i = 0; i < listBoisson.length; i++) {
                  if (listBoisson[i].choix == true) {
                    print(
                        '**************************************************** $i');
                    /*for (int j = 0; j < widget.menu.products!.length; j++) {
                      if (listBoisson[i].sId) {}
                    }*/

                    if (countt < 2) {
                      liquide = listBoisson[i].productName!;
                      products.add(listBoisson[i]);
                    } else {
                      if (listBoisson[i].sId != boison) {
                        liquide = listBoisson[i].productName!;
                        products.add(listBoisson[i]);
                      }
                    }
                  }
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var aa = ProduitsCommande(
                  id: widget.menu.sId,
                  imageUrl: widget.menu.image,
                  title: widget.menu.menuTitle,
                  price: prix,
                  nombre: count,
                  products: products,
                  boisson: liquide,
                  personnalisation: sauce == true && oignon == true
                      ? 'Sauce, Oignon'
                      : sauce == true
                          ? 'Sauce'
                          : oignon == true
                              ? 'Oignon'
                              : 'Rien',
                );

                String tt = prefs.getString('panierCommande').toString();

                int article = 0;
                // ignore: unnecessary_null_comparison
                if (tt != 'null') {
                  var panierCommande = jsonDecode(tt);
                  for (int i = 0; i < panierCommande.length; i++) {
                    listCommander
                        .add(ProduitsCommande.fromJson(panierCommande[i]));
                  }
                  print('6');

                  listCommander.add(aa);
                } else {
                  print('2');
                  listCommander.add(aa);
                }

                var jj = jsonEncode(listCommander);

                prefs.setString('panierCommande', jj);
                article = listCommander.length;
                prefs.setInt('panier', article);
                print('list');
                print(prefs.getString('panierCommande').toString());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Panier()));
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  minimumSize: const Size(180, 50)),
              child: Text("Ajouter au panier $count pour $prix dh"),
            )),
          ),
          /////////////////// Box d'ajout de la quantité
          Positioned(
            bottom: 90,
            width: 100,
            height: 40,
            child: ajout(price),
          ),
          ///////////////// Détails du produit
          Container(
            padding: const EdgeInsets.all(50),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.menu.menuTitle!,
                    style: const TextStyle(
                        fontFamily: 'Allerta',
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.menu.price} MAD',
                    style: const TextStyle(
                        fontFamily: 'Allerta',
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.menu.description!,
                    //'Notre tacos français est un mélange unique de saveurs françaises  et mexicaines, chaque bouchée est remplie de viande tendre, de fromage fondant, de légumes croquants et de sauces délicieuses préparées au jour en respectant le processus de qualité HACCP',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 155, 153, 153),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //////////////////// La personnalisation de la commande
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      child: Row(
                        children: [
                          const Text(
                            "Personnaliser votre commande",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Container()),
                          perso == false
                              ? const Icon(
                                  Icons.arrow_right_rounded,
                                  color: Palette.yellowColor,
                                  size: 40,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Palette.yellowColor,
                                  size: 40,
                                ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          perso = !perso;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //////////////////////// SI la personnalisation est choisi les détails s'affichent sinon non
                  perso == false ? Container() : personnalisation(),
                  const SizedBox(
                    height: 20,
                  ),
                  ////////////////////// Choix de la boisson
                  SizedBox(
                    height: 50,
                    child: InkWell(
                      child: Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Choisir sa boisson",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Choisir un article",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Palette.yellowColor,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: const Text(
                                          '   Obligatoire   ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                          persoboisson == false
                              ? const Icon(
                                  Icons.arrow_right_rounded,
                                  color: Palette.yellowColor,
                                  size: 40,
                                )
                              : const Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Palette.yellowColor,
                                  size: 40,
                                ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          persoboisson = !persoboisson;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //////////////////////// si selectionner les détails s'affichent sinon non.
                  persoboisson == false ? Container() : boisson(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          ///////////////// FIN Détails du produit
        ]),
      ),
    );
  }

///////////////////////Widget du box d'ajout de quantité
  Widget ajout(int price) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Palette.greenColors),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                /*for (int i = 0; i < listBoisson.length; i++) {
                  for (int j = 0; j < widget.menu.products!.length; j++) {
                    if (widget.menu.products![i].category!.title == 'Sodas' ||
                        widget.menu.products![i].category!.title == 'Jus') {

                        }
                  }
                  if (index != i) {
                    listBoisson[i].choixTotal = !listBoisson[i].choixTotal!;
                  }
                }*/
                setState(() {
                  if (count > 1) {
                    prix = 0;
                    count--;
                    prix = price * count;
                  }
                });
              },
              child: const Icon(
                Icons.remove,
                color: Colors.white,
                size: 16,
              )),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3), color: Colors.white),
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  prix = 0;
                  count++;
                  prix = price * count;
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              )),
        ],
      ),
    );
  }

////////////////////////// Widget pour la personnalisation. choix multiple
  Widget personnalisation() {
    return Container(
      child: Column(
        children: [
          InkWell(
            child: Row(
              children: [
                const Text(
                  "Sauce",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(child: Container()),
                sauce == false
                    ? const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Palette.yellowColor,
                      )
                    : const Icon(
                        Icons.done_outline_rounded,
                        color: Palette.yellowColor,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                sauce = !sauce;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Row(
              children: [
                const Text(
                  "Sans oignon",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(child: Container()),
                oignon == false
                    ? const Icon(
                        Icons.add_circle_outline_outlined,
                        color: Palette.yellowColor,
                      )
                    : const Icon(
                        Icons.done_outline_rounded,
                        color: Palette.yellowColor,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                oignon = !oignon;
              });
            },
          ),
        ],
      ),
    );
  }

  var boison = '';
////////////////////////// Widget pour les boissons. choix unique
  Widget boisson() {
    //listBoisson
    return Container(
        height: (50 * listBoisson.length).toDouble(),
        child: ListView.builder(
          itemCount: listBoisson.length,
          itemBuilder: (context, index) {
            print(jsonEncode(widget.menu));
            var diff = 0;
            print('----------------------------------------');
            print('object');

            for (int i = 0; i < widget.menu.products!.length; i++) {
              if (widget.menu.products![i].category!.title == 'Sodas' ||
                  widget.menu.products![i].category!.title == 'Jus') {
                if (listBoisson[index].sId != widget.menu.products![i].sId) {
                  print('kkkkkkkkkkkkkkkk');
                  diff = listBoisson[index].price!.toInt() -
                      widget.menu.products![i].price!.toInt();
                } else {
                  listBoisson[index].choix = true;
                  boison = listBoisson[index].sId!;
                }
              }
            }

            return Column(
              children: [
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        listBoisson[index].productName!,
                        style: TextStyle(
                            color: listBoisson[index].choixTotal == false
                                ? Colors.white
                                : Colors.grey),
                      ),
                      Expanded(child: Container()),
                      Text(
                        diff < 0 ? diff.toString() : '+ ${diff.toString()}',
                        style: TextStyle(
                            color: listBoisson[index].choixTotal == false
                                ? Colors.white
                                : Colors.grey),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      /////////////////
                      listBoisson[index].choixTotal == false
                          ? listBoisson[index].choix == false
                              ? const Icon(
                                  Icons.add_circle_outline_outlined,
                                  color: Palette.yellowColor,
                                )
                              : const Icon(
                                  Icons.done_outline_rounded,
                                  color: Palette.yellowColor,
                                )
                          : const Icon(
                              Icons.add_circle_outline_outlined,
                              color: Colors.grey,
                            ),
                      /////////////////
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (listBoisson[index].choixTotal != true) {
                        listBoisson[index].choix = !listBoisson[index].choix!;
                        if (listBoisson[index].choix == true) {
                          prix = prix + diff;
                        } else {
                          prix = prix - diff;
                        }
                        for (int i = 0; i < listBoisson.length; i++) {
                          if (index != i) {
                            listBoisson[i].choixTotal =
                                !listBoisson[i].choixTotal!;
                          }
                        }
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          },
        ));
  }
}

class ProduitsCommande {
  String? id;
  String? imageUrl;
  String? title;
  int? price;
  int? nombre;
  String? boisson;
  List<Products>? products;
  String? personnalisation;

  ProduitsCommande(
      {this.id,
      this.imageUrl,
      this.title,
      this.price,
      this.nombre,
      this.boisson,
      this.products,
      this.personnalisation});

  ProduitsCommande.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    price = json['price'];
    nombre = json['nombre'];
    boisson = json['boisson'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    personnalisation = json['personnalisation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['price'] = price;
    data['nombre'] = nombre;
    data['boisson'] = boisson;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['personnalisation'] = personnalisation;
    return data;
  }
}
