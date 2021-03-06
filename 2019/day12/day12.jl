positions = [
             -7   -1   6;
             6    -9  -9;
             -12   2  -7;
             4   -17 -12
            ]

#var positions = [
#    [-1, 0, 2],
#    [2, -10, -7],
#    [4, -8, 8],
#    [3, 5, -1],
#]

positions = [
             -1 0 2;
             2 -10 -7
             4 -8 8
             3 5 -1
            ]

velocities = zeros(Int64, 4, 3)

function unit(x)
    if x == 0
        0
    elseif x > 0
        1
    else
        -1
    end
end

# 1014
for step in 1:3
    println("STEP ", step)
    for id in 1:4
        # apply gravity
        for snd in 1:4
            if snd == id
                continue
            end
            grav = unit.(positions[snd, :] - positions[id, :])
            println("hey", id)
            println(positions[id, :])
            println(positions[snd, :])
            println(grav)
            velocities[id, :] += grav
        end
       # p1 = positions[id]
       # for snd in 1:4
       #     if snd == id
       #         continue
       #     end
       #     p2 = positions[snd]
       #     for coord in 1:3
       #         d = if (p1[coord] == p2[coord])
       #                 0
       #             elseif p1[coord] > p2[coord]
       #                 -1
       #             else 1
       #             end
       #     velocities[id][coord] += d
       #     end
       # end
    end
    # apply velocity
    global positions += velocities
    posmat = hcat(positions...)'
    velmat = hcat(velocities...)'
    pots = sum(abs.(posmat), dims=2)
    kins = sum(abs.(velmat), dims=2)
    tots = pots .* kins
    tot = sum(tots)

    println("energy: ", tot)
    println("---")
end
