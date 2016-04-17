package states;

import luxe.States;
import luxe.Sprite;
import luxe.Color;
import luxe.options.*;
import luxe.Input;
import luxe.Vector;
import luxe.Text;
import luxe.Log.*;
import entities.*;
import components.*;

class GameState extends SceneState {

    public var slimePool : SlimePool;
    public var fillPolys : Array<FillPoly>;

    public var buttonLeft : Button;
    public var buttonRight : Button;

    public var levelId = -1;
    public var levelDef : Level;

    public function new(_options:StateOptions, levelId:Int, levelDef:Level) {
        super(_options);

        this.levelId = levelId;
        this.levelDef = levelDef;
    }

    override function onenter<T>(with:T) {
        slimePool = new SlimePool({
            name: 'SlimePool',
            pos: levelDef.sourcePos,
        });
        slimePool.initialVelocity = levelDef.sourceVel;
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

        if (levelId > 1) {
            buttonLeft = new Button({
                name: 'buttonLeft',
                pos: new Vec(40, Luxe.screen.h - 52),
            });
            buttonLeft.onClick = function() { Main.state.set('game' + (levelId - 1)); };
            scene.add(buttonLeft);
        }

        if (levelId < Main.LEVELS.length) {
            buttonRight = new Button({
                name: 'buttonRight',
                pos: new Vec(Luxe.screen.w - 40, Luxe.screen.h - 52),
            });
            buttonRight.upSprite.flipx = true;
            buttonRight.downSprite.flipx = true;
            buttonRight.disabledSprite.flipx = true;
            buttonRight.onClick = function() { Main.state.set('game' + (levelId + 1)); };
            scene.add(buttonRight);
        }

        // tutorial
        if (levelId == 1) {
            scene.add(new Text({
                text : 'tut stuff',
                color: new Color().rgb(0x000000),
                align: TextAlign.center,
                align_vertical: TextAlign.center,
                pos : new Vec(Luxe.screen.w/2, 400),
                point_size: 36,
                depth: 500,
            }));
        }

        // polys
        fillPolys = new Array<FillPoly>();
        for (poly in levelDef.polys) {
            var fillPoly = new FillPoly({
                name: 'poly' + fillPolys.length,
                pos: poly.pos,
            }, {
                r: 86,
                sides: poly.sides,
                color: new Color().rgb(0xff9d1e),
                depth: -99,
            }, slimePool.slimes);
            fillPolys.push(fillPoly);
            scene.add(fillPoly);
        }
    }

    override function onmousedown(e:MouseEvent) {
    }

    override function update(dt:Float) {
        if (buttonRight != null) {
            buttonRight.disabled = Main.solvedLevel < levelId;
        }

        var anyUnsolved = false;
        for (poly in fillPolys) {
            if (Main.solvedLevel >= levelId) {
                poly.fillAmount = 1;
            }
            anyUnsolved = anyUnsolved || (poly.fillAmount < 1);
        }
        if (!anyUnsolved) {
            Main.solvedLevel = levelId > Main.solvedLevel ? levelId : Main.solvedLevel;
            for (slime in slimePool.slimes) {
                slime.isRainbow = true;
            }
        }
    }
}
