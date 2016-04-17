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

    public var dragable : Dragable;

    override function init() {
        dragable = new Dragable({name: 'Dragable'});
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

    override function update(dt:Float) {
        var emit = !dragable.dragging;

        if (emit) {
            emitTime += emitSpeed*dt;
            var emitCount = Math.floor(emitTime);
            emitTime -= emitCount;
            for (slime in slimes) {
                if (emitCount <= 0) {
                    break;
                }
                if (!slime.isEnabled) {
                    slime.reset();
                    slime.collider.body.position = new Vec2(pos.x, pos.y);
                    slime.pos = new Vec(pos.x, pos.y);
                    slime.enable();
                    emitCount--;
                }
            }
        }
        var timeMultiplier = emit ? 1 : 5;
        for (slime in slimes) {
            slime.lifeTimeMultiplier = timeMultiplier;
        }
    }

    override function destroy(?_from_parent:Bool=false) {
        super.destroy(_from_parent);
        for (slime in slimes) {
            slime.destroy();
        }
    }
}