import 'package:photogram/import/core.dart';

class DependencyGraph<StartPointType, EndPointType> {
  final String graphTitle;

  DependencyGraph([this.graphTitle = 'DependencyGraph']);

  final _graph = <String, Map<StartPointType, List<EndPointType>>>{};

  Map<StartPointType, List<EndPointType>> _dependencies<DependencyType>() {
    if (!_graph.containsKey(DependencyType.toString())) return {};

    return _graph[DependencyType.toString()]!;
  }

  List<EndPointType> list<DependencyType>({required StartPointType startPoint}) {
    if (_dependencies<DependencyType>().containsKey(startPoint)) {
      return _dependencies<DependencyType>()[startPoint]!;
    }

    return <EndPointType>[];
  }

  bool isDependency<DependencyType>({required StartPointType startPoint, required EndPointType endPoint}) {
    if (!_graph.containsKey(DependencyType.toString())) return false;

    if (!_dependencies<DependencyType>().containsKey(startPoint)) return false;

    if (!_dependencies<DependencyType>()[startPoint]!.contains(endPoint)) return false;

    return true;
  }

  void add<DependencyType>({required StartPointType startPoint, required EndPointType endPoint}) {
    if (!_graph.containsKey(DependencyType.toString())) {
      _graph.addAll({DependencyType.toString(): {}});

      AppLogger.info('$graphTitle:[$DependencyType] Init', logType: AppLogType.dependencyGraph);
    }

    if (!_dependencies<DependencyType>().containsKey(startPoint)) {
      _graph[DependencyType.toString()]!.addAll({startPoint!: []});

      AppLogger.info('$graphTitle:[$DependencyType] Create StartPoint:$startPoint',
          logType: AppLogType.dependencyGraph);
    }

    if (!_dependencies<DependencyType>()[startPoint]!.contains(endPoint)) {
      _graph[DependencyType.toString()]![startPoint]!.add(endPoint);

      AppLogger.info('$graphTitle:[$DependencyType] Add StartPoint($startPoint) -> EndPoint($endPoint)',
          logType: AppLogType.dependencyGraph);
    }
  }

  void remove<DependencyType>({required StartPointType startPoint, required EndPointType endPoint}) {
    if (_dependencies<DependencyType>().containsKey(startPoint)) {
      if (_dependencies<DependencyType>()[startPoint]!.contains(endPoint)) {
        _graph[DependencyType.toString()]![startPoint]!.remove(endPoint);

        AppLogger.info('$graphTitle:[$DependencyType] Remove StartPoint($startPoint) -> EndPoint($endPoint)',
            logType: AppLogType.dependencyGraph);
      }

      if (_dependencies<DependencyType>()[startPoint]!.isEmpty) {
        _graph[DependencyType.toString()]!.remove(startPoint);

        AppLogger.info('$graphTitle:[$DependencyType] Detach StartPoint($startPoint)',
            logType: AppLogType.dependencyGraph);
      }
    }
  }

  void clear() => _graph.clear();
}
