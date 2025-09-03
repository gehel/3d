from panel.commons import Line, KorrySwitch, FlipSwitch, Potentiometer, Label, write_scad
from skip import Schematic

panel_x = 310
panel_y = 130

components = [
    Line('L1', (5, panel_y - 25), (5, 25)),
    Line('L2', (panel_x - 5, panel_y - 25), (panel_x - 5, 25)),
    Line('L3', (35, 110), (35, 90)),
    Line('L4', (65, 110), (65, 90)),
    Line('L5', (125, 110), (125, 90)),
    Line('L6', (175, 110), (175, 90)),
    Line('L7', (10, 83), (panel_x - 10, 83)),
    Line('L8', (132, 80), (132, 5)),
    Line('L9', (168, 80), (168, 5)),
    Line('L10', (37, 37), (58, 37)),
    Line('L11', (37, 37), (37, 35)),
    Line('L12', (72, 37), (93, 37)),
    Line('L13', (93, 37), (93, 35)),
    Line('L14', (175, 43), (panel_x - 10, 43)),
    Line('L15', (237, 35), (237, 5)),

    Label('ANTI ICE', 65, 120, text='ANTI ICE', size=3),
    KorrySwitch('WING', 20, 100, text='WING'),
    KorrySwitch('ENG 1', 80, 100, text='ENG 1'),
    KorrySwitch('ENG2', 110, 100, text='ENG 2'),
    Label('PROBE_WINDOW', 150, 120, text='PROBE/WINDOW', size=3),
    Label('HEAT', 150, 115, text='HEAT', size=3),
    KorrySwitch('AUTO', 150, 100, text_right='AUTO', text_right_direction='ttb'),
    FlipSwitch('CABIN_PRESSURE', 190, 100, text_top_1='MAN V/S CTL', text_right_up='UP', text_right_down='DN'),
    Label('CABIN_PRESS', 220, 120, text='CABIN PRESS', size=3),
    KorrySwitch('MODE_SEL', 220, 100, text='MODE SEL', text_right='AUTO', text_right_direction='ttb'),
    Potentiometer('LDG_ELEV', 250, 100, text_top_1='LDG ELEV', text_top_2='AUTO'),
    KorrySwitch('DITCHING', 280, 100, text='DITCHING'),

    FlipSwitch('STROBE', 20, 60, text_top_1='STROBE', text_top_2='ON', text_right='AUTO', text_bottom='OFF',
               text_right_direction='ttb'),
    FlipSwitch('BEACON', 50, 60, text_top_1='BEACON', text_top_2='ON', text_bottom='OFF'),
    Label('EXT_LT', 65, 80, text='EXT LT', size=3),
    FlipSwitch('EXT_LT_WING', 80, 60, text_top_1='WING', text_top_2='ON', text_bottom='OFF'),
    FlipSwitch('EXT_LT_NAV_LOGO', 110, 60, text_top_1='NAV & LOGO', text_top_2='2', text_right='1', text_bottom='OFF'),
    Label('APU', 150, 80, text='APU', size=3),
    KorrySwitch('APU_MASTER_SW', 150, 60, text='MASTER SW'),
    Potentiometer('OVHD_INTEG_LT', 190, 60, text_top_1='OVHD INTEG LT', text_bottom_left='OFF', text_bottom_right='BRT'),
    FlipSwitch('LT', 220, 60, text_top_1='ICE IND &', text_top_2='STBY COMPASS', text_bottom='OFF'),
    Label('INT_LT', 235, 80, text='INT LT', size=3),
    FlipSwitch('INT_LT_', 250, 60, text_top_2='DOME', text_right_up='BRT', text_right='DIM', text_right_down='OFF'),
    FlipSwitch('ANN_LT', 280, 60, text_top_2='ANN LT', text_right_up='TEST', text_right='BRT', text_right_down='DIM'),

    FlipSwitch('RUNWAY TURN OFF', 20, 20, text_top_1='RUNWAY TURN OFF', text_top_2='ON', text_bottom='OFF'),
    FlipSwitch('LAND_L', 50, 20, text_top_2='L'),
    Label('LAND', 65, 37, text='LAND'),
    FlipSwitch('LAND_R', 80, 20, text_top_2='R'),
    FlipSwitch('TAXI', 110, 20, text_top_2='NOSE', text_right_up='T.O', text_right='TAXI', text_right_down='OFF'),
    KorrySwitch('APU_START', 150, 20, text='START'),
    FlipSwitch('SEAT_BELTS', 190, 20, text_top_1='SEAT BELTS', text_top_2='ON', text_bottom='OFF'),
    FlipSwitch('NO_SMOKING', 220, 20, text_top_1='NO SMOKING', text_top_2='ON', text_right='AUTO', text_bottom='OFF',
               text_right_direction='ttb'),
    Label('SIGNS', 242, 40, text='SIGNS', size=3),
    KorrySwitch('EMER_EXT_LT', 250, 20),
    Label('EMER_EXT_LT_LABEL', 265, 33, text='EMER EXT LT'),
    FlipSwitch('EMER_EXT_LT_', 280, 20, text_right_up='ON', text_right='ARM', text_right_down='OFF'),
]


def kicad_schematic(filename, components):
    schem = Schematic('../../commons/kicad-template/kicad-template.kicad_sch')

    spdt = schem.symbol.SW1
    korry = schem.symbol.SW2
    pot = schem.symbol.RV1

    for c in components:
        if isinstance(c, FlipSwitch):
            symbol = spdt.clone()
            symbol.setAllReferences(c.id)
            symbol.move(c.x, c.y)

    spdt.delete()
    korry.delete()
    pot.delete()
    schem.write(filename)

if __name__ == '__main__':
    write_scad('target/out.scad', components, panel_x, panel_y)
    kicad_schematic('target/out.kicad_sch', components)
