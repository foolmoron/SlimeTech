package components;

import luxe.Component;
import luxe.Input;
import luxe.Vector;
import luxe.utils.Maths;
import nape.geom.*;
import nape.phys.*;
import luxe.components.physics.nape.*;

class BoundToArea extends Component {

    public var tlx = 0.0;
    public var tly = 0.0;
    public var brx = 0.0;
    public var bry = 0.0;
    public var rectX = 16.0;
    public var rectY = 16.0;

    override function update(dt:Float) {
        pos.x = Maths.clamp(pos.x, rectX/2 + tlx, brx - rectX/2);
        pos.y = Maths.clamp(pos.y, rectY/2 + tly, bry - rectY/2);
    }
}
