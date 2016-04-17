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

    public var initialVelocity = new Vec2(0, 0);
    
    public var emitSpeed = 20;
    public var emitTime = 0.0;
    public var emitIndex = 0;

    public var dragable : Dragable;

    override function init() {
        // dragable = new Dragable({name: 'Dragable'});
        // dragable.rectX = 24;
        // dragable.rectY = 24;
        // add(dragable);

        var boundToArea = new BoundToArea({name: 'boundToArea'});
        boundToArea.tlx = 30;
        boundToArea.tly = 54;
        boundToArea.brx = 670;
        boundToArea.bry = 694;
        boundToArea.rectX = 24;
        boundToArea.rectY = 24;
        add(boundToArea);

        new Sprite({
            name: 'sprite',
            parent: this,
            color: new Color().rgb(0xbeb9ff),
            texture: Main.tex('circle'),
            size: new Vec(32, 32),
            depth: 10,
        });

        for (i in 0 ... slimeCount) {
            var slime = new Slime();
            slime.collider.body.position = new Vec2(pos.x, pos.y);
            var angle = Main.rand.get() * Math.PI * 2;
            slime.collider.body.velocity = initialVelocity.add(new Vec2(Math.cos(angle), Math.sin(angle)).muleq(Main.rand.get() * 5));
            slimes.push(slime);
            slimeColliders.push(slime.collider);
        }
    }

    override function update(dt:Float) {
        var emit = true;//!dragable.dragging;

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
                    var angle = Main.rand.get() * Math.PI * 2;
                    slime.collider.body.velocity = initialVelocity.add(new Vec2(Math.cos(angle), Math.sin(angle)).muleq(Main.rand.get() * 5));
                    slime.enable();
                    emitCount--;
                }
            }
        }
        var timeMultiplier = emit ? 1 : 5;
        for (slime in slimes) {
            if (!emit) {
                slime.lifeTime = Math.max(slime.lifeTime, slime.lifeTimeMax/2);
                slime.lifeTimeMultiplier = 5;
            }
        }
    }

    override function destroy(?_from_parent:Bool=false) {
        super.destroy(_from_parent);
        for (slime in slimes) {
            slime.destroy();
        }
    }
}