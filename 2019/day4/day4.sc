#!/usr/bin/env scopes

let min = 168630
let max = 718098
let count = 0

fn six(n)
    true

# initially I wanted do convert n to a string and work with that
# but I didn't manage to find how to do it
fn adj(n)
    loop (n prev = n -1)
        let this = (n % 10)
        let next = (n // 10)
        if (this == prev)
            break true
        elseif (n >= 10)
            repeat next this
        else
            break false

fn neverdec(n)
    loop (n prev = n 10)
        let this = (n % 10)
        let next = (n // 10)
        if (this > prev)
            break false
        elseif (n >= 10)
            repeat next this
        else
            break true

fn calc(min max)
    loop (a count = min 0)
        if (a >= max)
            print "finished"
            print count
            break a count
        elseif ((six a) and (adj a) and (neverdec a))
            repeat (a + 1) (count + 1)
        else
            repeat (a + 1) count

print "adj"
print (adj 11234) true
print (adj 12234) true
print (adj 12334) true
print (adj 12344) true
print (adj 12345) false

print "neverdec"
print (neverdec 12345) true
print (neverdec 12340) false
print (neverdec 11111) true
print (neverdec 10234) false
print (neverdec 12045) false

print "starting"
print (calc min max)
print "done"
