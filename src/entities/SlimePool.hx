package entities;

import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Entity;
import luxe.utils.Maths;
import nape.geom.*;
import luxe.tween.easing.*;

class SlimePool extends Entity {

    public var slimeCount = 200;
    public var slimes = new Array<Slime>();
    
    public var emitSpeed = 50;
    public var emitTime = 0.0;
    public var emitIndex = 0;

    public var mousePos : Vec = Luxe.screen.mid;

    override function init() {
        for (i in 0 ... slimeCount) {
            var slime = new Slime();
            slime.collider.body.position = new Vec2(pos.x, pos.y);
            slimes.push(slime);
        }
    }

    override function onmousedown(e:MouseEvent) {
        mousePos = new Vec(e.x, e.y);
    }
    override function onmousemove(e:MouseEvent) {
        mousePos = new Vec(e.x, e.y);
    }

    override function ontouchdown(e:TouchEvent) {
        mousePos = new Vec(e.x, e.y) * Luxe.screen.size;
    }
    override function ontouchmove(e:TouchEvent) {
        mousePos = new Vec(e.x, e.y) * Luxe.screen.size;
    }

    override function update(dt:Float) {
        // resets
        emitTime += emitSpeed*dt;
        var emitCount = Math.floor(emitTime);
        emitTime -= emitCount;
        for (i in 0 ... emitCount) {
            slimes[emitIndex].reset();
            slimes[emitIndex].collider.body.position = new Vec2(pos.x, pos.y);
            emitIndex = (emitIndex + 1) % slimes.length;
        }

        // gravity
        for (i in 0 ... slimes.length) {
            var vectorToMouse = mousePos - slimes[i].pos;
            var distToMouse = vectorToMouse.length;
            var strength = Maths.clamp(1/distToMouse, 0, 1) * 8;
            var deltaV = vectorToMouse * strength;
            slimes[i].collider.body.velocity.addeq(new Vec2(deltaV.x, deltaV.y));
        }
    }

    override function destroy(?_from_parent:Bool=false) {
        super.destroy(_from_parent);
        for (slime in slimes) {
            slime.destroy();
        }
    }
}