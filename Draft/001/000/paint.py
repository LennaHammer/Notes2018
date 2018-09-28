import pygame

pygame.init()
# print(pygame.font.get_fonts())
screen = pygame.display.set_mode((480, 320))
screen.fill((255, 255, 255))

md = 0
ox = 0
oy = 0

while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            exit()
        elif event.type == pygame.MOUSEBUTTONDOWN:
            md = 1
            ox, oy = event.pos
        elif event.type == pygame.MOUSEBUTTONUP:
            if md == 1:
                pygame.draw.line(screen, (0, 0, 0), (ox, oy), event.pos)
                md = 0
        elif event.type == pygame.MOUSEMOTION:
            if md == 1:
                pygame.draw.line(screen, (0, 0, 0), (ox, oy), event.pos)
                ox, oy = event.pos
    
    pygame.display.flip()
    pygame.time.wait(1000//30)
