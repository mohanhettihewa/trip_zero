import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/destination.dart';

class CmsService extends ChangeNotifier {
  static final CmsService _instance = CmsService._internal();
  factory CmsService() => _instance;
  CmsService._internal();

  static const String _fileName = 'destinations.json';
  List<Destination> _destinations = [];
  bool _isLoaded = false;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<Destination>> getDestinations() async {
    if (_isLoaded) return _destinations;
    
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        _destinations = _getDefaultDestinations();
      } else {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _destinations = jsonList.map((json) => Destination.fromJson(json)).toList();
      }
    } catch (e) {
      _destinations = _getDefaultDestinations();
    }
    
    _isLoaded = true;
    notifyListeners(); // Notify just in case data wasn't there before
    return _destinations;
  }

  Future<void> saveDestinations(List<Destination> destinations) async {
    final file = await _localFile;
    final String jsonString = json.encode(destinations.map((d) => d.toJson()).toList());
    await file.writeAsString(jsonString);
  }

  Future<void> addDestination(Destination destination) async {
    // Ensure data is loaded
    if (!_isLoaded) await getDestinations();
    
    _destinations.add(destination);
    await saveDestinations(_destinations);
    notifyListeners();
  }

  Future<void> updateDestination(Destination updatedDestination) async {
    if (!_isLoaded) await getDestinations();

    final index = _destinations.indexWhere((d) => d.id == updatedDestination.id);
    if (index != -1) {
      _destinations[index] = updatedDestination;
      await saveDestinations(_destinations);
      notifyListeners();
    }
  }

  Future<void> deleteDestination(String id) async {
    if (!_isLoaded) await getDestinations();

    _destinations.removeWhere((d) => d.id == id);
    await saveDestinations(_destinations);
    notifyListeners();
  }

  List<Destination> _getDefaultDestinations() {
    return [
      Destination(
        id: '1',
        title: 'Mountain Escape',
        image: 'https://picsum.photos/id/1018/400/300',
        description: 'Experience the serenity of the high mountains.',
      ),
      Destination(
        id: '2',
        title: 'Beach Paradise',
        image: 'https://picsum.photos/id/1015/400/300',
        description: 'Relax on the pristine white sands.',
      ),
      Destination(
        id: '3',
        title: 'City Adventure',
        image: 'https://picsum.photos/id/1016/400/300',
        description: 'Explore the vibrant life of the city.',
      ),
      Destination(
        id: '4',
        title: 'Jungle Safari',
        image: 'https://picsum.photos/id/1019/400/300',
        description: 'Discover the wild side of nature.',
      ),
      Destination(
        id: '5',
        title: 'Desert Trek',
        image: 'https://picsum.photos/id/1020/400/300',
        description: 'Journey through the vast desert landscapes.',
      ),
      Destination(
        id: '6',
        title: 'Island Hop',
        image: 'https://picsum.photos/id/1021/400/300',
        description: 'Hop between beautiful tropical islands.',
      ),
    ];
  }
}
