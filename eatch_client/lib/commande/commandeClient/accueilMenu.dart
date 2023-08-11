import 'dart:convert';
import 'package:eatch_client/paramettre/restaurant.dart' as r;
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getMenu.dart' as m;
import 'package:eatch_client/service/getMenu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:eatch_client/commande/commandeClient/accueilClient.dart';
import 'package:eatch_client/commande/commandeClient/menuu.dart';
import 'package:eatch_client/commande/commandeClient/panier.dart';
import 'package:eatch_client/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MenuAccueil extends ConsumerStatefulWidget {
  const MenuAccueil({Key? key}) : super(key: key);

  @override
  MenuAccueilState createState() => MenuAccueilState();
}

class MenuAccueilState extends ConsumerState<MenuAccueil> {
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
      if (prefs.getString('idRestaurant')!.toString().isNotEmpty) {
        eatch = true;
        print('PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP');
      }
    });
    print('panier');
    print(panier);
  }

  bool eatch = false;
  int panier = 0;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isChecked = false;
  // Show the password or hide it
  bool notVisible = true;
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
    final viewModele = ref.watch(m.getDataMenuFuture);
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
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      opacity: 150,
                      image: AssetImage('assets/Eatch.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      left: 50,
                      width: 300,
                      height: 150,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logo_vert.png'))),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 0,
                      width: 130,
                      height: 50,
                      child: InkWell(
                        child: Container(
                          width: 130.0,
                          decoration: const BoxDecoration(
                            color: Palette.fourthColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: eatch == true
                              ? const Center(
                                  child: Text(
                                    'Eatch',
                                    style: TextStyle(
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(05.0),
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
                        onTap: () {
                          /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Restaurants()));*/
                          dialogAuthentification();
                        },
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 130,
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
                                        builder: (context) =>
                                            const ClientAccueil()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Notre Carte',
                        style: TextStyle(
                            fontFamily: 'Boogaloo',
                            fontSize: 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Nous sommes fiers de travailler avec des ingrédients de qualité supérieure, en privilégiant les produits locaux et durables pour garantir la fraîcheur et le goût de chaque plat.',
                        style: TextStyle(
                            fontFamily: 'Allerta',
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 700,
                  width: width - 100,
                  color: Colors.green,
                  padding: const EdgeInsets.all(15),
                  child: listCat.isEmpty
                      ? const Center(
                          child: Text(
                              'PAS DE MENU DISPONIBLE. Veuillez vous connectez et choisir un restaurant'),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 300),
                          itemCount: listCat.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuClient(
                                              commande: listCat,
                                              page: index,
                                              listMenu: listMenu,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Palette.yellowColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 200,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: listCat[index].title == 'Menu'
                                          ? Image.asset('assets/menu.png')
                                          : Image.network(
                                              'http://13.39.81.126:4005${listCat[index].image!}',
                                              fit: BoxFit.cover),
                                    ),
                                    Container(
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        listCat[index].title!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: Palette.marronColor,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.greenColors,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.violetColor,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.yellowColor,
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
          panier != 0
              ? Positioned(
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
                )
              : Container(),
        ]),
        //padding: EdgeInsets.all(10),
        /*child: */
      ),
    );
  }

  Widget verticalView(double height, double width, contextt,
      List<Categorie> listCat, List<Menus> listMenu) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      opacity: 150,
                      image: AssetImage('Eatch.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(
                      left: 50,
                      width: 300,
                      height: 150,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('logo_vert.png'))),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 0,
                      width: 130,
                      height: 50,
                      child: InkWell(
                        child: Container(
                          width: 130.0,
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
                        onTap: () {
                          /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Restaurants()));*/
                          dialogAuthentification();
                        },
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 130,
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
                                        builder: (context) =>
                                            const ClientAccueil()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Notre Carte',
                        style: TextStyle(
                            fontFamily: 'Boogaloo',
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Nous sommes fiers de travailler avec des ingrédients de qualité supérieure, en privilégiant les produits locaux et durables pour garantir la fraîcheur et le goût de chaque plat.',
                        style: TextStyle(
                            fontFamily: 'Allerta',
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 700,
                  width: width - 100,
                  color: Colors.green,
                  padding: const EdgeInsets.all(15),
                  child: listCat.isEmpty
                      ? const Center(
                          child: Text(
                              'PAS DE MENU DISPONIBLE. Veuillez vous connectez et choisir un restaurant'),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 50,
                                  mainAxisExtent: 300),
                          itemCount: listCat.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MenuClient(
                                              commande: listCat,
                                              page: index,
                                              listMenu: listMenu,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Palette.yellowColor,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 200,
                                      width: 250,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: listCat[index].title == 'Menu'
                                          ? Image.asset('assets/menu.png')
                                          : Image.network(
                                              'http://13.39.81.126:4005${listCat[index].image!}',
                                              fit: BoxFit.cover),
                                    ),
                                    Container(
                                      height: 30,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        listCat[index].title!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: Palette.marronColor,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.greenColors,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.violetColor,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Palette.yellowColor,
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
          panier != 0
              ? Positioned(
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
                )
              : Container(),
        ]),
        //padding: EdgeInsets.all(10),
        /*child: */
      ),
    );
  }

  Future dialogAuthentification() {
    return showDialog(
      context: context,
      builder: (con) {
        return AlertDialog(
          backgroundColor: Palette.marronColor,
          title: const Center(
            child: Text(
              "Authentifaction Manager",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'HelveticaNeue',
              ),
            ),
          ),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(
                Icons.close,
                size: 14,
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              onPressed: () {
                Navigator.of(con, rootNavigator: true).pop();
              },
              label: const Text("Annuler   "),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                color: Palette.marronColor,
                height: MediaQuery.of(context).size.height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo_vert.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ////////////
                      const SizedBox(height: 10),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '    Ne laissez pas vide';
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return null;
                            } else {
                              return '    Entrer un email valide';
                            }
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Nom d'utlisateur",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/user.png"),
                            ),
                            contentPadding: const EdgeInsets.only(top: 16),
                            hintText: "Entrer votre nom d'utilisateur",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          style: GoogleFonts.raleway().copyWith(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          obscureText: notVisible,
                          validator: (valuep) {
                            if (valuep!.isEmpty) {
                              return '    Ne laissez pas vide';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              "Mot de passe",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset("assets/images/cle.png"),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  notVisible = !notVisible;
                                });
                              },
                              icon: Icon(
                                  notVisible == true
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black12),
                            ),
                            hintText: "Entrer votre mot de passe",
                            hintStyle: GoogleFonts.raleway().copyWith(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              // ignore: use_build_context_synchronously
                              login(context, usernameController.text,
                                  passwordController.text);
                              //Navigator.of(con, rootNavigator: true).pop();
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.yellow,
                            ),
                            child: Text(
                              'Se connecter',
                              style: GoogleFonts.raleway().copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Future<void> login(BuildContext context, email, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String url = "http://13.39.81.126:4001/api/users/login";
    print(url);
    print(email);
    print(pass);

    if (pass.isNotEmpty && email.isNotEmpty) {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': pass,
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        prefs.setString('IdUser', data['user']['_id']);
        prefs.setString('UserName',
            '${data['user']['firstName']} ${data['user']['lastName']} ');
        prefs.setString('token', data['accessToken']);

        prefs.setString('Idrole', data['user']['role']);
        print(data['user']['role']);
        var role = data['user']['role'];
        if (role == 'MANAGER') {
          print('gggggggggggg $role');
          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const r.Restaurants()));
        } else {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.info(
              backgroundColor: Palette.deleteColors,
              message: "Seulement le manager peut se connecter",
            ),
          );
        }

        print("Vous êtes connecté");
      } else {
        print("Vous n'êtes pas connecté");
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            backgroundColor: Palette.deleteColors,
            message: "Erreur d'authentification ",
          ),
        );
      }
    } else {
      print("Il y'a une erreur");
    }
  }
}
