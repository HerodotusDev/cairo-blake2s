use cairo_blake2s::blake2s::blake2s;
use debug::PrintTrait;

#[test]
#[available_gas(9999999999)]
fn test_blake2s() {
    let mut in = ArrayTrait::new();
    let mut i: u32 = 1;
    loop {
        if i > 600 {
            break ();
        }
        in.append((i%256).try_into().unwrap()); 
        i += 1;
    };

    let res = blake2s(in);

    assert(res == 0xb313d5aa69f9b08bbdf026f95b9af6e31b8120f3aa1842e9b0ff935878bfc500, 'invalid hash');
}