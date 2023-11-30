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
    h: Array<u32>, // length: 8
    t0: u32,
    t1: u32,
    f: Array<u32>, // length: 2
    buf: Array<u8>, // length: 64
    buflen: u32,
    // outlen: u32,
    // last_node: u8,
}

fn print_state(s: blake2s_state) -> blake2s_state {
    (*s.h[0]).print();
    (*s.h[1]).print();
    (*s.h[2]).print();
    (*s.h[3]).print();
    (*s.h[4]).print();
    (*s.h[5]).print();
    (*s.h[6]).print();
    (*s.h[7]).print();
    s.t0.print();
    s.t1.print();
    (*s.f[0]).print();
    (*s.f[1]).print();
    return s;
}

fn blake2s_init() -> blake2s_state { // 
    let blake2s_IV = array![
        0x6A09E667 ^ 0x01010020, // xor (depth, fanout, digest_length)
        0xBB67AE85,
        0x3C6EF372,
        0xA54FF53A,
        0x510E527F,
        0x9B05688C,
        0x1F83D9AB,
        0x5BE0CD19
    ];
    let mut buf = ArrayTrait::new();
    let mut i = 0;
    loop {
        if i == 64 {
            break;
        }
        buf.append(0);
        i += 1;
    };
    blake2s_state {
        h: blake2s_IV,
        t0: 0,
        t1: 0,
        f: array![0, 0],
        buf: buf,
        buflen: 0
    }
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

    let mut new_h = ArrayTrait::new();
    new_h.append((*s.h[0]) ^ v0 ^ v8);
    new_h.append((*s.h[1]) ^ v1 ^ v9);
    new_h.append((*s.h[2]) ^ v2 ^ v10);
    new_h.append((*s.h[3]) ^ v3 ^ v11);
    new_h.append((*s.h[4]) ^ v4 ^ v12);
    new_h.append((*s.h[5]) ^ v5 ^ v13);
    new_h.append((*s.h[6]) ^ v6 ^ v14);
    new_h.append((*s.h[7]) ^ v7 ^ v15);
    s.h = new_h;

    s
}

fn blake2s_update(mut s: blake2s_state, in: Array<u8>) -> blake2s_state {
    let mut in_len = in.len();
    let mut in_shift = 0;
    let in_span = in.span();
    if in_len != 0 {
        let left = s.buflen;
        let fill = 64 - left;
        if in_len > fill {
            s.buflen = 0;

            let mut new_buf = ArrayTrait::new();
            let buf_span = s.buf.span();
            let mut i: u32 = 0;
            loop {
                if i == left {
                    break;
                }
                new_buf.append(*buf_span.at(i));
                i += 1;
            };

            i = 0;
            loop {
                if i == fill {
                    break;
                }
                new_buf.append(*in_span[i]);
                i += 1;
            };

            // blake2s_increment_counter
            s.t0 = u32_wrapping_add(s.t0, 64_u32);
            if s.t0 < 64_u32 {
                s.t1 = u32_wrapping_add(s.t1, 1);
            }

            s = blake2s_compress(s, new_buf);

            in_shift += fill;
            in_len -= fill;

            loop {
                if in_len <= 64_u32 { // TODO: check if this can be converted to ==
                    break;
                }

                // blake2s_increment_counter
                s.t0 = u32_wrapping_add(s.t0, 64_u32);
                if s.t0 < 64_u32 {
                    s.t1 = u32_wrapping_add(s.t1, 1);
                }

                let mut compress_in = ArrayTrait::new();
                i = 0;
                loop {
                    if i == 64_u32 {
                        break;
                    }
                    compress_in.append(*in_span[in_shift + i]);
                    i += 1;
                };

                s = blake2s_compress(s, compress_in);

                in_shift += 64_u32;
                in_len -= 64_u32;
            };
        }

        let mut new_buf = ArrayTrait::new();
        let buf_span = s.buf.span();
        let mut i = 0;
        loop {
            if i == s.buflen {
                break;
            }
            new_buf.append(*buf_span[i]);
            i += 1;
        };
        i = 0;
        loop {
            if i == in_len {
                break;
            }
            new_buf.append(*in_span[in_shift + i]);
            i += 1;
        };
        loop {
            if new_buf.len() == 64_u32 {
                break;
            }
            new_buf.append(0);
        };
        s.buf = new_buf;
        s.buflen += in_len;
    }
    s
}

fn blake2s_final(mut s: blake2s_state) -> Array<u8> {
    assert(*s.f[0] == 0, 'blake2s_is_lastblock');

    // blake2s_increment_counter 
    s.t0 = u32_wrapping_add(s.t0, s.buflen);
    if s.t0 < s.buflen {
        s.t1 = u32_wrapping_add(s.t1, 1);
    }

    let f1 = *s.f[1];
    s.f = array![0xffffffff, f1];

    let mut i = 0;
    let buf_span = s.buf.span();
    let mut buf = ArrayTrait::new();
    loop {
        if i == s.buflen {
            break;
        }
        buf.append(*buf_span[i]);
        i += 1;
    };
    loop {
        if i == 64 {
            break;
        }
        buf.append(0);
        i += 1;
    };

    s = blake2s_compress(s, buf);

    let mut result: Array<u8> = ArrayTrait::new();
    i = 0;
    loop {
        if i == 8 {
            break;
        }
        let mut x = *s.h[i];
        result.append((x%256).try_into().unwrap());
        x /= 256;
        result.append((x%256).try_into().unwrap());
        x /= 256;
        result.append((x%256).try_into().unwrap());
        x /= 256;
        result.append((x%256).try_into().unwrap());
        i += 1;
    };
    result
}

fn blake2s(data: Array<u8>) -> Array<u8> {
    let mut state = blake2s_init();
    state = blake2s_update(state, data);
    blake2s_final(state)
}