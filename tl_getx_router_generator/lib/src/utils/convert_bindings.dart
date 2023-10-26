import '../models/importable_type.dart';

ImportableType convertBindings(ImportableType viewType) {
  return ImportableType(
    className: '${viewType.className.replaceAll('View', '')}Binding',
    import: viewType.import?.replaceAll('/view.dart', '/binding.dart'),
  );
}
