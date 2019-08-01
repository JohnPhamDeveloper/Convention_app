// Check to see how many firestore calls are being made
class FirestoreReadcheck {
  // Reads
  static int searchInfoPageReads = 0;
  static int userProfileReads = 0;
  static int rankPageReads = 0;
  static int heroCreatorReads = 0;

  // Writes
  static int userProfileWrites = 0;
  static int heroCreatorWrites = 0;

  // Total
  static int _totalReads = searchInfoPageReads + userProfileReads + rankPageReads + heroCreatorReads;
  static int _totalWrites = userProfileWrites + heroCreatorWrites;
  static int _totalOverall = _totalReads + _totalWrites;

  static printSearchInfoPageReads() {
    print("Search info page reads: $searchInfoPageReads");
  }

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

  static printTotalReads() {
    print("Total reads: $_totalReads");
  }

  static printTotalWrites() {
    print("Total writes: $_totalWrites");
  }

  static printTotalOverall() {
    print("Total overall: $_totalOverall");
  }
}
