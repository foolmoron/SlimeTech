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

    public var letters : Array<Text>;
    public var hueRate = -360.0;
    public var hueOffset = 0.0;

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
            pos: new Vec(Luxe.screen.w/2 - 50, 725),
        });
        attractor1.targets = slimePool.slimeColliders;
        scene.add(attractor1);

        var attractor2 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 0, 725),
        });
        attractor2.targets = slimePool.slimeColliders;
        scene.add(attractor2);

        var attractor3 = new Attractor({
            name: 'Attractor.' + Luxe.utils.uniqueid(),
            pos: new Vec(Luxe.screen.w/2 + 50, 725),
        });
        attractor3.targets = slimePool.slimeColliders;
        scene.add(attractor3);

        if (levelId > 1) {
            buttonLeft = new Button({
                name: 'buttonLeft',
                pos: new Vec(30, Luxe.screen.h - 52),
            });
            buttonLeft.onClick = function() { Main.state.set('game' + (levelId - 1)); };
            scene.add(buttonLeft);
        }

        if (levelId < Main.LEVELS.length) {
            buttonRight = new Button({
                name: 'buttonRight',
                pos: new Vec(Luxe.screen.w - 30, Luxe.screen.h - 52),
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

        // achieved
        var lets = ['S','C','I','E','N','C','E',' ','A','C','H','I','E','V','E','D','!'];
        letters = new Array<Text>();
        for (i in 0...lets.length) {
            var letter = lets[i];
            var t = new Text({
                text : letter,
                color: new ColorHSV(i*40, 0.75, 1, 1),
                align: TextAlign.center,
                align_vertical: TextAlign.center,
                pos : new Vec(i*35 + 75, 770),
                point_size: 52,
                depth: 500,
            });
            letters.push(t);
            scene.add(t);
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
            hueOffset = (hueOffset + hueRate*dt) % 360;
            for (i in 0 ... letters.length) {
                var hue = (i*40 + hueOffset) % 360;
                letters[i].color = new ColorHSV(hue, 0.75, 1, 1);
            }
        } else {
            for (i in 0 ... letters.length) {
                letters[i].color.a = 0;
            }
        }
    }
}
