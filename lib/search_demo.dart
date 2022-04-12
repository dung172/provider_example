import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as english_words;

// Adapted from search demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/search_demo.dart
class AppBarSearchExample extends StatefulWidget {
  const AppBarSearchExample({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppBarSearchExampleState();
  }
}
class _AppBarSearchExampleState extends State<AppBarSearchExample>{
    final List<String> kEnglishWord;
    late _MysearchDelegate _delegate;
    _AppBarSearchExampleState():
          kEnglishWord = List.from(Set.from(english_words.all))
      ..sort(
              (w1,w2)=>w1.toLowerCase().compareTo(w2.toLowerCase())
      ),
          super();
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _delegate = _MysearchDelegate(kEnglishWord);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('english words'),
        actions: [
          IconButton(
              tooltip: 'search' ,
              onPressed: () async{
                final String? selected = await showSearch<String>(
                  context: context,
                  delegate: _delegate,
                );
                if(mounted &&selected!=null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('you have selected $selected'),));
                }
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: kEnglishWord.length,
            itemBuilder: (context,index)=>ListTile(
              title: Text(kEnglishWord[index]),
            ) ,
        ),
      ),
    );
  }
}
class _MysearchDelegate extends SearchDelegate<String>{
  final List<String> _words;
  final List<String> _history;
  _MysearchDelegate(List<String> words)
      : _words = words,
        _history = <String>['apple','hello'],
        super();
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(tooltip: 'back',
        onPressed: ()=>this.close(context, ''),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        )
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return[
      if(query.isEmpty)
        IconButton(
            tooltip: 'voicesearch',
            onPressed: ()=>this.query = 'asdas',
            icon: const Icon(Icons.mic))
      else
        IconButton(
          tooltip: 'clear',
            onPressed: (){
              query ='';
              showSuggestions(context);
        }, icon: const Icon(Icons.clear))
    ];
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final Iterable<String> suggestions = this.query.isEmpty?_history:_words.where((word) => word.startsWith(query));
    return _SuggestionList(
      query:this.query,
      suggestions:suggestions.toList(),
      onSelected:(String suggestion){
        this.query = suggestion;
        this._history.insert(0,suggestion);
        showResults(context);
      }
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Padding(
        padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('you have selected'),
            GestureDetector(
              onTap: ()=>this.close(context, this.query),
              child: Text(this.query,style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget{
  const _SuggestionList(
      {required this.suggestions,
        required this.query,
        required this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;
  @override
  Widget build( context) {
    // TODO: implement build
    final textTheme = Theme.of(context).textTheme.subtitle1!;
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: ( context, int i){
          final String suggestion = suggestions[i];
          return ListTile(
            leading: query.isEmpty?const Icon(Icons.history):const Icon(null),
            title: RichText(
              text: TextSpan(
                text: suggestion.substring(0,query.length),
                style: textTheme.copyWith(fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: suggestion.substring(query.length),
                    style: textTheme,
                  )
                ]
              ),
            ),
            onTap: ()=>onSelected(suggestion),
          );
        });
  }
}