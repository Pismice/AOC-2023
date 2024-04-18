const std = @import("std");

fn manip1(file_content: []u8) void {
    var i: usize = 0;
    var sum: u128 = 0;
    var first: ?u8 = null;
    var last: ?u8 = null;

    // Loop on each char
    while (i < file_content.len) : (i += 1) {
        const current_char: u8 = file_content.ptr[i];

        // End of line
        if (current_char == '\n') {
            if (first == null) {
                std.log.err("first is null", .{});
                continue;
            }
            if (last == null) {
                last = first;
            }
            sum += ((first.? - '0') * 10) + (last.? - '0');
            std.log.info("First: {c}, Last: {c}, Sum: {d}", .{ first.?, last.?, sum });
            first = null;
            last = null;
        }

        // Is a number
        if (current_char >= '0' and current_char <= '9') {
            if (first == null) {
                first = current_char;
            } else {
                last = current_char;
            }
        }
    }

    std.debug.print("Sum: {d}\n", .{sum});
}

fn manip2(file_content: []u8) void {
    var i: usize = 0;
    var sum: u128 = 0;
    var first: ?u8 = null;
    var last: ?u8 = null;

    const NUMS = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

    // Loop on each char
    while (i < file_content.len) : (i += 1) {
        const current_char: u8 = file_content.ptr[i];

        // End of line
        if (current_char == '\n') {
            if (first == null) {
                std.log.err("first is null", .{});
                continue;
            }
            if (last == null) {
                last = first;
            }
            sum += (first.? * 10) + last.?;
            //std.log.info("First: {c}, Last: {c}, Sum: {d}", .{ first.?, last.?, sum });
            first = null;
            last = null;
        }

        // Is a number
        if (current_char >= '0' and current_char <= '9') {
            if (first == null) {
                first = current_char - '0';
            } else {
                last = current_char - '0';
            }
        } else {
            // Former notre gros bout restant
            var bout_restant: []u8 = undefined;
            var j: usize = 0;
            var c: u8 = current_char;
            while (c != '\n') : (j += 1) {
                c = file_content.ptr[i + j];
            }
            bout_restant = file_content[i .. i + j];

            // Verifier si notre gros bout restant contient un des mots
            for (NUMS, 1..) |numo, index| {
                if (std.mem.startsWith(u8, bout_restant, numo)) {
                    // Found a word !!!
                    if (first == null) {
                        first = @intCast(index);
                    } else {
                        last = @intCast(index);
                    }
                }
            }
        }
    }

    std.debug.print("Sum: {d}\n", .{sum});
}

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // Alocator
    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    // Path
    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = try std.fs.realpath("./input.txt", &path_buffer);

    // Open file
    const file = try std.fs.openFileAbsolute(path, .{});
    defer file.close();

    // Read
    const file_content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));
    defer allocator.free(file_content);

    manip2(file_content);
}
