import Type "types";
import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Bool "mo:base/Bool";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor MotoCoin {

  type Account = Type.Account;

  let ledger = TrieMap.TrieMap<Account, Nat>(Type.accountsEqual, Type.accountsHash);


  var totalSupply : Nat = 0;

  //

  public shared query func name() : async Text {
    return "Motocoin";
  };

  //step 3
  public shared query func symbol() : async Text {
    let tokenName = "MotoCoin";
    return tokenName;
  };

  //step4

  public func incrementTotalSupply(amount : Nat) : async Bool {
    totalSupply += amount;
    return true;
  };

  public func decrementTotalSupply(amount : Nat) : async Bool {
    if (totalSupply >= amount) {
      totalSupply -= amount;
      return true;
    } else {
      return false;
    };
  };
  
  //step5
  
  public func balanceOf(account : Account) : async Nat {
    switch (ledger.get(account)) {
      case null return (0);
      case (?res) return (res);
    };
  };

  
  //step6
  
  public shared func transfer(from : Account, to : Account, amount : Nat) : async Result.Result<(), Text> {
    switch (ledger.get(from)) {
      case null {
        #err("The transfer couldn't be Done");
      };
      case (?res) {
        if (res >= amount) {
          ledger.put(from, res -amount);
          ledger.put(to, res +amount);
        } else {
          return #err("saldo insuficiente");
        };
        return #ok();
      };
    };
  };

  //step7
  public shared func airdrop() : async Result.Result<(), Text> {
 
   for((key, value) in ledger.entries()) {
    ledger.put(key, value +100);
   };
   return #ok()
  };


  //step 8


};
