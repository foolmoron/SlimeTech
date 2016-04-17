package components;

import luxe.Component;
import luxe.Input;
import luxe.Vector;
import nape.geom.*;
import nape.phys.*;
import luxe.components.physics.nape.*;

class Dragable extends Component {

    public var napeBody : NapeBody;
    public var rectX = 32;
    public var rectY = 32;

    public var dragging = false;
    public var prevMousePos : Vec;

    override function init() {
        //called when initialising the component
    }

    public function contains(x:Float, y:Float) {
        var dx = Math.abs(x - pos.x);
        var dy = Math.abs(y - pos.y);
        return dx < rectX/2 && dy < rectY/2;
    }

    override function onmousedown(e:MouseEvent) {
        if (e.button == 3 && contains(e.x, e.y)) {
            dragging = true;
            prevMousePos = new Vec(e.x, e.y);
        }
    }

    override function onmousemove(e:MouseEvent) {
        if (dragging) {
            if (napeBody != null) {
                var delta = new Vec(napeBody.body.position.x, napeBody.body.position.y) - prevMousePos;
                napeBody.body.position.addeq(new Vec2(delta.x, delta.y));
            } else {
                pos.x += e.x - prevMousePos.x;
                pos.y += e.y - prevMousePos.y;
            }
            prevMousePos = new Vec(e.x, e.y);
        }
    }

    override function onmouseup(e:MouseEvent) {
        if (e.button == 3) {
            dragging = false;
        }
    }

    override function update(dt:Float) {
        //called every frame for you
    }

    override function onreset() {
        //called when the scene starts or restarts
    }
}
