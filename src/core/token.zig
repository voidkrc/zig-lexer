const std = @import("std");

pub const Token = union(enum) {
    Identifier: []const u8,
    Number: []const u8,
    OpenParen,
    CloseParen,
    Illegal,

    pub fn print(self: Token) void {
        switch (self) {
            Token.Identifier => |ch| std.debug.print("Identifier: {s}\n", .{ch}),
            Token.Number => |n| std.debug.print("Number: {s}\n", .{n}),
            Token.OpenParen => std.debug.print("Open Parentesis\n", .{}),
            Token.CloseParen => std.debug.print("Closing Parentesis\n", .{}),
            else => {},
        }
    }
};
