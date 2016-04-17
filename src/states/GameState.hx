package states;

import luxe.States;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Vector;
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
        if (e.button == 1) {
            var attractor = new Attractor({
                name: 'Attractor.' + Luxe.utils.uniqueid(),
                pos: new Vec(e.x, e.y),
            });
            attractor.targets = (cast scene.get('SlimePool')).slimeColliders;
            scene.add(attractor);
        }
    }

    override function update(dt:Float) {
    }
}
