package entities;

import luxe.Entity;
import luxe.options.EntityOptions;
import luxe.Vector;
import luxe.Sprite;
import luxe.Color;

class Slime extends Entity {

    public static var SLIME_COUNT = 0;

    public var backSprite : Sprite;
    public var frontSprite : Sprite;

    public function new(?_options:EntityOptions) {
        super(_options);

        backSprite = new Sprite({
            {
                name: 'sprite' + SLIME_COUNT,
                parent: this,
                texture: Main.tex('blobback'),
                color: new Color().rgb(0xbeb9ff),
                size: new Vec(24, 24),
                depth: 0,
            }
        });
        frontSprite = new Sprite({
            {
                name: 'sprite' + SLIME_COUNT,
                parent: this,
                texture: Main.tex('blob'),
                color: new Color().rgb(0x464fff),
                size: new Vec(16, 16),
                depth: 0.1,
            }
        });
        backSprite.rotation_z += Main.rand.get() * 360;
        frontSprite.rotation_z += Main.rand.get() * 360;
        SLIME_COUNT++;
    }

    public function setColor(color:Color) {
        frontSprite.color = color;
    }
}