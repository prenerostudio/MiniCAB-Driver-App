import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../flutter_flow/flutter_flow_theme.dart';

class DocumentBottomSheet extends StatefulWidget {
  String parameter;
  String postUrl;
  String getUrl;
  String showImageUrl;
  String forInsideArray;
  String name;
  String? numberParamter;
  String? dateParamter;
  String? fieldTitle;
  String? dateTitle;
  bool? isDateAvaiabl;
  bool? isfieldAvailable;
  bool? bothFrontAndBack;
  DocumentBottomSheet({
    super.key,
    required this.parameter,
    required this.getUrl,
    required this.postUrl,
    required this.showImageUrl,
    required this.forInsideArray,
    required this.name,
    this.fieldTitle,
    this.numberParamter,
    this.dateParamter,
    this.dateTitle,
    this.isDateAvaiabl,
    this.isfieldAvailable,
    this.bothFrontAndBack,
  });

  @override
  State<DocumentBottomSheet> createState() => _DocumentBottomSheetState();
}

class _DocumentBottomSheetState extends State<DocumentBottomSheet> {
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
    return Container(
      width: double.infinity,
      color: Colors.white,
      height: widget.isfieldAvailable == null && widget.isDateAvaiabl == null
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open Sans',
                    letterSpacing: 0,
                  ),
            ),
            // Text("${widget.showImageUrl}$uploadedImage"),
            _imageFile == null && uploadedImage.isNotEmpty
                ? Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                                height: 200,
                                width: 200,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "${widget.showImageUrl}$uploadedImage",
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          Center(child: Text('Loading..')),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fadeInDuration: Duration(
                                          milliseconds:
                                              500), // Optional fade-in effect
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                      // Positioned(
                      //     right: 0,
                      //     top: 0,
                      //     child: Container(
                      //       decoration: const BoxDecoration(
                      //           color: Colors.blue, shape: BoxShape.circle),
                      //       child: const Center(
                      //         child: Icon(
                      //           color: Colors.white,
                      //           Icons.add,
                      //           size: 30,
                      //         ),
                      //       ),
                      //     ))
                    ],
                  )
                : _imageFile != null
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
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
                                    height: 200,
                                    width: 200,
                                    child: Image.file(
                                      File(
                                        _imageFile!.path,
                                      ),
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            ),
                          ),
                          // Positioned(
                          //     right: 0,
                          //     top: 0,
                          //     child: Container(
                          //       decoration: const BoxDecoration(
                          //           color: Colors.blue, shape: BoxShape.circle),
                          //       child: const Center(
                          //         child: Icon(
                          //           color: Colors.white,
                          //           Icons.add,
                          //           size: 30,
                          //         ),
                          //       ),
                          //     ))
                        ],
                      )
                    : Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                              height: MediaQuery.sizeOf(context).height * 0.25,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

            widget.isfieldAvailable == null
                ? SizedBox.shrink()
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.fieldTitle ?? 'dymmy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'License Number',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.3),
                                fontSize: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey))),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            // Text(
            //   '${widget.fieldTitle}',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // SizedBox(
            //   height: 10,
            // ),

            widget.isDateAvaiabl == null
                ? SizedBox.shrink()
                : Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.dateTitle ?? 'date dymmy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _pickDate(context);
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(9)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                _selectedDate != null
                                    ? "${_formatDate(_selectedDate!)}"
                                    : "mm/dd/yyyy",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),

            SizedBox(
              height: 20,
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
                text: uploadedImage.isNotEmpty ? 'Update' : 'Upload Now',
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 15,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 54,
                  padding: const EdgeInsets.all(0),
                  iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }

  DateTime? _selectedDate; // Store the selected date

  // Function to show the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to format the date
  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date); // 'MM:DD:YYYY' format
  }

  TextEditingController numberController = TextEditingController();
  bool isloading = false;
  _uploadImage() async {
    // print('the date choosen ${_formatDate(_selectedDate!)}');
    setState(() {});
    SharedPreferences sp = await SharedPreferences.getInstance();
    String did = sp.getString('d_id') ?? '';
    if (_imageFile == null) {
      // No image selected
      return;
    }

    // Define your API endpoint
    final Uri apiUrl = Uri.parse(widget.postUrl);

    // Prepare the multipart request
    var request = http.MultipartRequest('POST', apiUrl);

    // Add the image file
    request.files.add(
      http.MultipartFile(
        widget.parameter, // Field name expected by the server
        File(_imageFile!.path).readAsBytes().asStream(),
        File(_imageFile!.path).lengthSync(),
        filename: _imageFile!.path,
      ),
    );

    // Add other parameters
    request.fields['d_id'] = did; // Replace with your actual ID
    if (widget.isfieldAvailable != null && numberController.text.isNotEmpty) {
      request.fields[widget.numberParamter ?? ''] =
          numberController.text.toString(); // Replace with your actual ID
    }

    if (widget.isDateAvaiabl != null && _selectedDate != null) {
      request.fields[widget.dateParamter ?? ''] =
          _formatDate(_selectedDate!).toString(); // Replace with your actual ID
      print(
          'the date for ${widget.dateParamter} is for ${_formatDate(_selectedDate!)}');
    }
    // request.fields['d_id'] = did; // Replace with your actual ID
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
        print('the  uploaded response is ${responseData['message']}');
        _showToastMessage(responseData['message']);
        if (responseData['message'] == 'Some fields are missing') {
        } else {
          _imageFile == null;
          getFront();
        }
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest('POST', Uri.parse(widget.getUrl));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        print('Now the condition is true ${jsonResponse}');
        setState(() {
          _imageFile == null;
          uploadedImage = jsonResponse['data'][0][widget.forInsideArray] ?? '';
        });
        // Navigator.pop(context);
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String uploadedImage = '';

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }
}
