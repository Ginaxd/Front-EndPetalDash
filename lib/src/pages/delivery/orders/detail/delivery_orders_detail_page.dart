import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petaldash/src/models/product.dart';
import 'package:petaldash/src/models/user.dart';
import 'package:petaldash/src/utils/relative_time_util.dart';
import 'package:petaldash/src/widgets/no_data_widget.dart';

import 'package:petaldash/src/pages/delivery/orders/detail/delivery_orders_detail_controller.dart';

class DeliveryOrdersDetailPage extends StatelessWidget {

  DeliveryOrdersDetailController con = Get.put(DeliveryOrdersDetailController());


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height:MediaQuery.of(context).size.height * 0.45,
        padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            _dataDate(),
            _dataClient(),
            _dataAddress(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Order #${con.order.id}',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: con.order.products!.isNotEmpty
          ? ListView(
        children: con.order.products!.map((Product product) {
          return _cardProduct(product);
        }).toList(),
      )
          : Center(
          child: NoDataWidget(text: 'No hay ningun producto agregado aun')
      ),
    ));
  }

  Widget _dataClient() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Cliente y Telefono'),
        subtitle: Text('${con.order.client?.name ?? ''} ${con.order.client?.lastname ?? ''} - ${con.order.client?.phone ?? ''}'),
        trailing: Icon(Icons.person),
      ),
    );
  }



  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Direccion de entrega'),
        subtitle: Text(con.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }

  Widget _dataDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('Fecha del pedido'),
        subtitle: Text('${RelativeTimeUtil.getRelativeTime(con.order.timestamp ?? 0)}'),
        trailing: Icon(Icons.timer),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Cantidad: ${product.quantity}',
                style: TextStyle(
                  // fontWeight: FontWeight.bold
                    fontSize: 13
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage('assets/img/no-image.png') as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage('assets/img/no-image.png'),
        ),
      ),
    );
  }

  // Widget _totalToPay(BuildContext context) {
  //   return Column(
  //     children: [
  //       Divider(height: 1, color: Colors.grey[300]),
  //       con.order.status == 'PAGADO'
  //           ? Container(
  //         width: double.infinity,
  //         alignment: Alignment.centerLeft,
  //         margin: EdgeInsets.only(left: 30, top: 10),
  //         child: Text(
  //           'ASIGNAR REPARTIDOR',
  //           style: TextStyle(
  //               fontStyle: FontStyle.italic,
  //               color: Color(0xFF540748)
  //           ),
  //         ),
  //       )
  //           : Container(),
  //       con.order.status == 'PAGADO' ? _dropDownDeliveryMen(con.users) : Container(),
  //       Container(
  //         margin: EdgeInsets.only(left: con.order.status == 'PAGADO' ? 30 : 37, top: 15),
  //         child: Row(
  //           mainAxisAlignment: con.order.status == 'PAGADO'
  //               ? MainAxisAlignment.center
  //               : MainAxisAlignment.start,
  //           children: [
  //             Text(
  //               'TOTAL: \$${con.total.value}',
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 17
  //               ),
  //             ),
  //             con.order.status == 'PAGADO'
  //                 ? Container(
  //               margin: EdgeInsets.symmetric(horizontal: 30),
  //               child: ElevatedButton(
  //                   onPressed: () => con.updateOrder(),
  //                   style: ElevatedButton.styleFrom(
  //                       padding: EdgeInsets.all(10)
  //                   ),
  //                   child: Text(
  //                     'DESPACHAR ORDEN',
  //                     style: TextStyle(
  //                         color: Colors.black
  //                     ),
  //                   )
  //               ),
  //             )
  //                 : Container()
  //           ],
  //         ),
  //       )
  //
  //     ],
  //   );
  // }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(left: 20, top: 25),
          child: Row(
            mainAxisAlignment: con.order.status == 'PAGADO' ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Text(
                'TOTAL: \$${con.total.value}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
              ),
              con.order.status == 'DESPACHADO'
                  ? _buttonUpdateOrder()
                  : con.order.status == 'EN CAMINO'
                  ? _buttonGoToOrderMap()
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget _buttonGoToOrderMap() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child: ElevatedButton(
          onPressed: () => con.goToOrderMap(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15)
          ),
          child: Text(
            'VOLVER AL MAPA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _buttonUpdateOrder() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),

      child: ElevatedButton(
          onPressed: () => con.updateOrder(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15)
          ),
          child: Text(
            'INICIAR ENTREGA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

}
