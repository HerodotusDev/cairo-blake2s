fn rotr16(n: u32) -> u32 {
    return n / 65536 + (n % 65536) * 65536;
}

fn rotr12(n: u32) -> u32 {
    return n / 4096 + (n % 4096) * 1048576;
}

fn rotr8(n: u32) -> u32 {
    return n / 256 + (n % 256) * 16777216;
}

fn rotr7(n: u32) -> u32 {
    return n / 128 + (n % 128) * 33554432;
}