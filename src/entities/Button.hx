package entities;

import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.utils.Maths;
import luxe.Color;
import luxe.components.physics.nape.*;
import luxe.tween.easing.*;
import nape.phys.*;
import nape.geom.*;

class Button extends Entity {

    public var rectX = 40;
    public var rectY = 76;
    public var down = false;

    public var upSprite : Sprite;
    public var downSprite : Sprite;

    public var onClick = function() {};

    public function new(?_options:EntityOptions) {
        super(_options);

        upSprite = new Sprite({
            name: 'up',
            parent: this,
            texture: Main.tex('button'),
            size: new Vec(40, 76),
            depth: 101,
        });
        downSprite = new Sprite({
            name: 'down',
            parent: this,
            texture: Main.tex('buttondown'),
            size: new Vec(40, 76),
            depth: 101,
        });
    }

    public function contains(x:Float, y:Float) {
        var dx = Math.abs(x - pos.x);
        var dy = Math.abs(y - pos.y);
        return dx < rectX/2 && dy < rectY/2;
    }

    override function onmousedown(e:MouseEvent) {
        if (contains(e.x, e.y)) {
            down = true;
        }
    }

    override function onmouseup(e:MouseEvent) {
        if (down && contains(e.x, e.y)) {
            onClick();
        }
        down = false;
    }

    override function update(dt:Float) {
        upSprite.color.a = down ? 0 : 1;
        downSprite.color.a = down ? 1 : 0;
    }
}