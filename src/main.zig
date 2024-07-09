const std = @import("std");
const Lexer = @import("./core/lexer.zig").Lexer;

pub fn main() void {
    const input: []const u8 =
        \\   int main() {
        \\     40
        \\  }
        \\
    ;

    var lexer = Lexer.init(input);

    while (lexer.has_next()) {
        const token = lexer.read_char();
        token.print();
    }
}

test {
    std.testing.refAllDecls(@This());
}
