part of 'task.dart';

class TaskAdapter extends TypeAdapter<TaskEntity> {
  @override
  TaskEntity read(BinaryReader reader) {
    final numOfFeilds = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFeilds; i++) reader.readByte(): reader.read()
    };
    return TaskEntity(
        title: fields[0],
        content: fields[1],
        tag: fields[2],
        checked: fields[3],
        important: fields[4]);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, TaskEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.tag)
      ..writeByte(3)
      ..write(obj.checked)
      ..writeByte(4)
      ..write(obj.important);
  }

  @override
  final int typeId = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
