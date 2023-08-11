import 'package:eatch_client/commande/commandeClient/accueilClient.dart';
import 'package:eatch_client/palette.dart';
import 'package:eatch_client/service/getCategorie.dart';
import 'package:eatch_client/service/getCommande.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumCommande extends ConsumerStatefulWidget {
  final int numero;
  const NumCommande({Key? key, required this.numero}) : super(key: key);

  @override
  NumCommandeState createState() => NumCommandeState();
}

class NumCommandeState extends ConsumerState<NumCommande> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.yellowColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Palette.marronColor),
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Merci chers client pour votre commande. Votre numéro est le suivant',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.greenColors),
                        onPressed: () {
                          ref.refresh(getDataCategoriesFuture);
                          ref.refresh(getDataCommandeFuture);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClientAccueil(),
                            ),
                          );
                        },
                        child: const Text('Ok'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ) /*IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    
                  },
                ),*/
                  ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height - 300,
                child: Text(
                  'N° ${widget.numero}',
                  style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
