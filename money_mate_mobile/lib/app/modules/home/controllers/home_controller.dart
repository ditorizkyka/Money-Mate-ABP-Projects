import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:money_mate_mobile/app/data/model/currency.dart';
import 'package:money_mate_mobile/app/shared/constanta.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  //isloading
  RxBool isLoading = false.obs;
  var selectedExpense = "USD".obs; // State yang bisa berubah

  final List<String> expenses = ["USD", "EUR", "JPY"];

  var total = 0.0.obs;
  var result = ''.obs;

  void setSelectedExpense(String value) {
    selectedExpense.value = value;
  }

  Future<Currency?> getCurrency() async {
    try {
      isLoading.value = true;
      String apiKey = dotenv.env['API_KEY'] ?? 'default_value';
      final response = await dio.get(
        'https://v6.exchangerate-api.com/v6/$apiKey/latest/IDR',
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        return Currency.fromJson(response.data);
      }
      isLoading.value = false;
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<double?> countCurrency(int value) async {
    Currency? currency = await getCurrency();

    Map<String, double> currencyconversionRates = currency!.conversionRates;

    if (selectedExpense.value == "USD") {
      total.value = value! * currencyconversionRates["USD"]!;
      result.value = "\$${total.value.toStringAsFixed(2)}";
    }

    if (selectedExpense.value == "EUR") {
      total.value = value! * currencyconversionRates["EUR"]!;
      result.value = "€${total.value.toStringAsFixed(2)}";
    }

    if (selectedExpense.value == "JPY") {
      total.value = value! * currencyconversionRates["JPY"]!;
      result.value = "¥${total.value.toStringAsFixed(2)}";
    }
  }
}
