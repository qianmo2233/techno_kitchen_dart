class MusicData {
  final int musicId;
  final int level;
  final int playCount;
  final int achievement;
  final int comboStatus;
  final int syncStatus;
  final int deluxscoreMax;
  final int scoreRank;
  final int extNum1;

  MusicData({
    required this.musicId,
    required this.level,
    required this.playCount,
    required this.achievement,
    required this.comboStatus,
    required this.syncStatus,
    required this.deluxscoreMax,
    required this.scoreRank,
    required this.extNum1,
  });

  factory MusicData.defaultData() {
    return MusicData(
      musicId: 834,
      level: 4,
      playCount: 11,
      achievement: 91000,
      comboStatus: 0,
      syncStatus: 0,
      deluxscoreMax: 2102,
      scoreRank: 5,
      extNum1: 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'musicId': musicId,
        'level': level,
        'playCount': playCount,
        'achievement': achievement,
        'comboStatus': comboStatus,
        'syncStatus': syncStatus,
        'deluxscoreMax': deluxscoreMax,
        'scoreRank': scoreRank,
        'extNum1': extNum1,
      };
}

class ArcadeInfo {
  final int regionId;
  final String regionName;
  final int placeId;
  final String placeName;
  final String clientId;

  ArcadeInfo({
    required this.regionId,
    required this.regionName,
    required this.placeId,
    required this.placeName,
    required this.clientId,
  });

  factory ArcadeInfo.defaultInfo() {
    return ArcadeInfo(
      regionId: 1,
      regionName: "北京",
      placeId: 1403,
      placeName: "插电师电玩北京西单大悦城店",
      clientId: "A63E01C2805",
    );
  }

  Map<String, dynamic> toJson() => {
        'regionId': regionId,
        'regionName': regionName,
        'placeId': placeId,
        'placeName': placeName,
        'clientId': clientId,
      };
}