import 'package:advanced/Catalog.dart';import 'package:advanced/Cart.dart';
import 'package:advanced/models/CartModel.dart';
import 'package:advanced/models/Catalog.dart';
import 'package:flutter/material.dart';
import 'search_demo.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CatalogModel(),),
        ChangeNotifierProxyProvider<CatalogModel,CartModel>(
          create: (_) => CartModel(),
          update: (context,catalog,cart){
            if(cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },)
      ],
      child: MaterialApp(
        title: 'Provider',
        initialRoute: '/',
        routes: {
          '/':(_)=> const MyCatalog(),
          '/cart': (_)=> const MyCart(),
        },
      ),
    );
  }
}
