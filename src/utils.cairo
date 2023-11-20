use cairo_blake2s::sigma::get_sigma;
use core::integer::{u32_wrapping_add, u32_wide_mul};
use core::debug::PrintTrait;




fn G(m: Array<u32>, r: u32, i: u32, mut a: u32, mut b: u32, mut c: u32, mut d: u32) -> (u32, u32, u32, u32) {
    a = u32_wrapping_add(u32_wrapping_add(a, b), *m.at(get_sigma(r, 2*i))); // a + b + m[sigma[r][2*i]]
    d = d ^ a;
    return (a, b, c, d);
}

#[cfg(test)]
mod tests {
    use super::G;
    use core::debug::PrintTrait;

    #[test]
    #[available_gas(100000)]
    fn Gtest() {
        let m: Array<u32> = array![0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        let (a, b, c, d) = G(m, 0, 0, 4294967200, 4294967200, 3, 4);
        a.print();
        d.print();
    }
}