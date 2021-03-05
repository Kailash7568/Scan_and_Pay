import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  String qrCodeResult = "Not Yet Scanned";

  Razorpay razorpay;
  TextEditingController textEditingController = new TextEditingController();
  @override
  void initState(){
    super.initState();
    razorpay= new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,handlerPaymentSuccess );
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,handlerErrorFailure );
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handlerExternalWallet );
  }

  @override
  void dispose(){
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(){
    var options ={
      "key":"rzp_test_3br45XmDDPxz5S",
      "amount": num.parse(textEditingController.text)*100,
      "name": "Scan & pay App",
      "description": "Payment for some random product",
      "prefill": {
        "contact": "7568708066",
        "email": "182076@nith.ac.in"
      },
      "external":{
        "wallets": ["paytm"]
      }

    };

    try{
      razorpay.open(options);
    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print('Payment success');
    Toast.show("Payment success",context);
  }

  void handlerErrorFailure(){
    print('Payment Error');
    Toast.show("Payment Error",context);
  }

  void handlerExternalWallet(){
    print('External Wallet');
    Toast.show("External Wallet",context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(60.0,20.0, 60.0, 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {


                String codeSanner = await BarcodeScanner.scan();    //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }


              },
              child: Text(
                "Open Scanner",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
            SizedBox(height: 20.0,),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: "amount to pay"
              ),
            ),
            SizedBox(height: 12,),
            RaisedButton(
                color: Colors.blue,
                onPressed:(){
                  openCheckout();
                },
                child:Text(
                  'Pay now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )

          ],
        ),
      ),
    );
  }

  //its quite simple as that you can use try and catch staatements too for platform exception
}
