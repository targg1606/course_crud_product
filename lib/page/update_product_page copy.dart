import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key, required this.product});
  final Map product;

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final controllerName = TextEditingController();
  final controllerDescription = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? newimageName;
  Uint8List? newImageByte;

  pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      newimageName = image.name;
      newImageByte = await image.readAsBytes();
      setState(() {});
    }
  }

  createProduct() async {
    if (formkey.currentState!.validate()) {
      if (newImageByte == null) {
        DInfo.toastError('Image cannot be empty');
      } else {
        String url =
            'http://192.168.1.6/course_api_crud_product/product/create.php';
        var response = await http.post(Uri.parse(url), body: {
          'id': controllerName.text,
          'description': controllerDescription.text,
          'old_image': 'imageName',
          'new_image': 'imageName',
          'new_base64code': base64Encode(List<int>.from(newImageByte!)),
        });
        Map responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          DInfo.toastSuccess('Success Create Product');
          Navigator.pop(context);
        } else {
          DInfo.toastError('Failed Create Product');
        }
      }
    }
  }

  @override
  void initState() {
    controllerName.text = widget.product['name'];
    controllerDescription.text = widget.product['description'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DView.appBarLeft('Update Product'),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerName,
              title: 'Name',
              validator: (input) => input == '' ? "Don't empty" : null,
            ),
            SizedBox(
              height: 20,
            ),
            DInput(
              controller: controllerDescription,
              minLine: 3,
              maxLine: 5,
              title: 'Description',
              validator: (input) => input == '' ? "Don't empty" : null,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => pickImage(),
              child: const Text('Pick Image'),
            ),
            SizedBox(
              height: 20,
            ),
            // imageByte == null
            //     ? const Text('Empty Photo')
            //     : Image.memory(
            //         imageByte!,
            //         height: 280,
            //         fit: BoxFit.fitHeight,
            //       ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => createProduct(),
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }
}
