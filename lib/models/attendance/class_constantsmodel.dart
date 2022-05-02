class ClassConstantsModel {
  final List? subjectList;
  final List? classRange;

  String? className;

  ClassConstantsModel({this.classRange, this.className, this.subjectList});

  Map<String, dynamic> toJson() => {
        'className': className,
        'subjectList': subjectList,
        'classRange': classRange,
      };
}
