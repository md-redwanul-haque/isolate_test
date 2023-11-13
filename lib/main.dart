import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

 int heavyLoad(int value) {
   int tValue = 0;
   for(int i=0; i<value;i++){
     tValue ++;
   }

   return tValue;
 }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           CircularProgressIndicator(),
            ElevatedButton(onPressed: () {
              var testData  =  heavyLoad(5000000000);
              print(testData);
            }, child: Text('press')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () {
              useIsolate();
            }, child: Text('press with Isolate')),
            ElevatedButton(onPressed: () async {
             final  recPost = ReceivePort();
             await Isolate.spawn(completeTask, recPost.sendPort);
              recPost.listen((total) {
                print(total);
              });

            }, child: Text('press with Isolate2')),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



}
useIsolate() async{
  final ReceivePort receivePort = ReceivePort();

  try{
    await Isolate.spawn(runTask, [receivePort.sendPort,40000000]);
  } on Object{
    print("Isolate Failed");
    receivePort.close();
  }
  final response = await receivePort.first;
  print('data Processed ${response}');
}

void runTask(List<dynamic> args){
  SendPort  resultPort = args[0];
  int value = 0;
  for(int i = 0;i<args[1];i++)
    value=i++;

  resultPort.send(value);

}

 completeTask(SendPort sendPort){
  var total =0;
  for (int i=0;i<40000000;i++){
    total +=i;
  }
  sendPort.send(total);

}