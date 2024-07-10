const std = @import("std");
const Token = @import("./token.zig").Token;

const testing = std.testing;

pub const Lexer = struct {
    input: []const u8,
    pos: usize = 0,
    read_pos: usize = 0,
    curr: u8 = 0,

    pub fn init(input: []const u8) Lexer {
        var lexer = Lexer{ .input = input };
        lexer.read_char();

        return lexer;
    }

    pub fn get_token(self: *Lexer) Token {
        self.skipWhitespace();
        const token: Token = switch (self.curr) {
            '(' => .lparen,
            ')' => .rparen,
            '{' => .lsquirly,
            '}' => .rsquirly,
            0 => .eof,
            'a'...'z', 'A'...'Z', '_' => {
                const ident = self.read_with_condition(std.ascii.isAlphabetic);
                return .{ .identifier = ident };
            },
            '0'...'9' => {
                const number = self.read_with_condition(std.ascii.isDigit);
                return .{ .number = number };
            },
            else => .illegal,
        };

        self.read_char();
        return token;
    }

    fn read_with_condition(self: *Lexer, condition: *const fn (c: u8) bool) []const u8 {
        const current_pos = self.pos;

        while (condition(self.curr)) {
            self.read_char();
        }

        return self.input[current_pos..self.pos];
    }

    fn skipWhitespace(self: *Lexer) void {
        while (std.ascii.isWhitespace(self.curr)) {
            self.read_char();
        }
    }

    fn read_char(self: *Lexer) void {
        if (self.read_pos >= self.input.len) {
            self.curr = 0;
        } else {
            self.curr = self.input[self.read_pos];
        }

        self.pos = self.read_pos;
        self.read_pos += 1;
    }
};

test "Lexer handles basic example" {
    const input =
        \\int main() {
        \\40
        \\}
    ;

    var lexer = Lexer.init(input);

    const tokens = [_]Token{
        .{ .identifier = "int" },
        .{ .identifier = "main" },
        .lparen,
        .rparen,
        .lsquirly,
        .{ .number = "40" },
        .rsquirly,
        .eof,
    };

    for (tokens) |token| {
        const t = lexer.get_token();

        try testing.expectEqualDeep(token, t);
    }
}
