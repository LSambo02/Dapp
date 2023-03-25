import 'dart:developer';

import 'package:despensa/models/Produto.dart';
import 'package:despensa/screens/single_product_screen.dart';
import 'package:despensa/services/ListaComprasController.dart';
import 'package:despensa/services/prateleira_service.dart';
import 'package:despensa/services/produto_service.dart';
import 'package:despensa/utils/AppPhoneSize.dart';
import 'package:despensa/utils/GetIt.dart';
import 'package:despensa/utils/constantes.dart';
import 'package:despensa/widgets/compraItem.dart';
import 'package:despensa/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_platform/universal_platform.dart';

class SavedListComprasScreen extends StatefulWidget {
  List? items;
  String? nome;
  SavedListComprasScreen({Key? key, required this.items, required this.nome})
      : super(key: key);

  @override
  _SavedListComprasScreenState createState() => _SavedListComprasScreenState();
}

class _SavedListComprasScreenState extends State<SavedListComprasScreen> {
  late String familyName;
  late ProdutosServices produtosServices;
  String sharableList = '';

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (Map<String, dynamic> prodMap in widget.items!) {
      Produto prod = Produto.fromJson(prodMap);
      double qntd = prod.quantidade - prod.disponivel;
      double subtotal = 0;
      log('lista_compras_screen.dart::: prod: ${prod.toJson()}');

      if (prod.pUnit != null) {
        // print(total);
        subtotal = prod.pUnit * qntd;
        total = total + subtotal;
      }
      sharableList += '- ';
      sharableList +=
          '${prod.nome}\n Quant: $qntd ${prod.unidade}| Preço Unit.: ${prod.pUnit}0| Subt.: ${subtotal}0MZN';
      sharableList += '\n';
    }
    sharableList += '\nTotal: ${total}0MZN';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lista de Compras',
        actions: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.save,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) =>
                  //             SaveDialog(widget.items!.toList()));
                  //   },
                  // ),
                  IconButton(
                    icon: Icon(
                      !UniversalPlatform.isIOS
                          ? Icons.share_outlined
                          : Icons.ios_share,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Share.share(sharableList);
                    },
                  ),
                ],
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
                height: 40,
                color: Colors.blueGrey,
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 30),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: widthScreen(context) / 40,
                        ),
                        text: 'Total\n',
                        children: [
                          TextSpan(
                            text: '${total}$currency',
                            style:
                                TextStyle(fontSize: widthScreen(context) / 30),
                          )
                        ]),
                  ),
                )),
            Divider(),
            Container(
                height: heightScreen(context) / 1.2,
                margin: EdgeInsets.all(0),
                child: ListView.separated(
                  separatorBuilder: (context, int index) => Divider(
                    thickness: 1,
                  ),
                  itemBuilder: (context, int index) {
                    Produto produto = Produto.fromJson(widget.items![index]);
                    double qntd = produto.quantidade - produto.disponivel;
                    produtosServices = ProdutosServices(
                        getIt<PrateleiraService>()
                            .prateleirasMap[produto.prateleira]);
                    return new ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          produto.nome,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      leading: Icon(Icons.fastfood_outlined),
                      subtitle: CompraItem(
                          descricao: produto.unidade ?? '',
                          qntd: qntd.toString(),
                          pUnit: produto.pUnit != null
                              ? '${produto.pUnit}$currency'
                              : '--',
                          pTotal: produto.pUnit != null
                              ? '${produto.pUnit * qntd}$currency'
                              : '--'),
                      trailing: Container(
                        alignment: Alignment.center,
                        width: widthScreen(context) / 5.5,
                        height: double.infinity,
                        child: Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blueGrey[400],
                              padding: EdgeInsets.all(0),
                            ),
                            child: Text('Repor'),
                            onPressed: () {
                              setState(() {
                                produto.setDisponivel(
                                    produto.quantidade.toDouble());
                                produtosServices
                                    .updateProduto(produto)
                                    .whenComplete(() {})
                                    .then((value) {
                                  setState(() {
                                    getIt<ListaComprasController>()
                                        .removeProductItem(produto);
                                  });
                                });
                              });
                            },
                          ),
                        ),
                      ),
                      isThreeLine: false,
                      // enabled: false,
                      onTap: () {
                        //   // =>
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SingleProductPage(produto)));
                      },
                    );
                  },
                  itemCount: widget.items!.length,
                ))
          ],
        ),
      ),
    );
  }
}
