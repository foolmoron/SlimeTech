package entities;

import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.utils.Maths;
import luxe.Color;
import luxe.components.physics.nape.*;
import nape.phys.*;
import nape.geom.*;

class Slime extends Entity {

    public static var SLIME_COUNT = 0;

    public var collider : CircleCollider;

    public var backSprite : Sprite;
    public var frontSprite : Sprite;

    public function new(?_options:EntityOptions) {
        super(_options);
        collider = add(new CircleCollider({
            name: 'collider',
            x: 0,
            y: 0,
            r: 4,
            body_type: BodyType.DYNAMIC,
        }));

        backSprite = new Sprite({
            {
                name: 'sprite' + SLIME_COUNT,
                parent: this,
                texture: Main.tex('blobback'),
                color: new Color().rgb(0xbeb9ff),
                size: new Vec(32, 32),
                depth: 0,
            }
        });
        frontSprite = new Sprite({
            {
                name: 'sprite' + SLIME_COUNT,
                parent: this,
                texture: Main.tex('blob'),
                color: new Color().rgb(0x464fff),
                size: new Vec(20, 20),
                depth: 0.1,
            }
        });
        SLIME_COUNT++;
        reset();
    }

    public function reset() {
        backSprite.rotation_z += Main.rand.get() * 360;
        frontSprite.rotation_z += Main.rand.get() * 360;
        var angle = Main.rand.get() * Math.PI * 2;
        collider.body.velocity = new Vec2(Math.cos(angle), Math.sin(angle)).muleq(Main.rand.get() * 10);
    }

    public function setColor(color:Color) {
        frontSprite.color = color;
    }

    public override function update(dt:Float) {
        frontSprite.color.r = pos.x / Luxe.screen.w;
        frontSprite.color.b = pos.y / Luxe.screen.h;
    }
}