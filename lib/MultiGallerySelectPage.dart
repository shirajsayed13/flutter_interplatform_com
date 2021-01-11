import 'package:flutter/material.dart';
import 'GalleryImage.dart';
import 'package:flutter/services.dart';

class MultiGallerySelectPage extends StatefulWidget {
  createState() => _MultiGallerySelectPageState();
}

class _MultiGallerySelectPageState extends State<MultiGallerySelectPage> {
  final _numberOfColumns = 4;
  final _title = "Gallery";

  final _channel = MethodChannel("/gallery");

  var _selectedItems = List<GalleryImage>();
  var _itemCache = Map<int, GalleryImage>();

  _selectItem(int index) async {
    var galleryImage = await _getItem(index);

    setState(() {
      if (_isSelected(galleryImage.id)) {
        _selectedItems.removeWhere((anItem) => anItem.id == galleryImage.id);
      } else {
        _selectedItems.add(galleryImage);
      }
    });
  }

  _isSelected(String id) {
    return _selectedItems.where((item) => item.id == id).length > 0;
  }

  var _numberOfItems = 0;

  @override
  void initState() {
    super.initState();

    _channel.invokeMethod<int>("getItemCount").then(
          (count) => setState(() {
            _numberOfItems = count;
          }),
        );
  }

  Future<GalleryImage> _getItem(int index) async {
    if (_itemCache[index] != null) {
      return _itemCache[index];
    } else {
      var channelResponse = await _channel.invokeMethod("getItem", index);
      var item = Map<String, dynamic>.from(channelResponse);

      var galleryImage = GalleryImage(
          bytes: item['data'],
          id: item['id'],
          dateCreated: item['created'],
          location: item['location']);

      _itemCache[index] = galleryImage;

      return galleryImage;
    }
  }

  _buildItem(int index) => GestureDetector(
        onTap: () {
          _selectItem(index);
        },
        child: Card(
          elevation: 2.0,
          child: FutureBuilder(
              future: _getItem(index),
              builder: (context, snapshot) {
                var item = snapshot?.data;
                if (item != null) {
                  return Container(
                    child: Image.memory(item.bytes, fit: BoxFit.cover),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                          style: _isSelected(item.id)
                              ? BorderStyle.solid
                              : BorderStyle.none),
                    ),
                  );
                }
                return Container();
              }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('$_title'),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Total gallery images - $_numberOfItems',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _numberOfColumns),
        itemCount: _numberOfItems,
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent),
    );
  }
}
