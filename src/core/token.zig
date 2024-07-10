const std = @import("std");

pub const Token = union(enum) {
    identifier: []const u8,
    number: []const u8,

    // Tokens
    lparen,
    rparen,
    lsquirly,
    rsquirly,
    if_token,
    function,
    else_token,
    return_token,
    true_token,
    false_token,
    let,
    semicolon,

    // Operators
    equal,

    illegal,
    eof,
};
