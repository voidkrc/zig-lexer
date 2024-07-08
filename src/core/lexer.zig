const std = @import("std");

const Token = union(enum) {
    Identifier: []const u8,
    Number,
    OpenParen,
    CloseParen,
    Illegal,
};

pub const Lexer = struct {
    input: []const u8,
    pos: u8 = 0,

    pub fn has_next(self: *Lexer) bool {
        return self.pos < self.input.len;
    }

    pub fn read_char(self: *Lexer) u8 {
        const current = self.input[self.pos];

        self.pos += 1;
        return current;
    }
};

test "Lexer" {
    const testing = std.testing;

    var count: u8 = 0;
    var lexer = Lexer{ .input = "Hello" };

    while (lexer.has_next()) {
        _ = lexer.read_char();
        count += 1;
    }

    try testing.expectEqual(5, count);
}
