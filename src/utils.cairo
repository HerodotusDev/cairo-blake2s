use core::integer::{u32_wrapping_add, u32_wide_mul};

use cairo_blake2s::sigma::get_sigma;
use cairo_blake2s::rotr::{rotr16, rotr12, rotr8, rotr7};

use core::debug::PrintTrait;


fn G(
    m: Array<u32>, r: u32, i: u32, mut a: u32, mut b: u32, mut c: u32, mut d: u32
) -> (u32, u32, u32, u32) {
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

    return (a, b, c, d);
}
