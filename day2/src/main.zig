const std = @import("std");
const bufIter = @import("buf-iter.zig");

pub fn main() !void {
    var iter = try bufIter.iterLines("input.txt");

    const Color = struct {
        name: []const u8,
        max: u32,
    };

    const COLORS = [_]Color{
        .{ .name = "red", .max = 12 },
        .{ .name = "green", .max = 13 },
        .{ .name = "blue", .max = 14 },
    };

    // 12 red cubes, 13 green cubes, and 14 blue cubes

    // Une Game
    var index: u32 = 0;
    var result: u32 = 0;
    var result2: u32 = 0;
    while (try iter.next()) |raw_line| {
        var isValidGame: bool = true;
        var squares_picked: u8 = undefined;
        var color: Color = undefined;
        var maxes: [3]Color = [_]Color{ .{ .name = "red", .max = 0 }, .{ .name = "green", .max = 0 }, .{ .name = "blue", .max = 0 } };
        defer {
            index += 1;
            std.debug.print("Game {} is valid = {}\n", .{ index, isValidGame });
            if (isValidGame) {
                result += index;
            }
            result2 += maxes[0].max * maxes[1].max * maxes[2].max;
        }
        const line = remove_til(raw_line, ':');
        var prevIsNumber: bool = false;
        for (line, 0..) |current_char, i| {
            if (prevIsNumber) {
                prevIsNumber = false; // assume qu on aura jamais de centaine 100
                if (current_char <= '9' and current_char >= '0') {
                    squares_picked = squares_picked * 10 + (current_char - '0');
                    continue;
                } else {}
            } else {
                if (current_char <= '9' and current_char >= '0') {
                    squares_picked = current_char - '0';
                    prevIsNumber = true;
                } else if (current_char == ',') {
                    prevIsNumber = false;
                    squares_picked = undefined;
                } else if (current_char == ';') {
                    prevIsNumber = false;
                    color = undefined;
                    squares_picked = undefined;
                } else {
                    prevIsNumber = false;
                    const bout_restant = line[i..];
                    for (COLORS) |coloro| {
                        if (std.mem.startsWith(u8, bout_restant, coloro.name)) {
                            color = coloro;
                            std.debug.print("Found color = {s} with {d} squares\n", .{ color.name, squares_picked });

                            if (std.mem.eql(u8, color.name, "red")) {
                                if (maxes[0].max < squares_picked) {
                                    maxes[0].max = squares_picked;
                                }
                            } else if (std.mem.eql(u8, color.name, "green")) {
                                if (maxes[1].max < squares_picked) {
                                    maxes[1].max = squares_picked;
                                }
                            } else if (std.mem.eql(u8, color.name, "blue")) {
                                if (maxes[2].max < squares_picked) {
                                    maxes[2].max = squares_picked;
                                }
                            }

                            if (squares_picked > color.max) {
                                isValidGame = false;
                                // was only useful for performance in part 1
                                //                                break :outer;
                            }
                        }
                    }
                }
            }
        }
    }
    std.debug.print("Result part 1 = {}\n", .{result});
    std.debug.print("Result part 2 = {}\n", .{result2});
}

fn remove_til(s: []const u8, c: u8) []const u8 {
    var i: usize = 0;
    while (s[i] != c) {
        i += 1;
    }
    return s[i..];
}
