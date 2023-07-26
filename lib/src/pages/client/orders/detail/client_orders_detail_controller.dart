import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:petaldash/src/models/order.dart';
import 'package:petaldash/src/models/response_api.dart';
import 'package:petaldash/src/models/user.dart';
import 'package:petaldash/src/providers/orders_provider.dart';
import 'package:petaldash/src/providers/user_providers.dart';

class ClientOrdersDetailController extends GetxController {

  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UserProvider usersProvider = UserProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  ClientOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getTotal();
  } 

  void goToOrderMap() {
    Get.toNamed('/client/orders/map', arguments: {
      'order': order.toJson()
    });
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

}