use cairo_blake2s::rotr::{rotr16, rotr12, rotr8, rotr7};

#[test]
#[available_gas(9999999999)]
fn test_rotr16() {
    assert(rotr16(0x11112222) == 0x22221111, 'rotr16(0x11112222) = 0x22221111');
    assert(rotr16(0x1a3b4c6d) == 0x4c6d1a3b, 'rotr16(0x1a3b4c6d) = 0x4c6d1a3b');
    assert(rotr16(0x1a3f7b9e) == 0x7b9e1a3f, 'rotr16(0x1a3f7b9e) = 0x7b931a3f');
    assert(rotr16(0x8d2e6f4c) == 0x6f4c8d2e, 'rotr16(0x8d2e6f4c) = 0x6f4c8d2e');
    assert(rotr16(0xf0a12e87) == 0x2e87f0a1, 'rotr16(0xf0a12e87) = 0x2e87f0a1');
    assert(rotr16(0x76c98d5a) == 0x8d5a76c9, 'rotr16(0x76c98d5a) = 0x8d5a76c9');
    assert(rotr16(0xe9b57423) == 0x7423e9b5, 'rotr16(0xe9b57423) = 0x7423e9b5');
    assert(rotr16(0x2f63a1d8) == 0xa1d82f63, 'rotr16(0x2f63a1d8) = 0xa1d82f63');
}


#[test]
#[available_gas(9999999999)]
fn test_rotr12() {
    assert(rotr12(0x11112222) == 0x22211112, 'rotr12(0x11112222) = 0x22211112');
    assert(rotr12(0x1a3b4c6d) == 0xc6d1a3b4, 'rotr12(0x1a3b4c6d) = 0xc6d1a3b4');
    assert(rotr12(0x1a3f7b9e) == 0xb9e1a3f7, 'rotr12(0x1a3f7b9e) = 0xb9e1a3f7');
    assert(rotr12(0x8d2e6f4c) == 0xf4c8d2e6, 'rotr12(0x8d2e6f4c) = 0xf4c8d2e6');
    assert(rotr12(0xf0a12e87) == 0xe87f0a12, 'rotr12(0xf0a12e87) = 0xe87f0a12');
    assert(rotr12(0x76c98d5a) == 0xd5a76c98, 'rotr12(0x76c98d5a) = 0xd5a76c98');
    assert(rotr12(0xe9b57423) == 0x423e9b57, 'rotr12(0xe9b57423) = 0x423e9b57');
    assert(rotr12(0x2f63a1d8) == 0x1d82f63a, 'rotr12(0x2f63a1d8) = 0x1d82f63a');
}

#[test]
#[available_gas(9999999999)]
fn test_rotr8() {
    assert(rotr8(0x11112222) == 0x22111122, 'rotr8(0x11112222) = 0x22111122');
    assert(rotr8(0x1a3b4c6d) == 0x6d1a3b4c, 'rotr8(0x1a3b4c6d) = 0x6d1a3b4c');
    assert(rotr8(0x1a3f7b9e) == 0x9e1a3f7b, 'rotr8(0x1a3f7b9e) = 0x9e1a3f7b');
    assert(rotr8(0x8d2e6f4c) == 0x4c8d2e6f, 'rotr8(0x8d2e6f4c) = 0x4c8d2e6f');
    assert(rotr8(0xf0a12e87) == 0x87f0a12e, 'rotr8(0xf0a12e87) = 0x87f0a12e');
    assert(rotr8(0x76c98d5a) == 0x5a76c98d, 'rotr8(0x76c98d5a) = 0x5a76c98d');
    assert(rotr8(0xe9b57423) == 0x23e9b574, 'rotr8(0xe9b57423) = 0x23e9b574');
    assert(rotr8(0x2f63a1d8) == 0xd82f63a1, 'rotr8(0x2f63a1d8) = 0xd82f63a1');
}

#[test]
#[available_gas(9999999999)]
fn test_rotr7() {
    assert(rotr7(0x11112222) == 0x44222244, 'rotr7(0x11112222) = 0x44222244');
    assert(rotr7(0x1a3b4c6d) == 0xda347698, 'rotr7(0x1a3b4c6d) = 0xda347698');
    assert(rotr7(0x1a3f7b9e) == 0x3c347ef7, 'rotr7(0x1a3f7b9e) = 0x3c347ef7');
    assert(rotr7(0x8d2e6f4c) == 0x991a5cde, 'rotr7(0x8d2e6f4c) = 0x991a5cde');
    assert(rotr7(0xf0a12e87) == 0x0fe1425d, 'rotr7(0xf0a12e87) = 0x0fe1425d');
    assert(rotr7(0x76c98d5a) == 0xb4ed931a, 'rotr7(0x76c98d5a) = 0xb4ed931a');
    assert(rotr7(0xe9b57423) == 0x47d36ae8, 'rotr7(0xe9b57423) = 0x47d36ae8');
    assert(rotr7(0x2f63a1d8) == 0xb05ec743, 'rotr7(0x2f63a1d8) = 0xb05ec743');
}
