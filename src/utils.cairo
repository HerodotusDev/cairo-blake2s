use core::integer::{u32_wrapping_add, u32_wide_mul};

use cairo_blake2s::sigma::get_sigma;
use cairo_blake2s::rotr::{rotr16, rotr12, rotr8, rotr7};

use core::debug::PrintTrait;


fn G(
    m: Array<u32>, r: u32, i: u32, mut a: u32, mut b: u32, mut c: u32, mut d: u32
) -> (u32, u32, u32, u32, Array<u32>) {
    // a = a + b + m[sigma[r][2*i]]
    a = u32_wrapping_add(u32_wrapping_add(a, b), *m.at(get_sigma(r, 2 * i)));

    d = rotr16(d ^ a);

    // c = c + d
    c = u32_wrapping_add(c, d);

    b = rotr12(b ^ c);

    // a = a + b + m[sigma[r][2*i+1]]
    a = u32_wrapping_add(u32_wrapping_add(a, b), *m.at(get_sigma(r, 2 * i + 1)));

    d = rotr8(d ^ a);

    // c = c + d
    c = u32_wrapping_add(c, d);

    b = rotr7(b ^ c);

    return (a, b, c, d, m);
}

fn Gv2(
    m: Array<u32>, r: u32, i: u32, mut a: u32, mut b: u32, mut c: u32, mut d: u32
) -> (u32, u32, u32, u32, Array<u32>) {
    // a = a + b + m[sigma[r][2*i]]
    a = u32_wrapping_add(u32_wrapping_add(a, b), *m.at(get_sigma(r, 2 * i)));

    d = rotr16(d ^ a);

    // c = c + d
    c = u32_wrapping_add(c, d);

    b = rotr12(b ^ c);

    // a = a + b + m[sigma[r][2*i+1]]
    a = u32_wrapping_add(u32_wrapping_add(a, b), *m.at(get_sigma(r, 2 * i + 1)));

    d = d ^ a;
    d = d ^ a;
    d = d ^ a;
    d = d ^ a;
    d = d ^ a;
    // (d).print();
    // (a).print();
    // d = rotr8(d ^ a);

    // // c = c + d
    // c = u32_wrapping_add(c, d);

    // b = rotr7(b ^ c);

    return (a, b, c, d, m);
}

fn round(
    m: Array<u32>,
    r: u32,
    v0: u32,
    v1: u32,
    v2: u32,
    v3: u32,
    v4: u32,
    v5: u32,
    v6: u32,
    v7: u32,
    v8: u32,
    v9: u32,
    v10: u32,
    v11: u32,
    v12: u32,
    v13: u32,
    v14: u32,
    v15: u32
) -> (Array<u32>, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32, u32) {
    let (v0, v4, v8, v12, m) = G(m, r, 0, v0, v4, v8, v12);
    let (v1, v5, v9, v13, m) = G(m, r, 1, v1, v5, v9, v13);
    let (v2, v6, v10, v14, m) = G(m, r, 2, v2, v6, v10, v14);
    let (v3, v7, v11, v15, m) = G(m, r, 3, v3, v7, v11, v15);
    let (v0, v5, v10, v15, m) = G(m, r, 4, v0, v5, v10, v15);
    let (v1, v6, v11, v12, m) = G(m, r, 5, v1, v6, v11, v12);
    let (v2, v7, v8, v13, m) = G(m, r, 6, v2, v7, v8, v13);
    let (v3, v4, v9, v14, m) = G(m, r, 7, v3, v4, v9, v14);
    return (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
}

fn load32(p0: u8, p1: u8, p2: u8, p3: u8) -> u32 {
    let mut x: u32 = p3.into();
    x = x * 256 + p2.into();
    x = x * 256 + p1.into();
    x = x * 256 + p0.into();
    x
}

#[derive(Drop, Clone)]
struct blake2s_state {
    h: Array<u32>,
    t: Array<u32>,
    f: Array<u32>,
    // buf: Array<u8>,
    // buflen: u32,
    // outlen: u32,
    // last_node: u8,
}

fn blake2s_compress(s: blake2s_state, in: Array<u8>) {
    let mut m = ArrayTrait::new();
    
    let mut i: u32 = 0;
    loop {
        if i >= 16 {
            break;
        }
        m.append(load32(*in[4*i+0], *in[4*i+1], *in[4*i+2], *in[4*i+3]));
        i += 1;
    };
    
    let mut v0: u32 = *s.h[0];
    let mut v1: u32 = *s.h[1];
    let mut v2: u32 = *s.h[2];
    let mut v3: u32 = *s.h[3];
    let mut v4: u32 = *s.h[4];
    let mut v5: u32 = *s.h[5];
    let mut v6: u32 = *s.h[6];
    let mut v7: u32 = *s.h[7];
    let mut v8: u32 = 0x6A09E667;
    let mut v9: u32 = 0xBB67AE85;
    let mut v10: u32 = 0x3C6EF372;
    let mut v11: u32 = 0xA54FF53A;
    let mut v12: u32 = (*s.t[0]) ^ 0x510E527F;
    let mut v13: u32 = (*s.t[1]) ^ 0x9B05688C;
    let mut v14: u32 = (*s.f[0]) ^ 0x1F83D9AB;
    let mut v15: u32 = (*s.f[1]) ^ 0x5BE0CD19;

    let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 0, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 1, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 2, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);


    let (v0, v4, v8, v12, m) = G(m, 3, 0, v0, v4, v8, v12);
    let (v1, v5, v9, v13, m) = G(m, 3, 1, v1, v5, v9, v13);
    let (v2, v6, v10, v14, m) = G(m, 3, 2, v2, v6, v10, v14);

    let (v3, v7, v11, v15, m) = Gv2(m, 3, 3, v3, v7, v11, v15);

    // let (v3, v7, v11, v15, m) = G(m, 3, 3, v3, v7, v11, v15);
    // let (v0, v5, v10, v15, m) = G(m, 3, 4, v0, v5, v10, v15);
    // let (v1, v6, v11, v12, m) = G(m, 3, 5, v1, v6, v11, v12);
    // let (v2, v7, v8, v13, m) = G(m, 3, 6, v2, v7, v8, v13);
    // let (v3, v4, v9, v14, m) = G(m, 3, 7, v3, v4, v9, v14);

    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 3, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 4, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 5, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 6, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 7, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 8, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);
    // let (m, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15) = round(m, 9, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15);


    // let h1 = (*s.h[0]) ^ v0 ^ v8;
    // let h2 = (*s.h[1]) ^ v1 ^ v9;
    // let h3 = (*s.h[2]) ^ v2 ^ v10;
    // let h4 = (*s.h[3]) ^ v3 ^ v11;
    // let h5 = (*s.h[4]) ^ v4 ^ v12;
    // let h6 = (*s.h[5]) ^ v5 ^ v13;
    // let h7 = (*s.h[6]) ^ v6 ^ v14;
    // let h8 = (*s.h[7]) ^ v7 ^ v15;

    // h1.print();
    // h2.print();
}