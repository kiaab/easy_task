part of 'task.dart';

class TaskAdapter extends TypeAdapter<TaskEntity> {
  @override
  TaskEntity read(BinaryReader reader) {
    final numOfFeilds = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFeilds; i++) reader.readByte(): reader.read()
    };
    return TaskEntity(fields[0], fields[1], fields[2]);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, TaskEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.checked)
      ..writeByte(2)
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
