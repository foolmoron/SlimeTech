package states;

import luxe.States;
import luxe.Sprite;
import luxe.Color;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Vector;
import luxe.Log.*;
import entities.*;
import components.*;

class GameState extends SceneState {

    override function onenter<T>(with:T) {
        scene.add(new SlimePool({
            name: 'SlimePool',
            pos: Luxe.screen.mid,
        }));

        var attractor1 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 - 50, 735),
        });
        attractor1.targets = (cast scene.get('SlimePool')).slimeColliders;
        scene.add(attractor1);

        var attractor2 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 0, 735),
        });
        attractor2.targets = (cast scene.get('SlimePool')).slimeColliders;
        scene.add(attractor2);

        var attractor3 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 50, 735),
        });
        attractor3.targets = (cast scene.get('SlimePool')).slimeColliders;
        scene.add(attractor3);

        var buttonLeft = new Button({
            name: 'buttonLeft',
            pos: new Vec(40, Luxe.screen.h - 52),
        });
        buttonLeft.onClick = function() { log('LEFT'); };
        scene.add(buttonLeft);

        var buttonRight = new Button({
            name: 'buttonRight',
            pos: new Vec(Luxe.screen.w - 40, Luxe.screen.h - 52),
        });
        buttonRight.upSprite.flipx = true;
        buttonRight.downSprite.flipx = true;
        buttonRight.onClick = function() { log('RIGHT'); };
        scene.add(buttonRight);
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('title');
    }

    override function onmousedown(e:MouseEvent) {
    }

    override function update(dt:Float) {
    }
}
