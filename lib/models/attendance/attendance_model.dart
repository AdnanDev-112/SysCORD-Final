class AttendanceModel {
  final List? classRange;
  final List? subjectList;
  String? className;

  AttendanceModel({this.classRange, this.className, this.subjectList});

  Map<String, dynamic> toJson() => {
        'subjectList': subjectList,
        'className': className,
        'classRange': classRange,
      };
}
