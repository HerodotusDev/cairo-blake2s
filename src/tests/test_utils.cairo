use cairo_blake2s::utils::{blake2s_compress, blake2s_state};
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

#[test]
#[available_gas(9999999999)]
fn test_blake2s_compress() {
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
        t: array![64, 0],
        f: array![4294967295, 0]
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