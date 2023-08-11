import 'dart:convert';
import 'package:eatch_client/commande/commandeClient/detailsMenu.dart';
import 'package:eatch_client/commande/commandeClient/menuu.dart';
import 'package:eatch_client/commande/commandeClient/panier.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends ConsumerStatefulWidget {
  final Products produit;
  final int page;
  const Details({Key? key, required this.produit, required this.page})
      : super(key: key);

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends ConsumerState<Details> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prix = widget.produit.price!.toInt();
      panier = prefs.getInt('panier')!.toInt();
    });
    print('panier');
    print(panier);
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

  int panier = 0;
  bool perso = false;
  bool oignon = false;
  bool sauce = false;
  bool persoboisson = false;
  bool miranda = false;
  bool miranda2 = false;
  bool coca = false;
  bool coca2 = false;
  int count = 1;
  int prix = 0;
  List<ProduitsCommande> listCommander = [];

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
                                'http://13.39.81.126:4003${widget.produit.image!}'),
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
                    child: recapitulatif(
                        widget.produit.price!.toInt(),
                        widget.produit.category!.title == 'Nos tacos' ||
                                widget.produit.category!.title ==
                                    'Nos Sandwich' ||
                                widget.produit.category!.title ==
                                    'Nos petits cheeses' ||
                                widget.produit.category!.title ==
                                    'Nos accompagnements'
                            ? true
                            : false),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuClient(
                                    commande: listCat,
                                    page: widget.page,
                                    listMenu: listMenu,
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

  Widget verticalView(double height, double width, context,
      List<Categorie> listCat, List<Menus> listMenu) {
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
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, top: 100, bottom: 100),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'http://13.39.81.126:4003${widget.produit.image!}'),
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
                      child: recapitulatif(
                          widget.produit.price!.toInt(),
                          widget.produit.category!.title == 'Nos tacos' ||
                                  widget.produit.category!.title ==
                                      'Nos Sandwich' ||
                                  widget.produit.category!.title ==
                                      'Nos petits cheeses' ||
                                  widget.produit.category!.title ==
                                      'Nos accompagnements'
                              ? true
                              : false),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MenuClient(
                                      commande: listCat,
                                      page: widget.page,
                                      listMenu: listMenu,
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
        ),
      ),
    );
  }

  Widget recapitulatif(int price, bool dessert) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///////////////// Détails du produit
            Container(
              padding: const EdgeInsets.only(right: 50, left: 50, top: 50),
              height: MediaQuery.of(context).size.height - 102,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.produit.productName!,
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
                    '${widget.produit.price} MAD',
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
                    widget.produit.recette!.description!,
                    //'Notre tacos français est un mélange unique de saveurs françaises  et mexicaines, chaque bouchée est remplie de viande tendre, de fromage fondant, de légumes croquants et de sauces délicieuses préparées au jour en respectant le processus de qualité HACCP',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 155, 153, 153),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //////////////////// La personnalisation de la commande
                  dessert == false
                      ? Container()
                      : SizedBox(
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

                  //////////////////////// si selectionner les détails s'affichent sinon non.
                  persoboisson == false ? Container() : boisson(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            ///////////////// FIN Détails du produit
            const SizedBox(
              height: 10,
            ),
            //ajout(price),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: ElevatedButton(
                onPressed: (() async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var aa = ProduitsCommande(
                    id: widget.produit.sId,
                    imageUrl: widget.produit.image,
                    products: [],
                    title: widget.produit.productName,
                    price: widget.produit.price,
                    nombre: count,
                    //boisson: miranda == true ? 'Miranda' : 'Coca Cola',
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ]),
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

////////////////////////// Widget pour les boissons. choix unique
  Widget boisson() {
    return Container(
      child: Column(
        children: [
          InkWell(
            child: Row(
              children: [
                Text(
                  "Miranda",
                  style: TextStyle(
                      color: miranda2 == false ? Colors.white : Colors.grey),
                ),
                Expanded(child: Container()),
                miranda2 == false
                    ? miranda == false
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
              ],
            ),
            onTap: () {
              setState(() {
                if (miranda2 != true) {
                  miranda = !miranda;
                  coca2 = !coca2;
                }
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Row(
              children: [
                Text(
                  "Coca-Cola",
                  style: TextStyle(
                      color: coca2 == false ? Colors.white : Colors.grey),
                ),
                Expanded(child: Container()),
                coca2 == false
                    ? coca == false
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
              ],
            ),
            onTap: () {
              setState(() {
                if (coca2 != true) {
                  coca = !coca;
                  miranda2 = !miranda2;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
