const std = @import("std");
const input = @embedFile("input.txt");

const Symbole = struct {
    x: usize,
    y: usize,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const taille: f32 = @floatFromInt(input.len);
    const largeur: u32 = @intFromFloat(@sqrt(taille));
    std.debug.print("Largeur = {}\n", .{largeur});

    // 1. Passer une 1ere fois pour connaitre la position de tous les symboles
    var symboles: std.ArrayList(Symbole) = std.ArrayList(Symbole).init(allocator);
    defer symboles.deinit();
    for (0..largeur) |i| {
        for (0..largeur) |j| {
            const c = input[i * (largeur + 1) + j];
            if (c != '.' and !(c >= '0' and c <= '9')) {
                try symboles.append(Symbole{ .x = j, .y = i });
            }
        }
    }
    std.debug.print("Found symboles = {}\n", .{symboles.items.len});

    // 2. Parser les nombres et durant le parsage verifier si chaque digit est adjacent si aucun n est adjacent, on ne compte pas le nombre
    var total: usize = 0;
    // i = y
    // j = x
    for (0..largeur) |i| {
        var previIsNumber = false;
        var number: usize = 0;
        var isAdjacent = false;
        for (0..largeur) |j| {
            const c = input[i * (largeur + 1) + j];
            if (c >= '0' and c <= '9') {
                number = number * 10 + (c - '0');
                // Test if digit is adajcent
                for (symboles.items) |s| {
                    // Adjacent to right or left
                    if (s.y == i and (s.x == @subWithOverflow(j, 1)[0] or s.x == j + 1)) {
                        isAdjacent = true;
                        break;
                    }
                    // Adjacent to 3 position top or 3 position bottom
                    else if ((s.y == @subWithOverflow(i, 1)[0] or s.y == i + 1) and (s.x == j or s.x == j + 1 or s.x == @subWithOverflow(j, 1)[0])) {
                        //                        std.debug.print("Symbole {} is adjacent to number {}\n", .{ s, number });
                        isAdjacent = true;
                        break;
                    }
                }
                previIsNumber = true;
            } else {
                if (previIsNumber) {
                    // We are at the end of a number
                    if (isAdjacent) {
                        total += number;
                        std.debug.print("Number {} is OK !\n", .{number});
                    } else {
                        std.debug.print("Number {} is NOT OK !\n", .{number});
                    }
                    isAdjacent = false;
                    number = 0;
                }
                previIsNumber = false;
            }
        }
    }

    std.debug.print("Total = {}\n", .{total});
}
