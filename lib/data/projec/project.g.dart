part of 'project.dart';

class ProjectAdapter extends TypeAdapter<ProjectEntity> {
  @override
  ProjectEntity read(BinaryReader reader) {
    final numOfFeilds = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFeilds; i++) reader.readByte(): reader.read()
    };
    return ProjectEntity(title: fields[0], progres: fields[1]);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, ProjectEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.progres);
  }

  @override
  final int typeId = 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
