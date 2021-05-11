import 'package:flutter/material.dart';
import 'package:marvel_flutter/componets/progress_bar.dart';

import 'caracter_webclient.dart';
import 'componets/centered_message.dart';
import 'model/characters_response.dart';

class CaracterList extends StatefulWidget {
  @override
  _CaracterLisState createState() => _CaracterLisState();
}

class _CaracterLisState extends State<CaracterList> {
  final CaracterWebClient _webClient = CaracterWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters Marvel'),
      ),

      body: FutureBuilder<CharactersResponse>(
        future: _webClient.getCaracters().catchError((onError) {
          print(onError);
        }),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return ProgressBar();
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final CharactersResponse characters = snapshot.data;

                if (characters != null) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Character character =
                      characters.data.characters[index];
                      return _BuildCard(
                        context,
                        character,
                        onClick: () {},
                      );
                    },
                    itemCount: characters.data.characters.length,
                  );
                }
              }
              if (snapshot.hasData) {}
              break;
          }

          return CenteredMessage('Unknown error');
        },
      ),
    );
  }
}

class _BuildCard extends StatefulWidget {
  final BuildContext context;
  final Character character;
  final Function onClick;

  _BuildCard(this.context, this.character, {@required this.onClick});

  @override
  _BuildCardState createState() => _BuildCardState();
}

class _BuildCardState extends State<_BuildCard> {
  @override
  Widget build(BuildContext context) {
    String _image = widget.character.thumbnail.path + '/portrait_medium.' +
        widget.character.thumbnail.extension;
    _image = _image.replaceAll('http', 'https');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100.0,
        height: 150.0,
        child: Card(
          child: Container(
            color: Colors.black54,
            child: ListTile(
              onTap: () => widget.onClick(),
              leading: Image.network(widget.character.thumbnail.getImageLarge()),
              title: Text(
                widget.character.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.character.description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
