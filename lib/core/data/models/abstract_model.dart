abstract class AbstractModel {
  var isModel = false;
  var _isVisible = true;

  int get intId => 0;
  bool get isNotModel => !isModel;

  // !important
  /// Called when a object is received in response and there exists another object, that has
  /// same [intId] as that of received object. received object will be passed to exisiting
  /// object's [mergeChanges] so that existing object can update itself.
  ///
  /// We could have simply replace object's old reference with received one, but keep in
  /// mind that there might be some widgets in tree that are holding old reference and any update
  /// to those objects will not refelect globally. therefore rather than dispose old reference
  /// of a object we keep it and allow the object update itself. this means newer objects with
  /// same [intId] values will not be available for widgets, at all, and it's important for all
  /// subtypes of [AbstractModel] class to provide their respective well-throught implementation
  /// for [mergeChanges] method.
  ///
  void mergeChanges(dynamic receivedModel);

  /*
  |--------------------------------------------------------------------------
  | visiblity
  |--------------------------------------------------------------------------
  */

  /// Toggle object's visiblity. to check current state of object's visibility
  /// use [isVisible] getter
  void setVisibility([bool toSet = true]) => _isVisible = toSet;

  bool get isVisible => _isVisible;
}
