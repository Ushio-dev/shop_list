import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_list/src/data/ItemModel.dart';
import 'package:shop_list/src/data/ListaModel.dart';
import 'package:shop_list/src/providers/items_provider.dart';

class ItemsScreen extends StatefulWidget {
  final ListaModel MyLista;
  ItemsScreen({super.key, required this.MyLista});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  ItemProvider? data;
  var lista;
  var id;
  var name;

  @override
  void initState() {
    // TODO: implement initState
    data = Provider.of<ItemProvider>(context, listen: false);
    lista = widget.MyLista;
    id = lista.id;
    name = lista.name;
    context.read<ItemProvider>().fetchItems(id);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    data!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GlobalKey<FormState> formDeleteKey = GlobalKey<FormState>();
    TextEditingController nombreItemController = TextEditingController();
    TextEditingController cantidadController = TextEditingController();
    TextEditingController precioController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      floatingActionButton: MyFab(
        formKey: formKey,
        nombreItemController: nombreItemController,
        cantidadController: cantidadController,
        precioController: precioController,
        idLista: id,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Center(
            child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: context.watch<ItemProvider>().items.length,
                  itemBuilder: (context, index) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          nombreItemController.text =
                              context.read<ItemProvider>().items[index].name;
                          precioController.text = context
                              .read<ItemProvider>()
                              .items[index]
                              .price
                              .toString();
                          cantidadController.text = context
                              .read<ItemProvider>()
                              .items[index]
                              .amount
                              .toString();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                title: const Text(
                                  'Nueva Producto',
                                  textAlign: TextAlign.center,
                                ),
                                content: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Form(
                                        key: formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                autofocus: true,
                                                controller:
                                                    nombreItemController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Nombre",
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Campo requerido";
                                                  }
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: cantidadController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "Cantidad"),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: precioController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            "Precio Unidad"),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      nombreItemController
                                                          .text = "";
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("Cancelar")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        String name =
                                                            nombreItemController
                                                                .text;
                                                        int cantidad =
                                                            cantidadController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? int.parse(
                                                                    cantidadController
                                                                        .text)
                                                                : 1;
                                                        double precio =
                                                            precioController
                                                                    .text
                                                                    .isNotEmpty
                                                                ? double.parse(
                                                                    precioController
                                                                        .text)
                                                                : 0;

                                                        ItemModel nuevoItem =
                                                            ItemModel(
                                                                id: context
                                                                    .read<
                                                                        ItemProvider>()
                                                                    .items[
                                                                        index]
                                                                    .id,
                                                                name: name,
                                                                amount:
                                                                    cantidad,
                                                                price: precio,
                                                                id_lista: id);
                                                        context
                                                            .read<
                                                                ItemProvider>()
                                                            .updateItem(
                                                                nuevoItem,
                                                                index);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child:
                                                        const Text("Agregar")),
                                              ],
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  title: const Text(
                                      "¿Eliminar?", textAlign: TextAlign.center,),
                                  content: Container(
                                    height: 95.0,
                                    child: Column(
                                      children: [
                                        Form(
                                            key: formDeleteKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  "Esta seguro que desea eliminar ${context.read<ItemProvider>().items[index].name}?"),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancelar")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  // eliominar
                                                  context
                                                      .read<ItemProvider>()
                                                      .deleteItem(index);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Confirmar"))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(context
                                    .read<ItemProvider>()
                                    .items[index]
                                    .name),
                                subtitle: Text(
                                    "Cantidad: ${context.read<ItemProvider>().items[index].amount.toString()}"),
                                trailing: Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    "\$" +
                                        context
                                            .read<ItemProvider>()
                                            .items[index]
                                            .price
                                            .toString()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              ),
              Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Total: ${context.read<ItemProvider>().total}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}

class MyFab extends StatelessWidget {
  const MyFab(
      {super.key,
      required this.formKey,
      required this.nombreItemController,
      required this.cantidadController,
      required this.precioController,
      required this.idLista});

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreItemController;
  final TextEditingController cantidadController;
  final TextEditingController precioController;

  final int idLista;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text(
                'Nueva Producto',
                textAlign: TextAlign.center,
              ),
              content: Stack(
                clipBehavior: Clip.none,
                children: [
                  Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              autofocus: true,
                              controller: nombreItemController,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Campo requerido";
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: cantidadController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  const InputDecoration(labelText: "Cantidad"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: precioController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: "Precio Unidad"),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    nombreItemController.text = "";
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancelar")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      String name = nombreItemController.text;
                                      int cantidad = cantidadController
                                              .text.isNotEmpty
                                          ? int.parse(cantidadController.text)
                                          : 1;
                                      double precio = precioController
                                              .text.isNotEmpty
                                          ? double.parse(precioController.text)
                                          : 0;

                                      ItemModel nuevoItem = ItemModel(
                                          name: name,
                                          amount: cantidad,
                                          price: precio,
                                          id_lista: idLista);
                                      context
                                          .read<ItemProvider>()
                                          .nuevoItem(nuevoItem);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text("Agregar")),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
