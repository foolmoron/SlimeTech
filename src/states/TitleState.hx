package states;

import luxe.States;
import luxe.Vector;
import luxe.Color;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Sprite;
import luxe.Text;
import luxe.Log.*;
import entities.*;

class TitleState extends SceneState {

    override function onenter<T>(with:T) {
        scene.add(new Text({
            text : 'SLIME\nTECH',
            color: new Color().rgb(0x000000),
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            pos : new Vec(Luxe.screen.w/2, 300),
            point_size: 84,
            depth: 500,
        }));
        scene.add(new Text({
            text : 'by Momin \'foolmoron\' Khan for Ludum Dare 35',
            color: new Color().rgb(0x000000),
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            pos : new Vec(Luxe.screen.w/2, 430),
            point_size: 24,
            depth: 500,
        }));
        scene.add(new Text({
            text : 'Click anywhere to start!',
            color: new Color().rgb(0x000000),
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            pos : new Vec(Luxe.screen.w/2, 740),
            point_size: 48,
            depth: 500,
        }));
        scene.add(new Sprite({
            name: 'heart',
            texture: Main.tex('heart'),
            pos: new Vec(Luxe.screen.w/2, 490),
            size: new Vec(446, 60),
            depth: -90,
        }));

        var slimePool1 = new SlimePool({
            name: 'SlimePool1',
            pos: new Vec(187, 255),
        });
        slimePool1.slimeCount = 140;
        slimePool1.emitSpeed = 14;
        scene.add(slimePool1);
        var attractor1 = new Attractor({
            name: 'Attractor1',
            pos: new Vec(496, 255),
        });
        attractor1.targets = slimePool1.slimeColliders;
        attractor1.remove('Dragable');
        scene.add(attractor1);

        var slimePool2 = new SlimePool({
            name: 'SlimePool2',
            pos: new Vec(496, 355),
        });
        slimePool2.slimeCount = 140;
        slimePool2.emitSpeed = 14;
        scene.add(slimePool2);
        var attractor2 = new Attractor({
            name: 'Attractor2',
            pos: new Vec(187, 355),
        });
        attractor2.targets = slimePool2.slimeColliders;
        attractor2.remove('Dragable');
        scene.add(attractor2);
    }

    override function onmouseup(e:MouseEvent) {
        Main.state.set('game1');
    }
    override function ontouchup(e:TouchEvent) {
        Main.state.set('game1');
    }

    override function update(dt:Float) {
    }
}
