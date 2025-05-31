// ==================== CONTROLLER ====================
import 'dart:async';

import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Model untuk currency data
class CurrencyModel {
  final String code;
  final String symbol;
  final String name;

  CurrencyModel({required this.code, required this.symbol, required this.name});
}

class CurrencyConverterController extends GetxController {
  // Text controller untuk input rupiah
  final TextEditingController rupiahController = TextEditingController();

  // Observable variables
  final selectedCurrency = Rx<CurrencyModel?>(null);
  final convertedAmount = 0.0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Available currencies (selain Rupiah)
  final List<CurrencyModel> availableCurrencies = [
    CurrencyModel(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyModel(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyModel(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default currency
    selectedCurrency.value = availableCurrencies[0]; // USD as default

    // Listen to text field changes
    rupiahController.addListener(_onRupiahAmountChanged);
  }

  @override
  void onClose() {
    rupiahController.dispose();
    super.onClose();
  }

  // Method untuk mengubah currency yang dipilih
  void changeCurrency(CurrencyModel currency) {
    selectedCurrency.value = currency;
    // Auto convert jika ada input
    if (rupiahController.text.isNotEmpty) {
      convertCurrency();
    }
  }

  // Method yang dipanggil saat input rupiah berubah
  void _onRupiahAmountChanged() {
    if (rupiahController.text.isNotEmpty) {
      // Debounce untuk menghindari terlalu banyak API call
      _debounceTimer?.cancel();
      _debounceTimer = Timer(Duration(milliseconds: 500), () {
        convertCurrency();
      });
    } else {
      convertedAmount.value = 0.0;
      errorMessage.value = '';
    }
  }

  Timer? _debounceTimer;

  // Method untuk convert currency melalui API
  Future<void> convertCurrency() async {
    if (rupiahController.text.isEmpty || selectedCurrency.value == null) {
      return;
    }

    final amount = double.tryParse(rupiahController.text);
    if (amount == null || amount <= 0) {
      errorMessage.value = 'Please enter a valid amount';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Panggil API untuk konversi
      final result = await _callConversionAPI(
        amount,
        'IDR',
        selectedCurrency.value!.code,
      );

      convertedAmount.value = result;
    } catch (e) {
      errorMessage.value = 'Conversion failed: ${e.toString()}';
      convertedAmount.value = 0.0;
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk memanggil API konversi
  Future<double> _callConversionAPI(
    double amount,
    String from,
    String to,
  ) async {
    // Simulasi API call - ganti dengan API sebenarnya
    await Future.delayed(Duration(milliseconds: 800));

    // Simulasi exchange rates (ganti dengan response API yang sebenarnya)
    final Map<String, double> exchangeRates = {
      'USD': 0.000067, // 1 IDR = 0.000067 USD
      'EUR': 0.000061, // 1 IDR = 0.000061 EUR
      'JPY': 0.0098, // 1 IDR = 0.0098 JPY
    };

    final rate = exchangeRates[to] ?? 0.0;
    return amount * rate;

    // Contoh implementasi dengan HTTP request:
    /*
    final response = await http.get(
      Uri.parse('https://your-api-endpoint.com/convert?from=$from&to=$to&amount=$amount'),
    );
   
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['convertedAmount'].toDouble();
    } else {
      throw Exception('Failed to convert currency');
    }
    */
  }

  // Method untuk handle tombol convert
  void onConvertPressed() {
    if (rupiahController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter rupiah amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    convertCurrency();

    // Show success message
    Get.snackbar(
      'Success',
      'Converting ${rupiahController.text} IDR to ${selectedCurrency.value?.code}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      colorText: Colors.green[800],
    );
  }

  // Method untuk clear input
  void clearInput() {
    rupiahController.clear();
    convertedAmount.value = 0.0;
    errorMessage.value = '';
  }
}

class ConvertSpentCard extends StatelessWidget {
  const ConvertSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(CurrencyConverterController());

    return Container(
      // height: SizeApp.customHeight(350),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.clearInput,
                    child: Icon(Icons.clear, size: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_outward, size: 18, color: Colors.grey[600]),
                ],
              ),
            ],
          ),
          Text(
            'Convert Rupiah to Foreign Currency',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Gap.h12,

          // Currency Selection Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Convert to',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 6),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CurrencyModel>(
                      value: controller.selectedCurrency.value,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, size: 20),
                      items:
                          controller.availableCurrencies.map((currency) {
                            return DropdownMenuItem<CurrencyModel>(
                              value: currency,
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        currency.symbol,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        currency.code,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        currency.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.changeCurrency(value);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Status Badge
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    controller.isLoading.value
                        ? Colors.orange[100]
                        : Colors.blue[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                controller.isLoading.value
                    ? 'Converting...'
                    : 'Ready to Convert',
                style: TextStyle(
                  fontSize: 10,
                  color:
                      controller.isLoading.value
                          ? Colors.orange[700]
                          : Colors.blue[700],
                ),
              ),
            ),
          ),

          SizedBox(height: 12),

          // Rupiah Input
          TextFormField(
            controller: controller.rupiahController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Enter rupiah amount",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),

          SizedBox(height: 12),

          // Conversion Result
          Obx(
            () => Row(
              children: [
                Icon(
                  controller.isLoading.value
                      ? Icons.hourglass_bottom
                      : Icons.calculate,
                  size: 16,
                  color: Colors.grey[600],
                ),
                if (controller.isLoading.value) ...[
                  SizedBox(width: 6),
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ],
                SizedBox(width: 6),
                Text(
                  controller.selectedCurrency.value?.name ?? 'Select Currency',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? 'Error'
                      : '${controller.selectedCurrency.value?.symbol ?? ''} ${controller.convertedAmount.value.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        controller.errorMessage.value.isNotEmpty
                            ? Colors.red
                            : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Error message
          Obx(
            () =>
                controller.errorMessage.value.isNotEmpty
                    ? Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(fontSize: 11, color: Colors.red),
                      ),
                    )
                    : SizedBox.shrink(),
          ),

          SizedBox(height: 12),

          // Convert Button
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : controller.onConvertPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      controller.isLoading.value
                          ? Colors.grey[300]
                          : ColorApp.mainColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    controller.isLoading.value
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Converting...',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                        : Text('Convert Now', style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
