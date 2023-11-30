use core::integer::{u32_wrapping_add, u32_wide_mul};

use cairo_blake2s::sigma::get_sigma;
use cairo_blake2s::rotr::{rotr16, rotr12, rotr8, rotr7};

use core::debug::PrintTrait;


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
    t0: u32,
    t1: u32,
    f: Array<u32>,
    buf: Array<u8>,
    buflen: u32,
    // outlen: u32,
    // last_node: u8,
}

fn blake2s_compress(mut s: blake2s_state, in: Array<u8>) -> blake2s_state {
    assert(in.len() == 64, 'in array must have length 64');
    let mut m: Array<u32> = ArrayTrait::new();
    
    let mut i: u32 = 0;
    loop {
        if i == 16 {
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
    let mut v12: u32 = (s.t0) ^ 0x510E527F;
    let mut v13: u32 = (s.t1) ^ 0x9B05688C;
    let mut v14: u32 = (*s.f[0]) ^ 0x1F83D9AB;
    let mut v15: u32 = (*s.f[1]) ^ 0x5BE0CD19;

    let m_span = m.span();

    let mut r = 0;
    loop {
        if r == 10 {
            break;
        }
        // ROUND function begin

        let mut a = 0;
        let mut b = 0;
        let mut c = 0;
        let mut d = 0;
        let mut i = 0;
        loop {
            if i == 8 {
                break;
            }
            if i == 0 {
                a = v0; b = v4; c = v8; d = v12;
            } else if i == 1 {
                a = v1; b = v5; c = v9; d = v13;
            } else if i == 2 {
                a = v2; b = v6; c = v10; d = v14;
            } else if i == 3 {
                a = v3; b = v7; c = v11; d = v15;
            } else if i == 4 {
                a = v0; b = v5; c = v10; d = v15;
            } else if i == 5 {
                a = v1; b = v6; c = v11; d = v12;
            } else if i == 6 {
                a = v2; b = v7; c = v8; d = v13;
            } else if i == 7 {
                a = v3; b = v4; c = v9; d = v14;
            };

            // G function begin
            
            // a = a + b + m[sigma[r][2*i]]
            a = u32_wrapping_add(u32_wrapping_add(a, b), *m_span.at(get_sigma(r, 2 * i)));

            d = rotr16(d ^ a);

            // c = c + d
            c = u32_wrapping_add(c, d);

            b = rotr12(b ^ c);

            // a = a + b + m[sigma[r][2*i+1]]
            a = u32_wrapping_add(u32_wrapping_add(a, b), *m_span.at(get_sigma(r, 2 * i + 1)));

            d = rotr8(d ^ a);

            // c = c + d
            c = u32_wrapping_add(c, d);

            b = rotr7(b ^ c);

            // G function end

            if i == 0 {
                v0 = a; v4 = b; v8 = c; v12 = d;
            } else if i == 1 {
                v1 = a; v5 = b; v9 = c; v13 = d;
            } else if i == 2 {
                v2 = a; v6 = b; v10 = c; v14 = d;
            } else if i == 3 {
                v3 = a; v7 = b; v11 = c; v15 = d;
            } else if i == 4 {
                v0 = a; v5 = b; v10 = c; v15 = d;
            } else if i == 5 {
                v1 = a; v6 = b; v11 = c; v12 = d;
            } else if i == 6 {
                v2 = a; v7 = b; v8 = c; v13 = d;
            } else if i == 7 {
                v3 = a; v4 = b; v9 = c; v14 = d;
            };

            i += 1;
        };

        // ROUND function end

        r += 1;
    };


    let h1 = (*s.h[0]) ^ v0 ^ v8;
    let h2 = (*s.h[1]) ^ v1 ^ v9;
    let h3 = (*s.h[2]) ^ v2 ^ v10;
    let h4 = (*s.h[3]) ^ v3 ^ v11;
    let h5 = (*s.h[4]) ^ v4 ^ v12;
    let h6 = (*s.h[5]) ^ v5 ^ v13;
    let h7 = (*s.h[6]) ^ v6 ^ v14;
    let h8 = (*s.h[7]) ^ v7 ^ v15;

    h1.print(); // 0x214d3e11
    h2.print(); // 0x19e05713
    h3.print(); // 0xfa70f7ac

    s
}

fn blake2s_update(mut s: blake2s_state, in: Array<u8>) -> blake2s_state {
    let inlen = in.len();
    if inlen == 0 {
        return s;
    }
    let left = s.buflen;
    let fill = 64 - left;
    if inlen > fill {
        s.buflen = 0;
        let mut i: u32 = 0;
        loop {
            if i == fill {
                break;
            }
            s.buf.append(*in.at(i));
            i += 1;
        };
        s.t0 = u32_wrapping_add(s.t0, 64_u32);
        if s.t0 < 64_u32 {
            s.t1 = u32_wrapping_add(s.t1, 1);
        }
        let mut buf: Array<u8> = s.buf.clone();
        s = blake2s_compress(s, buf);
    }
    s
}