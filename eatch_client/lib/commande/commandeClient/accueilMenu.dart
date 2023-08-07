import 'dart:convert';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:http/http.dart' as http;
import 'package:eatch_client/commande/commandeClient/accueilClient.dart';
import 'package:eatch_client/commande/commandeClient/menuu.dart';
import 'package:eatch_client/commande/commandeClient/panier.dart';
import 'package:eatch_client/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    });
    print('panier');
    print(panier);
  }

  int panier = 0;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listCategori);
          } else {
            return verticalView(height(context), width(context), context);
          }
        },
      ),
    );
  }

  Widget horizontalView(
      double height, double width, context, List<Categorie> listCat) {
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
                              child: Row(
                                children: const [
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
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
                  height: 500,
                  width: width - 100,
                  color: Colors.green,
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
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
                                      borderRadius: BorderRadius.circular(15.0),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        color: Colors.black,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Colors.black,
                      )),
                      const VerticalDivider(
                        width: 2,
                      ),
                      Expanded(
                          child: Container(
                        color: Colors.black,
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

  Widget verticalView(double height, double width, context) {
    return Scaffold(body: Container());
  }

  Future<void> login(BuildContext context, email, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String url =
        "http://13.39.81.126:4001/api/users/login"; //13.39.81.126:4001 //13.39.81.126:4001 // $adress_url
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
        prefs.setString("isLogin", 'true');

        prefs.setString('Idrole', data['user']['role']);
        print(data['user']['role']);

        /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Accueil()));*/

        print("Vous êtes connecté");
      } else {
        prefs.setString("isLogin", 'false');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email ou Mot de passe incorrect."),
        ));

        print("Vous n'êtes pas connecté");
      }
    } else {
      print("Il y'a une erreur");
    }
  }
}
