import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despensa/screens/saved_list_screen.dart';
import 'package:flutter/material.dart';

import '../models/ListaCompras.dart';
import '../services/familia_service.dart';
import '../services/lista_compras_service.dart';
import '../utils/AppPhoneSize.dart';
import '../utils/GetIt.dart';
import '../utils/constantes.dart';
import '../widgets/custom_appBar.dart';
import '../widgets/no_data.dart';
import '../widgets/remove_shelf_dialog.dart';

class DisplayListasCompras extends StatefulWidget {
  DisplayListasCompras({Key? key}) : super(key: key);

  @override
  State<DisplayListasCompras> createState() => _DisplayListasComprasState();
}

class _DisplayListasComprasState extends State<DisplayListasCompras> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Listas de Compras',
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: heightScreen(context) / 1.2,
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: getIt<ListaComprasService>()
                    .familias
                    .doc(getIt<FamiliaService>().familia.id)
                    .collection(listaCompras_colecao)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  // print(snapshot.data.docs);
                  if (snapshot.hasError) {
                    return Text('Occorreu um erro');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("SEM DADOS"),
                    );
                  }
                  // List shlvs = [];
                  // for (var shlv in snapshot.data!.docs) {}
                  return snapshot.data!.docs.length == 0
                      ? NoData()
                      : ListView(
                          children: snapshot.data!.docs
                              .map<Widget>((DocumentSnapshot document) {
                            Map<String, dynamic> _prateleirasMap =
                                document.data()! as Map<String, dynamic>;

                            ListaCompras listaCompras =
                                ListaCompras.fromJson(_prateleirasMap);

                            // getIt<ListaComprasService>()
                            //     .addPrateleirasTemp(listaCompras.nomeLista, document.id);
                            // if (controller == 0) {
                            //   log('okay');
                            // produtosService = ProdutosServices(shelve.nome);
                            // produtosService.getAllProducts(snapshot.data!.docs);
                            // setState(() {
                            // controller += 1;
                            // produtosService
                            //     .countShelveProducts(shelve)
                            //     .then<Widget>((value) {
                            //   // setState(() {
                            //   nrItens = value.toString();
                            //   // });
                            //   log('dashboard message: $nrItens');

                            // });
                            // }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Dismissible(
                                key: Key(document.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    getIt<ListaComprasService>()
                                        .deleteListaCompra(
                                            listaCompras.nomeLista!,
                                            document.id);
                                  });
                                },
                                confirmDismiss: (direction) => showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return RemoveShelveDialog(
                                        width: widthScreen(context),
                                        item: 'LISTA',
                                      );
                                    }),
                                child: Card(
                                  elevation: 5,
                                  margin: EdgeInsets.all(0),
                                  child: new ListTile(
                                    title: new Text(
                                      listaCompras.nomeLista!,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    leading: Image.asset(shelveIcon),
                                    subtitle: new Text(
                                      snapshot.data.toString().isNotEmpty
                                          ? '${listaCompras.lista!.length ?? ''}  itens'
                                          : '',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.black),
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SavedListComprasScreen(
                                                  nome: listaCompras.nomeLista,
                                                  items: listaCompras.lista,
                                                ))),
                                  ),
                                ),
                              ),
                            );

                            // });
                          }).toList(),
                        );
                },
              ),
            ),
          ],
        ),
      ),

      // SpeedDialFabWidget(
      //     primaryIconExpand: Icons.add,
      //     primaryIconCollapse: Icons.clear,
      //     secondaryIconsList: [
      //       Icons.local_grocery_store_outlined,
      //       Icons.amp_stories_outlined,
      //     ],
      //     secondaryIconsText: [
      //       "Adicionar Produto",
      //       "Adicionar Prateleira",
      //     ],
      //     secondaryIconsOnPress: [
      //       () => Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => AddProductPage()),
      //           ),
      //       () => showDialog(
      //           context: context,
      //           barrierDismissible: true,
      //           builder: (BuildContext context) {
      //             return AddShelve(width: widthScreen(context));
      //           }),
      //     ],
      //     primaryBackgroundColor: Colors.blueGrey,
      //     primaryForegroundColor: Colors.white,
      //   )
    );
  }
}
