import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? _xfile = await _picker.pickImage(source: source);
  if (_xfile != null) {
    return await _xfile.readAsBytes();
  }
  print('did not select photo');
}

showSnackBar(BuildContext context, String content){
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content),),);
}
