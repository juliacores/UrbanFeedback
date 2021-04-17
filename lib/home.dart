import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'form.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [
            Image.asset('assets/banner.png'),
            Heading(),
            Description(),
            Message()
              ],
    )
    )
    )
    ;
  }
}

class Heading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Поможем Петербургу стать комфортным',
      style: Constants().header)
    );
  }
}

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '''Здесь вы можете оставить отзыв о проблеме в городской инфраструктуре СПб, а также посмотреть аналитику проблем города.

Мы находимся в процессе сбора данных, а затем займемся тем, чтобы ваши проблемы были решены властями.

Ваше обращение очень важно для того, чтобы наш город стал комфортным для всех!
''',
style: Constants().maintext
      ),
    );
  }
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Constants.accent),
            margin: EdgeInsets.only(left: 40, right: 40, top: 10),
            padding: EdgeInsets.all(16),
      child: FlatButton(
        child: Text(
          'Сообщить о проблеме',
          style: Constants().buttontext,
        ),
        onPressed:(){
          Navigator.of(context).pushNamed(Forma.routeName);
        }
        ,),
    );
  }
}