use cairo_blake2s::blake2s_internal::{blake2s_init, blake2s_update, blake2s_final};

fn blake2s(data: Array<u32>) -> u256 {
    let mut state = blake2s_init();
    state = blake2s_update(state, data);
    blake2s_final(state)
}