import luxe.Input;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.Ev;
import luxe.utils.Random;
import luxe.utils.Maths;
import luxe.tween.easing.*;

class Main extends luxe.Game {

    var rand = new Random(0x3389345);

    var squares = new Array<Sprite>();
    var centers = new Array<Vector>();
    var offsets = new Array<Float>();
    var mousePos = new Vec();

    override function ready() {
        new FPS();

        for (i in 0 ... 2000) {
            squares.push(new Sprite({
                name: 'sprite' + i,
                pos: Luxe.screen.mid,
                color: Color.random(),
                size: new Vec(16, 16),
            }));
            centers.push(Luxe.screen.mid + new Vec(rand.get()-0.5, rand.get()-0.5) * 150);
            offsets.push(rand.get() * 10);
        }

        app.on(Ev.mousemove, moused);
        app.on(Ev.mousedown, moused);
        app.on(Ev.touchmove, touched);
        app.on(Ev.touchdown, touched);
    }

    override function onkeyup(e:KeyEvent) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }
    }

    function moused(e:MouseEvent) {
        mousePos = new Vec(e.x, e.y);
    }
    function touched(e:TouchEvent) {
        mousePos = new Vec(e.x, e.y) * Luxe.screen.size;
    }

    override function update(dt:Float) {
        for (i in 0 ... squares.length) {
            var pos = centers[i] + new Vec(Math.cos(Luxe.time + offsets[i]), Math.sin(Luxe.time + offsets[i])) * 200;
            var distToMouse = (mousePos - pos).length;
            var amount = 150 + 30 * Math.sin(Luxe.time + offsets[i]);
            var lerp = Maths.clamp(Math.max(Back.easeInOut.calculate(1 - (distToMouse/amount)), 100/distToMouse), 0, 1);
            squares[i].pos = pos * (1 - lerp) + mousePos * (lerp);
        }
    }
}