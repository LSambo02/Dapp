import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:despensa/models/Prateleira.dart';
import 'package:despensa/services/auth_service.dart';
import 'package:despensa/services/familia_service.dart';
import 'package:despensa/services/prateleira_service.dart';
import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/utils/GetIt.dart';
import 'package:despensa/utils/app_colors.dart';
import 'package:despensa/utils/constantes.dart';
import 'package:despensa/utils/sharedPreferences.dart';
import 'package:despensa/widgets/add_shelve_dialog.dart';
import 'package:despensa/widgets/family_menu_dialog.dart';
import 'package:despensa/widgets/new_family_dialog.dart';
import 'package:despensa/widgets/no_data.dart';
import 'package:despensa/widgets/remove_shelve_dialog.dart';
import 'package:flutter/material.dart';

import '../services/produto_service.dart';
import '../widgets/custom_rounded_button.dart';
import '../widgets/existing_family_dialog.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String familyName = '';
  String user = 'user';
  late ProdutosServices produtosService;

  var controller = 0;

  @override
  void initState() {
    super.initState();
    getIt<UserState>().readFamilyId().whenComplete(() {}).then((value) {
      if (value != null) {
        dev.log('dashboard.dart::: preferences is not null');
        getIt<FamiliaService>().setFamilia(value).whenComplete(() {
          // setState(() {
        }).then((value) {
          setState(() => familyName = value!.nome);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 20,
                    top: heightScreen(context) / 20,
                    right: 20,
                    bottom: 0),
                margin: EdgeInsets.all(0),
                height: heightScreen(context) / 3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: shadesOfGrey,
                  begin: Alignment.centerLeft,
                  end: Alignment(
                    0.3,
                    3,
                  ),
                )),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10),
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.shopping_basket_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pushNamed(
                                context, lista_compras_screen),
                          ),
                          IconButton(
                              icon: Icon(Icons.settings_outlined,
                                  color: Colors.white),
                              onPressed: () => Navigator.pushNamed(
                                  context, settings_screen)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 10),
                                child: ClipOval(
                                  child: getIt<AuthService>().user!.photoURL !=
                                          null
                                      ? Image.network(
                                          getIt<AuthService>().user!.photoURL!,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                        )
                                      : Image.asset(
                                          'assets/person-icon.jpeg',
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                        ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Olá, ${getIt<AuthService>().user!.displayName ?? getIt<AuthService>().user!.email} ",
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  familyName.isNotEmpty
                                      ? Text(
                                          "Família $familyName",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : Text("Sem Família",
                                          style:
                                              TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(70))),
                height: heightScreen(context) / 1.2,
                margin: EdgeInsets.only(
                  top: heightScreen(context) / 4.5,
                ),
                child: getIt<FamiliaService>().familia.id == ''
                    ? Center(
                        child: CustomRoundedButton(
                        text: 'Aderir a Família',
                        action: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => familyDialog()),
                      ))
                    : StreamBuilder<QuerySnapshot>(
                        stream: getIt<PrateleiraService>()
                            .familias
                            .doc(getIt<FamiliaService>().familia.id)
                            .collection('prateleiras')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          // print(snapshot.data.docs);
                          if (snapshot.hasError) {
                            return Text('Occorreu um erro');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                        document.data()!
                                            as Map<String, dynamic>;

                                    Shelve shelve =
                                        Shelve.fromJson(_prateleirasMap);

                                    getIt<PrateleiraService>()
                                        .addPrateleirasTemp(
                                            shelve.nome, document.id);
                                    String nrItens = '0';
                                    // if (controller == 0) {
                                    //   log('okay');
                                    produtosService =
                                        ProdutosServices(shelve.nome);
                                    produtosService
                                        .getAllProducts(snapshot.data!.docs);
                                    // setState(() {
                                    controller += 1;
                                    // produtosService
                                    //     .countShelveProducts(shelve)
                                    //     .then<Widget>((value) {
                                    //   // setState(() {
                                    //   nrItens = value.toString();
                                    //   // });
                                    //   log('dashboard message: $nrItens');

                                    // });
                                    // }

                                    return FutureBuilder<int?>(
                                        future: produtosService
                                            .countShelveProducts(shelve),
                                        builder: (context, snapshot) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: Dismissible(
                                              key: Key(document.id),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors.red,
                                              ),
                                              onDismissed: (direction) {
                                                setState(() {
                                                  getIt<PrateleiraService>()
                                                      .deleteShelve(shelve.nome,
                                                          document.id);
                                                });
                                              },
                                              confirmDismiss: (direction) =>
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return RemoveShelveDialog(
                                                          width: widthScreen(
                                                              context),
                                                        );
                                                      }),
                                              child: Card(
                                                elevation: 5,
                                                margin: EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(60),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    60))),
                                                child: new ListTile(
                                                  title: new Text(
                                                    shelve.nome,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black),
                                                  ),
                                                  leading:
                                                      Image.asset(shelveIcon),
                                                  subtitle: new Text(
                                                    '${snapshot.data.toString()} itens',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        color: Colors.black),
                                                  ),
                                                  onTap: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          produtos_screen,
                                                          arguments:
                                                              shelve.nome),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                    // });
                                  }).toList(),
                                );
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AddShelve(width: widthScreen(context));
              }),
        )
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

  Widget familyDialog() {
    return FamilyDialog(
        text1: 'Família Existente',
        text2: 'Criar Família',
        action1: () => showDialog(
            context: context,
            builder: (BuildContext context) => ExistingFamilyDialog()),
        action2: () => showDialog(
            context: context,
            builder: (BuildContext context) => NewFamilyDialog()));
  }
}
