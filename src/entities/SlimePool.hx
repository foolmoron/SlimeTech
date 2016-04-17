package entities;

import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Entity;
import luxe.utils.Maths;
import nape.geom.*;
import luxe.components.physics.nape.*;
import luxe.tween.easing.*;
import components.*;

class SlimePool extends Entity {

    public var slimeCount = 200;
    public var slimes = new Array<Slime>();
    public var slimeColliders = new Array<CircleCollider>();
    
    public var emitSpeed = 20;
    public var emitTime = 0.0;
    public var emitIndex = 0;

    override function init() {
        var dragable = new Dragable({name: 'Dragable'});
        dragable.rectX = 24;
        dragable.rectY = 24;
        add(dragable);

        new Sprite({
            name: 'sprite',
            parent: this,
            color: new Color().rgb(0xff0000),
            size: new Vec(24, 24),
            depth: 1,
        });

        for (i in 0 ... slimeCount) {
            var slime = new Slime();
            slime.collider.body.position = new Vec2(pos.x, pos.y);
            slimes.push(slime);
            slimeColliders.push(slime.collider);
        }
    }

    // override function onmousedown(e:MouseEvent) {
    //     mousePos = new Vec(e.x, e.y);
    // }
    // override function onmousemove(e:MouseEvent) {
    //     mousePos = new Vec(e.x, e.y);
    // }

    // override function ontouchdown(e:TouchEvent) {
    //     mousePos = new Vec(e.x, e.y) * Luxe.screen.size;
    // }
    // override function ontouchmove(e:TouchEvent) {
    //     mousePos = new Vec(e.x, e.y) * Luxe.screen.size;
    // }

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

        // // gravity
        // for (i in 0 ... slimes.length) {
        //     var vectorToMouse = mousePos - slimes[i].pos;
        //     var distToMouse = vectorToMouse.length;
        //     var strength = Maths.clamp(1/distToMouse, 0, 1) * 8;
        //     var deltaV = vectorToMouse * strength;
        //     slimes[i].collider.body.velocity.addeq(new Vec2(deltaV.x, deltaV.y));
        // }
    }

    override function destroy(?_from_parent:Bool=false) {
        super.destroy(_from_parent);
        for (slime in slimes) {
            slime.destroy();
        }
    }
}