package components;

import luxe.Component;
import luxe.Input;
import luxe.Vector;
import luxe.utils.Maths;
import nape.geom.*;
import nape.phys.*;
import luxe.components.physics.nape.*;

class BoundToScreen extends Component {

    public var rectX = 16.0;
    public var rectY = 16.0;

    override function update(dt:Float) {
        pos.x = Maths.clamp(pos.x, rectX/2, Luxe.screen.w - rectX/2);
        pos.y = Maths.clamp(pos.y, rectY/2, Luxe.screen.h - rectY/2);
    }
}
