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
    public var disabled = false;

    public var upSprite : Sprite;
    public var downSprite : Sprite;
    public var disabledSprite : Sprite;

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
        disabledSprite = new Sprite({
            name: 'down',
            parent: this,
            texture: Main.tex('buttondisabled'),
            size: new Vec(40, 76),
            depth: 101,
        });
    }

    public function contains(x:Float, y:Float) {
        var dx = Math.abs(x - pos.x);
        var dy = Math.abs(y - pos.y);
        return dx < rectX/2 && dy < rectY/2;
    }

    public function ondown(x:Float, y:Float) {
        if (contains(x, y)) {
            down = true;
        }        
    }

    public function onup(x:Float, y:Float) {
        if (down && !disabled && contains(x, y)) {
            onClick();
        }
        down = false;        
    }

    override function onmousedown(e:MouseEvent) {
        ondown(e.x, e.y);
    }
    override function onmouseup(e:MouseEvent) {
        onup(e.x, e.y);
    }
    override function ontouchdown(e:TouchEvent) {
        ondown(e.x * Luxe.screen.w, e.y * Luxe.screen.h);
    }
    override function ontouchup(e:TouchEvent) {
        onup(e.x * Luxe.screen.w, e.y * Luxe.screen.h);
    }
    override function update(dt:Float) {
        upSprite.color.a = !down && !disabled ? 1 : 0;
        downSprite.color.a = down && !disabled ? 1 : 0;
        disabledSprite.color.a = disabled ? 1 : 0;
    }
}