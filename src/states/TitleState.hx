package states;

import luxe.States;
import luxe.Vector;
import luxe.Color;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Text;
import luxe.Log.*;

class TitleState extends SceneState {

    override function onenter<T>(with:T) {
        scene.add(new Text({
            text : 'SLIME TECH',
            color: new Color().rgb(0x000000),
            align: TextAlign.center,
            align_vertical: TextAlign.center,
            pos : Luxe.screen.mid,
            point_size: 84,
        }));
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('game');
    }

    override function update(dt:Float) {
    }
}
