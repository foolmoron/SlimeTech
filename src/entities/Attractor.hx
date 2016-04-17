package entities;

import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.utils.Maths;
import luxe.Log.*;
import luxe.Color;
import luxe.tween.easing.*;
import luxe.components.physics.nape.*;
import nape.phys.*;
import nape.geom.*;
import components.*;

class Attractor extends Entity {

    public var sprite : Sprite;
    public var rotationRate = 180;

    public var targets : Array<NapeBody>;

    public function new(?_options:EntityOptions) {
        super(_options);

        var dragable = new Dragable({name: 'Dragable'});
        dragable.rectX = 32;
        dragable.rectY = 32;
        add(dragable);

        sprite = new Sprite({
            name: 'sprite',
            parent: this,
            color: new Color().rgb(0x000000),
            size: new Vec(32, 32),
            depth: 1,
        });
    }

    public override function update(dt:Float) {
        sprite.rotation_z += rotationRate*dt;

        // pull in targets
        var napePos = new Vec2(pos.x, pos.y);
        if (targets != null) {
            for (target in targets) {
                var vectorToSelf = napePos.sub(target.body.position);
                var distToSelf = vectorToSelf.length;
                var strength = Maths.clamp(1 - Quad.easeOut.calculate(distToSelf / 320), 0.05, 1) * 600;
                var deltaV = vectorToSelf.mul(strength*dt/distToSelf);
                target.body.velocity.addeq(deltaV);
            }
        }
    }
}