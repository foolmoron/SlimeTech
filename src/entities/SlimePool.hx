package entities;

import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Entity;
import luxe.utils.Maths;
import luxe.tween.easing.*;

class SlimePool extends Entity {

    public var slimeCount = 1000;
    public var slimes = new Array<Slime>();
    public var centers = new Array<Vector>();
    public var offsets = new Array<Float>();
    
    public var mousePos = new Vec();
    public var rotationRate = 120;

    override function init() {
        for (i in 0 ... slimeCount) {
            var slime = new Slime();
            slimes.push(slime);
            centers.push(Luxe.screen.mid + new Vec(Main.rand.get()-0.5, Main.rand.get()-0.5) * 32);
            offsets.push(Main.rand.get() * 10);
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

    override function update(dt:Float){
        for (i in 0 ... slimes.length) {
            var pos = centers[i] + new Vec(Math.cos(Luxe.time + offsets[i]), Math.sin(Luxe.time + offsets[i])) * 200;
            var distToMouse = (mousePos - pos).length;
            var amount = 150 + 30 * Math.sin(Luxe.time + offsets[i]);
            var lerp = Maths.clamp(Math.max(Back.easeInOut.calculate(1 - (distToMouse/amount)), 100/distToMouse), 0, 1);
            slimes[i].pos = pos * (1 - lerp) + mousePos * (lerp);
        }
    }

    override function destroy(?_from_parent:Bool=false) {
        super.destroy(_from_parent);
        for (slime in slimes) {
            slime.destroy();
        }
    }
}