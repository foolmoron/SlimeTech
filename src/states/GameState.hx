package states;

import luxe.States;
import luxe.Sprite;
import luxe.Color;
import luxe.options.*;
import luxe.Input;
import luxe.Vector;
import luxe.Log.*;
import entities.*;
import components.*;

class GameState extends SceneState {

    public var slimePool : SlimePool;
    public var z : FillPoly;

    override function onenter<T>(with:T) {
        slimePool = new SlimePool({
            name: 'SlimePool',
            pos: Luxe.screen.mid,
        });
        scene.add(slimePool);

        var attractor1 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 - 50, 735),
        });
        attractor1.targets = slimePool.slimeColliders;
        scene.add(attractor1);

        var attractor2 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 0, 735),
        });
        attractor2.targets = slimePool.slimeColliders;
        scene.add(attractor2);

        var attractor3 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 50, 735),
        });
        attractor3.targets = slimePool.slimeColliders;
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

        // polys
        scene.add(new FillPoly({
            name: 'poly1',
            pos: new Vec(140, 600)
        }, {
            r: 100,
            sides: 3,
            color: new Color().rgb(0xff9d1e),         
        }, slimePool.slimes));
        scene.add(new FillPoly({
            name: 'poly2',
            pos: new Vec(550, 330)
        }, {
            r: 100,
            sides: 4,
            color: new Color().rgb(0xff9d1e),
        }, slimePool.slimes));
        scene.add(new FillPoly({
            name: 'poly3',
            pos: new Vec(200, 250)
        }, {
            r: 100,
            sides: 7,
            color: new Color().rgb(0xff9d1e),
        }, slimePool.slimes));
        scene.add(new FillPoly({
            name: 'poly4',
            pos: new Vec(0, 400)
        }, {
            r: 100,
            sides: 5,
            color: new Color().rgb(0xff9d1e),
        }, slimePool.slimes));
        scene.add(z = new FillPoly({
            name: 'poly5',
            pos: new Vec(400, 500)
        }, {
            r: 100,
            sides: 6,
            color: new Color().rgb(0xff9d1e),
        }, slimePool.slimes));
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('title');
    }

    override function onmousedown(e:MouseEvent) {
    }

    override function update(dt:Float) {
        if (z.solved) {
            for (slime in slimePool.slimes) {
                slime.isRainbow = true;
            }
        }
    }
}
