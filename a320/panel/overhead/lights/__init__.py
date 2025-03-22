from typing import Sequence


header = """include <../../commons/panels.scad>

$fn=100;
"""

class Component:

    def hole(self) -> str:
        return ''

    def outline(self) -> str:
        return ''


class Line(Component):

    def __init__(self, start:tuple[int, int], end:tuple[int, int]):
        self.start = start
        self.end = end

    def outline(self) -> str:
        return f'line([{self.start[0]}, {self.start[1]}], [{self.end[0]}, {self.end[1]}]);'

class PositionedComponent(Component):
    def __init__(self, x: int, y: int) -> None:
        self.x = x
        self.y = y

    def _translate(self) -> str:
        return f'translate([{self.x}, {self.y}])'

    def _hole(self) -> str:
        pass

    def hole(self) -> str:
        hole = self._hole()
        if hole:
            return ' '.join([self._translate(), hole]) + ';'
        else:
            return ''

    def _outline(self) -> str:
        pass

    def outline(self) -> str:
        outline = self._outline()
        if outline:
            return ' '.join([self._translate(), outline]) + ';'
        else:
            return ''


class KorrySwitch(PositionedComponent):

    def __init__(self, x: int, y: int, text:str=None, text_right:str=None, text_right_direction:str=None) -> None:
        super().__init__(x, y)
        self.text = text
        self.text_right = text_right
        self.text_right_direction = text_right_direction

    def _outline(self) -> str:
        args = []
        if self.text:
            args.append(f'text="{self.text}"')
        if self.text_right:
            args.append(f'text_right="{self.text_right}"')
        if self.text_right_direction:
            args.append(f'text_right_direction="{self.text_right_direction}"')

        return f'korry_outline({', '.join(args)})'

    def _hole(self) -> str:
        return 'korry_hole()'


class FlipSwitch(PositionedComponent):

    def __init__(self, x: int, y: int, text_top_1:str=None, text_top_2:str=None, text_right_up:str=None, text_right:str=None, text_right_down:str=None, text_bottom:str=None, text_right_direction:str=None) -> None:
        super().__init__(x, y)
        self.text_top_1 = text_top_1
        self.text_top_2 = text_top_2
        self.text_right_up = text_right_up
        self.text_right = text_right
        self.text_right_down = text_right_down
        self.text_bottom = text_bottom
        self.text_right_direction = text_right_direction

    def _outline(self) -> str:
        args = []
        if self.text_top_1:
            args.append(f'text_top_1="{self.text_top_1}"')
        if self.text_top_2:
            args.append(f'text_top_2="{self.text_top_2}"')
        if self.text_right_up:
            args.append(f'text_right_up="{self.text_right_up}"')
        if self.text_right:
            args.append(f'text_right="{self.text_right}"')
        if self.text_right_down:
            args.append(f'text_right_down="{self.text_right_down}"')
        if self.text_bottom:
            args.append(f'text_bottom="{self.text_bottom}"')
        if self.text_right_direction:
            args.append(f'text_right_direction="{self.text_right_direction}"')

        return  f'switch_outline({', '.join(args)})'

    def _hole(self) -> str:
        return 'switch_hole()'


class Potentiometer(PositionedComponent):

    def __init__(self, x: int, y: int, text_top_1:str=None, text_top_2:str=None, text_bottom_left:str=None, text_bottom_right:str=None) -> None:
        super().__init__(x, y)
        self.text_top_1 = text_top_1
        self.text_top_2 = text_top_2
        self.text_bottom_left = text_bottom_left
        self.text_bottom_right = text_bottom_right

    def _outline(self) -> str:
        args = []
        if self.text_top_1:
            args.append(f'text_top_1="{self.text_top_1}"')
        if self.text_top_2:
            args.append(f'text_top_2="{self.text_top_2}"')
        if self.text_bottom_left:
            args.append(f'text_bottom_left="{self.text_bottom_left}"')
        if self.text_bottom_right:
            args.append(f'text_bottom_right="{self.text_bottom_right}"')
        return  f'pot_outline({', '.join(args)})'

    def _hole(self) -> str:
        return 'pot_hole()'


class Label(PositionedComponent):

    def __init__(self, x: int, y: int, text:str=None, size:float=None,) -> None:
        super().__init__(x, y)
        self.text = text
        self.size = size

    def _outline(self) -> str:
        args = []
        if self.text:
            args.append(f'text="{self.text}"')
        if self.size:
            args.append(f'size={self.size}')
        return  f'label({', '.join(args)})'

    def _hole(self) -> str:
        return ''


def main_panel(x: int, y: int, components: Sequence[Component]) -> str:

    head = ('difference() {\n'
            'color("grey")\n'
            'linear_extrude(backplate_thickness)\n'
            f'rounded_square(x={x}, y={y}, r=3, center=false  );\n')

    return '\n'.join([
        head,
        '\n'.join([c.hole() for c in components if c.hole()]),
        '}'
    ])


if __name__ == '__main__':
    panel_x = 310
    panel_y = 130

    components = [
        Line((5, panel_y-25), (5, 25)),
        Line((panel_x-5, panel_y-25), (panel_x-5, 25)),
        Line((35, 110), (35, 90)),
        Line((65, 110), (65, 90)),
        Line((125, 110), (125, 90)),
        Line((175, 110), (175, 90)),
        Line((10, 83), (panel_x-10, 83)),
        Line((132, 80), (132, 5)),
        Line((168, 80), (168, 5)),
        Line((37, 37), (58, 37)),
        Line((37, 37), (37, 35)),
        Line((72, 37), (93, 37)),
        Line((93, 37), (93, 35)),
        Line((175, 43), (panel_x-10, 43)),
        Line((237, 35), (237, 5)),
        
        Label(65, 120, text='ANTI ICE', size=3),
        KorrySwitch(20, 100, text='WING'),
        KorrySwitch(80, 100, text='ENG 1'),
        KorrySwitch(110, 100, text='ENG 2'),
        Label(150, 120, text='PROBE/WINDOW', size=3),
        Label(150, 115, text='HEAT', size=3),
        KorrySwitch(150, 100, text_right='AUTO', text_right_direction='ttb'),
        FlipSwitch(190, 100, text_top_1='MAN V/S CTL', text_right_up='UP', text_right_down='DN'),
        Label(220, 120, text='CABIN PRESS', size=3),
        KorrySwitch(220, 100, text='MODE SEL', text_right='AUTO', text_right_direction='ttb'),
        Potentiometer(250, 100, text_top_1='LDG ELEV', text_top_2='AUTO'),
        KorrySwitch(280, 100, text='DITCHING'),

        FlipSwitch(20, 60, text_top_1='STROBE', text_top_2='ON', text_right='AUTO', text_bottom='OFF',
                   text_right_direction='ttb'),
        FlipSwitch(50, 60, text_top_1='BEACON', text_top_2='ON', text_bottom='OFF'),
        Label(65, 80, text='EXT LT', size=3),
        FlipSwitch(80, 60, text_top_1='WING', text_top_2='ON', text_bottom='OFF'),
        FlipSwitch(110, 60, text_top_1='NAV & LOGO', text_top_2='2', text_right='1', text_bottom='OFF'),
        Label(150, 80, text='APU', size=3),
        KorrySwitch(150, 60, text='MASTER SW'),
        Potentiometer(190, 60, text_top_1='OVHD INTEG LT', text_bottom_left='OFF', text_bottom_right='BRT'),
        FlipSwitch(220, 60, text_top_1='ICE IND &', text_top_2='STBY COMPASS', text_bottom='OFF'),
        Label(235, 80, text='INT LT', size=3),
        FlipSwitch(250, 60, text_top_2='DOME', text_right_up='BRT', text_right='DIM', text_right_down='OFF'),
        FlipSwitch(280, 60, text_top_2='ANN LT', text_right_up='TEST', text_right='BRT', text_right_down='DIM'),

        FlipSwitch(20, 20, text_top_1='RUNWAY TURN OFF', text_top_2='ON', text_bottom='OFF'),
        FlipSwitch(50, 20, text_top_2='L'),
        Label(65, 37, text='LAND'),
        FlipSwitch(80, 20, text_top_2='R'),
        FlipSwitch(110, 20, text_top_2='NOSE', text_right_up='T.O', text_right='TAXI', text_right_down='OFF'),
        KorrySwitch(150, 20, text='START'),
        FlipSwitch(190, 20, text_top_1='SEAT BELTS', text_top_2='ON', text_bottom='OFF'),
        FlipSwitch(220, 20, text_top_1='NO SMOKING', text_top_2='ON', text_right='AUTO', text_bottom='OFF',
                   text_right_direction='ttb'),
        Label(242, 40, text='SIGNS', size=3),
        KorrySwitch(250, 20),
        Label(265, 33, text='EMER EXT LT'),
        FlipSwitch(280, 20, text_right_up='ON', text_right='ARM', text_right_down='OFF'),
    ]

    with open('out.scad', 'w') as f:
        f.write(header)
        f.write(main_panel(panel_x, panel_y, components))

        f.write('\n')

        f.write('\n'.join([c.outline() for c in components if c.outline()]))
