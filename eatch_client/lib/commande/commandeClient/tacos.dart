import 'package:eatch_client/commande/commandeClient/detail.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:flutter/material.dart';

class Tacos extends StatefulWidget {
  final List<Products> produits;
  final int page;
  const Tacos({Key? key, required this.produits, required this.page})
      : super(key: key);

  @override
  TacosState createState() => TacosState();
}

class TacosState extends State<Tacos> {
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
    return Scaffold(
      backgroundColor: Palette.yellowColor,
      body: widget.produits.isEmpty
          ? const Center(
              child: Text(
                'Aucun produit disponible',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 50,
                      mainAxisExtent: 200),
                  itemCount: widget.produits.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                      produit: widget.produits[index],
                                      page: widget.page,
                                    )));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 160,
                              width: 200,
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'http://13.39.81.126:4003${widget.produits[index].image!}'),
                                    fit: BoxFit.cover),
                              ),
                              child: const Icon(
                                Icons.add_box,
                                color: Colors.black,
                                size: 35,
                              ),
                            ),
                            Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.produits[index].productName!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Expanded(child: Container()),
                                    Text(
                                      widget.produits[index].price.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
