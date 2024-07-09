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
        return self.pos < self.input.len;
    }

    pub fn read_identifier(self: *Lexer, condition: *const fn (c: u8) bool) []const u8 {
        const current_pos = self.pos;

        while (condition(self.curr)) {
            self.pos += 1;
            self.curr = self.input[self.pos];
        }

        const id = self.input[current_pos..self.pos];
        self.pos -= 1;
        return id;
    }

    fn match_char(self: *Lexer) Token {
        const token: Token = switch (self.curr) {
            'A'...'Z', 'a'...'z' => .{ .Identifier = self.read_identifier(std.ascii.isAlphabetic) },
            '0'...'9' => .{ .Number = self.read_identifier(std.ascii.isDigit) },
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

fn tokensEqual(a: Token, b: Token) bool {
    if (!std.mem.eql(u8, @tagName(a), @tagName(b))) {
        return false;
    }

    switch (a) {
        .Identifier => |identifier| return std.mem.eql(u8, identifier, b.Identifier),
        .Number => |number| return std.mem.eql(u8, number, b.Number),
        else => return true,
    }
}

test "Lexer handles basic example" {
    const input: []const u8 =
        \\ int main() {
        \\   40
        \\}
        \\
    ;

    var lexer = Lexer.init(input);
    var list = std.ArrayList(Token).init(testing.allocator);
    defer list.deinit();

    while (lexer.has_next()) {
        const token = lexer.read_char();

        switch (token) {
            .Illegal => {},
            else => try list.append(token),
        }
    }

    const tokens = [_]Token{
        .{ .Identifier = "int" },
        .{ .Identifier = "main" },
        .OpenParen,
        .CloseParen,
        .OpenParen,
        .{ .Number = "40" },
        .CloseParen,
    };

    try testing.expectEqual(7, list.items.len);

    for (0.., tokens) |idx, token| {
        try testing.expect(tokensEqual(token, list.items[idx]));
    }
}
