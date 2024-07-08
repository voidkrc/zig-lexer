const std = @import("std");
const Lexer = @import("./core/lexer.zig").Lexer;

pub fn main() void {
    var lexer = Lexer{ .input = "Hello World" };

    while (lexer.has_next()) {
        std.log.info("Character is {c}", .{lexer.read_char()});
    }
}

test {
    _ = Lexer;
}
