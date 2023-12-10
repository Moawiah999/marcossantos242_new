import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/bloc/theme/theme_bloc.dart';

class PgExclusive extends StatefulWidget {
  const PgExclusive({
    Key? key,
  }) : super(key: key);

  @override
  _PgExclusiveState createState() => _PgExclusiveState();
}

class _PgExclusiveState extends State<PgExclusive> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body(),
      ),
    );
  }

  body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          imageContainer(),
          const SizedBox(height: 20),
          buttonExclusive(),
          const SizedBox(height: 20),
          dividerSpalhe(),
          const SizedBox(height: 10),
          textAssignSpalhe(),
          const SizedBox(height: 10),
          lastText(),
        ],
      ),
    );
  }

  imageContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/png/fundo.png"), fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
            Spacer(),
            const Text(
              'Exclusivo na Spalhe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 18,
                  backgroundColor: Colors.grey[300],
                  child: Image.asset(
                    'assets/png/color_spalhe.png',
                    height: 12,
                    width: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Spalhe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Image.asset(
                  'assets/png/carraca.png',
                  height: 16,
                  width: 26,
                ),
              ],
            ),
          ],
        ),
      ), // Foreground widget here
    );
  }

  buttonExclusive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            launch('https://about.spalhe.com/exclusivo');
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: const Color(0xff7934E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/coroa.svg',
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Exclusivo',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  dividerSpalhe() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 2,
            color: ThemeBloc.colorScheme.onBackground,
          ),
        ],
      ),
    );
  }

  textAssignSpalhe() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Assinatura Spalhe',
            style: TextStyle(
              color: ThemeBloc.colorScheme.onBackground,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  lastText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: AutoSizeText(
        'De acordo com as informações, as assinaturas são apenas '
        'um dos vários recursos que a Spalhe oferecerá '
        'para os criadores de conteúdo monetizarem suas '
        'publicações. Desta forma, a empresa espera que haja '
        'uma produção maior de conteúdos de qualidade em '
        'sua plataforma.',
        style: TextStyle(
          color: ThemeBloc.colorScheme.onBackground,
        ),
      ),
    );
  }
}