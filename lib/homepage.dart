import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class homepage extends StatelessWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skin Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: MyHomePage(title: 'Skin Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late File _image;
  bool valid=false;
  bool computed=false;
  String output="";
  Map<String,String> dictionary={
    "acn":"Acne is a common skin condition that happens when hair follicles under the skin become clogged.",
    "akiec":"actinic keratosis is a precancerous condition resulting from sun exposure, presenting as rough, scaly patches.",
    "bcc":" Basal-cell cancer often displays as raised area of skin, it grows slowly and can be harmful to the tissue around it but is not commonly to spread to distant areas or lead to death.",
    "bkl":"benign keratosis-like lesion often do not require treatment. However, it is essential to be able to differentiate these lesions from other benign and malignant skin tumors.",
    "df":"dermatofibromas aren’t malignant (noncancerous) so you don't usually need treatment for them. But they’re more likely to spread to other parts of your body.",
    "ecz":"Eczema is a skin problem that causes dry, itchy, scaly, red skin. it can be treated with moisturizers and prescription ointments and creams.",
    "mel":"melanoma is a serious type of skin cancer. exposure to UV radiations increases the risk of it. seeing a doctor is advised.",
    "nv":"melanocytic nevi are benign skin lesions that usually present at birth and vary from small to large in size. Larger lesions are rarer and have both higher malignant potential and often require more complex treatment.",
    "psor":"Psoriasis is a skin disease that causes a rash with itchy, scaly patches, most commonly on the knees, elbows, trunk and scalp. Psoriasis is a common, long-term (chronic) disease with no cure.",
    "tin":"Tinea versicolor is a common fungal infection of the skin. The fungus interferes with the normal pigmentation of the skin, resulting in discolored patches. These patches most commonly affect the trunk and shoulders.",
    "vasc":"Vascular lesions are relatively common abnormalities of the skin and underlying tissues, more commonly known as birthmarks. There are three major categories of vascular lesions: Hemangiomas, Vascular Malformations, and Pyogenic Granulomas.",

  };
  final picker = ImagePicker();

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        valid=true;
        computed=false;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        valid=true;
        computed=false;
      } else {
        print('No image selected.');
      }
    });
  }
  void detectImage(File img) async {
    // var dialog = showDialog(context: context, builder: (context) =>  const Center(child: CircularProgressIndicator()));

    late BuildContext dialogContext; // global declaration
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Container(
          color: Colors.transparent, // Set the background color to transparent
          child: Dialog(
            backgroundColor: Colors.transparent, // Set the dialog background color to transparent
            child: Center(

                child : CircularProgressIndicator(
                  color: Colors.white,
                ),
            ),
          ),
        );
      },
    );


    // await _longOperation();// asynchronous operation

    List<int> imageBytes = await File(img.path).readAsBytes();
    String base64Image = base64Encode(imageBytes);
    print("image encoded");
    final apiURL = "https://zondl-skinscanner.hf.space/run/predict"; // Replace with your Gradio API URL
    print("###");
    print(base64Image);
    print("###");
    var response = await http.post(Uri.parse(apiURL), body: jsonEncode({
      'data': [base64Image],
    }),    headers: {'Content-Type': 'application/json'});
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        computed=true;
        output=data['data'][0];
      });
    } else {
      throw Exception('Failed to classify image');
    }
    Navigator.pop(dialogContext);// pop dialog with use of Dialog context

    // dialog.ignore();
    // Navigator.of(context).pop();
    // Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    if(!valid){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             !valid
                ? const Text('No image selected.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 38), // Adjust padding
                textStyle: TextStyle(fontSize: 18), // Adjust text size
              ),
              onPressed: getImageFromCamera,
              child: const Text('Take Picture'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust padding
                textStyle: TextStyle(fontSize: 18), // Adjust text size
              ),
              onPressed: getImageFromGallery,
              child: const Text('Select Picture'),
            ),
          ],
        ),
      ),
    );
  }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 300,
                  width: 300,
                child: Image.file(_image!),
              ),

              const SizedBox(height: 20),

              computed? Column (
                children: [
                  // Text(output,style: TextStyle(
                  //
                  //   color: Colors.black,
                  //   fontSize: 20,
                  //   fontWeight: FontWeight.bold,
                  // ),textAlign: TextAlign.center, ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12, // Shading box color
                      borderRadius: BorderRadius.circular(12), // Border radius of the box
                    ),
                    padding: EdgeInsets.all(16), // Padding inside the box
                    child: Text(
                      output,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black, // Text color
                        fontWeight: FontWeight.bold,
                      ),textAlign: TextAlign.center,
                    ),
                  ),
                  Text(dictionary[output.split(" ")[5]]!,style: TextStyle(

                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.values[5],
                  ),textAlign: TextAlign.center,)
                ],
              ):
              ElevatedButton(style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust padding
                textStyle: TextStyle(fontSize: 18), // Adjust text size
              ),
                onPressed: ()=>{
                setState(()  { detectImage(_image);})},
                child: const Text('Scan'),
              ),
                const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjust padding
                  textStyle: TextStyle(fontSize: 18), // Adjust text size
                ),
                onPressed: ()=>{setState((){valid = false;computed=false;})},
                child: const Text('Retry'),
              ),
              // Text(output+"\n"+dictionary[output.split(" ")[5]]!)
              
              
            ],
          ),
        ),
      );
    }
  }
}
