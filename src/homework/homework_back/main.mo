import Text "mo:base/Text";
import Int "mo:base/Int";
import Bool "mo:base/Bool";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

actor Hm {

    
     type Homework = {
        title : Text;
        description : Text;
        dueDate : Int;
        completed : Bool;
    };

    let homeworkDiary = Buffer.Buffer<Homework>(0);

    public func addHomework(homework : Homework) : async Nat {
        homeworkDiary.add(homework);
        return homeworkDiary.size() - 1;
    };

    public func getHomework(id : Nat) : async Result.Result<Homework, ()> {
        switch (homeworkDiary.getOpt(id)) {
            case (null) return #err();
            case (?res) return #ok(res);
        };
    };

    public func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(id)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                homeworkDiary.put(id, homework);
                return #ok();
            };
        };
    };

    public func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(id)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                let newhomework = {
                    title = res.title;
                    description = res.description;
                    dueDate = res.dueDate;
                    completed = true;
                };

                homeworkDiary.put(id, newhomework);
                return #ok();
            };
        };
    };

    public func deleteHomework(id : Nat) : async Result.Result<(), Text> {
        switch (?homeworkDiary.get(id)) {
            case (null) return #err("Homework doesn't exist.");
            case (?res) {
                let removed = homeworkDiary.remove(id);
                return #ok();
            };
        };
    };

    public func getAllHomework() : async [Homework] {
        return Buffer.toArray(homeworkDiary);
    };

    public func getPendingHomework() : async [Homework] {
        let homeworkPending = Buffer.Buffer<Homework>(0);
        for (homework in homeworkDiary.vals()) {
            if (homework.completed == false) homeworkPending.add(homework);
        };

        return Buffer.toArray(homeworkPending);
    };

    public query func searchHomework(searchTeam : Text) : async [Homework] {
        let homeworkPending = Buffer.Buffer<Homework>(0);
        for (homework in homeworkDiary.vals()) {
            if (Text.contains(homework.title, #text searchTeam) or Text.contains(homework.description, #text searchTeam)) homeworkPending.add(homework);
        };

        return Buffer.toArray(homeworkPending);
    };

   
};