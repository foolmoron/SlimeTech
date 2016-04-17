package states;

import luxe.States;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Log.*;
import entities.*;

class GameState extends SceneState {

    override function onenter<T>(with:T) {
        scene.add(new SlimePool({
            name: 'SlimePool',
            pos: Luxe.screen.mid,
        }));
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('title');
    }

    override function onmousedown(e:MouseEvent) {
    }

    override function update(dt:Float) {
    }
}
