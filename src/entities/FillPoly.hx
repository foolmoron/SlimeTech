package entities;

import luxe.Entity;
import luxe.options.*;
import luxe.options.DrawOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.Input;
import luxe.utils.Maths;
import luxe.Color;
import luxe.components.physics.nape.*;
import luxe.tween.easing.*;
import nape.phys.*;
import nape.geom.*;
import nape.shape.*;

class FillPoly extends Entity {

    public static var IsFillFrame = false;

    public var rectX = 40;

    public var originalR = 0.0;
    public var outlineOpts : DrawNgonOptions;
    public var fillOpts : DrawNgonOptions;

    public var dir = 0.5;
    public var fillAmount = 0.0;
    public var fillMultiplier = 0.9;
    public static var fillRatePerSlime = 0.005;
    public static var fillDrainRate = 0.25;

    public var collider : PolygonCollider;
    public var slimes : Array<Slime>;

    public function new(?_options:EntityOptions, ?_polyOpts:DrawNgonOptions, s:Array<Slime>) {
        super(_options);

        slimes = s;
        originalR = _polyOpts.r;
        fillMultiplier = [0.84, 0.9, 0.915, 0.915, 0.915, 0.915, 0.915, 0.915][_polyOpts.sides - 3];
        outlineOpts = {
            immediate: true,
            solid: true,
            r: originalR,
            sides: _polyOpts.sides,
            color: _polyOpts.color,
            x: pos.x, 
            y: pos.y,
            depth: _polyOpts.depth,
        };
        fillOpts = {
            immediate: true,
            solid: true,
            r: originalR,
            sides: _polyOpts.sides,
            color: new Color().rgb(0xe9e9e9),
            x: pos.x, 
            y: pos.y,
            depth: _polyOpts.depth,
        };

        var geom = Luxe.draw.ngon(outlineOpts);
        var verts = new Array<Vector>();
        for (vert in geom.vertices) {
            verts.push(new Vector(vert.pos.x, vert.pos.y));
        }
        collider = add(new PolygonCollider({
            name: 'collider',
            x: 0,
            y: 0,
            polygon: verts,
            body_type: BodyType.KINEMATIC,
        }));
        collider.body.shapes.at(0).sensorEnabled = true;
    }

    override function update(dt:Float) {
        var polygon = collider.body.shapes.at(0);
        var containedSlimes = 0;
        for (slime in slimes) {
            if (slime.isEnabled && polygon.contains(slime.collider.body.position)) {
                slime.isActive = slime.isActive || true;
                slime.isRainbow = slime.isRainbow || fillAmount >= 1;
                containedSlimes++;
            }
        }
        fillAmount += fillRatePerSlime * containedSlimes * dt;
        if (containedSlimes == 0) {
            fillAmount -= fillDrainRate * dt;
        }
        fillAmount = Maths.clamp(fillAmount, 0, 1);

        outlineOpts.x = pos.x;
        outlineOpts.y = pos.y;
        fillOpts.x = pos.x;
        fillOpts.y = pos.y;
        fillOpts.r = originalR * (1 - fillAmount) * fillMultiplier;
        
        Luxe.draw.ngon(outlineOpts);
        Luxe.draw.ngon(fillOpts);
    }
}