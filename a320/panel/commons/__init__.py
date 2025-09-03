from abc import ABC, abstractmethod
from pathlib import Path
from typing import Sequence


header = """include <../../commons/panels.scad>

$fn=100;
"""


class Component(ABC):

    def __init__(self, id: str):
        self.id = id

    def hole(self) -> str:
        return ''

    def outline(self) -> str:
        return ''


class Line(Component):

    def __init__(self, id: str, start:tuple[int, int], end:tuple[int, int]):
        super().__init__(id)
        self.start = start
        self.end = end

    def outline(self) -> str:
        return f'line([{self.start[0]}, {self.start[1]}], [{self.end[0]}, {self.end[1]}]);'


class PositionedComponent(Component):
    def __init__(self, id: str, x: int, y: int) -> None:
        super().__init__(id)
        self.x = x
        self.y = y

    def _translate(self) -> str:
        return f'translate([{self.x}, {self.y}])'

    @abstractmethod
    def _hole(self) -> str:
        pass

    def hole(self) -> str:
        hole = self._hole()
        if hole:
            return ' '.join([self._translate(), hole]) + ';'
        else:
            return ''

    @abstractmethod
    def _outline(self) -> str:
        pass

    def outline(self) -> str:
        outline = self._outline()
        if outline:
            return ' '.join([self._translate(), outline]) + ';'
        else:
            return ''


class KorrySwitch(PositionedComponent):

    def __init__(self, id: str, x: int, y: int, text:str=None, text_right:str=None, text_right_direction:str=None) -> None:
        super().__init__(id, x, y)
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

        return f'korry_outline({", ".join(args)})'

    def _hole(self) -> str:
        return 'korry_hole()'


class FlipSwitch(PositionedComponent):

    def __init__(self, id: str, x: int, y: int, text_top_1:str=None, text_top_2:str=None, text_right_up:str=None, text_right:str=None, text_right_down:str=None, text_bottom:str=None, text_right_direction:str=None) -> None:
        super().__init__(id, x, y)
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

        return  f'switch_outline({", ".join(args)})'

    def _hole(self) -> str:
        return 'switch_hole()'


class Potentiometer(PositionedComponent):

    def __init__(self, id: str, x: int, y: int, text_top_1:str=None, text_top_2:str=None, text_bottom_left:str=None, text_bottom_right:str=None) -> None:
        super().__init__(id, x, y)
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
        return  f'pot_outline({", ".join(args)})'

    def _hole(self) -> str:
        return 'pot_hole()'


class Label(PositionedComponent):

    def __init__(self, id: str, x: int, y: int, text:str=None, size:float=None,) -> None:
        super().__init__(id, x, y)
        self.text = text
        self.size = size

    def _outline(self) -> str:
        args = []
        if self.text:
            args.append(f'text="{self.text}"')
        if self.size:
            args.append(f'size={self.size}')
        return  f'label({", ".join(args)})'

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


def write_scad(file: Path, components: Sequence[Component], panel_x: int, panel_y: int):
    if not file.parent.exists():
        file.parent.mkdir()

    with file.open('w') as f:
        f.write(header)
        f.write(main_panel(panel_x, panel_y, components))

        f.write('\n')

        f.write('\n'.join([c.outline() for c in components if c.outline()]))
