import pygame
from math import pi
pygame.init()

size = width, height = 800, 800
screen = pygame.display.set_mode(size)
myfont = pygame.font.SysFont('monospace', 20)
shipw = pygame.image.load("ship.png")
shipe =  pygame.transform.flip(shipw, True, False)
shipn =  pygame.transform.rotate(shipw, -90)
ships =  pygame.transform.rotate(shipw, 90)

with open('input') as f:
    inp = f.read().strip().split('\n')

def draw(x, y, px, py, l, f, angles=None):
    screen.fill((255, 255, 255))
    shipcol = (255, 0, 0)
    drawx = 300
    drawy = height-100
    black = (0, 0, 0)
    pygame.draw.line(screen, black,
                     (-1000+drawx, drawy),
                     (1000+drawx, drawy))
    pygame.draw.line(screen, black,
                     (drawx, -1000+drawy),
                     (drawx, 1000+drawy))
    # -y because for pygame positive y is down
    transform = lambda x, y: (x//1.1+drawx, -y//1.1+drawy)
    sx, sy = transform(x, y)
    spx, spy = transform(px, py)
    pygame.draw.line(screen, black,
                     (spx, spy),
                     (sx, sy))

    if angles:
        d2r = lambda d : pi * (d/180)
        start_angle, stop_angle = angles
        pygame.draw.arc(screen, (0, 255, 0),
                        (sx-100, sy-100, 200, 200),
                        d2r(start_angle), d2r(stop_angle))

    #pygame.draw.rect(screen, shipcol, (x//1.1+drawx, y//1.1+drawy, 5, 5))
    # -4 because the rect is 8x8
    shiprect = (sx-4, sy-4, 8, 8)
    ship = {'W': shipw, 'E': shipe, 'N': shipn, 'S': ships}[f]
    screen.blit(ship, shiprect)
    lsurf = myfont.render(l, False, black)
    screen.blit(lsurf, (20, height-120))
    psurf = myfont.render(str((x, y, f)), False, black)
    screen.blit(psurf, (20, height-100))
    dsurf = myfont.render("dist: "+str(abs(x)+abs(y)),
                          False, black)
    screen.blit(dsurf, (20, height-80))
    pygame.display.flip()
    #pygame.time.wait(150)

x = 0
y = 0
f = 'E' # we start facing east
for l in inp:
    #print('\n'*50)
    print(l, x, y)
    a = l[0]
    b = int(l[1:])
    if a == 'F':
        a = f
    if a in 'RL':
        pf = f
        b = b % 360
        if a == 'L':
            360 - b
        for i in range(b//90):
            print(f)
            f = {
                'W': 'N',
                'N': 'E',
                'E': 'S',
                'S': 'W'
            }[f]
        print('rotated from '+pf+' to '+f)
        #ang = lambda d: {'W': 180, 'N': 90, 'E': 0, 'S': 270}[d]
        #angles = ang(pf), ang(f)
        #for a in range(angles[0], angles[1]):
        #    tmpangles = a, angles[1]
        #    #if a == 'L':
        #    #    tmpangles = angles[1], a
        #    draw(x, y, px, py, l, pf, tmpangles)
        draw(x, y, px, py, l, f)
        #pygame.time.wait(2000)
        continue
    elif a == 'N':
        v = (0, 1)
    elif a == 'S':
        v = (0, -1)
    elif a == 'E':
        v = (1, 0)
    elif a == 'W':
        v = (-1, 0)
    dx, dy = v
    px, py = x, y
    for i in range(b):
        x += dx
        y += dy
        draw(x, y, px, py, l, f)
    #dx *= b
    #dy *= b
    #x += dx
    #y += dy

    print(l, x, y)
    draw(x, y, px, py, l, f)
    pygame.time.wait(50)

print(x, y, abs(x)+abs(y))
