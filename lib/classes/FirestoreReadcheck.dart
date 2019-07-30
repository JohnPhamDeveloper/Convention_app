class FirestoreReadcheck {
  static int searchInfoPageReads = 0;
  static int userProfileReads = 0;
  static int userProfileWrites = 0;
  static int rankPageReads = 0;
  static int heroCreatorReads = 0;
  static int heroCreatorWrites = 0;

  static printUserProfileReads() {
    print("User profile reads: $userProfileReads");
  }

  static printUserProfileWrites() {
    print("User profile writes: $userProfileWrites");
  }

  static printHeroCreatorReads() {
    print("Hero creator reads: $heroCreatorReads");
  }

  static printHeroCreatorWrites() {
    print("Hero creator writes: $heroCreatorWrites");
  }
}
