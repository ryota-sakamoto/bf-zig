const std = @import("std");

pub const Type = enum {
    PointerIncrement,
    PointerDecrement,
    ValueIncrement,
    ValueDecrement,
    Print,
    Read,
    WhileStart,
    WhileEnd,
    Unknown,
};

pub fn run(actions: []Type) void {
    std.log.info("{s}", .{ actions });
}
