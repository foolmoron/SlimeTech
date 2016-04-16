package states;

import luxe.States;
import luxe.Vector;
import luxe.Color;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Text;
import luxe.Log.*;

class TitleState extends State {

    var text:Text;

    public function new(?_options:StateOptions) {
        super(_options);
    } 

    override function init() {
    }

    override function onenter<T>(with:T) {
        text = new Text({
            text : 'SLIMY SQUAD!',
            color: new Color().rgb(0x000000),
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            pos : Luxe.screen.mid,
            point_size: 84,
        });
    }

    override function onleave<T>(with:T) {
        text.destroy();
        text = null;
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('game');
    }

    override function update(dt:Float) {

    }
}
