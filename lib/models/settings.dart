import 'package:isar/isar.dart';

part 'settings.g.dart';

@Collection()
class Appsettings {
  Id id = Isar.autoIncrement;
  DateTime? firstLaunchDate;
}
