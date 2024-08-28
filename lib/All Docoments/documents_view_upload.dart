import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DocumentsUploadView extends StatefulWidget {
  const DocumentsUploadView({super.key});

  @override
  State<DocumentsUploadView> createState() => _DocumentsUploadViewState();
}

class _DocumentsUploadViewState extends State<DocumentsUploadView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getFront();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.chevron_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 30,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver PCO License',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Open Sans',
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _imageFile == null && uploadedImage.isNotEmpty
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _pickImage(ImageSource.gallery);
                                // context.pushNamed('DriverPCOLicense');
                              },
                              child: SizedBox(
                                  height: 500,
                                  width: 400,
                                  child: Image.network(
                                      fit: BoxFit.contain,
                                      "https://www.minicaboffice.com/img/drivers/driving-license/$uploadedImage")),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                child: const Center(
                                  child: Icon(
                                    color: Colors.white,
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                              ))
                        ],
                      )
                    : _imageFile != null
                        ? Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _pickImage(ImageSource.gallery);
                                    // context.pushNamed('DriverPCOLicense');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                        height: 500,
                                        width: 400,
                                        child: Image.file(
                                          File(
                                            _imageFile!.path,
                                          ),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        color: Colors.white,
                                        Icons.add,
                                        size: 30,
                                      ),
                                    ),
                                  ))
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 20, 0, 0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _pickImage(ImageSource.gallery);
                                // context.pushNamed('DriverPCOLicense');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/pngwing.com.png',
                                  width: MediaQuery.sizeOf(context).width,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                  child: FFButtonWidget(
                    onPressed: () async {
                      setState(() {});
                      isloading = true;
                      await _uploadImage();

                      print('Button pressed ..$isloading.');
                    },
                    text: 'Upload Now',
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 15,
                    ),
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 54,
                      padding: const EdgeInsets.all(0),
                      iconPadding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Open Sans',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                      elevation: 4,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isloading = false;
  _uploadImage() async {
    setState(() {});
    SharedPreferences sp = await SharedPreferences.getInstance();
    String did = sp.getString('d_id') ?? '';
    if (_imageFile == null) {
      // No image selected
      return;
    }

    // Define your API endpoint
    final Uri apiUrl = Uri.parse(
        'https://www.minicaboffice.com/api/driver/upload-license-front.php');

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', apiUrl);

    // Add the image file
    request.files.add(
      http.MultipartFile(
        'dl_front', // Field name expected by the server
        File(_imageFile!.path).readAsBytes().asStream(),
        File(_imageFile!.path).lengthSync(),
        filename: _imageFile!.path,
      ),
    );

    // Add other parameters
    request.fields['d_id'] = did; // Replace with your actual ID
    isloading = false;
    // Send the request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        isloading = false;
        // print('Image uploaded successfully');
        // Handle success
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = json.decode(responseBody);
        print('the  uploaded response is $responseBody');
        _imageFile == null;
        getFront();
        _showToastMessage('"License Upload Successfully"');
      } else {
        isloading = false;
        print('Failed to upload image');
        _showToastMessage('Failed to upload image');
        // Handle failure
      }
    } catch (e) {
      isloading = false;
      print('Error: $e');
      _showToastMessage(e.toString());
      // Handle error
    }
  }

  getFront() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://minicaboffice.com/api/driver/check-d-license-front.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      print(
          'Now the condition is true ${_imageFile == null && uploadedImage.isNotEmpty}');
      setState(() {
        _imageFile == null;
        uploadedImage = jsonResponse['data'][0]['d_license_front'];
      });
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }

  String uploadedImage = ''; // uploadDRLicenseFront() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   String did = sp.getString('d_id') ?? '';
  //   try {
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(
  //           'https://www.minicaboffice.com/api/driver/upload-license-front.php'),
  //     );
  //     request.fields.addAll({
  //       'd_id': did.toString(),
  //     });
  //     print(request.fields);

  //     if (selectedImage != null) {
  //       // If selectedImage is not null, upload it
  //       request.files.add(
  //         await http.MultipartFile.fromPath('d_img', _imageFile!.path),
  //       );
  //     } else if (dPic != null && dPic!.isNotEmpty) {
  //       // If dPic is not null and not empty, download the image and upload it
  //       var imageUrl = 'https://minicaboffice.com/img/drivers/$dPic';
  //       var response = await http.get(Uri.parse(imageUrl));
  //       if (response.statusCode == 200) {
  //         request.files.add(
  //           http.MultipartFile.fromBytes(
  //             'd_img',
  //             response.bodyBytes,
  //             filename: dPic!.split('/').last,
  //           ),
  //         );
  //       } else {
  //         print('Failed to load image from URL.');
  //       }
  //     }

  //     // request.files.add(
  //     //   await http.MultipartFile.fromPath(
  //     //       'd_img',selectedImage!.path ),
  //     // );
  //     final response = await request.send();
  //     if (response.statusCode == 200) {
  //       print(await response.stream.bytesToString());
  //       _showToastMessage('Profile updated successfully');
  //       context.pushNamed('Dashboard');
  //     } else {
  //       print(response.reasonPhrase);
  //       _showToastMessage(
  //           'Profile update failed. Please check your internet connection.');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //     _showToastMessage('Please $error');
  //   }
  // }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }
}
