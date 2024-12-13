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

fun int(ctx: &mut TxContext) {
    let admin = Forge {
        id: object::new(ctx),
        swords_created:0,
    };
    transfer::transfer(admin, ctx.sender());
}
