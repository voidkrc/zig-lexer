const std = @import("std");
const Lexer = @import("./core/lexer.zig").Lexer;

pub fn main() void {
    const input: []const u8 =
        \\   int main() {
        \\     40
        \\  }
        \\
    ;

    std.log.warn("Input length {d}", .{input.len});

    var lexer = Lexer.init(input);

    lexer.read_char();
    while (lexer.has_next()) {
        lexer.skip_whitespace();

        std.debug.print("Current char: {c}\n", .{lexer.curr});
        lexer.read_char();
    }
}

test {
    std.testing.refAllDecls(@This());
}
