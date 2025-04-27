import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:money_mate_mobile/app/widget/buttonApp.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/addcontent_controller.dart';

class AddcontentView extends GetView<AddcontentController> {
  const AddcontentView({super.key});
  @override
  Widget build(BuildContext context) {
    final AddcontentController controller = Get.put(AddcontentController());
    final TextEditingController nameAction = TextEditingController();
    final TextEditingController costController = TextEditingController();
    final TextEditingController descActionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Add Action", style: TypographyApp.titleField),
      ),
      backgroundColor: ColorApp.primaryGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // FORM
              Column(
                children: [
                  Container(
                    color: ColorApp.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tambahkan kebutuhan anda!",
                          style: TypographyApp.headline1,
                        ),
                        Gap.h8,
                        Text(
                          "Seluruh kebutuhan keuangan anda disimpan dalam database kami, anda bisa melihat report dan statistik jingan ingin!",
                          style: TypographyApp.desc,
                        ),
                        Gap.h24,
                        AddActionTextField(
                          controller: nameAction,
                          title: "Nama Kegiatan",
                        ),
                        Gap.h12,
                        Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              // labelText: "Jenis Pengeluaran",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            value: controller.selectedExpense.value,
                            items:
                                controller.expenses.map((String expense) {
                                  return DropdownMenuItem<String>(
                                    value: expense,
                                    child: Text(expense),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.setSelectedExpense(newValue);
                              }
                            },
                          ),
                        ),
                        Gap.h12,
                        Text("Tanggal"),
                        Gap.h8,
                        Obx(
                          () => GestureDetector(
                            onTap: () => _showDatePicker(context, controller),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      controller
                                          .selectedDate
                                          .value, // Mengambil tanggal yang dipilih dari controller
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Icon(Icons.calendar_month),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.h16,
                  Container(
                    color: ColorApp.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Prioritas dan Pengeluaran",
                          style: TypographyApp.titleField,
                        ),
                        Gap.h4,
                        Text(
                          "Momates, tentukan prioritas ini dengan sebaik baiknya ya, biar gak boros!",
                          style: TypographyApp.desc,
                        ),
                        Gap.h16,
                        Obx(
                          () => Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.priority.value = 1;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorApp.mainColor,
                                      ),
                                      color:
                                          controller.priority.value == 1
                                              ? ColorApp.mainColor
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Urgent", // Mengambil prioritas yang dipilih dari controller
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                controller.priority.value == 1
                                                    ? ColorApp.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap.w16,
                                GestureDetector(
                                  onTap: () {
                                    controller.priority.value = 2;
                                  },
                                  child: Container(
                                    width: SizeApp.customWidth(120),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorApp.mainColor,
                                      ),
                                      color:
                                          controller.priority.value == 2
                                              ? ColorApp.mainColor
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Tidak Urgent", // Mengambil prioritas yang dipilih dari controller
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              controller.priority.value == 2
                                                  ? ColorApp.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap.h12,
                        Text("Pengeluaran"),
                        Gap.h8,
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/indo.png',
                                    width: 30,
                                  ),
                                  Gap.w8,
                                  Text(
                                    "Rp", // Mengambil prioritas yang dipilih dari controller
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            Gap.w12,
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: costController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  // labelText: "Masukan nama",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap.h8,
                        Text(
                          "Saat ini, sistem hanya mendeteksi mata uang rupiah ya Momates!",
                          style: TypographyApp.desc,
                        ),
                        Gap.h12,
                        Text("Deskripsi"),
                        Gap.h8,
                        TextField(
                          controller: descActionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            // labelText: "Masukan nama",
                          ),
                        ),
                        Gap.h28,
                        ButtonApp(
                          action: "Simpan",
                          onTap: () {
                            if (nameAction.text.isEmpty &&
                                costController.text.isEmpty &&
                                descActionController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return InformationDialog(
                                    nameAction: "Error!",
                                    desc:
                                        "Isi semua yang diperlukan dengan benar dan pastikan seluruhnya sudah benar",
                                    title: "Tutup",
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            } else {
                              controller.addData(
                                nameAction.text,
                                controller.selectedExpense.value,
                                controller.selectedDate.value,
                                controller.priority.value,
                                costController.text,
                                descActionController.text,
                              );

                              controller.updateDetailCost(
                                controller.selectedExpense.value,
                                int.parse(costController.text),
                              );

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return InformationDialog(
                                    nameAction: "Success!",
                                    desc:
                                        "Berhasil menambahkan data anda! Terus percayakan pengeluaran mu dengan Moeny Mate ",
                                    title: "Tutup",
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );

                              controller.updateCost(costController.text);
                              // Reset semua text controller
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(
    BuildContext context,
    AddcontentController dateController,
  ) async {
    DateTime now = DateTime.now(); // Ambil tanggal sekarang
    DateTime lastDate = DateTime(
      now.year + 1,
      now.month,
      now.day,
    ); // Tentukan batas tanggal terakhir setahun setelah sekarang

    DateTime firstDate = DateTime(now.year - 5, now.month, now.day);
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now, // Tanggal awal
      firstDate: firstDate, // Tanggal pertama yang bisa dipilih
      lastDate: lastDate, // Tanggal terakhir yang bisa dipilih
    );

    // Jika ada tanggal yang dipilih, update tanggal di controller
    if (selectedDate != null) {
      dateController.selectedDate.value =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    }
  }
}

class InformationDialog extends StatelessWidget {
  const InformationDialog({
    super.key,
    required this.nameAction,
    required this.desc,
    required this.title,
    required this.onTap,
  });

  final String nameAction;
  final String desc;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.white,
      title: Text(nameAction, style: TypographyApp.mdblack),
      content: Text(desc),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: ColorApp.mainColor,
          ),
          onPressed: onTap,
          child: Text(
            title,
            style: TypographyApp.mdblack.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class AddActionTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const AddActionTextField({
    required this.title,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Gap.h8,
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: title,
              // labelText: "Masukan nama",
            ),
          ),
        ],
      ),
    );
  }
}
