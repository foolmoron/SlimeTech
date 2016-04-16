package states;

import luxe.States;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Log.*;
import entities.*;

class GameState extends State {
        
    var slimePool:SlimePool;

    public function new(?_options:StateOptions) {
        super(_options);
    } 

    override function init() {
    }

    override function onenter<T>(with:T) {
        slimePool = new SlimePool();
    }

    override function onleave<T>(with:T) {
        slimePool.destroy();
        slimePool = null;
    }

    override function onkeyup(e:KeyEvent) {
        Main.state.set('title');
    }

    override function update(dt:Float) {

    }
}
