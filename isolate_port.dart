import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

//在父Isolate中调用
Isolate isolate;
start() async {
  ReceivePort receivePort = ReceivePort();
  //创建子Isolate对象
  isolate = await Isolate.spawn(subIsolateMain, receivePort.sendPort);
  //监听子Isolate的返回数据
  receivePort.listen((data) {
    print('data：$data');

    if (data == 'done') {
      receivePort.close();
      //关闭Isolate对象
      isolate?.kill(priority: Isolate.immediate);
      isolate = null;
    }
  });
}

void subIsolateMain(sendPort) {
  int i = 0;
  while (i < 10) {
    sendPort.send('hello ${i}th');
    sleep(Duration(seconds: 1));
    i += 1;
  }
  sendPort.send('done');
}

main(List<String> args) {
  print("start");
  start();
  print("after start");
}
