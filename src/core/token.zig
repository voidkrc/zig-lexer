const std = @import("std");

pub const Token = union(enum) {
    identifier: []const u8,
    number: []const u8,
    lparen,
    rparen,
    lsquirly,
    rsquirly,
    illegal,
    eof,
};
