//import 'package:eatch/pages/commande/commandeClient/accueilMenu.dart';
import 'package:eatch_client/commande/commandeClient/accueilMenu.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getMenu.dart';
import 'package:eatch_client/service/getRestaurant.dart' as r;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Restaurants extends ConsumerStatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  RestaurantsState createState() => RestaurantsState();
}

class RestaurantsState extends ConsumerState<Restaurants> {
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

  var numero = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('----------------------------------------K');
    final viewModel = ref.watch(r.getDataRsetaurantFuture);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 900) {
            return horizontalView(height(context), width(context), context,
                viewModel.listRsetaurant);
          } else {
            return verticalView(height(context), width(context), context,
                viewModel.listRsetaurant);
          }
        },
      ),
    );
  }

  Widget horizontalView(double height, double width, contextt,
      List<r.Restaurant> listRsetaurant) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            opacity: 150,
            image: AssetImage('assets/Eatch.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.refresh(getDataCategoriesFuture);
                  ref.refresh(getDataMenuFuture);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuAccueil(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: listRsetaurant.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        child: Row(children: [
                          Expanded(
                            flex: 2,
                            child: Image.network(
                                'http://13.39.81.126:4002${listRsetaurant[index].infos!.logo.toString()}'),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                listRsetaurant[index].restaurantName!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              minRadius: 50,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                  tooltip: 'Choix du restaurant',
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('idRestaurant',
                                        listRsetaurant[index].sId!);
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.error(
                                        backgroundColor: Colors.green,
                                        message: "Restaurant bien enregistré",
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Palette.greenColors,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Numéro de table'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        controller: numero,
                        textInputAction: TextInputAction.next,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "S'il vous plaît entrez le numero de table .";
                          } else if (value.length < 2) {
                            return "Ce champ doit contenir au moins 2 lettres.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            prefix: const Padding(
                                padding: EdgeInsets.only(left: 0.0)),
                            hintText: "Numero de table*",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(Icons.numbers)),
                        /*onSaved: (value) {
                        numero = value!;
                      },*/
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      minRadius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                          tooltip: 'Valider le numéro de table',
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (numero.text.isNotEmpty) {
                              prefs.setString('numeroTable', numero.text);
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  backgroundColor: Colors.green,
                                  message: "Numéro de table enregistrer",
                                ),
                              );
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  backgroundColor: Colors.red,
                                  message: "Veuillez saisir le numéro de table",
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.done)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalView(
      double height, double width, context, List<r.Restaurant> listRsetaurant) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            opacity: 150,
            image: AssetImage('assets/Eatch.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              height: 60,
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.refresh(getDataCategoriesFuture);
                  ref.refresh(getDataMenuFuture);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuAccueil(),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: listRsetaurant.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        child: Row(children: [
                          Expanded(
                            flex: 2,
                            child: Image.network(
                                'http://13.39.81.126:4002${listRsetaurant[index].infos!.logo.toString()}'),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                listRsetaurant[index].restaurantName!,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              minRadius: 50,
                              backgroundColor: Colors.black,
                              child: IconButton(
                                  tooltip: 'Choix du restaurant',
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    prefs.setString('idRestaurant',
                                        listRsetaurant[index].sId!);
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.error(
                                        backgroundColor: Colors.green,
                                        message: "Restaurant bien enregistré",
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Palette.greenColors,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Numéro de table'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextFormField(
                        controller: numero,
                        textInputAction: TextInputAction.next,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "S'il vous plaît entrez le numero de table .";
                          } else if (value.length < 2) {
                            return "Ce champ doit contenir au moins 2 lettres.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hoverColor: Palette.primaryBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 42, vertical: 20),
                            filled: true,
                            fillColor: Palette.primaryBackgroundColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Palette.secondaryBackgroundColor),
                              gapPadding: 10,
                            ),
                            prefix: const Padding(
                                padding: EdgeInsets.only(left: 0.0)),
                            hintText: "Numero de table*",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(Icons.numbers)),
                        /*onSaved: (value) {
                        numero = value!;
                      },*/
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      minRadius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                          tooltip: 'Valider le numéro de table',
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (numero.text.isNotEmpty) {
                              prefs.setString('numeroTable', numero.text);
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  backgroundColor: Colors.green,
                                  message: "Numéro de table enregistrer",
                                ),
                              );
                            } else {
                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.error(
                                  backgroundColor: Colors.red,
                                  message: "Veuillez saisir le numéro de table",
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.done)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
