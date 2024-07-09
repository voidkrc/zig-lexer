const std = @import("std");
const Token = @import("./token.zig").Token;

const testing = std.testing;

pub const Lexer = struct {
    input: []const u8,
    pos: usize = 0,
    curr: u8 = 0,

    pub fn init(input: []const u8) Lexer {
        return .{ .input = input };
    }

    pub fn has_next(self: *Lexer) bool {
        return self.pos < self.input.len - 1;
    }

    pub fn read_identifier(self: *Lexer) []const u8 {
        const current_pos = self.pos;

        while (std.ascii.isAlphabetic(self.curr)) {
            self.pos += 1;
            self.curr = self.input[self.pos];
        }

        const id = self.input[current_pos..self.pos];
        self.pos -= 1;
        return id;
    }

    fn match_char(self: *Lexer) Token {
        const token: Token = switch (self.curr) {
            'A'...'Z', 'a'...'z' => .{ .Identifier = self.read_identifier() },
            '(' => .OpenParen,
            ')' => .CloseParen,
            '{' => .OpenParen,
            '}' => .CloseParen,
            else => .Illegal,
        };

        self.pos += 1;
        self.curr = self.input[self.pos];
        return token;
    }

    pub fn read_char(self: *Lexer) Token {
        const current: u8 = self.input[self.pos];

        if (std.ascii.isWhitespace(current)) {
            self.pos += 1;
            return .Illegal;
        }

        self.curr = current;

        return self.match_char();
    }
};

test "Lexer skip whitespaces" {
    const input: []const u8 =
        \\ int main() {
        \\   40
        \\}
        \\
    ;

    var lexer = Lexer.init(input);

    var list = std.ArrayList(u8).init(testing.allocator);
    defer list.deinit();

    while (lexer.has_next()) {
        lexer.skip_whitespace();
        try list.append(lexer.curr);
        _ = lexer.read_char();
    }

    var whitespace_found = false;
    for (list.items) |ch| {
        if (std.ascii.isWhitespace(ch)) {
            whitespace_found = true;
        }
    }

    try testing.expectEqual(false, whitespace_found);
}
