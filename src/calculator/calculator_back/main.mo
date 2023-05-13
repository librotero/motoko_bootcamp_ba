import Buffer "mo:base/Buffer";
import Type "types";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
actor {

type Homework = Type.Homework;

// step 1
var homeworkDiary = Buffer.Buffer<Homework>(0);

//check
public shared func createHomework(homework : Homework) : async Nat {
  homeworkDiary.add(homework);
  homeworkDiary.size() - 1;
};

//  step 2
public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
  if (id >= homeworkDiary.size()) {
    return #err("id invalid");
  } else {
    return #ok(homeworkDiary.get(id));
  };
};

//step 3
public func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {

  if (id >= homeworkDiary.size()) {
    return #err("Invalid homework id");
  };
  homeworkDiary.put(id, homework);
  #ok( );

};

//step 4

public shared query func updateHomeworkCompleted(id : Nat, completed: Bool) : async Result.Result<Homework, Text> {
  if (id >= homeworkDiary.size()) {
    return #err("Invalid homework id");
  } else {

  let homeworkOpt : ?Homework = homeworkDiary.getOpt(id);

  switch (homeworkOpt) {
    case (null) {
      return #err("Homework not found with the id");
    };
    case (?homework) {
      let newHomework = {
        title = homework.title;
        description = homework.description;
        dueDate = homework.dueDate;
        completed = true;
      };
      homeworkDiary.put(id, newHomework);
      return #ok(homeworkDiary.get(id));
    };
  };
  };
};
// step 5

public shared query func deleteHomwork ( id: Nat) : async Result.Result<(), Text> {
   if (id >= homeworkDiary.size()) {
    return #err("Invalid homework id");
  } else {
  let newHomeworkDiary = homeworkDiary.remove(id);
  return #ok()
  }

};

//step 6 

public shared query func getAllHomework () : async [Homework] {
  Buffer.toArray(homeworkDiary);
};

//step 7.- 
  public shared query func getPendingHomework() : async [Homework] {
    let result = Buffer.Buffer<Homework>(0);
    Buffer.iterate<Homework>(
      homeworkDiary,
      func(homework) {
        if (not (homework.completed)) result.add(homework);
      },
    );
    Buffer.toArray(result);
  };

// step 8

   public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    let result = Buffer.Buffer<Homework>(0);
    Buffer.iterate<Homework>(
      homeworkDiary,
      func(homework) {
        if (homework.title == searchTerm or homework.description == searchTerm) result.add(homework);
      },
    );
    Buffer.toArray(result);
  };

}
