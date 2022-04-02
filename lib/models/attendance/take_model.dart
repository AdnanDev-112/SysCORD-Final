class SavedAttendance {
  final List? classNumbers;
  final List<bool>? colorState;
  String? subjectName;
  String? timeTaken;
  String? takenDate;
  String? timeStamp;
  int? month;
  int? yearTaken;

  SavedAttendance(
      {this.timeStamp,
      this.classNumbers,
      this.subjectName,
      this.timeTaken,
      this.takenDate,
      this.colorState,
      this.month,
      this.yearTaken});

  Map<String, dynamic> toJson() => {
        'timeStamp': timeStamp,
        'colorState': colorState,
        'subjectName': subjectName,
        'classNumbers': classNumbers,
        'timeTaken': timeTaken,
        'takenDate': takenDate,
        'month': month,
        'year': yearTaken
      };
}
