package states;

import luxe.States;
import luxe.options.StateOptions;
import luxe.Input;
import luxe.Scene;
import luxe.Log.*;
import entities.*;

class SceneState extends State {
        
    var scene : Scene;

    override function init() {
        scene = new Scene('game');
    }

    override function onenter<T>(with:T) {
    }

    override function onleave<T>(with:T) {
        scene.empty();
    }
}
