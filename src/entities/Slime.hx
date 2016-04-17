package entities;

import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.utils.Maths;
import luxe.Color;
import luxe.components.physics.nape.*;
import luxe.tween.easing.*;
import nape.phys.*;
import nape.geom.*;

class Slime extends Entity {

    public static var SLIME_MATERIAL = Material.sand();

    public var collider : CircleCollider;

    public var backSprite : Sprite;
    public var frontSprite : Sprite;

    public var lifeTimeMax = 5.0;
    public var lifeTime = 0.0;
    public var lifeTimeMultiplier = 1.0;

    public var isEnabled = true;

    public function new(?_options:EntityOptions) {
        super(_options);
        collider = add(new CircleCollider({
            name: 'collider',
            x: 0,
            y: 0,
            r: 4,
            body_type: BodyType.DYNAMIC,
            material: SLIME_MATERIAL,
        }));

        backSprite = new Sprite({
            name: 'backsprite',
            parent: this,
            texture: Main.tex('blobback'),
            color: new Color().rgb(0xbeb9ff),
            size: new Vec(32, 32),
            depth: 0,
        });
        frontSprite = new Sprite({
            name: 'frontsprite',
            parent: this,
            texture: Main.tex('blob'),
            color: new Color().rgb(0x464fff),
            size: new Vec(20, 20),
            depth: 0.1,
        });
        reset();
        disable();
    }

    public function reset() {
        lifeTime = 0;
        backSprite.rotation_z += Main.rand.get() * 360;
        frontSprite.rotation_z += Main.rand.get() * 360;
        backSprite.color.a = 1;
        frontSprite.color.a = 1;
        frontSprite.size.x = 20;
        frontSprite.size.y = 20;
        var angle = Main.rand.get() * Math.PI * 2;
        collider.body.velocity = new Vec2(Math.cos(angle), Math.sin(angle)).muleq(Main.rand.get() * 5);
    }

    public function setColor(color:Color) {
        frontSprite.color = color;
    }

    public function enable() {
        collider.body.allowMovement = true;
        collider.body.allowRotation = true;
        backSprite.color.a = 1;
        frontSprite.color.a = 1;
        isEnabled = true;
    }

    public function disable() {
        collider.body.allowMovement = false;
        collider.body.allowRotation = false;
        backSprite.color.a = 0;
        frontSprite.color.a = 0;
        isEnabled = false;
    }

    public override function update(dt:Float) {
        if (isEnabled) {
            lifeTime += dt*lifeTimeMultiplier;
            if (lifeTime >= lifeTimeMax) {
                disable();
            }

            var lifeLerp = Maths.clamp(1 - (lifeTime / lifeTimeMax), 0, 0.25) * 4;
            backSprite.color.a = lifeLerp;
            frontSprite.size.x = lifeLerp * 20;
            frontSprite.size.y = lifeLerp * 20;
        }
    }
}