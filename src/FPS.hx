import luxe.Log.*;
import luxe.Vector;
import luxe.Text;

class FPS extends Text {

    public function new( ?_options:luxe.options.TextOptions ) {
        def(_options, {});
        def(_options.name, "fps");
        def(_options.pos, new Vector(Luxe.screen.w - 5, 5));
        def(_options.point_size, 14);
        def(_options.align, TextAlign.right);

        super(_options);
    }

    public override function update(dt:Float) {
        text = 'FPS : ' + Math.round(1.0/Luxe.debug.dt_average);
    }
}