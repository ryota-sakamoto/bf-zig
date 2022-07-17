const std = @import("std");
const allocator = std.heap.page_allocator;

pub const Type = union(enum) {
    PointerIncrement: void,
    PointerDecrement: void,
    ValueIncrement: void,
    ValueDecrement: void,
    Print: void,
    Read: void,
    WhileStart: struct { end: usize },
    WhileEnd: struct { start: usize },
    Unknown: void,
};

pub fn run(actions: []Type) anyerror!void {
    const stdout = std.io.getStdOut().writer();

    var data = std.ArrayList(u8).init(allocator);
    defer data.deinit();
    try data.append(0);

    var actionIndex: usize = 0;
    var pointerIndex: usize = 0;
    while (actionIndex < actions.len) {
        const v = actions[actionIndex];
        // std.log.debug("{d} {d} {s}", .{actionIndex, pointerIndex, v});
        switch (v) {
            .PointerIncrement => {
                pointerIndex += 1;
                if (data.items.len <= pointerIndex) try data.append(0);
            },
            .PointerDecrement => pointerIndex -= 1,
            .ValueIncrement => data.items[pointerIndex] += 1,
            .ValueDecrement => data.items[pointerIndex] -= 1,
            .Print => try stdout.print("{c}", .{data.items[pointerIndex]}),
            .Read => {},
            .WhileStart => {
                if (data.items[pointerIndex] == 0) {
                    actionIndex = v.WhileStart.end;
                }
            },
            .WhileEnd => {
                if (data.items[pointerIndex] != 0) {
                    actionIndex = v.WhileEnd.start;
                }
            },
            .Unknown => {},
        }

        actionIndex += 1;
    }
}
