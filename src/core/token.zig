const std = @import("std");

pub const Token = union(enum) {
    Identifier: []const u8,
    Number: i32,
    OpenParen,
    CloseParen,
    Illegal,
};
