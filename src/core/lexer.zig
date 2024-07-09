const std = @import("std");
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

    pub fn skip_whitespace(self: *Lexer) void {
        while (std.ascii.isWhitespace(self.curr)) {
            self.curr = self.input[self.pos];
            self.pos += 1;
        }
    }

    pub fn read_char(self: *Lexer) void {
        if (!self.has_next()) return;

        const current: u8 = self.input[self.pos];
        self.curr = current;
        self.pos += 1;
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
    lexer.read_char();

    var list = std.ArrayList(u8).init(testing.allocator);
    defer list.deinit();

    while (lexer.has_next()) {
        lexer.skip_whitespace();
        try list.append(lexer.curr);
        lexer.read_char();
    }

    var whitespace_found = false;
    for (list.items) |ch| {
        if (std.ascii.isWhitespace(ch)) {
            whitespace_found = true;
        }
    }

    try testing.expectEqual(false, whitespace_found);
}
