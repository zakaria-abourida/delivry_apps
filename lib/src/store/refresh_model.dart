import 'package:scoped_model/scoped_model.dart';

class RefreshModel extends Model {
  bool _isRefreshed = false;
  bool get counter => _isRefreshed;
  void refresh() {
    _isRefreshed = true;
    notifyListeners();
  }
  void unRefresh() {
    _isRefreshed = false;
    notifyListeners();
  }
}
