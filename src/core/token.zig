const std = @import("std");

pub const Token = union(enum) {
    Identifier: []const u8,
    Number: []const u8,
    LParen,
    RParen,
    LSquirly,
    RSquirly,
    Illegal,
    EOF,
};
