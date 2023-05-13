import Type "types";
import Int "mo:base/Int";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Hash "mo:base/Hash";
import Array "mo:base/Array";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

actor {
  type Content = Type.Content;

  type Message = Type.Message;

  let wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

  var messageId : Nat = 0;


  public shared ({ caller }) func writeMessage(content : Content) : async Result.Result<Message, Text> {
    messageId += 1;

    let message : Message = {
      vote = 0;
      content = content;
      creator = caller;
      messageId;
    };
    return #ok(message);
  };

  public shared ({ caller }) func getMessage(messageId : Nat) : async Result.Result<?Message, Text> {
    if (messageId >= wall.size()) {
      return #err("Invalid message id");
    };
    var message = wall.get(messageId);
    #ok(message);
  };

  public shared func deleteMessage(messageId : Nat) : async Result.Result<?Message, Text> {
    if (messageId >= wall.size()) {
      return #err("Invalid message id");
    };
    let message = wall.remove(messageId);
    #ok(message);
  };

  public shared ({ caller }) func upVote(messageId : Nat) : async Result.Result<(), Text> {
    switch (wall.get(messageId)) {
      case (?res) {
        let newMessage : Message = {
          vote = res.vote +1;
          content = res.content;
          creator = res.creator;
        };
        wall.put(messageId, newMessage);
        return #ok();
      };
      case null {
        return #err("hola no hay nada aca");
      };
    };
  };

  public shared func downVote(messageId : Nat) : async Result.Result<(), Text> {
  switch (wall.get(messageId)) {
      case (?res) {
        let newMessage : Message = {
          vote = res.vote -1;
          content = res.content;
          creator = res.creator;
        };
        wall.put(messageId, newMessage);
        return #ok();
      };
      case null {
        return #err("hola no hay nada aca");
      };
    };
  };

  public shared({caller}) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
    switch(wall.get(messageId)) {
      case(?res) {
         let newMessage : Message = {
          vote = res.vote;
          content = c;
          creator = res.creator;
        };
        wall.put(messageId, newMessage);
        return #ok();
       };
       case null {
        return #err("no es el user")
       }
    };
  };


  public shared func getAllMessages() : async [Message] {
    let buffer = Buffer.Buffer<Message>(0);
    for((key, value) in wall.entries()) {
      buffer.add(value);
    };
    return Buffer.toArray<Message>(buffer);
  };

  //getAllMessagesRanked :

  public shared func getAllMessagesRanked() : async [Message] {
     let buffer = Buffer.Buffer<Message>(0);
    for((key, value) in wall.entries()) {
      buffer.add(value);
    };
    let arrayAux = Buffer.toArray<Message>(buffer);
    //
    return Array.sort<Message>(arrayAux, func(a : Message, b : Message) { return Int.compare(b.vote, a.vote) });
  };

};
