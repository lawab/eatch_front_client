import 'package:eatch_client/commande/commandeClient/accueilMenu.dart';
import 'package:eatch_client/commande/commandeClient/menuMenu.dart';
import 'package:eatch_client/commande/commandeClient/panier.dart';
import 'package:eatch_client/commande/commandeClient/tacos.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuClient extends ConsumerStatefulWidget {
  final List<Categorie> commande;
  final int page;
  const MenuClient({Key? key, required this.commande, required this.page})
      : super(key: key);

  @override
  MenuClientState createState() => MenuClientState();
}

class MenuClientState extends ConsumerState<MenuClient> {
  @override
  void initState() {
    aa();
    // TODO: implement initState
    super.initState();
  }

  void aa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      panier = prefs.getInt('panier')!.toInt();
    });
    print('panier');
    print(panier);
  }

  int panier = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.page,
      length: widget.commande.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.marronColor,
          centerTitle: true,
          title: const Text('EATCH'),
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuAccueil()));
              }),
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    color: Palette.violetColor,
                    child: TabBar(
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          const Color.fromARGB(255, 219, 220, 224),
                      tabs: [
                        for (int i = 0; i < widget.commande.length; i++)
                          Tab(
                            text: widget.commande[i].title,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(
                      children: [
                        for (int i = 0; i < widget.commande.length; i++)
                          Container(
                            child: widget.commande[i].title != 'Menu'
                                ? Tacos(
                                    produits: widget.commande[i].products!,
                                    page: i,
                                  )
                                : MenuMenu(
                                    page: i,
                                  ),
                          ),
                        /*Container(
                          child: Tacos(
                            produits: widget.commande[0].products!,
                          ),
                        ),
                        Container(
                          child: Boisson(
                            produits: widget.commande[2].products!,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 0,
              width: 130,
              height: 50,
              child: Container(
                width: 130.0,
                /*padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),*/
                decoration: const BoxDecoration(
                  color: Palette.fourthColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(05.0),
                        child: const Icon(Icons.person)),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 05.0,
                        ),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
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
                                style: const TextStyle(color: Colors.white),
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
}
