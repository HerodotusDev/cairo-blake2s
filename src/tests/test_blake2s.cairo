use cairo_blake2s::blake2s::blake2s;
use debug::PrintTrait;


fn get_arr_v1(n: u32) -> Array<u8> {
    let mut arr = ArrayTrait::new();
    let mut i: u32 = 1;
    loop {
        arr.append((i%256).try_into().unwrap()); 
        if i == n {
            break;
        }
        i += 1;
    };
    arr
}

fn get_arr_v2(n: u32) -> Array<u8> {
    let mut arr = ArrayTrait::new();
    let mut s: u32 = 1;
    let mut i: u32 = 1;
    loop {
        s *= 17;
        s = s^i;
        s %= 256;
        arr.append(s.try_into().unwrap()); 
        if i == n {
            break;
        }
        i += 1;
    };
    arr
}

#[test]
#[available_gas(9999999999)]
fn test_blake2s_v1() {
    assert(blake2s(get_arr_v1(1)) == 0x9199df0eea470f4311b8d4207d44d190b269c08919a62a282d9421d7f1f487fc, 'invalid hash (1)');
    assert(blake2s(get_arr_v1(5)) == 0x1049667103a7da13dbd3ecec3f556f59f33a4cf9a588aa01b5f03e8d0220a14f, 'invalid hash (5)');
    assert(blake2s(get_arr_v1(64)) == 0xc7fa21bb08b0bd19600ad212c0fa0f7ff332f415ae1527282a939406413299aa, 'invalid hash (64)');
    assert(blake2s(get_arr_v1(65)) == 0x2c29cd914274e30a12eb9fcd3db6c2f3aa191e096ebce21223b77bca39284935, 'invalid hash (65)');
    assert(blake2s(get_arr_v1(128)) == 0x5651036b64f7affbe498f0409950e06a352bcae03f5a79b78fec58a4cebe10d5, 'invalid hash (128)');
    assert(blake2s(get_arr_v1(132)) == 0x42d5eeff1aa4972630bcca469f37bbe8c2f8014937e28cbedbc671571d3eb87c, 'invalid hash (132)');
    assert(blake2s(get_arr_v1(1000)) == 0x33fc848fc73514d8bc3f338b23ba684d945081da37e5a8e490db5032eac34630, 'invalid hash (1000)');
    assert(blake2s(get_arr_v1(1088)) == 0x1b5ad0d1b82600127a6add8e1cf604a075843c3d35bbe31d636fa071674c9432, 'invalid hash (1088)');
}

#[test]
#[available_gas(9999999999)]
fn test_blake2s_v2() {
    assert(blake2s(get_arr_v2(1)) == 0xd92e761177b537afcd649b0d7f9425cafd5e312c86ab6dd5789884129dd8a012, 'invalid hash (1)');
    assert(blake2s(get_arr_v2(5)) == 0x550396af1abce8dd342fd0601c439896944948f20553b2b16d7cce63ac93d39e, 'invalid hash (5)');
    assert(blake2s(get_arr_v2(64)) == 0xdfe91aa5523f1df5e6549d98121e9bdbac4cbba4375e93d812ef487d0fe562f6, 'invalid hash (64)');
    assert(blake2s(get_arr_v2(65)) == 0x87f25fbbe4a1dc684cfaf28e27e665413e3111961711cf7c570cd775dcb95a51, 'invalid hash (65)');
    assert(blake2s(get_arr_v2(128)) == 0x83e9b2b70274d9198b6b77a1760ebacfd1f0fe232a0ed78f1c722e154ee72362, 'invalid hash (128)');
    assert(blake2s(get_arr_v2(132)) == 0x93a7f68b8ea17374c11e1da719885513b598c4e191825fb584e399206c05ae15, 'invalid hash (132)');
    assert(blake2s(get_arr_v2(1000)) == 0xe4e6bd453ba2eb5a378d7933576dbf697b6d31cf38061c550ea36f6843a9bf43, 'invalid hash (1000)');
    assert(blake2s(get_arr_v2(1088)) == 0x5906fef89f21466142323029000040f6c25be2ff87d581a8f752b94ad3662762, 'invalid hash (1088)');
}