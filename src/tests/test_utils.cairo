use cairo_blake2s::utils::{blake2s_compress, blake2s_state, blake2s_update, print_state, blake2s};
use debug::PrintTrait;

// #[test]
// #[available_gas(9999999999)]
// fn test_utils_G() {
//     let m = array![
//         67305985,
//         134678021,
//         202050057,
//         269422093,
//         336794129,
//         404166165,
//         471538201,
//         538910237,
//         606282273,
//         673654309,
//         741026345,
//         808398381,
//         875770417,
//         943142453,
//         1010514489,
//         1077886525
//     ];
//     assert(
//         G(
//             m, 9, 7, 333420414, 3486986113, 2388885035, 1087284008
//         ) == (2363701700, 2138128836, 3562199216, 3889364834),
//         '1. G()'
//     );
// }

// #[test]
// #[available_gas(9999999999)]
// fn test_utils_round() {
//     let m = array![];
//     let arr = array![1, 2, 3, 4, 5, 6];
//     let res = round(m, arr, 0);
//     let mut i = 0;
//     loop {
//         if i == res.len() {
//             break ();
//         }
//         (*res.at(i)).print();
//         i += 1;
//     }
// }

// #[test]
// #[available_gas(9999999999)]
fn test_blake2s_compress() {
    let mut buf = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i == 64 {
            break;
        }
        buf.append(0);
        i += 1;
    };

    let state = blake2s_state {
        h: array![
            1795745351,
            3144134277,
            1013904242,
            2773480762,
            1359893119,
            2600822924,
            528734635,
            1541459225
        ],
        t0: 64,
        t1: 0,
        f: array![4294967295, 0],
        buflen: 0,
        buf: buf
    };
    let mut in = ArrayTrait::new();
    let mut i: u8 = 1;
    loop {
        if i > 64 {
            break ();
        }
        in.append(i); 
        i += 1;
    };

    blake2s_compress(state, in);
}


#[test]
#[available_gas(9999999999)]
fn test_blake2s() {
    let mut in = ArrayTrait::new();
    let mut i: u32 = 1;
    loop {
        if i > 600 {
            break ();
        }
        let val: Option<u8> = (i%256).try_into();
        in.append(val.unwrap()); 
        i += 1;
    };

    let res = blake2s(in);

    assert(res == 0xb313d5aa69f9b08bbdf026f95b9af6e31b8120f3aa1842e9b0ff935878bfc500, 'invalid hash');
}