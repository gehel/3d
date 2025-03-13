import drawsvg as draw

d = draw.Drawing(200, 100, origin='center')

d.append(draw.Lines(-80, 45,
                    70, 49,
                    95, -49,
                    -90, -40,
                    close=False,
                    fill='#eeee00',
                    stroke='black'))
d.save_svg('example.svg')
