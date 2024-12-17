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
fun init(ctx: &mut TxContext) {
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

public fun sword_create(magic: u64, strength: u64, ctx: &mut TxContext): Sword {
    Sword {
        id: object::new(ctx),
        magic: magic,
        strength: strength,
    }
}

//To check the Forge working
public fun new_sword(forge: &mut Forge, magic: u64, strength: u64, ctx: &mut TxContext): Sword {
    forge.swords_created = forge.swords_created + 1;
    Sword {
        id: object::new(ctx),
        magic: magic,
        strength: strength,
    }
}


#[test]
//Using test_utils i.e. can be done with test_scenario or without any module.
fun test_sword_create() {
    use sui::test_utils;
    // use sui::test_scenario;
    
    let magic: u64 = 42;
    let strength: u64 = 7;

    //sets up the context
    // let initial_owner = @0xCAFE;
    let mut ctx = tx_context::dummy();

    // Create the sword using the transaction context
    let sword = sword_create(magic, strength, &mut ctx);

    // Assert that sword attributes match
    test_utils::assert_eq(magic, sword.magic());
    test_utils::assert_eq(strength, sword.strength());

    // End the scenario (clean-up)
    test_utils::destroy(sword);
}

#[test]
fun test_sword_transaction() {
    use sui::test_scenario;

    //Test network
    let initial_owner = @0xCAFE;
    let final_owner = @0xFACE;

    //Initial Transaction
    let mut scenario = test_scenario::begin(initial_owner);
    {
        //create sword and transfer to initial owner
        let sword = sword_create(42, 7, scenario.ctx());
        transfer::public_transfer(sword, initial_owner);
    };

    //Second Transaction
    scenario.next_tx(initial_owner); 
    {
        //Extract the sword owned by initial owner
        let sword = scenario.take_from_sender<Sword>();
        transfer::public_transfer(sword, final_owner);
    };

    //Third Transaction by final owner
    scenario.next_tx(final_owner);
    {
        let sword = scenario.take_from_sender<Sword>();
        //verify sword properties
        assert!(sword.magic == 42 && sword.strength == 7, 1);
        //Retrun the sword to the object pool
        scenario.return_to_sender(sword);
    };
    scenario.end();
}

#[test]
fun test_module_init() {
    use sui::test_scenario;

    let admin = @0xAD;
    let initial_owner = @0xCAFE;

    let mut scenario = test_scenario::begin(admin);
    {
        init(scenario.ctx());
    };

    scenario.next_tx(admin);
    {
        let forge = scenario.take_from_sender<Forge>();
        assert!(forge.swords_created() == 0,1);
        scenario.return_to_sender(forge);
    };

    scenario.next_tx(admin);
    {
        let mut forge = scenario.take_from_sender<Forge>();
        let sword = forge.new_sword(42, 7, scenario.ctx());
        transfer::public_transfer(sword, initial_owner);
        scenario.return_to_sender(forge);
    };
    scenario.end();
}