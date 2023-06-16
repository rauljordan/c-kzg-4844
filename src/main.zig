const std = @import("std");
const cblst = @cImport({
    @cInclude("blst.h");
});

const FIELD_ELEMENTS_PER_BLOB = 4096;
const BYTES_PER_COMMITMENT = 48;
const BYTES_PER_PROOF = 48;
const BYTES_PER_FIELD_ELEMENT = 32;
const BYTES_PER_BLOB = FIELD_ELEMENTS_PER_BLOB * BYTES_PER_FIELD_ELEMENT;

const g1_t = cblst.blst_p1;
const g2_t = cblst.blst_p2;
const fr_t = cblst.blst_fr;

const Bytes32 = struct {
    bytes: [32]u8,
};

const Bytes48 = struct {
    bytes: [48]u8,
};

const Blob = struct {
    bytes: [BYTES_PER_BLOB]u8,
};

const KZGCommitment = Bytes48;
const KZGProof = Bytes48;

const KZGErr = enum {
    BadArgs,
    Error,
    Malloc,
};

const KZGSettings = struct {
    max_width: u64,
    roots_of_unity: *fr_t,
    g1_values: *g1_t,
    g2_values: *g2_t,
};

fn fr_is_one(ac: std.mem.Allocator, p: *const fr_t) !bool {
    var items = try ac.alloc(u64, 4);
    cblst.blst_uint64_from_fr(items, p);
    return items[0] == 1 and items[1] == 0 and items[2] == 0 and items[3] == 0;
}

fn fr_is_zero(ac: std.mem.Allocator, p: *const fr_t) !bool {
    var items = try ac.alloc(u64, 4);
    cblst.blst_uint64_from_fr(items, p);
    return items[0] == 0 and items[1] == 0 and items[2] == 0 and items[3] == 0;
}

const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
    try std.testing.expectEqual(cblst.BLST_POINT_NOT_ON_CURVE, cblst.BLST_POINT_NOT_ON_CURVE);
}
