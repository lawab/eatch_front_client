import 'package:eatch_client/commande/commandeClient/detailsMenu.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuMenu extends ConsumerStatefulWidget {
  final int page;
  final List<Menus> listMenu;
  const MenuMenu({Key? key, required this.page, required this.listMenu})
      : super(key: key);

  @override
  MenuMenuState createState() => MenuMenuState();
}

class MenuMenuState extends ConsumerState<MenuMenu> {
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
      body: Container(
        padding: const EdgeInsets.all(10),
        child: widget.listMenu.isEmpty
            ? const Center(
                child: Text('Aucun menu disponible'),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 50,
                    mainAxisExtent: 200),
                itemCount: widget.listMenu.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsMenu(
                                    menu: widget.listMenu[index],
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
                                      'http://13.39.81.126:4009${widget.listMenu[index].image!}'),
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
                                    widget.listMenu[index].menuTitle!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    widget.listMenu[index].price.toString(),
                                    style: const TextStyle(color: Colors.white),
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
