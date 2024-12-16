/*
/// Module: dapp
module dapp::dapp;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions

module dapp::dapp;

//struct definitions
public struct Sword has key, store {
    id:UID,
    magic: u64,
    strength: u64
}

public struct Forge has key {
    id: UID,
    swords_created: u64,
}

// Module initializer to be executed when this module is published

#[allow(unused_function)]
fun int(ctx: &mut TxContext) {
    let admin = Forge {
        id: object::new(ctx),
        swords_created:0,
    };
    transfer::transfer(admin, ctx.sender());
}

//Accessors to read struct fields
public fun magic(self: &Sword) : u64 {
    self.magic
}

public fun strength(self: &Sword) : u64 {
    self.strength
}

public fun swords_created(self: &Forge) : u64 {
    self.swords_created
}


#[test]

public fun test_swords_create() {
    //create dummy for testing
    let mut ctx = tx_context::dummy();

    let sword = Sword{
        id: object::new(&mut ctx),
        magic: 10,
        strength: 7,
    };
 
    assert!(sword.magic() == 42 && sword.strength() == 7, 1);
}